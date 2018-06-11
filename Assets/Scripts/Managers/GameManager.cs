using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : Singleton<GameManager>
{
    IEnumerator LoadAsyncScene()
    {
        AsyncOperation operation = SceneManager.LoadSceneAsync(1);
        UIManager.Instance.mainMenuPanel.gameObject.SetActive(false);
        UIManager.Instance.loadingScreenPanel.SetActive(true);

        while (!operation.isDone)
        {
            yield return null;
            if(operation.isDone == true)
            {
                UIManager.Instance.loadingScreenPanel.SetActive(false);
                UIManager.Instance.levelPanel.SetActive(true);
            }
        }
    }

    public void Play()
    {
        StartCoroutine(LoadAsyncScene());
    }

    public void Quit()
    {
        Application.Quit();
    }

    public void ReloadScene()
    {
        Scene scene = SceneManager.GetActiveScene();
        SceneManager.LoadScene(scene.name);
    }

    public void LevelClearedReloadScene()
    {
        Scene clearedScene = SceneManager.GetActiveScene();
        SceneManager.LoadScene(clearedScene.name);
        UIManager.Instance.levelClearedPanel.SetActive(false);
        UIManager.Instance.levelPanel.SetActive(true);
    }

    public void LoadMainMenu()
    {
        SceneManager.LoadScene(0);
        UIManager.Instance.mainMenuPanel.gameObject.SetActive(true);
        UIManager.Instance.loadingScreenPanel.gameObject.SetActive(false);
        UIManager.Instance.levelPanel.gameObject.SetActive(false);
        UIManager.Instance.levelClearedPanel.gameObject.SetActive(false);
    }
}
