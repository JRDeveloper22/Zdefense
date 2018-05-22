using System;
using UnityEngine;

[RequireComponent(typeof(UnityEngine.AI.NavMeshAgent))]
[RequireComponent(typeof(HumaniodMovement))]
public class ZombieMachine : MonoBehaviour {
    //navMesh//
    public UnityEngine.AI.NavMeshAgent agent { get; private set; }
    public HumaniodMovement Zombie { get; private set; }
    //SearchVariables//
    public bool isNear;
    float cooldown;
    float radius = 10;
    public float fieldOfViewAngle = 110f;
    //target//
    public Transform Player;
    public Vector3 Target;
    private StateMachine<ZombieMachine> myMachine;
    void Awake()
    {
        //navmesh Setup//
        agent = GetComponentInChildren<UnityEngine.AI.NavMeshAgent>();
        agent.updateRotation = false;
        agent.updatePosition = true;
        //movement
        Zombie = GetComponent<HumaniodMovement>();
        //StateMachine Setup//
        myMachine = new StateMachine<ZombieMachine>();
        myMachine.Configure(this, SearchState.Instance);
        //
        Player = GameObject.FindGameObjectWithTag("Player").transform;
    }
    //StateMachine Specific////////////////
    public void ChangeState(StateInterface<ZombieMachine> e)
    {
        myMachine.ChangeState(e);
    }
    public void RevertState()
    {
        myMachine.RevertToPreviousState();
    }
    void Update()
    {
        myMachine.Update();
    }
    //////////// Target ///////////////////
    public Vector3 SetTarget(Vector3 T)
    {
        return this.Target = T;
    }
    public void SearchPosition()
    {
        cooldown -= Time.deltaTime;
        if (cooldown < 0)
        {
            cooldown += UnityEngine.Random.Range(3, 5);
            SetTarget(new Vector3((transform.position.x + UnityEngine.Random.Range(-radius, radius)),
                   0, transform.position.z + UnityEngine.Random.Range(-radius, radius)));
        }
    }
    public void Movement()
    {
        if (Target != null)
        {
            agent.SetDestination(Target);
        }
        if (agent.remainingDistance > agent.stoppingDistance)
        {
            if (agent.isOnOffMeshLink == true)
            {
                Zombie.Anim.SetBool("jump", true);
            }
            else Zombie.Anim.SetBool("jump", false);

            Zombie.Move(agent.desiredVelocity, false);
        }
        else
            Zombie.Move(Vector3.zero, false);
    }
    //NavmeshStartStop
    Vector3 LastAgentVelocity;
     UnityEngine.AI.NavMeshPath lastAgentPath;
    public void PauseMesh()
    {
        LastAgentVelocity = agent.velocity;
        lastAgentPath = agent.path;
        agent.velocity = Vector3.zero;
        agent.ResetPath();
    }
    public void ResumeMesh()
    {
        agent.velocity = LastAgentVelocity;
        agent.SetPath(lastAgentPath);
    }

}
