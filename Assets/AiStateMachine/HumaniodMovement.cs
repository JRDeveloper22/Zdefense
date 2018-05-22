using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumaniodMovement : MonoBehaviour
{
    float MovingTurnSpeed = 180;
    float StationaryTurnSpeed = 180;
    float JumpPower = 12f;
    [Range(1f,4f)]float Gravity = 2f;
    float Run = 0.2f;
    float MoveSpeed = 1f;
    float AnimSpeed = 1f;
    float GroundCheckDistance = 0.1f;

    //anim
    public Animator Anim;
    //
    public Rigidbody rigidB;
    public bool IsGrounded;
    float OrigGroundCheckDistance;
    const float Half = 0.5f;
    float TurnAmount;
    float FowardAmount;
    Vector3 groundNormal;

	// Use this for initialization
	void Start ()
    {
        Anim = GetComponent<Animator>();
        rigidB = GetComponent<Rigidbody>();
        rigidB.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
        OrigGroundCheckDistance = GroundCheckDistance;

	}
    public void Move(Vector3 move, bool jump)
    {
        if (move.magnitude > 1f) move.Normalize();
        move = transform.InverseTransformDirection(move);
        CheckGround();
        move = Vector3.ProjectOnPlane(move, groundNormal);
        TurnAmount = Mathf.Atan2(move.x, move.z);
        FowardAmount = move.z;
        ExtraTurnRotation();
        

    }
    void ExtraTurnRotation()
    {
        float turnSpeed = Mathf.Lerp(StationaryTurnSpeed, MovingTurnSpeed, FowardAmount);
        transform.Rotate(0, TurnAmount * turnSpeed * Time.deltaTime, 0);
    }
    void CheckGround()
    {
        RaycastHit hitinfo;
#if UNITY_EDITOR
        Debug.DrawLine(transform.position + (Vector3.up * 0.1f), transform.position + (Vector3.up * 0.1f) + (Vector3.down * GroundCheckDistance));
#endif
        if (Physics.Raycast(transform.position + (Vector3.up * 0.1f), Vector3.down, out hitinfo, GroundCheckDistance))
        {
            groundNormal = hitinfo.normal;
            IsGrounded = true;
            Anim.applyRootMotion = true;
        }
        else
        {
            IsGrounded = false;
            groundNormal = Vector3.up;
            Anim.applyRootMotion = false;
        }
    }

}
