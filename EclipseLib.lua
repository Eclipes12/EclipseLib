-- EclipseLib.lua
local EclipseLib = {}
EclipseLib.__index = EclipseLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Helper Functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for key, value in pairs(properties) do
        if key ~= "Parent" then
            instance[key] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function getPlayerProfileImage(userId)
    return "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420"
end

-- Window Creation
function EclipseLib:MakeWindow(options)
    options = options or {}
    local window = setmetatable({}, EclipseLib)

    -- Create ScreenGui
    local ScreenGui = createInstance("ScreenGui", {
        Name = "EclipseLib_ScreenGui",
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Frame
    local MainFrame = createInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true,
        Draggable = true
    })

    -- Rounded Corners for MainFrame
    local MainUICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = MainFrame
    })

    -- Title Panel
    local Panel = createInstance("Frame", {
        Name = "Panel",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(39, 39, 39),
        Size = UDim2.new(1, 0, 0, 40)
    })

    -- Rounded Corners for Panel
    local PanelUICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Panel
    })

    -- Title Label
    local Title = createInstance("TextLabel", {
        Name = "Title",
        Parent = Panel,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 1, 0),
        Position = UDim2.new(0.05, 0, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = options.Name or "Eclipse Library",
        TextColor3 = Color3.fromRGB(252, 252, 252),
        TextScaled = true,
        TextSize = 20,
        TextWrapped = true
    })

    -- Close Button
    local CloseButton = createInstance("TextButton", {
        Name = "CloseButton",
        Parent = Panel,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(0.9, 0, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "X",
        TextColor3 = Color3.fromRGB(222, 9, 37),
        TextScaled = true,
        TextSize = 20,
        TextWrapped = true
    })

    CloseButton.MouseButton1Click:Connect(function()
        if options.CloseCallback then
            options.CloseCallback()
        end
        ScreenGui:Destroy()
    end)

    -- Left Side (Tabs)
    local LeftSide = createInstance("Frame", {
        Name = "LeftSide",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        Size = UDim2.new(0, 150, 1, -40),
        Position = UDim2.new(0, 0, 0, 40)
    })

    -- Rounded Corners for LeftSide
    local LeftSideUICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = LeftSide
    })

    -- Profile Image
    local ProfileImage = createInstance("ImageLabel", {
        Name = "ProfileImage",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0.85, 0),
        Size = UDim2.new(0, 50, 0, 50),
        Image = getPlayerProfileImage(Players.LocalPlayer.UserId),
        ImageRectSize = Vector2.new(420, 420),
        ImageRectOffset = Vector2.new(0, 0),
        ClipsDescendants = true
    })

    -- Rounded Corners for ProfileImage
    local ProfileUICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 25),
        Parent = ProfileImage
    })

    -- Roblox Name Label
    local RobloxName = createInstance("TextLabel", {
        Name = "RobloxName",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.12, 0, 0.85, 0),
        Size = UDim2.new(0.4, 0, 0, 50),
        Font = Enum.Font.SourceSansBold,
        Text = Players.LocalPlayer.Name,
        TextColor3 = Color3.fromRGB(245, 245, 245),
        TextSize = 18,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container (Buttons)
    local TabContainer = createInstance("Frame", {
        Name = "TabContainer",
        Parent = LeftSide,
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        Size = UDim2.new(1, 0, 0.8, 0),
        Position = UDim2.new(0, 0, 0.1, 0)
    })

    -- ScrollFrame for Tabs (in case of many tabs)
    local TabsScroll = createInstance("ScrollingFrame", {
        Parent = TabContainer,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })

    -- UIListLayout for Tabs
    local TabsLayout = createInstance("UIListLayout", {
        Parent = TabsScroll,
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    -- Tabs Frame (for dynamic tab addition)
    local TabsFrame = createInstance("Frame", {
        Parent = TabsScroll,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    })

    -- Content Frame (Right Side)
    local ContentFrame = createInstance("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(47, 47, 47),
        Size = UDim2.new(1, -150, 1, -40),
        Position = UDim2.new(0.3, 0, 0, 40)
    })

    -- ScrollingFrame for Content (in case of many elements)
    local ContentScroll = createInstance("ScrollingFrame", {
        Parent = ContentFrame,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    })

    -- UIListLayout for Content
    local ContentLayout = createInstance("UIListLayout", {
        Parent = ContentScroll,
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    -- Store Tabs
    window.Tabs = {}
    window.CurrentTab = nil
    window.Options = options
    window.MainFrame = MainFrame
    window.ContentScroll = ContentScroll
    window.TabsFrame = TabsFrame
    window.TabsScroll = TabsScroll

    -- Function to Create Tabs
    function window:MakeTab(tabOptions)
        tabOptions = tabOptions or {}
        local tab = {}
        tab.Name = tabOptions.Name or "Tab"
        tab.Icon = tabOptions.Icon or ""
        tab.PremiumOnly = tabOptions.PremiumOnly or false

        -- Create Tab Button
        local TabButton = createInstance("TextButton", {
            Parent = TabsFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(42, 42, 42),
            Text = tab.Name,
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 0
        })

        -- Optional Icon
        if tab.Icon ~= "" then
            local Icon = createInstance("ImageLabel", {
                Parent = TabButton,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 5, 0.5, -10),
                Image = tab.Icon,
                BackgroundTransparency = 1
            })
        end

        -- Create Tab Content Frame
        local TabContent = createInstance("Frame", {
            Parent = ContentScroll,
            Size = UDim2.new(1, 0, 0, 300),
            BackgroundTransparency = 1,
            Visible = false
        })

        -- Add UIListLayout to TabContent
        local TabLayout = createInstance("UIListLayout", {
            Parent = TabContent,
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        -- Update CanvasSize
        local function updateTabCanvas()
            TabLayout.Parent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end

        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)

        -- Tab Button Click Event
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, existingTab in pairs(window.Tabs) do
                existingTab.TabContent.Visible = false
            end
            -- Show this tab
            TabContent.Visible = true
            window.CurrentTab = tab
        end)

        -- Initialize as first tab if none selected
        if #window.Tabs == 0 then
            TabContent.Visible = true
            window.CurrentTab = tab
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end

        -- Store Tab Information
        tab.TabButton = TabButton
        tab.TabContent = TabContent
        tab.Elements = {}

        -- Function to Add Button to Tab
        function tab:AddButton(buttonOptions)
            buttonOptions = buttonOptions or {}
            local button = {}

            local Button = createInstance("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, -20, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Text = buttonOptions.Name or "Button",
                Font = Enum.Font.SourceSansBold,
                TextColor3 = Color3.fromRGB(248, 248, 248),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 0,
                Position = UDim2.new(0.1, 0, 0, 0)
            })

            -- Rounded Corners for Button
            local ButtonUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = Button
            })

            -- Button Click Event
            Button.MouseButton1Click:Connect(function()
                if buttonOptions.Callback then
                    buttonOptions.Callback()
                end
            end)

            table.insert(tab.Elements, Button)
            return Button
        end

        -- Function to Add Slider to Tab
        function tab:AddSlider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local slider = {}

            -- Slider Frame
            local SliderFrame = createInstance("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, -20, 0, 60),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                BackgroundTransparency = 0
            })

            -- Rounded Corners for SliderFrame
            local SliderUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderFrame
            })

            -- Slider Label
            local SliderLabel = createInstance("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.3, 0, 0.5, 0),
                Position = UDim2.new(0.05, 0, 0.25, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansBold,
                Text = sliderOptions.Name or "Slider",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- Slider Value Display
            local SliderValue = createInstance("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.15, 0, 0.5, 0),
                Position = UDim2.new(0.8, 0, 0.25, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansBold,
                Text = tostring(sliderOptions.Default or sliderOptions.Min or 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            -- Slider Input (Using a TextBox for simplicity)
            local SliderInput = createInstance("TextBox", {
                Parent = SliderFrame,
                Size = UDim2.new(0.6, 0, 0.3, 0),
                Position = UDim2.new(0.35, 0, 0.35, 0),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Text = "",
                Font = Enum.Font.SourceSans,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                ClearTextOnFocus = true,
                PlaceholderText = sliderOptions.ValueName or ""
            })

            -- Slider Configuration
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local increment = sliderOptions.Increment or 1
            local valueName = sliderOptions.ValueName or ""

            -- Set Default Value
            SliderValue.Text = tostring(default) .. " " .. valueName
            SliderInput.Text = tostring(default)

            -- Slider Callback
            SliderInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local value = tonumber(SliderInput.Text)
                    if value then
                        value = math.clamp(math.floor(value / increment) * increment, min, max)
                        SliderInput.Text = tostring(value)
                        SliderValue.Text = tostring(value) .. " " .. valueName
                        if sliderOptions.Callback then
                            sliderOptions.Callback(value)
                        end
                    else
                        -- Reset to default if invalid input
                        SliderInput.Text = tostring(default)
                        SliderValue.Text = tostring(default) .. " " .. valueName
                    end
                end
            end)

            table.insert(tab.Elements, SliderFrame)
            return SliderFrame
        end

        -- Function to Add Notification
        function EclipseLib:MakeNotification(notificationOptions)
            notificationOptions = notificationOptions or {}
            local notification = {}

            -- Notification Frame
            local NotificationFrame = createInstance("Frame", {
                Parent = ScreenGui,
                Size = UDim2.new(0, 300, 0, 100),
                Position = UDim2.new(0.8, 0, 0.9, 0),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0
            })

            -- Rounded Corners for NotificationFrame
            local NotificationUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = NotificationFrame
            })

            -- Notification Title
            local NotificationTitle = createInstance("TextLabel", {
                Parent = NotificationFrame,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                BackgroundTransparency = 0,
                Font = Enum.Font.SourceSansBold,
                Text = notificationOptions.Name or "Notification",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextWrapped = true
            })

            -- Notification Content
            local NotificationContent = createInstance("TextLabel", {
                Parent = NotificationFrame,
                Size = UDim2.new(1, 0, 0, 70),
                Position = UDim2.new(0, 0, 0.3, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSans,
                Text = notificationOptions.Content or "This is a notification.",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                TextWrapped = true
            })

            -- Auto-Destroy Notification after Time
            local displayTime = notificationOptions.Time or 5
            delay(displayTime, function()
                -- Fade Out Effect
                local tween = TweenService:Create(NotificationFrame, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1})
                tween:Play()
                tween.Completed:Wait()
                NotificationFrame:Destroy()
            end)
        end

        -- Function to Add Slider to Tab
        function tab:AddSlider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local slider = {}

            -- Slider Frame
            local SliderFrame = createInstance("Frame", {
                Parent = tab.TabContent,
                Size = UDim2.new(1, -20, 0, 60),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                BackgroundTransparency = 0
            })

            -- Rounded Corners for SliderFrame
            local SliderUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderFrame
            })

            -- Slider Label
            local SliderLabel = createInstance("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.3, 0, 0.5, 0),
                Position = UDim2.new(0.05, 0, 0.25, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansBold,
                Text = sliderOptions.Name or "Slider",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- Slider Value Display
            local SliderValue = createInstance("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.15, 0, 0.5, 0),
                Position = UDim2.new(0.8, 0, 0.25, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansBold,
                Text = tostring(sliderOptions.Default or sliderOptions.Min or 0) .. " " .. (sliderOptions.ValueName or ""),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            -- Slider Input (Using a TextBox for simplicity)
            local SliderInput = createInstance("TextBox", {
                Parent = SliderFrame,
                Size = UDim2.new(0.6, 0, 0.3, 0),
                Position = UDim2.new(0.35, 0, 0.35, 0),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Text = "",
                Font = Enum.Font.SourceSans,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                ClearTextOnFocus = true,
                PlaceholderText = sliderOptions.ValueName or ""
            })

            -- Slider Configuration
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local increment = sliderOptions.Increment or 1
            local valueName = sliderOptions.ValueName or ""

            -- Set Default Value
            SliderValue.Text = tostring(default) .. " " .. valueName
            SliderInput.Text = tostring(default)

            -- Slider Callback
            SliderInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local value = tonumber(SliderInput.Text)
                    if value then
                        value = math.clamp(math.floor(value / increment) * increment, min, max)
                        SliderInput.Text = tostring(value)
                        SliderValue.Text = tostring(value) .. " " .. valueName
                        if sliderOptions.Callback then
                            sliderOptions.Callback(value)
                        end
                    else
                        -- Reset to default if invalid input
                        SliderInput.Text = tostring(default)
                        SliderValue.Text = tostring(default) .. " " .. valueName
                    end
                end
            end)

            table.insert(tab.Elements, SliderFrame)
            return SliderFrame
        end

        -- Function to Add Notification (Accessible via Window)
        function window:MakeNotification(notificationOptions)
            self:MakeNotification(notificationOptions)
        end

        -- Add Tab to Window
        table.insert(self.Tabs, tab)
        return tab
    end

    return EclipseLib
