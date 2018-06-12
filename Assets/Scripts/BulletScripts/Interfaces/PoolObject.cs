using UnityEngine;
using System.Collections;

public class PoolObject : MonoBehaviour, IPoolable
{
    private IPool pool;

    public void Begin(IPool myPool)
    {
        pool = myPool;
    }

    public void End()
    {
        pool.ReturnItem(this);
    }

    public GameObject GetSource()
    {
        return pool.GetPrefab();
    }
}
