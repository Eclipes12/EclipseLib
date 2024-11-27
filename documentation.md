local EclipseLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Eclipes12/EclipseLib/refs/heads/main/EclipseLib.txt'))()

Create a Window
lua
Copy code
local OrionLib = loadstring(game:HttpGet("https://your-github-raw-link"))()
local Window = OrionLib:MakeWindow({
    Name = "My UI Library",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyConfigFolder"
})

Add Tabs
lua
Copy code
local Tab = Window:MakeTab({
    Name = "Main Tab",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Add Buttons
lua
Copy code
Tab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button Clicked!")
    end
})

Show Notifications
lua
Copy code
OrionLib:MakeNotification({
    Name = "Hello!",
    Content = "This is a test notification.",
    Time = 5
})
