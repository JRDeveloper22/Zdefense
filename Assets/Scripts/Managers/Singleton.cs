using UnityEngine;

public class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T m_Instance;
    protected bool destroyingSelf = false;
    private static bool applicationIsQuitting = false;
    public static T Instance
    {
        get
        {
            if (m_Instance == null)
            {
                m_Instance = (T)FindObjectOfType(typeof(T));

                if (m_Instance == null)
                {
                    GameObject singleton = new GameObject();
                    m_Instance = singleton.AddComponent<T>();
                    singleton.name = typeof(T).ToString();
                    DontDestroyOnLoad(singleton);
                }
            }
            return m_Instance;
        }
    }
    public void OnDestroy()
    {
        applicationIsQuitting = true;
    }
    //used to not destroy mannagers
    protected void Awake()
    {
        if(Instance != this){
            destroyingSelf = true;
            Destroy(gameObject);
        }
        DontDestroyOnLoad(gameObject);
    }
}