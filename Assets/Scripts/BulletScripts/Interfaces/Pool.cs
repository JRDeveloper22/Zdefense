using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Pool : IPool
{
    private GameObject prefab;
    private List<IPoolable> active;
    private Queue<IPoolable> inactive;

    public Pool(GameObject newPrefab)
    {
        prefab = newPrefab;
        active = new List<IPoolable>();
        inactive = new Queue<IPoolable>();
    }

    public PoolObject GetItem()
    {
        PoolObject item = null;
        if (inactive.Count == 0)
        {
            GameObject poolObject = (GameObject)Object.Instantiate(prefab, Vector3.zero, Quaternion.identity);
            item = poolObject.GetComponent<PoolObject>();
            if (item == null)
                Debug.LogError(poolObject.name + " : Not a poolable object!");
            item.Begin(this);
        }
        else
        {
            item = (PoolObject)inactive.Dequeue();
        }
        active.Add(item);
        return item;
    }

    public void ReturnItem(IPoolable item)
    {
        inactive.Enqueue(item);
        active.Remove(item);
    }

    public GameObject GetPrefab()
    {
        return prefab;
    }

    /*
    void Start()
    {

        BulletPool = new Rigidbody[maxBullets];

        for (int i = 0; i < maxBullets; ++i)
        {
            Rigidbody Bullet;
            Bullet = Instantiate(BulletPrefab, gameObject.transform.position, gameObject.transform.rotation) as Rigidbody;
            BulletPool[i] = Bullet;
            Bullet.gameObject.SetActive(false);
        }

    }
    void Update()
    {
        foreach (Rigidbody bullet in BulletPool)
        {
            if (bullet.gameObject.activeSelf == false && !inactive.Contains(bullet))
            {
                if (active.Contains(bullet))
                {
                    active.Remove(bullet);
                }
                inactive.Add(bullet);
            }
            else if (bullet.gameObject.activeSelf == true && !active.Contains(bullet))
            {
                if (inactive.Contains(bullet))
                {
                    inactive.Remove(bullet);
                }
                active.Add(bullet);
            }
        }

    }*/


}
