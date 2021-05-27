def main():
    from selenium import webdriver
    import time
    from PIL import Image
    import requests
    from io import BytesIO
    import os.path

    insta_id = ""
    insta_pw = ""
    norang_url = "https://www.instagram.com/norang__lunch/"

    options = webdriver.ChromeOptions()
    # options.headless = True
    options.add_argument("--window-size=1920,1080")
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")
    options.add_argument(
        "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
    )
    browser = webdriver.Chrome(options=options)

    browser.get("https://www.instagram.com/accounts/login/?source=auth_switcher")
    time.sleep(3)
    username = browser.find_element_by_name("username")
    password = browser.find_element_by_name("password")
    username.send_keys(insta_id)
    password.send_keys(insta_pw)
    password.send_keys(webdriver.common.keys.Keys.ENTER)
    time.sleep(3)
    while True:
        print("tick")
        browser.get(norang_url)
        sharedData = browser.execute_script("return window._sharedData;")
        first_post_node = sharedData["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"][
            "edges"
        ][0]["node"]
        if not os.path.isfile(str(first_post_node["taken_at_timestamp"]) + ".png"):
            response = requests.get(first_post_node["display_url"])
            img = Image.open(BytesIO(response.content))
            img.save(str(first_post_node["taken_at_timestamp"]) + ".png")
            notify_todays_menu(str(first_post_node["taken_at_timestamp"]))
        time.sleep(10)


if __name__ == "__main__":
    main()