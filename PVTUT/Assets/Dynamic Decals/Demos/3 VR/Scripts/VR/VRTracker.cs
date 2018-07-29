using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

namespace LlockhamIndustries.VR
{
    [RequireComponent(typeof(Rigidbody))]
    public class VRTracker : MonoBehaviour
    {
        public VRPlayspace playspace;
        public VRTarget target;
        public Vector3 offset;

        private Rigidbody rb;
        private XRNode node;

        void Start()
        {
            //Cache and setup our rigidbody
            rb = GetComponent<Rigidbody>();
            rb.isKinematic = true;

            //Cache our node
            switch (target)
            {
                case VRTarget.Head:
                    node = XRNode.Head;
                    break;
                case VRTarget.LeftHand:
                    node = XRNode.LeftHand;
                    break;
                case VRTarget.RightHand:
                    node = XRNode.RightHand;
                    break;
            }
        }
        private void FixedUpdate()
        {
            //Calculate rotation
            Quaternion rot = transform.parent.rotation * InputTracking.GetLocalRotation(node);

            if (target == VRTarget.Head)
            {
                //Convert to euler
                Vector3 headRot = rot.eulerAngles;

                //Zero our horizontal rotation
                headRot.x = 0;
                headRot.z = 0;

                //Convert back to quaternion
                rot = Quaternion.Euler(headRot);
            }

            //Calculate position
            Vector3 pos = transform.parent.position + InputTracking.GetLocalPosition(node) + (rot * offset);

            //If we have a playspace, clamp to bounds
            if (playspace != null) pos = playspace.ClampNode(pos);

            //Move rigidbody to target
            rb.MoveRotation(rot);
            rb.MovePosition(pos);
        }

        public enum VRTarget { LeftHand, RightHand, Head };
    }
}