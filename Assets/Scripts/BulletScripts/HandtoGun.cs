using UnityEngine;
using System.Collections;
public enum HandSide
{
    Left,
    right
}
public class HandtoGun : MonoBehaviour {


    public Gun GunAtrib;
    public HandSide myHand;
    //OVRInput.Button action;
    public KeyCode action;

    private bool shooting;
    IActable actObject;
	// Use this for initialization
	void Start ()
    {
        shooting = false;
        switch(myHand)
        {
            case HandSide.Left:
                action = KeyCode.Mouse0;
                //FireLR = OVRInput.Button.PrimaryIndexTrigger;
                break;
            case HandSide.right:
                action = KeyCode.Mouse1;
                //FireLR = OVRInput.Button.SecondaryIndexTrigger;
                break;
        }
        GunAtrib = gameObject.GetComponentInChildren<Gun>();
        actObject = gameObject.GetComponentInChildren<IActable>();
	}
    void Update()
    {
        if(Input.GetKey(action) && !shooting)
        {
            actObject.ActionStart();
            shooting = true;
        }
        else if(!Input.GetKey(action))
        {
            shooting = false;
        }
    }
}
