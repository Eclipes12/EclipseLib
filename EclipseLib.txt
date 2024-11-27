-- EclipseLib: Core Library
local EclipseLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create Main Window
function EclipseLib:MakeWindow(options)
    options = options or {}

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local CloseButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")

    -- Properties for ScreenGui
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Draggable = true
    MainFrame.Active = true

    -- Title
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Text = options.Name or "EclipseLib"
    
    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseButton.MouseButton1Click:Connect(function()
        if options.CloseCallback then
            options.CloseCallback()
        end
        ScreenGui:Destroy()
    end)

    -- Return the window object
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = {}
    }

    setmetatable(Window, { __index = EclipseLib })
    return Window
end

-- Create Tabs
function EclipseLib:MakeTab(options)
    options = options or {}

    local TabButton = Instance.new("TextButton")
    TabButton.Name = options.Name or "TabButton"
    TabButton.Parent = self.MainFrame
    TabButton.Size = UDim2.new(0, 100, 0, 30)
    TabButton.Position = UDim2.new(0, 10 + (#self.Tabs * 110), 0, 40)
    TabButton.Text = options.Name or "Tab"
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local Tab = {
        Parent = self.MainFrame,
        Elements = {}
    }

    table.insert(self.Tabs, Tab)

    setmetatable(Tab, { __index = EclipseLib })
    return Tab
end

-- Add Button to Tab
function EclipseLib:AddButton(options)
    options = options or {}

    local Button = Instance.new("TextButton")
    Button.Name = options.Name or "Button"
    Button.Parent = self.Parent
    Button.Size = UDim2.new(0, 100, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, (#self.Elements * 40) + 50)
    Button.Text = options.Name or "Button"
    Button.Font = Enum.Font.SourceSansBold
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

    Button.MouseButton1Click:Connect(function()
        if options.Callback then
            options.Callback()
        end
    end)

    table.insert(self.Elements, Button)
end

-- Add Slider to Tab
function EclipseLib:AddSlider(options)
    options = options or {}

    local SliderFrame = Instance.new("Frame")
    local Slider = Instance.new("TextButton")
    local Value = Instance.new("TextLabel")

    SliderFrame.Parent = self.Parent
    SliderFrame.Size = UDim2.new(0, 300, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

    Slider.Parent = SliderFrame
    Slider.Size = UDim2.new(0, 100, 0, 30)
    Slider.Position = UDim2.new(0.5, -50, 0.5, -15)
    Slider.Text = options.Default or tostring(options.Min)
    Slider.Font = Enum.Font.SourceSansBold
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

    Value.Parent = SliderFrame
    Value.Position = UDim2.new(1, -50, 0, 0)
    Value.Size = UDim2.new(0, 50, 0, 30)
    Value.Text = tostring(options.Default or options.Min)
    Value.Font = Enum.Font.SourceSans
    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
    Value.BackgroundTransparency = 1

    Slider.MouseButton1Click:Connect(function()
        if options.Callback then
            options.Callback(Value.Text)
        end
    end)

    table.insert(self.Elements, SliderFrame)
end

-- Create Notifications
function EclipseLib:MakeNotification(options)
    options = options or {}

    local NotificationFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Content = Instance.new("TextLabel")

    NotificationFrame.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
    NotificationFrame.Size = UDim2.new(0, 300, 0, 100)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    NotificationFrame.Position = UDim2.new(0.8, 0, 0.9, 0)

    Title.Parent = NotificationFrame
    Title.Text = options.Name or "Notification"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

    Content.Parent = NotificationFrame
    Content.Text = options.Content or "Content goes here."
    Content.Size = UDim2.new(1, 0, 0, 70)
    Content.Position = UDim2.new(0, 0, 0.3, 0)

    task.delay(options.Time or 5, function()
        NotificationFrame:Destroy()
    end)
end

return EclipseLib
