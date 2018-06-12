using UnityEngine;
using System.Collections;

[RequireComponent(typeof(PoolObject))]
public class Bullet : MonoBehaviour
{
    public Vector3 currentpos;
    public Vector3 lastpos;
    public Vector3 SavedSpawn;
    private new Rigidbody rigidbody;
    private TrailRenderer trail;
    private PoolObject poolObject = null;

    public float hitForce;
    public float damage = 50;
    //
    public float TimerDestroy;
    [HideInInspector]
    public float Timer;
    //public GunShootExample GunShoot;
    public TrailRenderer Trail
    {
        get
        {
            return trail;
        }
    }
    public Rigidbody Rigidbody
    {
        get
        {
            return rigidbody;
        }
    }
    // Use this for initialization

    void Awake()
    {
        trail = gameObject.GetComponent<TrailRenderer>();
        rigidbody = gameObject.GetComponent<Rigidbody>();
        currentpos = gameObject.GetComponent<Transform>().position;
        poolObject = GetComponent<PoolObject>();
    }
    void Start()
    {
        Timer = 0;
    }
    // Update is called once per frame
    void FixedUpdate ()
    {
        Destroy();
        Ray();
    }
    void Ray()
    {
        currentpos = gameObject.transform.position;
        Vector3 direction = currentpos - lastpos;
        RaycastHit hit;

        if (Physics.Raycast(lastpos, direction, out hit))
        {
            Debug.DrawLine(lastpos, hit.point);
            if (hit.transform.tag != "Bullet")
            {
                if (hit.transform.tag == "Enemy")
                {
                    Debug.Log("Damage");
                   // Healt HP = hit.transform.GetComponent<Healt>();
                    //HP.health(damage);
                }
                if (hit.rigidbody == true)
                {
                    hit.rigidbody.AddForce(direction * hitForce);

                }
                /*
                Timer = 0;
                poolObject.End();
                rigidbody.isKinematic = true;
                rigidbody.velocity = Vector3.zero;
                rigidbody.angularVelocity = Vector3.zero;
                trail.enabled = false;
                gameObject.SetActive(false);*/

            }

        }

        lastpos = currentpos;
    }
    void Destroy()
    {
        Timer += Time.deltaTime * 2;
        if (Timer >= TimerDestroy)
        {
            Timer = 0;
            poolObject.End();
            rigidbody.isKinematic = true;
            rigidbody.velocity = Vector3.zero;
            rigidbody.angularVelocity = Vector3.zero;
            trail.Clear();
            trail.enabled = false;
            gameObject.SetActive(false);
            //this.enabled = false;

        }
    }
}
