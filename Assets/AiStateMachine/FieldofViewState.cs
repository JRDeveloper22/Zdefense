using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FieldofViewState : StateInterface<ZombieMachine>
{

    static readonly FieldofViewState instance = new FieldofViewState();
    public static FieldofViewState Instance
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

        Vector3 direction = entity.Player.transform.position - entity.transform.position;

        float angle = Vector3.Angle(direction, entity.transform.forward);

        if (angle < entity.fieldOfViewAngle * 0.5f)
        {
            RaycastHit hit;

            if (Physics.Raycast(entity.transform.position, direction, out hit))
            {
                if (hit.collider.tag == "Player")
                {
                    Debug.DrawRay(entity.transform.position, direction);
                    entity.ChangeState(ChaseState.Instance);
                }
                else
                    entity.RevertState();
            }
        }
        else
            entity.RevertState();
    }
    public override void Exit(ZombieMachine entity)
    {

    }
}
