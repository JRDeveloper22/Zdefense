using UnityEngine;
using System.Collections;

public class StateMachine<T> {
    private T Owner;
    private StateInterface<T> CurrentState;
    private StateInterface<T> PreviousState;
    private StateInterface<T> GlobalState;
    // Use this for initialization
    public void Awake ()
    {
        CurrentState = null;
        PreviousState = null;
        GlobalState = null;
	
	}
	public void Configure(T owner, StateInterface<T> initialState)
    {
        Owner = owner;
        ChangeState(initialState);
    }
	// Update is called once per frame
	public void Update ()
    {
        if (GlobalState != null) GlobalState.Execute(Owner);
        if (CurrentState != null) CurrentState.Execute(Owner);
    }
    public void ChangeState(StateInterface<T> newState)
    {
        PreviousState = CurrentState;
        if (CurrentState != null)
            CurrentState.Exit(Owner);
        CurrentState = newState;
        if (CurrentState != null)
            CurrentState.Enter(Owner);
    }
    public void RevertToPreviousState()
    {
        if(PreviousState != null)
        {
            ChangeState(PreviousState);
        }
    }
}
