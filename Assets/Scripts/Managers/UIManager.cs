using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class UIManager : Singleton<UIManager> {
    //Main UI canvas and also to able to hide from inspector for less room for error
    public Canvas mainCanvas;
    //UI Panels
    public GameObject mainMenuPanel;
    public GameObject loadingScreenPanel;
    public GameObject levelPanel;
    public GameObject levelClearedPanel;
    //Button/Texts also Text must be pulled in via scene to work
    public Button playButton;
    public Button quitButton;
    public Button mainMenuButton;
    public Button reloadLevelButton;
    public Text pHealth;

    private void Start()
    {
        //after finds we set up listeners for buttons
        SetMainMenuUIListeners();
        SetLevelClearedUIListners();
        //Sets the panels according to levels
        SetupUI();
    }

    public void SetMainMenuUIListeners()
    {
        playButton.onClick.AddListener(GameManager.Instance.Play);
        quitButton.onClick.AddListener(GameManager.Instance.Quit);
    }

    public void SetLevelClearedUIListners()
    {
        mainMenuButton.onClick.AddListener(GameManager.Instance.LoadMainMenu);
        reloadLevelButton.onClick.AddListener(GameManager.Instance.LevelClearedReloadScene);
    }

    public void SetupUI()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        string currentSceneName = currentScene.name;
        if(currentSceneName == "Day_Time_Scene")
        {
            mainMenuPanel.gameObject.SetActive(true);
            loadingScreenPanel.gameObject.SetActive(false);
            levelPanel.gameObject.SetActive(false);
            levelClearedPanel.gameObject.SetActive(false);
        }
        else
        {
            levelPanel.gameObject.SetActive(true);
            loadingScreenPanel.gameObject.SetActive(false);
            mainMenuPanel.gameObject.SetActive(false);
            levelClearedPanel.gameObject.SetActive(false);
        }
    }

    public void UpdateHealth(int PLHealth)
    {
        pHealth.text = PLHealth.ToString();
    }

    public void SetLevelClearedUI()
    {
        levelClearedPanel.gameObject.SetActive(true);
        mainMenuPanel.gameObject.SetActive(false);
        loadingScreenPanel.gameObject.SetActive(false);
        levelPanel.gameObject.SetActive(false);
    }
}
