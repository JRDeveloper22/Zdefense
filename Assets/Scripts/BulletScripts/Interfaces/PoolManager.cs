using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PoolManager : MonoBehaviour
{
    private Dictionary<GameObject, IPool> pools;

    private void Awake()
    {
        pools = new Dictionary<GameObject, IPool>();
    }

    public PoolObject GetItem(GameObject itemType)
    {
        IPool pool = GetPool(itemType);
        PoolObject item = null;
        if(pool != null)
            item = pool.GetItem();
        return item;
    }

    public void ReturnItem(IPoolable item)
    {
        GetPool(item.GetSource()).ReturnItem(item);
    }

    private IPool GetPool(GameObject itemType)
    {
        IPool pool;
        if (!pools.ContainsKey(itemType))
        {
            pool = (IPool)new Pool(itemType);
            pools.Add(itemType, pool);
        }
        else
        {
            pool = pools[itemType];
        }
        return  pools[itemType];
    }
}
