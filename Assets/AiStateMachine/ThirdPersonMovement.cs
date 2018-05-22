using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThirdPersonMovement : MonoBehaviour {
    float MovingTurnSpeed = 360;
    float StationaryTurnSpeed = 180;
    float JumpPower = 12f;
    [Range(1f, 4f)] float Gravity = 2f;
    float Run = 0.2f;
    float MoveSpeed = 1f;
    float AnimSpeed = 1f;
    float GroundCheckDistance = 0.1f;

    //anim
    Animator Anim;

    //
    Rigidbody rigidB;
    public bool IsGrounded;
    float OrigGroundCheckDistance;
    const float Half = 0.5f;
    float TurnAmount;
    float FowardAmount;
    Vector3 groundNormal;
    //capsulesize and pos;
    float CapsuleHeight;
    Vector3 capsuleCenter;
    CapsuleCollider myCapsule;
    bool Crouching;

    // Use this for initialization
    void Start()
    {
        rigidB = GetComponent<Rigidbody>();
        myCapsule = GetComponent<CapsuleCollider>();
        CapsuleHeight = myCapsule.height;
        capsuleCenter = myCapsule.center;

        rigidB.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
        OrigGroundCheckDistance = GroundCheckDistance;

    }
    public void Move(Vector3 move, bool crouch, bool jump)
    {
        if (move.magnitude > 1f) move.Normalize();
        move = transform.InverseTransformDirection(move);
        CheckGround();
        move = Vector3.ProjectOnPlane(move, groundNormal);
        TurnAmount = Mathf.Atan2(move.x, move.z);
        FowardAmount = move.z;

        ExtraTurnRotation();

        if (IsGrounded)
        {
            GroundedMovement(crouch, jump);
        }
        else
        {
            Debug.Log("jumping");
            AirborneMovement();
        }
        //scale capsule for crouch;
        WhenCrouched(move);
    }
    void WhenCrouched(Vector3 move)
    {
        //capsule sized half it
        //slow down move speed
        //half capsule size;
    }
    void AirborneMovement()
    {
        // apply extra gravity from multiplier:
        Vector3 extraGravityForce = (Physics.gravity * Gravity) - Physics.gravity;
        rigidB.AddForce(extraGravityForce);

        GroundCheckDistance = rigidB.velocity.y < 0 ? OrigGroundCheckDistance : 0.01f;
    }


    void GroundedMovement(bool crouch, bool jump)
    {
        // check whether conditions are right to allow a jump:
        if (jump && !crouch /*&& current animation is named ground */)
        {
            // jump!
            rigidB.velocity = new Vector3(rigidB.velocity.x, JumpPower, rigidB.velocity.z);
            IsGrounded = false;
            //rootmotion on animation false here
            //Anim.applyRootMotion = false;
            GroundCheckDistance = 0.1f;
        }
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
            //Anim.applyRootMotion = true;
            //applyrootmotion here
        }
        else
        {
            IsGrounded = false;
            groundNormal = Vector3.up;
            //Anim.applyRootMotion = false;
            //disableroot motion here
        }
    }

}
