using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathState : StateInterface<ZombieMachine>
{
    static readonly DeathState instance = new DeathState();
    public static DeathState Instance
    {
        get
        {
            return instance;
        }
    }
    public override void Enter(ZombieMachine entity)
    {
        Debug.Log("Death");
        //turn off colliders of main parent
        entity.GetComponent<Rigidbody>().isKinematic = true;
        entity.GetComponent<CapsuleCollider>().enabled = false;
        entity.GetComponent<Animator>().enabled = false;
        entity.agent.enabled = false;
        //add counter here of max bodyparts iter through all of parts
        for (int i = 0; i < entity.BodyParts.Length; i++)
        {
            if (entity.BodyParts[i].GetComponent<CapsuleCollider>() == null)
            {
                entity.BodyParts[i].GetComponent<BoxCollider>().enabled = true;
            }
            else if(entity.BodyParts[i].GetComponent<BoxCollider>() == null)
            {
                entity.BodyParts[i].GetComponent<CapsuleCollider>().enabled = true;
            }
            entity.BodyParts[i].GetComponent<Rigidbody>().isKinematic = false;
            entity.BodyParts[i].GetComponent<Rigidbody>().useGravity = true;
        }
    }
    public override void Execute(ZombieMachine entity)
    {

    }
    public override void Exit(ZombieMachine entity)
    {
    }
}

