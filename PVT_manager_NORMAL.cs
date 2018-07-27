using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEditor;
using LlockhamIndustries.Decals;
using UnityEngine.Rendering;

//CRITICAL PROBLEM #1: WHEN TILE RESOLUTION IS 512x512, THE RENDER-TO-TEXTURE PROCESS IS TOO SLOW,
//CHANGING THE RESOLUTION TO 256x256 GREATLY IMPROVED THIS EVEN WITH MORE TILES.

//CRITICAL PROBLEM #2: WHEN USING LRU TO ALLOCATE NEW NODES FOR TILES, IF THE SIZE OF THE LINKED
//LIST IS SMALL, WE WILL REUSE THE ONES THAT ALREADY IN THE QUEUE BUT NOT RENDERED YET. THIS WILL
//RESULT IN NULL POINTER WHEN RENDERING. Should clear the current queue and reset the relevant
//states.

//FUTURE OPTIMIZATION #1: GROUP THE TILES ACCORDING TO BATCHES INSTEAD OF MIPLEVEL CAN GREATLY 
//REDUCE THE TIME USED TO GENERATE MIPMAPS.

//FUTURE OPTIMIZATION #2: RESTRICT THE NORMAL TEXTURE TO ONLY THE FINEST MIP LEVEL CAN REDUCE THE
//RENDERTEXTURE USAGE AS WELL AS GPU RENDERING TIME.

//FUTURE OPTIMIZATION #3: USE INSTANCED RENDERING WITH MULTI RENDERING TARGET TO RENDER MULTIPLE
//TILES IN ONE DRAW CALL

public class PVT_manager_NORMAL : MonoBehaviour
{
    public Terrain[] mTerrains;
    public Terrain[] mTargetTerrains;
    private int mTerrainCount;
    public int terrainCountX;
    public int terrainCountZ;
    public Transform mFocus;
    public Shader mRenderTextureShader;
    public Shader mTerrainShader;
    public Shader mDecalShader;
    public int generateTaskCounterMax = 0;
    public int processTaskCounterMax = 0;
    private int generateTaskCounter = 0;
    private int processTaskCounter = 0;
    private int cameraSector = -1;

    public int sectorCountXPerTerrain;
    public int sectorCountZPerTerrain;
    public int sectorPerTileX = 1;
    public int sectorPerTileY = 1;
    private int sectorCount;
    private int sectorCountX;
    private int sectorCountZ;

    public float borderOffset = 0.0f;//offset in pixels in sparse texture
    public int mipInitial = 2;
    public int mipDifference = 1;
    public int mipLevelMaxTileCountPerTerrainX = 2;//mip level max has a customized tile count
    public int mipLevelMaxTileCountPerTerrainY = 2;//mip level max has a customized tile count

    //update radius is only safe when it can reach the sectors that has the mipLevelMax, because this way, 
    //the un-updated sectors will always have mipLevelMax, and the mipLevelMax will always be resident, 
    //since at least one sector at this level is within the update radius
    private int updateRadius = -1;//radius of sectors that are updated during each frame, negative number means all the sectors
    public int updateTilePerFrame = 6;//number of tiles that are rendered during each frame, negative number means all tiles in the queue

    private float terrainWidthTotal;//width of combined terrain in unit
    private float terrainLengthTotal;//length of combined terrain in unit
    private float terrainWidth;//width of one terrain
    private float terrainLength;//length of one terrain
    private float sectorWidth;//in unit
    private float sectorLength;//in unit
    private Sector[] sectors;

    //0 is the first level, maximum value is 6 with current shader
    //actual mip level may not reach this maximum value, it depends on sector distance
    public int mipLevelMax = 0;
    public int tileWidth = 1;//in pixel
    public int tileHeight = 1;//in pixel
    public int tileCount = 1;//if this value is smaller than what's necessary, it will not be used.
    public int tileCountExtra = 0;
    public float[] mipScales;
    private LinkedList<Tile>[] tilesList;
    private int[] tileCounts;

    private int pageTableTileCountX;
    private int pageTableTileCountY;

    private RenderTexture[] textureArrayArray;
    private RenderTexture[] normalArrayArray;
    private MipLevel[] pageMipLevelTable;
    private Material[] mRenderTextureMaterials;
    private Material mTerrainMaterial;
    private Mesh mQuad;
    private Material mDecalMaterial;
    private Decal[] decalArray;
    private Texture2D mDecalAtlas;
    private Texture2D mDecalAtlasNormal;
    private Rect[] decalRectArray;
    private Rect[] decalRectArrayNormal;
    private List<Texture2D> decalAtlasList;
    private List<Texture2D> decalAtlasListNormal;
    private ProjectionRenderer[] DynamicDecalsScripts;

    public int decalAtlasMaxResolution = 8192;
    public int decalAtlasMaxResolutionNormal = 8192;

    private int lastSector = -1;
    private Queue<Task> tasks;
    private int candidateInitialCount = 0;

    private int debugMode = 0;
    private int debugArrayArrayIndex = 0;
    private int debugArrayIndex = 0;
    private int debugShowNormal = 1;
    private bool debugDecals = false;
    private bool debugPVT = true;

    // Use this for initialization
    void Start()
    {
        generateTaskCounter = 0;
        processTaskCounter = 0;
        Initialize();
        EnqueueMipLevelMax();
        GenerateTask(-1, false);
        ProcessTask(-1);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.G))
        {
            for (int i = 0; i <= mipLevelMax; i++)
            {
                LinkedListNode<Tile> temp = tilesList[i].First;
                do
                {
                    Debug.Log("i:" + i + ",mipLevel:" + temp.Value.mipLevel + ",nodeIndex:" + temp.Value.node + ",tileIndex:" + temp.Value.tileIndex);
                    temp = temp.Next;
                }
                while (temp != null);
            }
        }
        
        if (Input.GetKey(KeyCode.Q))
        {
            mipScales[debugArrayArrayIndex] -= 0.01f;
            mTerrainMaterial.SetFloat("_MipScale_" + debugArrayArrayIndex, mipScales[debugArrayArrayIndex]);
        }

        if (Input.GetKey(KeyCode.E))
        {
            mipScales[debugArrayArrayIndex] += 0.01f;
            mTerrainMaterial.SetFloat("_MipScale_" + debugArrayArrayIndex, mipScales[debugArrayArrayIndex]);
        }

        //apply all changes
        if (Input.GetKeyDown(KeyCode.H))
        {
            for(int i = 0;i<mipLevelMax;i++)
            {
                mTerrainMaterial.SetFloat("_MipScale_" + i, mipScales[i]);
            }
        }

        if (Input.GetKeyDown(KeyCode.R))
        {
            debugArrayArrayIndex = (debugArrayArrayIndex + 1) % (mipLevelMax + 1);
            mTerrainMaterial.SetInt("_DebugArrayArrayIndex", debugArrayArrayIndex);
            Debug.Log("debugArrayArrayIndex:" + debugArrayArrayIndex);
        }

        if (Input.GetKeyDown(KeyCode.T))
        {
            debugMode = (debugMode + 1) % 4;//4 modes
            mTerrainMaterial.SetInt("_DebugMode", debugMode);
        }

        if (Input.GetKeyDown(KeyCode.Y))
        {
            debugArrayIndex = (debugArrayIndex + 1) % tileCounts[debugArrayArrayIndex];
            mTerrainMaterial.SetInt("_DebugArrayIndex", debugArrayIndex);
        }

        if (Input.GetKeyDown(KeyCode.F))
        {
            debugPVT = !debugPVT;
            ////////////////////////////////////////////
            /////////////////////NEW////////////////////
            if (debugPVT)
            {
                for (int i = 0; i < mTerrainCount; i++)
                {
                    mTargetTerrains[i].gameObject.SetActive(true);
                    mTerrains[i].gameObject.SetActive(false);
                }

                ReactivateDecals(false);
            }
            else
            {
                for (int i = 0; i < mTerrainCount; i++)
                {
                    mTargetTerrains[i].gameObject.SetActive(false);
                    mTerrains[i].gameObject.SetActive(true);
                }

                ReactivateDecals(true);
            }
            //for(int i = 0;i< mTerrains.Length;i++)
            //{
            //    if (mTerrains[i].materialType == Terrain.MaterialType.Custom)
            //    {
            //        mTerrains[i].materialType = Terrain.MaterialType.BuiltInStandard;
            //        debugPVT = false;
            //        Debug.Log("terrain_" + i + ":builtin");
            //    }
            //    else
            //    {
            //        mTerrains[i].materialType = Terrain.MaterialType.Custom;
            //        mTerrains[i].materialTemplate = mTerrainMaterial;
            //        debugPVT = true;
            //        Debug.Log("terrain_" + i + ":custom");
            //    }
            //}
            /////////////////////NEW////////////////////
            ////////////////////////////////////////////
        }

        if (Input.GetKeyDown(KeyCode.C))
        {
            debugDecals = !debugDecals;
            ReactivateDecals(debugDecals);
            Debug.Log("debugDecals:" + debugDecals);
        }

        if (Input.GetKeyDown(KeyCode.N))
        {
            debugShowNormal = (debugShowNormal + 1) % 2;
            mTerrainMaterial.SetInt("_DebugShowNormal", debugShowNormal);
            Debug.Log("normal:" + debugShowNormal);
        }

        if(Input.GetKeyDown(KeyCode.P))
        {
            Color[] temp = pageMipLevelTable[0].texture64.GetPixels();
            for(int i = 0;i<temp.Length;i++)
            {
                if(temp[i].a > -1.0f)
                    Debug.Log(i + ":" + temp[i]);
            }
        }
    }

    void FixedUpdate()
    {
        //FixedUpdate is at the very front of the unity execution order, this can reduce the chance
        //of Gfx.WaitForPresent. And using refreshCounter to limit Execute() not to be called every
        //fixed time step further reduce the chance of Gfx.WaitForPresent.
        if (debugPVT)
        {
            if (generateTaskCounter >= generateTaskCounterMax)
            {
                //NEED TO APPLY CHANGES TO THE CHANGED TEXTURES
                //COMMENT THIS TO DEBUG
                GenerateTask(updateRadius, true);
                generateTaskCounter = 0;
            }
            else
            {
                generateTaskCounter++;
            }

            if (processTaskCounter >= processTaskCounterMax)
            {
                //NEED TO APPLY CHANGES TO THE CHANGED TEXTURES
                //COMMENT THIS TO DEBUG
                ProcessTask(updateTilePerFrame);
                processTaskCounter = 0;
            }
            else
            {
                processTaskCounter++;
            }
        }
        
    }
    
    void EnqueueMipLevelMax()
    {
        //Make sure all tiles in mipLevelMax are in VRAM
        for(int i = 0;i<pageMipLevelTable[mipLevelMax].count;i++)
        {
            DistributeTile(i, mipLevelMax);
        }
    }

    void GenerateTask(int radius, bool clearPreviousTask)
    {
        //1.Decide which terrain sector the player is standing on
        cameraSector = GetSector(mFocus.transform.position.x, mFocus.transform.position.z);

        //2.If the player has moved, update affected sectors and store the render task in a queue
        if (cameraSector != lastSector)
        {
            //When clearing tasks, remember to add the nodes back to the list
            if(clearPreviousTask)
                ClearTasks();
            UpdateSectors(cameraSector, radius);
            lastSector = cameraSector;
            candidateInitialCount = tasks.Count;

        }
    }

    void ProcessTask(int tilePerFrame)
    {
        //1.Process certain amount of task in the queue during each frame
        int candidatesSize = tilePerFrame >= 0 ? Mathf.Min(tilePerFrame, tasks.Count) : tasks.Count;
        bool[] needToUpdatePageMipLevelTable = new bool[mipLevelMax + 1];//default to false
        bool[] needToUpdateTextureArrayArray = new bool[mipLevelMax + 1];//default to false
        for (int i = 0; i < candidatesSize; i++)
        {
            Task candidate = tasks.Dequeue();
            if(candidate.unloadMipLevel!=-1&&candidate.unloadChunk!=-1)
            {
                //Add back the page table so that intermediate sectors can temporarily use a coarser mip level
                DeactivatePageMipLevelTable(candidate.unloadMipLevel, candidate.unloadChunk);//zero for deactivate
                needToUpdatePageMipLevelTable[candidate.unloadMipLevel] = true;
            }
            RenderAndUpdateTile(candidate.currentMipLevel, candidate.currentChunk, candidate.currentTile);
            ActivatePageMipLevelTable(candidate.currentMipLevel, candidate.currentChunk, candidate.currentTile.Value.tileIndex);//one for activate
            needToUpdatePageMipLevelTable[candidate.currentMipLevel] = true;
            needToUpdateTextureArrayArray[candidate.currentMipLevel] = true;
        }

        //2.Update the textures that are changed during this frame. This can be moved in 3.
        for (int i = 0; i <= mipLevelMax; i++)
        {
            if (needToUpdatePageMipLevelTable[i])
            {
                //pageMipLevelTable[i].texture.Apply(false);
                pageMipLevelTable[i].texture64.Apply(false);
            }

            if (needToUpdateTextureArrayArray[i])
            {
                //DEBUG
                textureArrayArray[i].GenerateMips();//generate mipmaps for the entire 2d texture array
                normalArrayArray[i].GenerateMips();//generate mipmaps for the entire 2d texture array
            }
        }

        //3.If the tasks which were enqueued at the same batch are finished, 
        //update the current sector in shader so that changes can be shown
        if (candidatesSize > 0)
        {
            candidateInitialCount -= candidatesSize;

            if (candidateInitialCount <= 0)
            {
                Vector2Int xz = SectorToXZ(cameraSector);
                mTerrainMaterial.SetInt("_CurrentSectorX", xz.x);
                mTerrainMaterial.SetInt("_CurrentSectorY", xz.y);
            }
        }
        
    }

    void Initialize()
    {
        //assuming terrains' size are same

        mTerrainCount = mTerrains.Length;

        terrainWidth = mTerrains[0].terrainData.size.x;
        terrainLength = mTerrains[0].terrainData.size.z;//not y

        terrainWidthTotal = terrainWidth * terrainCountX;
        terrainLengthTotal = terrainLength * terrainCountZ;

        sectorCountX = terrainCountX * sectorCountXPerTerrain;
        sectorCountZ = terrainCountZ * sectorCountZPerTerrain;

        tasks = new Queue<Task>();
        
        InitializeQuadMesh();
        
        mRenderTextureMaterials = new Material[mTerrainCount];
        for(int i = 0;i<mTerrainCount;i++)
        {
            mRenderTextureMaterials[i] = InitializeRenderMaterial(mTerrains[i]);
        }

        InitializeTerrainMaterial();

        InitializeDecalMaterial();

        ReactivateDecals(false);

        updateRadius = CalculateRadius(mipLevelMax - 1) + 1;

        Debug.Log("MAX_RESOLUTION = " + tileWidth  / (sectorWidth * sectorPerTileX) + " x " + tileHeight  / (sectorLength * sectorPerTileY));

        //////////////////////////////////
        ///////////////NEW////////////////
        for(int i = 0;i<mTerrainCount;i++)
        {
            mTerrains[i].gameObject.SetActive(false);
            mTargetTerrains[i].gameObject.SetActive(true);
        }
        Shader.WarmupAllShaders();
        ///////////////NEW////////////////
        //////////////////////////////////
    }

    void InitializePageMipLevelTable()
    {
        pageTableTileCountX = sectorCountX / sectorPerTileX;
        pageTableTileCountY = sectorCountZ / sectorPerTileY;

        pageMipLevelTable = new MipLevel[mipLevelMax + 1];
        for (int i = 0; i < mipLevelMax; i++)
        {
            pageMipLevelTable[i] = new MipLevel(Mathf.Max(1, sectorCountX /(sectorPerTileX << i)),
                                                Mathf.Max(1, sectorCountZ /(sectorPerTileY << i)));
        }
        
        //it seems the reason for the spike that Gfx.WaitForPresent created is Apply() of a large texture
        //not because the long Texture2DArray form RenderTexture, so no need to hard code the length to 64
        //UPDATE: After disabling apply, the Gfx.WaitForPresent is still there, causing spikes in the profiler.
        //A possible reason is the pageMipLevelTable Texture2D textures are too large.
        pageMipLevelTable[mipLevelMax] = new MipLevel(terrainCountX * mipLevelMaxTileCountPerTerrainX, terrainCountZ * mipLevelMaxTileCountPerTerrainY);//hard coded
    }

    void InitializeTextureArray()
    {
        int totalTileCount = 0;
        textureArrayArray = new CustomRenderTexture[mipLevelMax + 1];
        normalArrayArray = new CustomRenderTexture[mipLevelMax + 1];
        tileCounts = new int[mipLevelMax + 1];
        for (int i = 0; i <= mipLevelMax; i++)
        {
            int diameter = CalculateDiameter(i);
            Debug.Log("diameter " + i + " = " + diameter);
            tileCounts[i] = Mathf.Max(tileCount, (i == mipLevelMax ?
                                                  pageMipLevelTable[mipLevelMax].count ://all tiles in max level must be resident
                                                  tileCountExtra + ((diameter + (sectorPerTileX << i) - 1) / (sectorPerTileX << i) + 1) *
                                                                   ((diameter + (sectorPerTileY << i) - 1) / (sectorPerTileY << i) + 1)));//only nearby tiles must be resident


            textureArrayArray[i] = new CustomRenderTexture(tileWidth, tileHeight, RenderTextureFormat.ARGB32, RenderTextureReadWrite.sRGB);//16 bit depth buffer
            textureArrayArray[i].dimension = UnityEngine.Rendering.TextureDimension.Tex2DArray;
            textureArrayArray[i].volumeDepth = tileCounts[i];
            textureArrayArray[i].wrapMode = TextureWrapMode.Clamp;
            textureArrayArray[i].useMipMap = true;
            textureArrayArray[i].autoGenerateMips = false;
            textureArrayArray[i].filterMode = FilterMode.Trilinear;
            textureArrayArray[i].Create();
            //textureArray.anisoLevel = 16;//doesn't work 

            normalArrayArray[i] = new CustomRenderTexture(tileWidth, tileHeight, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);//16 bit depth buffer
            normalArrayArray[i].dimension = UnityEngine.Rendering.TextureDimension.Tex2DArray;
            normalArrayArray[i].volumeDepth = tileCounts[i];
            normalArrayArray[i].wrapMode = TextureWrapMode.Clamp;
            normalArrayArray[i].useMipMap = true;//default to false
            normalArrayArray[i].autoGenerateMips = false;
            normalArrayArray[i].filterMode = FilterMode.Trilinear;
            normalArrayArray[i].Create();

            totalTileCount += tileCounts[i];
        }

        Debug.Log("totalTileCount:" + totalTileCount);
        for(int i = 0;i<=mipLevelMax;i++)
        {
            Debug.Log("mip " + i + " tile count : " + tileCounts[i]);
        }
    }

    void InitializeSectorsAndTileList()
    {
        sectorWidth = terrainWidthTotal / sectorCountX;
        sectorLength = terrainLengthTotal / sectorCountZ;
        sectorCount = sectorCountX * sectorCountZ;
        sectors = new Sector[sectorCount];
        for (int i = 0; i < sectorCount; i++)
        {
            sectors[i] = new Sector(-1);
        }

        tilesList = new LinkedList<Tile>[mipLevelMax + 1];
        for (int j = 0; j <= mipLevelMax; j++)
        {
            tilesList[j] = new LinkedList<Tile>();
            for (int i = 0; i < tileCounts[j]; i++)
            {
                tilesList[j].AddLast(new Tile(i, -1, -1));
            }
        }
    }

    bool IfTextureHasAlpha(Texture2D tex)
    {
        //Stupid Unity terrain fucking bullshit, if the texture has alpha, the smoothness can be found
        //in the picture, so this value is zero. If the texture does not have alpha, the initial value for
        //smoothness is still zero. It doesn't tell you which situation it is. In the shader, you want
        //the ones who have alpha set this value as one, those who don't have alphas set this value as it is.

        //TextureImporter texImporter = (TextureImporter)TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(tex));
        //if (texImporter.DoesSourceTextureHaveAlpha()) return true;
        //else return false;

        //Can't use the code above since UnityEditor can only be used in Editor mode not in a build
        if (tex.format == TextureFormat.DXT5)//DXT5 has alpha
            return true;
        else//DXT1 does not have alpha, other formats are treated as not having alpha
            return false;
    }

    Material InitializeRenderMaterial(Terrain mTerrain)
    {
        Material mRenderTextureMaterial = new Material(mRenderTextureShader);

        //support 2 control maps and 8 splat textures maximum
        int controlShitCount = Mathf.Min(mTerrain.terrainData.alphamapTextures.Length, 3);
        int shitCount = Mathf.Min(mTerrain.terrainData.splatPrototypes.Length, 12);

        for (int i = 0; i < controlShitCount; i++)
        {
            mRenderTextureMaterial.SetTexture("_ControlShit" + i, mTerrain.terrainData.alphamapTextures[i]);
        }

        for (int i = 0; i < shitCount; i++)
        {
            mRenderTextureMaterial.SetTexture("_Shit" + i, mTerrain.terrainData.splatPrototypes[i].texture);
            mRenderTextureMaterial.SetTexture("_NormalShit" + i, mTerrain.terrainData.splatPrototypes[i].normalMap);

            //Stupid Unity terrain fucking bullshit, if the texture has alpha, the smoothness can be found
            //in the picture, so this value is zero. If the texture does not have alpha, the initial value for
            //smoothness is still zero. It doesn't tell you which situation it is. In the shader, you want
            //the ones who have alpha set this value as one, those who don't have alphas set this value as it is.
            if (IfTextureHasAlpha(mTerrain.terrainData.splatPrototypes[i].texture))
                mRenderTextureMaterial.SetFloat("_Smoothness" + i, 1);
            else
                mRenderTextureMaterial.SetFloat("_Smoothness" + i, mTerrain.terrainData.splatPrototypes[i].smoothness);

            mRenderTextureMaterial.SetFloat("_Metallic" + i, mTerrain.terrainData.splatPrototypes[i].metallic);

            Vector2 Shit_S = mTerrain.terrainData.splatPrototypes[i].tileSize;//not in uv unit but in world unit, need to divide it by the terrain size
            Vector2 Shit_T = mTerrain.terrainData.splatPrototypes[i].tileOffset;//not in uv unit but in world unit, need to divide it by the terrain size

            Vector4 Shit_ST = new Vector4(terrainWidth / Shit_S.x,
                                          terrainLength / Shit_S.y,
                                          Shit_T.x / Shit_S.x,
                                          Shit_T.y / Shit_S.y);

            mRenderTextureMaterial.SetVector("_Shit" + i + "_ST", Shit_ST);
        }

        return mRenderTextureMaterial;
    }

    void InitializeTerrainMaterial()
    {
        //order is important
        InitializePageMipLevelTable();
        InitializeTextureArray();
        InitializeSectorsAndTileList();

        //if not set in the editor, set to default
        if (mipScales.Length <= 0)
        {
            mipScales = new float[mipLevelMax + 1];
            if (mipLevelMax >= 0) mipScales[0] = 1.0f;
            if (mipLevelMax >= 1) mipScales[1] = 1.0f;
            if (mipLevelMax >= 2) mipScales[2] = 1.0f;
            if (mipLevelMax >= 3) mipScales[3] = 1.0f;
            if (mipLevelMax >= 4) mipScales[4] = 1.0f;
            if (mipLevelMax >= 5) mipScales[5] = 1.0f;
            if (mipLevelMax >= 6) mipScales[6] = 1.0f;
        }

        mTerrainMaterial = new Material(mTerrainShader);
        for(int i = 0;i<mTerrainCount;i++)
        {
            /////////////////////////////////////////////////////////////
            ////////////////////////////NEW//////////////////////////////
            mTargetTerrains[i].materialType = Terrain.MaterialType.Custom;
            mTargetTerrains[i].materialTemplate = mTerrainMaterial;
            //mTerrains[i].materialType = Terrain.MaterialType.Custom;
            //mTerrains[i].materialTemplate = mTerrainMaterial;
            ////////////////////////////NEW//////////////////////////////
            /////////////////////////////////////////////////////////////
        }

        for (int i = 0; i <= mipLevelMax; i++)
        {
            //mTerrainMaterial.SetTexture("_PageMipLevelTable_" + i, pageMipLevelTable[i].texture);
            mTerrainMaterial.SetTexture("_PageMipLevelTable_" + i, pageMipLevelTable[i].texture64);
            mTerrainMaterial.SetTexture("_TextureArray_" + i, textureArrayArray[i]);
            mTerrainMaterial.SetTexture("_NormalArray_" + i, normalArrayArray[i]);
            mTerrainMaterial.SetInt("_TileCount_" + i, tileCounts[i]);
            mTerrainMaterial.SetFloat("_MipScale_" + i, mipScales[i]);
            mTerrainMaterial.SetInt("_PageTableTileCountX_" + i, pageMipLevelTable[i].countX);
            mTerrainMaterial.SetInt("_PageTableTileCountY_" + i, pageMipLevelTable[i].countY);
        }
        mTerrainMaterial.SetFloat("_BorderScaleX", borderOffset / tileWidth);
        mTerrainMaterial.SetFloat("_BorderScaleY", borderOffset / tileHeight);
        mTerrainMaterial.SetFloat("_TerrainSizeX", terrainWidth);
        mTerrainMaterial.SetFloat("_TerrainSizeZ", terrainLength);
        mTerrainMaterial.SetInt("_TerrainCountX", terrainCountX);
        mTerrainMaterial.SetInt("_TerrainCountZ", terrainCountZ);
        mTerrainMaterial.SetInt("_SectorCountX", sectorCountX);
        mTerrainMaterial.SetInt("_SectorCountY", sectorCountZ);
        mTerrainMaterial.SetInt("_PageTableTileCountX", pageTableTileCountX);
        mTerrainMaterial.SetInt("_PageTableTileCountY", pageTableTileCountY);
        mTerrainMaterial.SetInt("_MipLevelMax", mipLevelMax);
        mTerrainMaterial.SetInt("_MipInitial", mipInitial);
        mTerrainMaterial.SetInt("_MipDifference", mipDifference);
        mTerrainMaterial.SetInt("_TileCount", tileCount);
        mTerrainMaterial.SetInt("_DebugMode", debugMode);
        mTerrainMaterial.SetInt("_DebugArrayIndex", debugArrayIndex);
        mTerrainMaterial.SetInt("_DebugShowNormal", debugShowNormal);
    }

    void InitializeDecalMaterial()
    {
        //order is important
        mDecalMaterial = new Material(mDecalShader);
        mDecalMaterial.enableInstancing = true;
        InitializeDecals();
        mDecalMaterial.SetTexture("_DecalTexture", mDecalAtlas);
        mDecalMaterial.SetTexture("_DecalTextureNormal", mDecalAtlasNormal);
    }

    //If you use this in your project, you'd better store this information 
    //somewhere else offline and read that file instead of acquiring the 
    //information by find objects
    void InitializeDecals()
    {
        DynamicDecalsScripts = FindObjectsOfType<ProjectionRenderer>();

        decalArray = new Decal[DynamicDecalsScripts.Length];
        for (int i = 0; i < DynamicDecalsScripts.Length; i++)
        {
            float rot = DynamicDecalsScripts[i].transform.eulerAngles.y - DynamicDecalsScripts[i].transform.eulerAngles.z;
            decalArray[i] = new Decal();

            //currently only care about general decal properties
            Metallic metallicProjection = (Metallic)DynamicDecalsScripts[i].Projection;
            if(metallicProjection.albedo.Texture != null) decalArray[i].albedo = (Texture2D)metallicProjection.albedo.Texture;//read texture from DynamicDecals
            if(metallicProjection.normal.Texture != null) decalArray[i].normal = (Texture2D)metallicProjection.normal.Texture;//read texture from DynamicDecals
            decalArray[i].normalStrength = metallicProjection.normal.Strength;
            decalArray[i].priority = metallicProjection.Priority;

            decalArray[i].origin = new Vector2(DynamicDecalsScripts[i].transform.position.x, DynamicDecalsScripts[i].transform.position.z);
            decalArray[i].size = new Vector2(DynamicDecalsScripts[i].transform.localScale.x, DynamicDecalsScripts[i].transform.localScale.y);//local could be a problem
            decalArray[i].rot = rot;
            decalArray[i].pos[0] = decalArray[i].origin + Rotate(new Vector2(-decalArray[i].size.x / 2.0f, decalArray[i].size.y / 2.0f), rot);//-1,1
            decalArray[i].pos[1] = decalArray[i].origin + Rotate(new Vector2(-decalArray[i].size.x / 2.0f, -decalArray[i].size.y / 2.0f), rot);//-1,-1
            decalArray[i].pos[2] = decalArray[i].origin + Rotate(new Vector2(decalArray[i].size.x / 2.0f, -decalArray[i].size.y / 2.0f), rot);//1,-1
            decalArray[i].pos[3] = decalArray[i].origin + Rotate(new Vector2(decalArray[i].size.x / 2.0f, decalArray[i].size.y / 2.0f), rot);//1,1

            decalArray[i].aabb = new Vector4(Mathf.Infinity, Mathf.NegativeInfinity,
                                             Mathf.Infinity, Mathf.NegativeInfinity);//bouding box of the decal

            for (int v = 0; v < 4; v++)
            {
                if (decalArray[i].pos[v].x < decalArray[i].aabb.x) decalArray[i].aabb.x = decalArray[i].pos[v].x;//xMin
                if (decalArray[i].pos[v].x > decalArray[i].aabb.y) decalArray[i].aabb.y = decalArray[i].pos[v].x;//xMax
                if (decalArray[i].pos[v].y < decalArray[i].aabb.z) decalArray[i].aabb.z = decalArray[i].pos[v].y;//yMin
                if (decalArray[i].pos[v].y > decalArray[i].aabb.w) decalArray[i].aabb.w = decalArray[i].pos[v].y;//yMax
            }
            
        }


        GenerateDecalAtlas();
        GatherDecals();
    }

    void ReactivateDecals(bool active)
    {
        foreach (var item in DynamicDecalsScripts)
        {
            item.gameObject.SetActive(active);
        }
    }

    void GenerateDecalAtlas()
    {
        decalAtlasList = new List<Texture2D>();
        decalAtlasListNormal = new List<Texture2D>();

        for(int i  = 0;i<decalArray.Length;i++)
        {
            if(decalArray[i].albedo!=null && !decalAtlasList.Contains(decalArray[i].albedo))
            {
                decalAtlasList.Add(decalArray[i].albedo);
            }

            if (decalArray[i].normal!=null && !decalAtlasListNormal.Contains(decalArray[i].normal))
            {
                decalAtlasListNormal.Add(decalArray[i].normal);
            }
        }

        mDecalAtlas = new Texture2D(decalAtlasMaxResolution, decalAtlasMaxResolution);//it is not necessarily this size after packing
        mDecalAtlasNormal = new Texture2D(decalAtlasMaxResolution, decalAtlasMaxResolution);//it is not necessarily this size after packing

        decalRectArray = mDecalAtlas.PackTextures(decalAtlasList.ToArray(), 0, decalAtlasMaxResolution);
        decalRectArrayNormal = mDecalAtlasNormal.PackTextures(decalAtlasListNormal.ToArray(), 0, decalAtlasMaxResolutionNormal);
        
        mDecalAtlas.Apply();
        mDecalAtlasNormal.Apply();
    }

    void InitializeQuadMesh()
    {
        List<Vector3> quadVertexList = new List<Vector3>();
        List<int> quadTriangleList = new List<int>();
        List<Vector2> quadUVList = new List<Vector2>();

        quadVertexList.Add(new Vector3(-1, 1, 0.1f));
        quadUVList.Add(new Vector2(0, 0));
        quadVertexList.Add(new Vector3(-1, -1, 0.1f));
        quadUVList.Add(new Vector2(0, 1));
        quadVertexList.Add(new Vector3(1, -1, 0.1f));
        quadUVList.Add(new Vector2(1, 1));
        quadVertexList.Add(new Vector3(1, 1, 0.1f));
        quadUVList.Add(new Vector2(1, 0));

        quadTriangleList.Add(0);
        quadTriangleList.Add(1);
        quadTriangleList.Add(2);

        quadTriangleList.Add(2);
        quadTriangleList.Add(3);
        quadTriangleList.Add(0);

        mQuad = new Mesh();
        mQuad.SetVertices(quadVertexList);
        mQuad.SetUVs(0, quadUVList);
        mQuad.SetTriangles(quadTriangleList, 0);
    }

    int GetSector(float x, float z)
    {
        int currentSectorX = (int)(x / sectorWidth);//assuming x are all positive
        int currentSectorZ = (int)(z / sectorLength);//assuming z are all positive
        return currentSectorZ * sectorCountX + currentSectorX;
    }

    Vector2Int SectorXzToChunkXz(Vector2Int XZ, int chunkCountX, int chunkCountZ)
    {
        //This is fucking stupid, float point error always finds its way to get you
        //float x = XZ.x / (float)sectorCountX;
        //float y = XZ.y / (float)sectorCountZ;

        //return new Vector2Int((int)(x * chunkCountX),
        //                      (int)(y * chunkCountZ));

        return new Vector2Int((int)(XZ.x * (chunkCountX / (float)sectorCountX)),
                              (int)(XZ.y * (chunkCountZ / (float)sectorCountZ)));
    }

    //TO DO: This function is not functional
    //FIXED
    int SectorIndexToChunkIndex(int sectorIndex, int chunkCountX, int chunkCountZ)
    {
        Vector2Int xz = SectorXzToChunkXz(SectorToXZ(sectorIndex), chunkCountX, chunkCountZ);
        return xz.y * chunkCountX + xz.x;
    }

    Vector2Int SectorToXZ(int currentSector)
    {
        Vector2Int XZ = new Vector2Int(currentSector % sectorCountX, currentSector / sectorCountX);
        return XZ;
    }

    int XzToSector(int x, int z)
    {
        return x + z * sectorCountX;
    }

    Vector2Int GetManhattanDistance(int from, int to)
    {
        Vector2Int fromXZ = SectorToXZ(from);
        Vector2Int toXZ = SectorToXZ(to);
        Vector2Int ManhattanDistance = new Vector2Int(Mathf.Abs(toXZ.x - fromXZ.x), Mathf.Abs(toXZ.y - fromXZ.y));
        return ManhattanDistance;
    }

    void UpdateSectors(int currentSector, int radius)
    {
        //1.unload unnecessary tiles
        //NOT NECESSARY, THEY ARE ALREADY BEHIND EMPTY TILES AND INFRONT OF NECESSARY TILES.
        //THEY WILL BE REUSED AFTER RUNNING OUT OF EMPTY TILES, E.G.
        //INITIAL STATE
        //|------------------------EMPTY-----------------------------|
        //
        //AFTER FIRST UPDATE
        //|-----------------EMPTY----------------|-----NECESSARY-----|
        //
        //AFTER SECOND UPDATE
        //|--EMPTY--|--UNNECESSARY--|-----------NECESSARY------------|
        //
        //AFTER THIRD UPDATE
        //|-----UNNECESSARY-----|-------------NECESSARY--------------|

        //2.load necessary tiles
        if (radius > 0)//update a small region
        {
            Vector2Int currentSectorXZ = SectorToXZ(currentSector);
            for (int p = -radius; p <= radius; p++)
            {
                if (currentSectorXZ.x + p < 0)
                {
                    p += -(currentSectorXZ.x + p) - 1;//skip negative values
                    continue;
                }
                if (currentSectorXZ.x + p >= sectorCountX)
                    break;

                for (int q = -radius; q <= radius; q++)
                {
                    if (currentSectorXZ.y + q < 0)
                    {
                        q += -(currentSectorXZ.y + q) - 1;//skip negative values
                        continue;
                    }
                    if (currentSectorXZ.y + q >= sectorCountZ)
                        break;

                    int i = XzToSector(currentSectorXZ.x + p, currentSectorXZ.y + q);
                    UpdateSector(currentSector, i);
                }
            }
        }
        else//update all sectors
        {
            for (int i = 0; i < sectorCount; i++)
            {
                UpdateSector(currentSector, i);
            }
        }
    }

    int CalculateMipLevel(int currentSector, int i)
    {
        //original, if you change this, do not forget to change diameter 
        //calculation and mip calculation in the shader
        Vector2Int ManhattanDistance = GetManhattanDistance(currentSector, i);
        int absX = Mathf.Abs(ManhattanDistance.x);
        int absY = Mathf.Abs(ManhattanDistance.y);
        int absMax = Mathf.Max(absX, absY);
        int tempMipLevel = (int)Mathf.Floor((-2.0f * mipInitial - mipDifference +
                                                Mathf.Sqrt(8.0f * mipDifference * absMax +
                                                    (2.0f * mipInitial - mipDifference) *
                                                    (2.0f * mipInitial - mipDifference)))
                                            / (2.0f * mipDifference)) + 1;
        tempMipLevel = Mathf.Clamp(tempMipLevel, 0, mipLevelMax);

        return tempMipLevel;
    }

    int CalculateRadius(int mipLevel)
    {
        int r = (2 * mipInitial + mipLevel * mipDifference) * (mipLevel + 1) / 2;
        return r;
    }

    int CalculateDiameter(int mipLevel)
    {
        int r = CalculateRadius(mipLevel);
        return r * 2 - 1;// (r - 1) * 2 + 1;
    }

    void ClearTasks()
    {
        int count = tasks.Count;
        for(int i = 0;i<count;i++)
        {
            Task temp = tasks.Dequeue();
            if(temp.unloadMipLevel!=-1&&temp.unloadChunk!=-1)
            {
                pageMipLevelTable[temp.unloadMipLevel].chunks[temp.unloadChunk].node = temp.currentTile;
                pageMipLevelTable[temp.unloadMipLevel].chunks[temp.unloadChunk].inTexture = true;
            }
            pageMipLevelTable[temp.currentMipLevel].chunks[temp.currentChunk].inQueue = false;
            tilesList[temp.currentMipLevel].AddFirst(temp.currentTile);
        }
    }

    void DistributeTile(int i, int tempMipLevel)
    {
        LinkedList<Tile> rotatedList = null;
        LinkedListNode<Tile> rotatedNode = null;

        int chunkIndex = SectorIndexToChunkIndex(i, pageMipLevelTable[tempMipLevel].countX, pageMipLevelTable[tempMipLevel].countY);
        
        rotatedList = tilesList[tempMipLevel];
        
        //Use inQueue and inTexture to test whether need to enqueue the task
        if (pageMipLevelTable[tempMipLevel].chunks[chunkIndex].inQueue)
        {
            //do nothing
        }
        else if(pageMipLevelTable[tempMipLevel].chunks[chunkIndex].inTexture)
        {
            //TILE ALREADY IN TEXTURE ARRAY
            rotatedList.Remove(pageMipLevelTable[tempMipLevel].chunks[chunkIndex].node);
            rotatedList.AddLast(pageMipLevelTable[tempMipLevel].chunks[chunkIndex].node);
        }
        else
        {
            //TILE NOT IN TEXTURE ARRAY
            rotatedNode = rotatedList.First;//use the least recently used one

            int unloadMipLevel = -1;
            int unloadChunk = -1;
            
            //Use inQueue and inTexture to test whether need to enqueue the task
            //If the node is previously assigned to a chunk, set the original chunk who points this tile to null
            if (rotatedNode.Value.mipLevel >= 0 && rotatedNode.Value.mipLevel <= mipLevelMax &&
                rotatedNode.Value.node >= 0 && rotatedNode.Value.node < pageMipLevelTable[rotatedNode.Value.mipLevel].count &&
                pageMipLevelTable[rotatedNode.Value.mipLevel].chunks[rotatedNode.Value.node].inTexture)
            {
                //If the linked list is not large enough, this will set a needed tile to null, 
                //but the task is still in the queue. This will cause error in the actual rendering 
                //function, which is good because you can know the tile size is not long enough

                //set the original chunk who points this tile to null
                unloadMipLevel = rotatedList.First.Value.mipLevel;
                unloadChunk = rotatedList.First.Value.node;

                //set these here to avoid incorrectlly assuming these soon-to-be rotated tiles are inTexture, 
                //but we should also set these back if we clear tasks to keep only one copy of these
                pageMipLevelTable[rotatedList.First.Value.mipLevel].chunks[rotatedList.First.Value.node].node = null;
                pageMipLevelTable[rotatedList.First.Value.mipLevel].chunks[rotatedList.First.Value.node].inTexture = false;
            }
            
            rotatedList.RemoveFirst();
            
            tasks.Enqueue(new Task(tempMipLevel, chunkIndex, rotatedNode, unloadMipLevel, unloadChunk));//update sparse texture(and pageMipLevelTable)
            pageMipLevelTable[tempMipLevel].chunks[chunkIndex].inQueue = true;
        }

    }

    void UpdateSector(int currentSector, int i)
    {
        int tempMipLevel = CalculateMipLevel(currentSector, i);
        
        DistributeTile(i, tempMipLevel);

        sectors[i].lastMipLevel = tempMipLevel;//put this here to be safe
    }

    void RenderAndUpdateTile(int mipLevel, int chunkIndex, LinkedListNode<Tile> tileNode)
    {
        Vector2Int chunkXZ = pageMipLevelTable[mipLevel].ChunkToXZ(chunkIndex);

        int terrainIndex = chunkXZ.x / (pageMipLevelTable[mipLevel].countX / terrainCountX) + (chunkXZ.y / (pageMipLevelTable[mipLevel].countY / terrainCountZ)) * terrainCountX;
        
        Vector4 tileST = new Vector4(terrainCountX / (float)pageMipLevelTable[mipLevel].countX + 2.0f * borderOffset * terrainCountX / (pageMipLevelTable[mipLevel].countX * (float)tileWidth),
                                     terrainCountZ / (float)pageMipLevelTable[mipLevel].countY + 2.0f * borderOffset * terrainCountZ / (pageMipLevelTable[mipLevel].countY * (float)tileHeight),
                                     (chunkXZ.x % (pageMipLevelTable[mipLevel].countX / terrainCountX)) / (float)(pageMipLevelTable[mipLevel].countX / terrainCountX) - borderOffset * terrainCountX / (pageMipLevelTable[mipLevel].countX * (float)tileWidth),
                                     (chunkXZ.y % (pageMipLevelTable[mipLevel].countY / terrainCountZ)) / (float)(pageMipLevelTable[mipLevel].countY / terrainCountZ) - borderOffset * terrainCountZ / (pageMipLevelTable[mipLevel].countY * (float)tileHeight));

        mRenderTextureMaterials[terrainIndex].SetVector("_Tile_ST", tileST);

        ///////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////NEW///////////////////////////////////////
        //textureArrayArray[mipLevel].material = mRenderTextureMaterials[terrainIndex];
        //textureArrayArray[mipLevel].Update();
        /////////////////////////////////////NEW///////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////

        //If the pageMipLevelTable is not large enough, this will set an necessary tile to null, 
        //but the task is still in the queue. This will cause error in the actual rendering 
        //function, which is good because you can know the tile size is not long enough

        //Use tileCountExtra to enlarge the linkedlist, this will grant more leeway to the rotation
        //algorithm and hopefully when you allocating the new tile, the spare nodes in the linkedlist
        //is abundant enough that you won't allocate those in the queue waiting for being rendered. 
        //Alternatively, you can create your own smart implementation to solve this puzzle

        RenderBuffer[] colorBuffers = new RenderBuffer[2];
        RenderBuffer depthBuffer = textureArrayArray[mipLevel].depthBuffer;
        colorBuffers[0] = textureArrayArray[mipLevel].colorBuffer;
        colorBuffers[1] = normalArrayArray[mipLevel].colorBuffer;
        RenderTargetSetup rts = new RenderTargetSetup(colorBuffers, depthBuffer, 0, CubemapFace.Unknown);
        rts.depthSlice = tileNode.Value.tileIndex;
        Graphics.SetRenderTarget(rts);//DEBUG

        //We are using command buffer here to bypass the problem that the regular DrawMeshInstanced must 
        //be used with a camera and SetRenderTarget doesn't affect it.
        //We are not using command buffer for performance, because creating command buffer every frame 
        //will not make the rendering faster. However we need to change the command every frame, since
        //the matrix list is not guairanteed to remain same every time. 
        //So we are creating command buffer just to use CommandBuffer.DrawMeshInstanced.
        CommandBuffer tempCB = new CommandBuffer();
        tempCB.ClearRenderTarget(true, true, Color.black, 1);
        tempCB.DrawMesh(mQuad, Matrix4x4.identity, mRenderTextureMaterials[terrainIndex]);

        if (pageMipLevelTable[mipLevel].chunks[chunkIndex].decalMatrixList.Count > 0)
        {
            //Set Graphics Instance Variants to Keep All if this draw call doesn't work
            tempCB.DrawMeshInstanced(mQuad, 0, mDecalMaterial, 0, pageMipLevelTable[mipLevel].chunks[chunkIndex].decalMatrixList.ToArray());
        }

        Graphics.ExecuteCommandBuffer(tempCB);//DEBUG

        pageMipLevelTable[mipLevel].chunks[chunkIndex].node = tileNode;
        pageMipLevelTable[mipLevel].chunks[chunkIndex].node.Value.mipLevel = mipLevel;
        pageMipLevelTable[mipLevel].chunks[chunkIndex].node.Value.node = chunkIndex;
        pageMipLevelTable[mipLevel].chunks[chunkIndex].inTexture = true;
        pageMipLevelTable[mipLevel].chunks[chunkIndex].inQueue = false;

        tilesList[mipLevel].AddLast(tileNode);
    }

    void ActivatePageMipLevelTable(int mipLevel, int chunkIndex, int tileIndex)
    {
        Vector2Int xz = pageMipLevelTable[mipLevel].ChunkToXZ(chunkIndex);
        
        pageMipLevelTable[mipLevel].SetPixel(xz.x,
                                             xz.y,
                                             new Color(xz.x / (float)(pageMipLevelTable[mipLevel].countX),//tile start uv coordinates in page table
                                                       xz.y / (float)(pageMipLevelTable[mipLevel].countY),//tile start uv coordinates in page table
                                                       tileIndex / (float)tileCounts[mipLevel],//tile index ratio in textureArray));
                                                       1));//1 for resident, 0 for not resident
    }

    void DeactivatePageMipLevelTable(int mipLevel, int chunkIndex)
    {
        Vector2Int xz = pageMipLevelTable[mipLevel].ChunkToXZ(chunkIndex);
        
        pageMipLevelTable[mipLevel].SetPixel(xz.x,
                                             xz.y,
                                             new Color(0,
                                                       0,
                                                       0,
                                                       0));//1 for resident, 0 for not resident
    }

    Vector2 Rotate(Vector2 v, float radian)
    {
        float cos = Mathf.Cos(radian * Mathf.Deg2Rad);
        float sin = Mathf.Sin(radian * Mathf.Deg2Rad);
        return new Vector2(v.x * cos - v.y * sin, v.x * sin + v.y * cos);
    }

    void GatherDecals()
    {

        for (int j = 0; j <= mipLevelMax; j++)
        {
            float chunkWidthInUnit = terrainWidthTotal / pageMipLevelTable[j].countX;
            float chunkLengthInUnit = terrainLengthTotal / pageMipLevelTable[j].countY;

            for (int k = 0; k < pageMipLevelTable[j].count; k++)
            {
                Vector2 chunckOrigin = pageMipLevelTable[j].ChunkToXZ(k);
                chunckOrigin.x = (chunckOrigin.x + 0.5f) * chunkWidthInUnit;
                chunckOrigin.y = (chunckOrigin.y + 0.5f) * chunkLengthInUnit;

                for (int i = 0; i < decalArray.Length; i++)
                {
                    if (DecalInChunk(decalArray[i].aabb, i, j, k))
                    {
                        float cos = Mathf.Cos(decalArray[i].rot * Mathf.Deg2Rad);
                        float sin = Mathf.Sin(decalArray[i].rot * Mathf.Deg2Rad);
                        float factorX = decalArray[i].size.x / chunkWidthInUnit;
                        float factorY = decalArray[i].size.y / chunkLengthInUnit;
                        float offsetX = (decalArray[i].origin.x - chunckOrigin.x) / chunkWidthInUnit * 2;//2 is because the length of the quad is 2
                        float offsetY = -(decalArray[i].origin.y - chunckOrigin.y) / chunkLengthInUnit * 2;//2 is because the length of the quad is 2, negative is because screen space y point downwards
                        
                        int index = decalAtlasList.IndexOf(decalArray[i].albedo);
                        int indexNormal = decalAtlasListNormal.IndexOf(decalArray[i].normal);
                        Matrix4x4 dataMat = new Matrix4x4();

                        dataMat.SetColumn(0, new Vector4(cos, sin, offsetX, offsetY));
                        dataMat.SetColumn(1, new Vector4(factorX, factorY, 0, decalArray[i].priority));//one spare value left

                        if (decalRectArray.Length > 0)//if there is at least one texture in the atlas, any index can be found, because we stored them manually
                        {
                            dataMat.SetColumn(2, new Vector4(decalRectArray[index].width,
                                                             decalRectArray[index].height,
                                                             decalRectArray[index].xMin,
                                                             decalRectArray[index].yMin));
                        }
                        else
                        {
                            dataMat.SetColumn(2, new Vector4(-1, -1, -1, -1));//use negative value to indicate it's invalid
                        }

                        if (decalRectArrayNormal.Length > 0)//if there is at least one texture in the atlas, any index can be found, because we stored them manually
                        {
                            dataMat.SetColumn(3, new Vector4(decalRectArrayNormal[indexNormal].width,
                                                             decalRectArrayNormal[indexNormal].height,
                                                             decalRectArrayNormal[indexNormal].xMin,
                                                             decalRectArrayNormal[indexNormal].yMin));

                        }
                        else
                        {
                            dataMat.SetColumn(3, new Vector4(-1, -1, -1, -1));//use negative value to indicate it's invalid
                        }
                        
                        pageMipLevelTable[j].chunks[k].decalMatrixList.Add(dataMat);
                    }
                }
                
            }

        }
    }

    bool DecalInChunk(Vector4 decalBoundingBox, int decalIndex, int mipLevel, int chunkIndex)
    {
        Vector2 xz = pageMipLevelTable[mipLevel].ChunkToXZ(chunkIndex);

        float xMinChunk = xz.x * terrainWidthTotal / pageMipLevelTable[mipLevel].countX;
        float xMaxChunk = (xz.x + 1) * terrainWidthTotal / pageMipLevelTable[mipLevel].countX;
        float yMinChunk = xz.y * terrainLengthTotal / pageMipLevelTable[mipLevel].countY;
        float yMaxChunk = (xz.y + 1) * terrainLengthTotal / pageMipLevelTable[mipLevel].countY;

        Vector2[] chunkVertex = new Vector2[4];
        chunkVertex[0] = new Vector2(xMinChunk, yMinChunk);//0,0
        chunkVertex[1] = new Vector2(xMaxChunk, yMinChunk);//1,0
        chunkVertex[2] = new Vector2(xMaxChunk, yMaxChunk);//1,1
        chunkVertex[3] = new Vector2(xMinChunk, yMaxChunk);//0,1

        if (xMinChunk > decalBoundingBox.y || xMaxChunk < decalBoundingBox.x || yMinChunk > decalBoundingBox.w || yMaxChunk < decalBoundingBox.z)
            return false;

        //whether decal vertices are in the chunk
        float areaChunk = (xMaxChunk - xMinChunk) * (yMaxChunk - yMinChunk);
        for (int i = 0; i < 4; i++)
        {
            if (InSquare(decalArray[decalIndex].pos[i],
                         chunkVertex[0],
                         chunkVertex[1],
                         chunkVertex[2],
                         chunkVertex[3],
                         areaChunk))
                return true;
        }

        //whether chunk vertices are in the decal
        float areaDecal = decalArray[decalIndex].size.x * decalArray[decalIndex].size.y;
        for (int i = 0; i < 4; i++)
        {
            if (InSquare(chunkVertex[i],
                         decalArray[decalIndex].pos[0],
                         decalArray[decalIndex].pos[1],
                         decalArray[decalIndex].pos[2],
                         decalArray[decalIndex].pos[3],
                         areaDecal))
                return true;
        }

        return false;
    }

    bool InSquare(Vector2 point, Vector2 a, Vector2 b, Vector2 c, Vector2 d, float area)
    {
        Vector3 pa = new Vector3(a.x - point.x, a.y - point.y, 0);
        Vector3 pb = new Vector3(b.x - point.x, b.y - point.y, 0);
        Vector3 pc = new Vector3(c.x - point.x, c.y - point.y, 0);
        Vector3 pd = new Vector3(d.x - point.x, d.y - point.y, 0);

        if ((Vector3.Cross(pa, pb).magnitude +
             Vector3.Cross(pb, pc).magnitude +
             Vector3.Cross(pc, pd).magnitude +
             Vector3.Cross(pd, pd).magnitude) * 0.5 > area + Mathf.Epsilon)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public class Tile
    {
        public Tile(int _tileIndex, int _mipLevel, int _node)
        {
            tileIndex = _tileIndex;
            mipLevel = _mipLevel;
            node = _node;
        }

        public int tileIndex;//coordinates in texture2darray
        public int mipLevel;
        public int node;
    }
    
    public class Decal
    {
        public Texture2D albedo;
        public Texture2D normal;
        public float priority;
        public float normalStrength;
        public Vector2[] pos;
        public Vector2 size;
        public Vector2 origin;
        public Vector4 aabb;//xMin,xMax,yMin,yMax
        public float rot;

        public Decal()
        {
            pos = new Vector2[4];
        }
    }

    public class Chunk
    {
        public LinkedListNode<Tile> node;
        public List<Matrix4x4> decalMatrixList;
        public CommandBuffer decalCB;

        public bool inQueue;
        public bool inTexture;

        public Chunk()
        {
            node = null;
            decalMatrixList = new List<Matrix4x4>();
            decalCB = new CommandBuffer();
            inQueue = false;
            inTexture = false;
        }
    }

    public class MipLevel
    {
        public int countX;
        public int countY;
        public int count;
        public Chunk[] chunks;
        //public Texture2D texture;
        public Texture2D texture64;

        public MipLevel(int _countX, int _countY)
        {
            countX = _countX;
            countY = _countY;
            count = countX * countY;
            //USE RGBAHALF TO ALLOW FOR MORE ACCURATE VALUE, NOTICE UNITY MANUEL SUGGEST SetPixel 
            //"only on RGBA32, ARGB32, RGB24 and Alpha8 texture formats. For other formats SetPixel is ignored."
            //Which is fucking bullshit
            texture64 = new Texture2D(64, 64, TextureFormat.RGBAFloat, false);//mipmap false
            texture64.filterMode = FilterMode.Point;
            texture64.wrapMode = TextureWrapMode.Repeat;

            //texture.filterMode = FilterMode.Point;
            //texture.wrapMode = TextureWrapMode.Clamp;
            chunks = new Chunk[count];
            for (int i = 0; i < count; i++)
            {
                chunks[i] = new Chunk();
            }
        }

        public void SetPixel(int x, int y, Color color)
        {
            int x64 = x % 64;
            int y64 = y % 64;
            
            texture64.SetPixel(x64, y64, color);
        }

        public Vector2Int ChunkToXZ(int index)
        {
            //Holly shiiiiiiit, how can you hide this long, boy
            //return new Vector2Int(index % countX, index / countY);

            return new Vector2Int(index % countX, index / countX);
        }
    }

    public class Sector
    {
        public int lastMipLevel;
        public Sector(int _lastMipLevel)
        {
            lastMipLevel = _lastMipLevel;
        }
    }

    public struct Task
    {
        public int currentMipLevel;
        public int currentChunk;
        public LinkedListNode<Tile> currentTile;
        public int unloadMipLevel;
        public int unloadChunk;

        public Task(int mipLevel, int chunk, LinkedListNode<Tile> tile, int uMipLevel, int uChunk)
        {
            currentMipLevel = mipLevel;
            currentChunk = chunk;
            currentTile = tile;
            unloadMipLevel = uMipLevel;
            unloadChunk = uChunk;
        }
    }

}
