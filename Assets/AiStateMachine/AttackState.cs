using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackState : StateInterface<ZombieMachine>
{

    static readonly AttackState instance = new AttackState();
    public static AttackState Instance
    {
        get
        {
            return instance;
        }
    }
    public override void Enter(ZombieMachine entity)
    {
        entity.PauseMesh();
    }
    public override void Execute(ZombieMachine entity)
    {
        float dist = Vector3.Distance(entity.Player.transform.position, entity.transform.position);
        entity.Zombie.Anim.SetBool("Attack", true);
        if (dist > 5f)
        {
            entity.ChangeState(ChaseState.Instance);
        }
    }
    public override void Exit(ZombieMachine entity)
    {
        entity.ResumeMesh();
        entity.Zombie.Anim.SetBool("Attack", false);
    }
}
