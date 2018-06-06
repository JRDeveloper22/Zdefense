using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChaseState : StateInterface<ZombieMachine>
{
    static readonly ChaseState instance = new ChaseState();
    public static ChaseState Instance
    {
        get
        {
            return instance;
        }
    }

    public override void Enter(ZombieMachine entity)
    {
    }
    public override void Execute(ZombieMachine entity)
    {
        entity.SetTarget(entity.Player.position);
        entity.Movement();
        entity.agent.speed = 3;
        float dist = Vector3.Distance(entity.Player.transform.position, entity.transform.position);
        if(dist < 2f)
        {
            entity.ChangeState(AttackState.Instance);
        }

        if(dist > 20f)
        {
            entity.ChangeState(SearchState.Instance);
        }
        if (entity.isDead == true)
        {
            entity.ChangeState(DeathState.Instance);
        }

    }
    public override void Exit(ZombieMachine entity)
    {

    }
}
