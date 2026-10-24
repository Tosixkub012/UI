local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local SOUND_IDS = {
    Open = "rbxassetid://140207837688369",
    Toggle = "rbxassetid://139719503904449",
    Key = "rbxassetid://127105730240202",
    Button = "rbxassetid://88442833509532"
}
local SOUND_LEVELS = { Open = 5, Toggle = 5, Key = 5, Button = 5 }

local IconList = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tosixkub012/UI/refs/heads/main/Icon.lua"))()

IconList.dashboard = IconList["layout-dashboard"]
IconList.mapPin = IconList["map-pin"]
IconList.refresh = IconList["refresh-cw"]
IconList.chevronRight = IconList["chevron-right"]
IconList.chevronDown = IconList["chevron-down"]
IconList.chevronUp = IconList["chevron-up"]
IconList.chevronsDown = IconList["chevrons-down"]

local function NormalizeIconName(name)
    name = string.gsub(name, "(%l)(%u)", "%1-%2")
    name = string.gsub(string.lower(name), "[%s_]+", "-")
    return name
end

local function ResolveIcon(icon, fallback)
    local kind = type(icon)
    if kind == "number" then
        return "rbxassetid://" .. icon
    end
    if kind == "string" and icon ~= "" then
        local found = IconList[icon] or IconList[NormalizeIconName(icon)]
        if found then
            return found
        end
        if string.find(icon, "rbxasset", 1, true) or string.find(icon, "http", 1, true) or tonumber(icon) then
            return tonumber(icon) and ("rbxassetid://" .. icon) or icon
        end
    end
    return fallback
end

local Palettes = {
    Dark = {
        Background = Color3.fromRGB(10, 10, 10),
        BackgroundTop = Color3.fromRGB(22, 22, 22),
        Card = Color3.fromRGB(24, 24, 24),
        Selected = Color3.fromRGB(34, 34, 34),
        Outline = Color3.fromRGB(46, 46, 46),
        Divider = Color3.fromRGB(38, 38, 38),
        Accent = Color3.fromRGB(34, 108, 232),
        AccentGlow = Color3.fromRGB(86, 158, 255),
        AccentAlt = Color3.fromRGB(60, 176, 255),
        Text = Color3.fromRGB(238, 238, 238),
        SubText = Color3.fromRGB(145, 145, 145),
        ToggleOff = Color3.fromRGB(58, 58, 58),
        OnAccent = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(238, 240, 245),
        BackgroundTop = Color3.fromRGB(250, 251, 253),
        Card = Color3.fromRGB(255, 255, 255),
        Selected = Color3.fromRGB(230, 233, 242),
        Outline = Color3.fromRGB(212, 216, 227),
        Divider = Color3.fromRGB(226, 229, 238),
        Accent = Color3.fromRGB(72, 92, 224),
        AccentGlow = Color3.fromRGB(98, 118, 240),
        AccentAlt = Color3.fromRGB(44, 170, 232),
        Text = Color3.fromRGB(28, 31, 42),
        SubText = Color3.fromRGB(108, 114, 134),
        ToggleOff = Color3.fromRGB(200, 205, 218),
        OnAccent = Color3.fromRGB(255, 255, 255)
    },
    Blue = {
        Background = Color3.fromRGB(9, 16, 30),
        BackgroundTop = Color3.fromRGB(15, 27, 49),
        Card = Color3.fromRGB(18, 31, 55),
        Selected = Color3.fromRGB(24, 41, 72),
        Outline = Color3.fromRGB(37, 58, 94),
        Divider = Color3.fromRGB(30, 49, 81),
        Accent = Color3.fromRGB(40, 126, 240),
        AccentGlow = Color3.fromRGB(96, 168, 255),
        AccentAlt = Color3.fromRGB(46, 214, 232),
        Text = Color3.fromRGB(230, 240, 255),
        SubText = Color3.fromRGB(128, 151, 187),
        ToggleOff = Color3.fromRGB(44, 63, 98),
        OnAccent = Color3.fromRGB(255, 255, 255)
    },
    Purple = {
        Background = Color3.fromRGB(16, 12, 26),
        BackgroundTop = Color3.fromRGB(27, 20, 43),
        Card = Color3.fromRGB(31, 24, 49),
        Selected = Color3.fromRGB(39, 30, 61),
        Outline = Color3.fromRGB(59, 46, 92),
        Divider = Color3.fromRGB(49, 38, 77),
        Accent = Color3.fromRGB(136, 82, 238),
        AccentGlow = Color3.fromRGB(170, 128, 255),
        AccentAlt = Color3.fromRGB(236, 104, 196),
        Text = Color3.fromRGB(240, 234, 252),
        SubText = Color3.fromRGB(151, 139, 180),
        ToggleOff = Color3.fromRGB(65, 53, 93),
        OnAccent = Color3.fromRGB(255, 255, 255)
    },
    Rose = {
        Background = Color3.fromRGB(22, 12, 16),
        BackgroundTop = Color3.fromRGB(35, 20, 26),
        Card = Color3.fromRGB(39, 24, 31),
        Selected = Color3.fromRGB(49, 29, 38),
        Outline = Color3.fromRGB(75, 45, 57),
        Divider = Color3.fromRGB(61, 37, 47),
        Accent = Color3.fromRGB(222, 68, 108),
        AccentGlow = Color3.fromRGB(255, 122, 152),
        AccentAlt = Color3.fromRGB(255, 154, 96),
        Text = Color3.fromRGB(252, 236, 240),
        SubText = Color3.fromRGB(177, 141, 151),
        ToggleOff = Color3.fromRGB(81, 53, 63),
        OnAccent = Color3.fromRGB(255, 255, 255)
    }
}

local THEME_ORDER = { "Dark", "Blue", "Purple", "Rose", "Custom" }
local CurrentTheme = "Dark"

local SURFACE = {
    Background = Color3.fromRGB(0, 0, 0),
    BackgroundTop = Color3.fromRGB(8, 8, 10),
    Card = Color3.fromRGB(14, 14, 16),
    Outline = Color3.fromRGB(36, 36, 42),
    Divider = Color3.fromRGB(24, 24, 28),
    Text = Color3.fromRGB(244, 244, 248),
    SubText = Color3.fromRGB(142, 142, 152),
    ToggleOff = Color3.fromRGB(46, 46, 52)
}

local Theme = {
    Red = Color3.fromRGB(255, 95, 87),
    Yellow = Color3.fromRGB(255, 189, 46),
    Green = Color3.fromRGB(39, 201, 63)
}
for key, value in pairs(Palettes.Dark) do
    Theme[key] = value
end

local function ApplySurface()
    for Key, Value in pairs(SURFACE) do
        Theme[Key] = Value
    end
    Theme.Selected = SURFACE.Card:Lerp(Theme.Accent, 0.12)
end

ApplySurface()

local C = setmetatable({}, {
    __index = function(_, key)
        return { __token = key }
    end
})

local Bound = {}
local ThemeListeners = {}
local NextThemeListener = 0

local function Track(instance, property, key)
    table.insert(Bound, { instance, property, key })
end

local function OnTheme(callback)
    NextThemeListener = NextThemeListener + 1
    local id = NextThemeListener
    ThemeListeners[id] = callback
    return function()
        ThemeListeners[id] = nil
    end
end

local PressTypes = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true
}

local FontPath = "rbxasset://fonts/families/Montserrat.json"
local Fonts = {}
for name, weight in pairs({
    Regular = Enum.FontWeight.Regular,
    Medium = Enum.FontWeight.Medium,
    SemiBold = Enum.FontWeight.SemiBold,
    Bold = Enum.FontWeight.Bold
}) do
    Fonts[name] = Font.new(FontPath, weight, Enum.FontStyle.Normal)
end

local function New(className, properties, children)
    local instance = Instance.new(className)
    local isText = instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")
    local props = properties or {}

    if instance:IsA("GuiObject") then
        instance.BorderSizePixel = 0
    end
    if instance:IsA("GuiButton") then
        instance.AutoButtonColor = false
    end
    if isText then
        instance.FontFace = Fonts.Regular
        instance.TextSize = 12
        instance.TextColor3 = Theme.Text
        instance.TextXAlignment = Enum.TextXAlignment.Left
        instance.Text = ""
        if props.TextColor3 == nil then
            Track(instance, "TextColor3", "Text")
        end
    end
    if isText or instance:IsA("ImageLabel") or instance:IsA("ImageButton") or instance:IsA("ScrollingFrame") then
        instance.BackgroundTransparency = 1
    end

    local parent
    for key, value in pairs(props) do
        if key == "Parent" then
            parent = value
        elseif key == "Weight" then
            instance.FontFace = Fonts[value] or Fonts.Regular
        else
            if type(value) == "table" and value.__token then
                Track(instance, key, value.__token)
                value = Theme[value.__token]
            end
            instance[key] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function Corner(radius, isCircle)
    if isCircle then
        return New("UICorner", { CornerRadius = UDim.new(1, 0) })
    end
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function Stroke(color, transparency, thickness)
    return New("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Tween(object, duration, properties, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function SafeCall(callback, ...)
    if type(callback) ~= "function" then
        return
    end
end

local Aura = {}
Aura.__index = Aura
Aura.Pool = {}
Aura.Next = 0

Aura.Styles = {
    Fill = function()
        return ColorSequence.new(Theme.Accent, Theme.AccentAlt)
    end,
    Shade = function()
        return ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.68, 0.68, 0.74))
    end,
    Haze = function()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Accent),
            ColorSequenceKeypoint.new(0.5, Theme.AccentAlt),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        })
    end,
    Rim = function()
        local base = Theme.Outline
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, base:Lerp(Theme.Accent, 0.55)),
            ColorSequenceKeypoint.new(0.35, base),
            ColorSequenceKeypoint.new(0.7, base:Lerp(Theme.AccentAlt, 0.55)),
            ColorSequenceKeypoint.new(1, base:Lerp(Theme.Accent, 0.55))
        })
    end
}

function Aura.Make(style, props)
    local self = setmetatable({ Style = style }, Aura)
    self.Gradient = New("UIGradient", props or {})
    self:Paint()
    Aura.Next = Aura.Next + 1
    Aura.Pool[Aura.Next] = self
    return self.Gradient
end

function Aura:Paint()
    self.Gradient.Color = Aura.Styles[self.Style]()
end

function Aura.Sync()
    for id, aura in pairs(Aura.Pool) do
        if aura.Gradient.Parent and aura.Gradient:IsDescendantOf(game) then
            aura:Paint()
        else
            Aura.Pool[id] = nil
        end
    end
end

local AccentSolid = false

local function SetTheme(name)
    local palette = Palettes[name]
    if not palette then
        return false
    end
    CurrentTheme = name
    for key, value in pairs(palette) do
        Theme[key] = value
    end
    if AccentSolid then
        Theme.AccentAlt = Theme.Accent
        Theme.AccentGlow = Theme.Accent
    end
    ApplySurface()

    local alive = {}
    for _, binding in ipairs(Bound) do
        local instance = binding[1]
        if instance.Parent ~= nil and instance:IsDescendantOf(game) then
            table.insert(alive, binding)
            Tween(instance, 0.25, { [binding[2]] = Theme[binding[3]] })
        end
    end
    Bound = alive
    Aura.Sync()

    for _, callback in pairs(ThemeListeners) do
        SafeCall(callback)
    end
    return true
end

local CUSTOM_KEYS = { "Accent", "AccentAlt" }
local CustomColors = {}
for _, Key in ipairs(CUSTOM_KEYS) do
    CustomColors[Key] = Palettes.Dark[Key]
end

local function ColorToHex(Color)
    return string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
end

local function ParseColor(Value)
    local Kind = typeof(Value)
    local Result = nil
    if Kind == "Color3" then
        Result = Value
    elseif Kind == "string" then
        local Red, Green, Blue = string.match(Value, "^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
        Result = Red and Color3.fromRGB(tonumber(Red, 16), tonumber(Green, 16), tonumber(Blue, 16)) or nil
    elseif Kind == "table" then
        local Channels = { Value.R or Value[1], Value.G or Value[2], Value.B or Value[3] }
        Result = #Channels == 3 and Color3.fromRGB(Channels[1], Channels[2], Channels[3]) or nil
    end
    return Result
end

local function BuildCustomPalette()
    local White = Color3.new(1, 1, 1)
    local Accent = CustomColors.Accent
    local Luma = Accent.R * 0.299 + Accent.G * 0.587 + Accent.B * 0.114
    return {
        Background = SURFACE.Background,
        BackgroundTop = SURFACE.BackgroundTop,
        Card = SURFACE.Card,
        Selected = SURFACE.Card:Lerp(Accent, 0.12),
        Outline = SURFACE.Outline,
        Divider = SURFACE.Divider,
        Accent = Accent,
        AccentGlow = Accent:Lerp(White, 0.35),
        AccentAlt = CustomColors.AccentAlt,
        Text = SURFACE.Text,
        SubText = SURFACE.SubText,
        ToggleOff = SURFACE.ToggleOff,
        OnAccent = Luma > 0.62 and Color3.fromRGB(20, 20, 24) or White
    }
end

Palettes.Custom = BuildCustomPalette()

local function SetAccentStyle(Style)
    AccentSolid = Style == "Solid"
    SetTheme(CurrentTheme)
end

local function ApplyCustomColors()
    Palettes.Custom = BuildCustomPalette()
    SetTheme("Custom")
end

local function ResolveParent()
    local ok, container = pcall(function()
        return gethui and gethui()
    end)
    if ok and container then
        return container
    end
    return CoreGui
end

local function Pick(Value, Fallback)
    local Options = { [true] = Value, [false] = Fallback }
    return Options[Value ~= nil]
end

local function CleanName(text)
    text = string.gsub(tostring(text), "[\\\\/:*?\"<>|]", "_")
    text = string.gsub(text, "^%s+", "")
    text = string.gsub(text, "%s+$", "")
    return text ~= "" and text or "default"
end

local function CountDecimals(step)
    local fraction = string.match(tostring(step), "%.(%d+)")
    return fraction and #fraction or 0
end

local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ Tasks = {} }, Maid)
end

function Maid:Give(task)
    table.insert(self.Tasks, task)
    return task
end

function Maid:Destroy()
    for _, task in ipairs(self.Tasks) do
        local kind = typeof(task)
        if kind == "RBXScriptConnection" then
            task:Disconnect()
        elseif kind == "Instance" then
            task:Destroy()
        elseif kind == "function" then
            task()
        end
    end
    table.clear(self.Tasks)
end

local function BindPointer(maid, target, handlers)
    local hovered = false
    local pressed = false

    local function SetHover(state)
        if state == hovered or not handlers.Hover then
            hovered = state
            return
        end
        hovered = state
        handlers.Hover(state)
    end

    local function SetPress(state)
        if state == pressed or not handlers.Press then
            pressed = state
            return
        end
        pressed = state
        handlers.Press(state)
    end

    maid:Give(target.MouseEnter:Connect(function()
        SetHover(true)
    end))

    maid:Give(target.MouseLeave:Connect(function()
        SetPress(false)
        SetHover(false)
    end))

    maid:Give(target.InputBegan:Connect(function(input)
        if not PressTypes[input.UserInputType] then
            return
        end
        if input.UserInputType == Enum.UserInputType.Touch then
            SetHover(true)
        end
        SetPress(true)
    end))

    maid:Give(target.InputEnded:Connect(function(input)
        if not PressTypes[input.UserInputType] then
            return
        end
        SetPress(false)
        if input.UserInputType == Enum.UserInputType.Touch then
            SetHover(false)
        end
    end))
end


local function GuiInset()
    local ok, inset = pcall(function()
        return GuiService:GetGuiInset()
    end)
    return ok and inset or Vector2.zero
end

local function PointInside(gui, position, tolerant)
    local from = gui.AbsolutePosition
    local to = from + gui.AbsoluteSize
    local function Test(point)
        return point.X >= from.X and point.X <= to.X and point.Y >= from.Y and point.Y <= to.Y
    end
    local raw = Vector2.new(position.X, position.Y)
    if Test(raw + GuiInset()) then
        return true
    end
    return tolerant == true and Test(raw)
end

local function TrackPointer(input, onMove, onEnd)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local finished = false
    local last = input.Position
    local connections = {}

    local function Finish(cancelled)
        if finished then
            return
        end
        finished = true
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        if onEnd then
            onEnd(last, cancelled)
        end
    end

    table.insert(connections, UserInputService.InputChanged:Connect(function(moved)
        local same = moved == input
            or (isTouch and moved.UserInputType == Enum.UserInputType.Touch)
            or (not isTouch and moved.UserInputType == Enum.UserInputType.MouseMovement)
        if same then
            last = moved.Position
            if onMove then
                onMove(last)
            end
        end
    end))
    table.insert(connections, input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            Finish(false)
        elseif input.UserInputState == Enum.UserInputState.Cancel then
            Finish(true)
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(ended)
        if ended == input or ended.UserInputType == input.UserInputType then
            Finish(false)
        end
    end))

    return Finish
end

local function BindTap(maid, target, callback)
    maid:Give(target.InputBegan:Connect(function(input)
        if not PressTypes[input.UserInputType] then
            return
        end
        local origin = input.Position
        local moved = false
        TrackPointer(input, function(position)
            if (position - origin).Magnitude > 10 then
                moved = true
            end
        end, function(position, cancelled)
            if cancelled or moved or (position - origin).Magnitude > 10 then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not PointInside(target, position, true) then
                return
            end
            callback(input)
        end)
    end))
end

local Builtins = {
    en = {
        Settings = "Settings",
        SettingsDesc = "Configure UI preferences",
        Language = "Language",
        LanguageDesc = "Choose the interface language",
        Interface = "Interface",
        InterfaceDesc = "Window options",
        Sound = "UI Sounds",
        SoundDesc = "Play sounds on open, clicks and typing",
        Volume = "Sound Volume",
        VolumeDesc = "Adjust how loud the UI sounds are",
        Scale = "UI Scale",
        ScaleDesc = "Resize the whole window",
        Acrylic = "Acrylic Effect",
        AcrylicDesc = "Frosted glass window",
        Transparency = "Transparency",
        TransparencyDesc = "How see-through the window is",
        Blur = "Background Blur",
        BlurDesc = "Blur the game behind the window (needs Acrylic on)",
        AccentStyle = "Accent Color Style",
        StyleGradient = "Gradient Mode",
        StyleSolid = "Solid Mode",
        ToneTitle = "Tone",
        ToneDark = "Dark",
        ToneLight = "Light",
        QuickPalettes = "Quick Accent Palettes (One-Tap)",
        PrimaryAccent = "Primary Accent",
        SecondaryAccent = "Secondary Accent",
        ToggleKey = "Toggle Key",
        ToggleKeyDesc = "Key to show or hide the window",
        ColorDone = "Done",
        ColorCancel = "Cancel",
        ResetAll = "Reset UI Settings",
        ResetAllDesc = "Restore every UI setting to default",
        Reset = "Reset UI Position",
        ResetDesc = "Move the window back to the center",
        Search = "Search...",
        None = "None",
        Select = "Select...",
        ManageFor = "Manage options and settings for %s",
        Appearance = "Appearance",
        AppearanceDesc = "Customize colors",
        Theme = "Theme",
        ThemeDesc = "Pick a color theme",
        ThemeDark = "Dark",
        ThemeLight = "Light",
        ThemeBlue = "Blue",
        ThemePurple = "Purple",
        ThemeRose = "Rose",
        ThemeCustom = "Custom",
        CustomTheme = "Custom Theme",
        CustomThemeDesc = "Pick your own colors",
        ColorAccent = "Accent",
        ColorAccentAlt = "Accent Alt",
        ColorBackground = "Background",
        ColorCard = "Card",
        ColorText = "Text",
        ColorSubText = "Sub Text",
        ResetColors = "Reset Colors",
        ResetColorsDesc = "Restore the default custom colors",
        Notifications = "Notifications",
        NotificationsDesc = "Toast options",
        NotifyTimer = "Timer Bar",
        NotifyTimerDesc = "Show the countdown line on notifications",
        NotifyLine = "Line Color",
        NotifyLineDesc = "Color of the stripe on the left edge",
        NotifyLineReset = "Auto Line Color",
        NotifyLineResetDesc = "Use the default color for each type",
        NotifyTest = "Test Notification",
        NotifyTestDesc = "Preview how a notification looks",
        NotifyTestBody = "This is a sample notification",
        Privacy = "Privacy",
        PrivacyDesc = "Hide personal info",
        HideName = "Hide Name",
        HideNameDesc = "Mask your name on the profile card",
        HideProfile = "Hide Profile",
        HideProfileDesc = "Hide the whole profile card",
        NoResults = "No results"
    },
    th = {
        Settings = "ตั้งค่า",
        SettingsDesc = "ปรับแต่งการใช้งานเมนู",
        Language = "ภาษา",
        LanguageDesc = "เลือกภาษาของหน้าต่างเมนู",
        Interface = "หน้าตาเมนู",
        InterfaceDesc = "ตั้งค่าหน้าต่าง",
        Sound = "เสียงเมนู",
        SoundDesc = "เล่นเสียงตอนเปิดเมนู กดปุ่ม และพิมพ์",
        Volume = "ระดับเสียง",
        VolumeDesc = "ปรับความดังของเสียงเมนู",
        Scale = "ขนาดเมนู",
        ScaleDesc = "ปรับขนาดหน้าต่างทั้งหมด",
        Acrylic = "เอฟเฟกต์ Acrylic",
        AcrylicDesc = "หน้าต่างแบบกระจกฝ้า",
        Transparency = "ความโปร่งใส",
        TransparencyDesc = "ปรับความโปร่งแสงของหน้าต่าง",
        Blur = "เบลอพื้นหลัง",
        BlurDesc = "เบลอฉากเกมด้านหลังหน้าต่าง (ต้องเปิด Acrylic)",
        AccentStyle = "สไตล์สีเน้น",
        StyleGradient = "โหมดไล่สี",
        StyleSolid = "โหมดสีเดียว",
        ToneTitle = "โทนสี",
        ToneDark = "มืด",
        ToneLight = "สว่าง",
        QuickPalettes = "พาเลตสีด่วน (แตะครั้งเดียว)",
        PrimaryAccent = "สีเน้นหลัก",
        SecondaryAccent = "สีเน้นรอง",
        ToggleKey = "ปุ่มเปิด/ปิดเมนู",
        ToggleKeyDesc = "ปุ่มลัดสำหรับแสดงหรือซ่อนหน้าต่าง",
        ColorDone = "เสร็จสิ้น",
        ColorCancel = "ยกเลิก",
        ResetAll = "รีเซ็ตการตั้งค่า UI",
        ResetAllDesc = "คืนค่าการตั้งค่า UI ทั้งหมดเป็นค่าเริ่มต้น",
        Reset = "รีเซ็ตตำแหน่งเมนู",
        ResetDesc = "ย้ายหน้าต่างกลับมากลางจอ",
        Search = "ค้นหา...",
        None = "ไม่มี",
        Select = "เลือก...",
        ManageFor = "จัดการตัวเลือกและการตั้งค่าของ %s",
        Appearance = "ธีม",
        AppearanceDesc = "ปรับสีหน้าตาเมนู",
        Theme = "ธีมสี",
        ThemeDesc = "เลือกธีมสีที่ชอบ",
        ThemeDark = "มืด",
        ThemeLight = "ขาว",
        ThemeBlue = "ฟ้า",
        ThemePurple = "ม่วง",
        ThemeRose = "ชมพู",
        ThemeCustom = "กำหนดเอง",
        CustomTheme = "ธีมกำหนดเอง",
        CustomThemeDesc = "เลือกสีได้อิสระ",
        ColorAccent = "สีหลัก",
        ColorAccentAlt = "สีรอง",
        ColorBackground = "สีพื้นหลัง",
        ColorCard = "สีการ์ด",
        ColorText = "สีตัวอักษร",
        ColorSubText = "สีตัวอักษรรอง",
        ResetColors = "รีเซ็ตสี",
        ResetColorsDesc = "คืนค่าสีกำหนดเองเป็นค่าเริ่มต้น",
        Notifications = "การแจ้งเตือน",
        NotificationsDesc = "ตั้งค่าแจ้งเตือนมุมจอ",
        NotifyTimer = "เส้นนับเวลา",
        NotifyTimerDesc = "แสดงเส้นนับถอยหลังในแจ้งเตือน",
        NotifyLine = "สีเส้นข้างหน้า",
        NotifyLineDesc = "สีของเส้นด้านซ้ายของแจ้งเตือน",
        NotifyLineReset = "สีเส้นอัตโนมัติ",
        NotifyLineResetDesc = "ใช้สีตามประเภทแจ้งเตือน",
        NotifyTest = "ทดสอบแจ้งเตือน",
        NotifyTestDesc = "ดูตัวอย่างหน้าตาแจ้งเตือน",
        NotifyTestBody = "นี่คือข้อความแจ้งเตือนตัวอย่าง",
        Privacy = "ความเป็นส่วนตัว",
        PrivacyDesc = "ซ่อนข้อมูลส่วนตัว",
        HideName = "ปิดชื่อ",
        HideNameDesc = "ซ่อนชื่อในการ์ดโปรไฟล์",
        HideProfile = "ปิดโปรไฟล์",
        HideProfileDesc = "ซ่อนการ์ดโปรไฟล์ทั้งหมด",
        NoResults = "ไม่พบผลลัพธ์"
    }
}

local Localization = {}
Localization.__index = Localization

function Localization.new()
    return setmetatable({
        Enabled = true,
        Prefix = "L:",
        Language = "en",
        Default = "en",
        Translations = {},
        Patterns = {},
        HasPhrases = false,
        Names = { en = "English", th = "ไทย" },
        Bindings = setmetatable({}, { __mode = "k" }),
        Listeners = {},
        NextId = 0
    }, Localization)
end

function Localization:AddTranslations(translations)
    for code, pack in pairs(translations or {}) do
        local target = self.Translations[code]
        if not target then
            target = {}
            self.Translations[code] = target
        end
        for key, value in pairs(pack) do
            target[key] = value
            if key ~= "LanguageName" and string.sub(key, 1, 9) ~= "Fracture." then
                self.HasPhrases = true
            end
        end
    end
end

function Localization:AddPatterns(patterns)
    for code, list in pairs(patterns or {}) do
        local Target = self.Patterns[code]
        if not Target then
            Target = {}
            self.Patterns[code] = Target
        end
        for _, entry in ipairs(list) do
            table.insert(Target, entry)
            self.HasPhrases = true
        end
    end
end

function Localization:Configure(config)
    config = config or {}
    if config.Enabled ~= nil then
        self.Enabled = config.Enabled ~= false
    end
    self.Prefix = config.Prefix or self.Prefix
    self.Default = config.DefaultLanguage or self.Default
    self:AddTranslations(config.Translations)
    if config.Language then
        self.Language = config.Language
    elseif not self.Translations[self.Language] and self.Language ~= "en" and self.Language ~= "th" then
        self.Language = self.Default
    end
    self:_Apply()
end

function Localization:SetLanguage(code)
    if code == nil or code == self.Language then
        return
    end
    self.Language = code
    self:_Apply()
end

function Localization:GetName(code)
    local pack = self.Translations[code]
    return (pack and pack.LanguageName) or self.Names[code] or code
end

function Localization:GetCode(name)
    for _, entry in ipairs(self:GetLanguages()) do
        if entry.Name == name then
            return entry.Code
        end
    end
    return nil
end

function Localization:GetLanguages()
    local list = {}
    local seen = {}

    local function Add(code)
        if not seen[code] then
            seen[code] = true
            table.insert(list, { Code = code, Name = self:GetName(code) })
        end
    end

    Add("en")
    Add("th")

    local extra = {}
    for code in pairs(self.Translations) do
        if not seen[code] then
            table.insert(extra, code)
        end
    end
    table.sort(extra)
    for _, code in ipairs(extra) do
        Add(code)
    end

    return list
end

local Separators = { "\n", " | ", " / " }

function Localization:_Line(Text, Pack, Patterns, Depth)
    local Result = Pack[Text]
    local Index = 1
    while Result == nil and Index <= #Patterns do
        local Entry = Patterns[Index]
        local Captures = { string.match(Text, Entry[1]) }
        if #Captures > 0 then
            Result = (string.gsub(Entry[2], "%%(%d)", function(Slot)
                local Value = Captures[tonumber(Slot)] or ""
                return Depth < 8 and self:_Whole(Value, Pack, Patterns, Depth + 1) or Value
            end))
        end
        Index = Index + 1
    end
    return Result
end

function Localization:_Whole(Text, Pack, Patterns, Depth)
    local Result = self:_Line(Text, Pack, Patterns, Depth)
    local Index = 1
    while Result == nil and Index <= #Separators do
        local Separator = Separators[Index]
        if string.find(Text, Separator, 1, true) then
            local Parts = string.split(Text, Separator)
            for PartIndex, Part in ipairs(Parts) do
                Parts[PartIndex] = self:_Whole(Part, Pack, Patterns, Depth)
            end
            Result = table.concat(Parts, Separator)
        end
        Index = Index + 1
    end
    return Result or Text
end

function Localization:Auto(Text)
    local Pack = self.Translations[self.Language]
    local Result = Text
    if self.HasPhrases and Pack and self.Language ~= "en" and Text ~= "" then
        Result = self:_Whole(Text, Pack, self.Patterns[self.Language] or {}, 0)
    end
    return Result
end

function Localization:Translate(text)
    local Result = text
    if self.Enabled and type(text) == "string" then
        local PrefixLength = #self.Prefix
        if string.sub(text, 1, PrefixLength) == self.Prefix then
            local Key = string.sub(text, PrefixLength + 1)
            local Pack = self.Translations[self.Language]
            local Value = Pack and Pack[Key]
            if Value == nil then
                local Fallback = self.Translations[self.Default]
                Value = Fallback and Fallback[Key]
            end
            Result = Value or Key
        else
            Result = self:Auto(text)
        end
    end
    return Result
end

function Localization:Builtin(key)
    local pack = self.Translations[self.Language]
    local custom = pack and pack["Fracture." .. key]
    if custom then
        return custom
    end
    local own = Builtins[self.Language]
    if own and own[key] then
        return own[key]
    end
    return Builtins.en[key] or key
end

function Localization:Resolve(source)
    if type(source) == "function" then
        return source()
    end
    if type(source) == "string" then
        return self:Translate(source)
    end
    return tostring(source)
end

function Localization:IsDynamic(source)
    local Kind = type(source)
    return Kind == "function" or (Kind == "string" and (self.HasPhrases or string.sub(source, 1, #self.Prefix) == self.Prefix))
end

function Localization:Bind(object, property, source)
    object[property] = self:Resolve(source)
    local bound = self.Bindings[object]
    if self:IsDynamic(source) then
        if not bound then
            bound = {}
            self.Bindings[object] = bound
        end
        bound[property] = source
    elseif bound then
        bound[property] = nil
    end
end

function Localization:Listen(callback)
    self.NextId = self.NextId + 1
    local id = self.NextId
    self.Listeners[id] = callback
    return function()
        self.Listeners[id] = nil
    end
end

function Localization:_Apply()
    for object, properties in pairs(self.Bindings) do
        for property, source in pairs(properties) do
            object[property] = self:Resolve(source)
        end
    end
    for _, callback in pairs(self.Listeners) do
        SafeCall(callback)
    end
end

local Locale = Localization.new()

local function Builtin(key)
    return function()
        return Locale:Builtin(key)
    end
end

local Flags = {}
local FlagElements = {}

local Element = {}
Element.__index = Element

function Element.extend()
    local class = {}
    class.__index = class
    return setmetatable(class, { __index = Element })
end

function Element:_Init(section, config, defaultTitle)
    self.Section = section
    self.Window = section.Window
    self.Callback = config.Callback
    self.TitleSource = config.Title or config.Name or defaultTitle
    self.DescSource = config.Desc
    self.HasDesc = config.Desc ~= nil and config.Desc ~= ""
    self.IconSource = config.Icon
    self.Flag = config.Flag
    self.Locked = config.Locked == true or config.Disabled == true
    self.Hidden = config.Visible == false
    self.Destroyed = false
    self.Listeners = {}
    self.NextListener = 0
end

function Element:_RowHeight()
    return self.HasDesc and 62 or 48
end

function Element:_TextX()
    if self.IconSource ~= nil then
        return math.max(self.BaseTextX, 52)
    end
    return self.BaseTextX
end

function Element:_CreateLabels(parent, textX, rightInset)
    self.BaseTextX = textX
    self.RightInset = rightInset

    self.IconImage = New("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        ImageColor3 = C.SubText,
        Visible = false,
        Parent = parent
    })

    self.TitleLabel = New("TextLabel", {
        TextSize = 13,
        Weight = "Medium",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = parent
    })
    Locale:Bind(self.TitleLabel, "Text", self.TitleSource)

    self.DescLabel = New("TextLabel", {
        TextSize = 11,
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Visible = false,
        Parent = parent
    })
    Locale:Bind(self.DescLabel, "Text", self.DescSource or "")

    self:_ApplyLabels()
end

function Element:_ApplyLabels()
    if not self.TitleLabel then
        return
    end
    local textX = self:_TextX()
    local hasDesc = self.HasDesc
    local width = -(textX + self.RightInset)

    self.IconImage.Visible = self.IconSource ~= nil
    if self.IconSource ~= nil then
        self.IconImage.Image = ResolveIcon(self.IconSource, "rbxassetid://6023426915")
        self.IconImage.Position = UDim2.fromOffset(16, (hasDesc and 31 or 24) - 10)
    end

    self.TitleLabel.Size = UDim2.new(1, width, 0, 20)
    self.TitleLabel.Position = UDim2.fromOffset(textX, hasDesc and 10 or 14)

    self.DescLabel.Visible = hasDesc
    self.DescLabel.Size = UDim2.new(1, width, 0, 18)
    self.DescLabel.Position = UDim2.fromOffset(textX, 32)
end

function Element:_Layout()
    self:_ApplyLabels()
    if self.Head then
        self.Head.Frame.Size = UDim2.new(1, 0, 0, self:_RowHeight())
    end
end

function Element:_ApplyLocked()
    local fade = self.Locked and 0.55 or 0
    if self.TitleLabel then
        self.TitleLabel.TextTransparency = fade
        self.DescLabel.TextTransparency = fade
        self.IconImage.ImageTransparency = fade
    end
    local hook = self._OnLocked
    if hook then
        hook(self, self.Locked)
    end
end

function Element:_SyncFlag()
    if self.Flag then
        Flags[self.Flag] = self:Get()
    end
end

function Element:_Emit(value, ...)
    if self.Flag then
        Flags[self.Flag] = value
    end
    SafeCall(self.Callback, value, ...)
    for _, listener in pairs(self.Listeners) do
        SafeCall(listener, value, ...)
    end
    if self.Flag and self.Window then
        self.Window:_QueueSave()
    end
end

function Element:_Finish(row, divider)
    self.Row = row
    if self.Flag then
        FlagElements[self.Flag] = self
        self:_SyncFlag()
    end
    self:_ApplyLocked()
    self.Section:_Register(self, row, divider)
    self.Section:_Refresh()
    return self
end

function Element:SetTitle(source)
    self.TitleSource = source
    Locale:Bind(self.TitleLabel, "Text", source)
    self.Section:_Refresh()
end

function Element:GetTitle()
    return Locale:Resolve(self.TitleSource)
end

function Element:SetDesc(source)
    self.DescSource = source
    self.HasDesc = source ~= nil and source ~= ""
    Locale:Bind(self.DescLabel, "Text", source or "")
    self:_Layout()
end

function Element:GetDesc()
    if not self.HasDesc then
        return ""
    end
    return Locale:Resolve(self.DescSource)
end

function Element:SetIcon(icon)
    self.IconSource = icon
    self:_Layout()
end

function Element:SetVisible(state)
    self.Hidden = state == false
    self.Section:_Refresh()
end

function Element:Show()
    self:SetVisible(true)
end

function Element:Hide()
    self:SetVisible(false)
end

function Element:SetLocked(state)
    self.Locked = state == true
    self:_ApplyLocked()
end

function Element:SetEnabled(state)
    self:SetLocked(state == false)
end

function Element:IsLocked()
    return self.Locked
end

function Element:SetCallback(callback)
    self.Callback = callback
end

function Element:OnChanged(callback)
    self.NextListener = self.NextListener + 1
    local id = self.NextListener
    self.Listeners[id] = callback
    return function()
        self.Listeners[id] = nil
    end
end

function Element:Set() end

function Element:Get()
    return nil
end

function Element:SetValue(...)
    return self:Set(...)
end

function Element:GetValue()
    return self:Get()
end

function Element:Refresh()
    Locale:Bind(self.TitleLabel, "Text", self.TitleSource)
    Locale:Bind(self.DescLabel, "Text", self.DescSource or "")
    self:_Layout()
end

function Element:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    local hook = self._Cleanup
    if hook then
        hook(self)
    end
    if self.Flag and FlagElements[self.Flag] == self then
        FlagElements[self.Flag] = nil
        Flags[self.Flag] = nil
    end
    self.Section:_Unregister(self)
    if self.Row then
        self.Row:Destroy()
    end
end

function Element:_CreateHead(parent, height, order, mode)
    local maid = self.Window.Maid

    local frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = order,
        Parent = parent
    })

    local divider = New("Frame", {
        Size = UDim2.new(1, -28, 0, 1),
        Position = UDim2.fromOffset(14, 0),
        BackgroundColor3 = C.Divider,
        Parent = frame
    })

    local glowStroke = Stroke(C.AccentGlow, 1, 1)
    local glow = New("Frame", {
        Size = UDim2.new(1, -12, 1, -6),
        Position = UDim2.fromOffset(6, 3),
        BackgroundColor3 = C.AccentGlow,
        BackgroundTransparency = 1,
        Parent = frame
    }, { Corner(8), glowStroke })

    local scale = mode == "bounce" and New("UIScale", { Scale = 1 }) or nil
    local hit = New("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        Parent = frame
    }, scale and { scale } or nil)

    local head = { Frame = frame, Divider = divider, Hit = hit, OnHover = nil }
    local hovered = false
    local pressed = false

    local function Render()
        local fill = 1
        local line = 1
        if pressed then
            fill, line = 0.93, 0.86
        elseif hovered then
            fill, line = 0.972, 1
        end
        Tween(glow, 0.2, { BackgroundTransparency = fill })
        Tween(glowStroke, 0.2, { Transparency = line })
    end

    BindPointer(maid, hit, mode == "none" and {} or {
        Hover = function(state)
            hovered = state
            Render()
            if head.OnHover then
                head.OnHover(state)
            end
        end,
        Press = mode and function(state)
            pressed = state
            Render()
            if scale then
                if state then
                    Tween(scale, 0.12, { Scale = 0.983 }, Enum.EasingStyle.Sine)
                else
                    Tween(scale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back)
                end
            end
        end or nil
    })

    self.Head = head
    return head
end

local UIButton = Element.extend()

function UIButton.new(section, config)
    local self = setmetatable({}, UIButton)
    self:_Init(section, config, "Button")
    self.ButtonTextSource = config.ButtonText

    local window = self.Window
    local head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "bounce")
    local hasText = self.ButtonTextSource ~= nil and self.ButtonTextSource ~= ""

    self:_CreateLabels(head.Hit, 16, hasText and 128 or 52)

    local pillStroke = Stroke(C.AccentGlow, 0.6, 1)
    self.Pill = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(0, 28),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, -16, 0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Visible = hasText,
        Parent = head.Hit
    }, {
        Corner(7),
        pillStroke,
        Aura.Make("Fill")
    })
    self.PillText = New("TextLabel", {
        Size = UDim2.fromOffset(0, 28),
        AutomaticSize = Enum.AutomaticSize.X,
        TextColor3 = C.OnAccent,
        TextXAlignment = Enum.TextXAlignment.Center,
        Weight = "SemiBold",
        Parent = self.Pill
    }, {
        New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) })
    })
    Locale:Bind(self.PillText, "Text", self.ButtonTextSource or "")

    self.Arrow = New("ImageLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -16, 0.5, 0),
        Image = IconList.chevronRight,
        ImageColor3 = C.SubText,
        Visible = not hasText,
        Parent = head.Hit
    })

    head.OnHover = function(state)
        if self.Pill.Visible then
            Tween(pillStroke, 0.2, { Transparency = state and 0.4 or 0.6 })
            Tween(self.Pill, 0.2, { BackgroundTransparency = state and 0.14 or 0 })
        else
            Tween(self.Arrow, 0.22, {
                Position = state and UDim2.new(1, -13, 0.5, 0) or UDim2.new(1, -16, 0.5, 0),
                ImageColor3 = state and Theme.Text or Theme.SubText
            })
        end
        Tween(self.IconImage, 0.2, { ImageColor3 = state and Theme.Text or Theme.SubText })
    end

    BindTap(window.Maid, head.Hit, function()
        if self.Locked then
            return
        end
        window:PlayClick("Button")
        self:Fire()
    end)

    return self:_Finish(head.Frame, head.Divider)
end

function UIButton:_ApplyMode()
    local hasText = self.ButtonTextSource ~= nil and self.ButtonTextSource ~= ""
    self.Pill.Visible = hasText
    self.Arrow.Visible = not hasText
    self.RightInset = hasText and 128 or 52
    Locale:Bind(self.PillText, "Text", self.ButtonTextSource or "")
    self:_ApplyLabels()
end

function UIButton:SetButtonText(source)
    self.ButtonTextSource = source
    self:_ApplyMode()
end

function UIButton:Fire(...)
    SafeCall(self.Callback, ...)
    for _, listener in pairs(self.Listeners) do
        SafeCall(listener, ...)
    end
end

UIButton.Click = UIButton.Fire

function UIButton:Refresh()
    Element.Refresh(self)
    self:_ApplyMode()
end

local UIToggle = Element.extend()

function UIToggle.new(section, config)
    local self = setmetatable({}, UIToggle)
    self:_Init(section, config, "Toggle")
    self.Value = (config.Default == true) or (config.Value == true)

    local window = self.Window
    local head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "tint")
    self:_CreateLabels(head.Hit, 16, 80)

    local trackStroke = Stroke(C.AccentGlow, 1, 1)
    self.Track = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(38, 20),
        Position = UDim2.new(1, -16, 0.5, 0),
        BackgroundColor3 = C.ToggleOff,
        Parent = head.Hit
    }, { Corner(nil, true), trackStroke })

    self.Fill = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = self.Value and 0 or 1,
        Parent = self.Track
    }, { Corner(nil, true), Aura.Make("Fill") })

    self.Knob = New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(14, 14),
        Position = self.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = self.Track
    }, { Corner(nil, true) })

    head.OnHover = function(state)
        Tween(trackStroke, 0.2, { Transparency = state and 0.78 or 1 })
        Tween(self.IconImage, 0.2, { ImageColor3 = state and Theme.Text or Theme.SubText })
    end

    BindTap(window.Maid, head.Hit, function()
        if self.Locked then
            return
        end
        window:PlayClick("Toggle")
        self:Set(not self.Value)
    end)

    return self:_Finish(head.Frame, head.Divider)
end

function UIToggle:_Paint()
    Tween(self.Knob, 0.2, {
        Position = self.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    }, Enum.EasingStyle.Quint)
    Tween(self.Fill, 0.2, { BackgroundTransparency = self.Value and 0 or 1 })
end

function UIToggle:Set(value, silent)
    local new = value == true
    local changed = new ~= self.Value
    self.Value = new
    self:_Paint()
    self:_SyncFlag()
    if changed and not silent then
        self:_Emit(self.Value)
    end
end

function UIToggle:Get()
    return self.Value
end

function UIToggle:Toggle(silent)
    self:Set(not self.Value, silent)
end

function UIToggle:Refresh()
    Element.Refresh(self)
    self:_Paint()
end

local UILabel = Element.extend()

function UILabel.new(section, config)
    local self = setmetatable({}, UILabel)
    self:_Init(section, config, "Label")
    local head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "none")
    self:_CreateLabels(head.Hit, 16, 16)
    self.DescLabel.TextWrapped = true
    self.DescLabel.TextTruncate = Enum.TextTruncate.None
    self.DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.DescLabel.AutomaticSize = Enum.AutomaticSize.Y
    self.DescLabel.LineHeight = 1.25
    self.Window.Maid:Give(self.DescLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        self:_Layout()
    end))
    return self:_Finish(head.Frame, head.Divider)
end

function UILabel:_RowHeight()
    local Bounds = self.DescLabel and self.DescLabel.TextBounds.Y or 0
    return self.HasDesc and math.max(62, 32 + math.ceil(Bounds) + 14) or 48
end

UILabel.SetText = Element.SetTitle

local HUE_KEYS = {
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
    ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
    ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
    ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
    ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))
}

local ACCENT_PRESETS = {
    Color3.fromRGB(239, 68, 68),
    Color3.fromRGB(245, 158, 11),
    Color3.fromRGB(14, 165, 233),
    Color3.fromRGB(16, 185, 129),
    Color3.fromRGB(139, 92, 246),
    Color3.fromRGB(244, 63, 94),
    Color3.fromRGB(37, 99, 235),
    Color3.fromRGB(249, 115, 22),
    Color3.fromRGB(132, 204, 22),
    Color3.fromRGB(148, 163, 184)
}

local UIColorPicker = Element.extend()

function UIColorPicker.new(section, config)
    local self = setmetatable({}, UIColorPicker)
    self:_Init(section, config, "ColorPicker")
    self.Value = ParseColor(Pick(config.Default, config.Value)) or Color3.new(1, 1, 1)

    local Window = self.Window
    local Head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "tint")
    self:_CreateLabels(Head.Hit, 16, 160)

    self.HexLabel = New("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -68, 0.5, 0),
        Size = UDim2.fromOffset(80, 18),
        TextSize = 12,
        Weight = "Medium",
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = ColorToHex(self.Value),
        Parent = Head.Hit
    })

    self.Swatch = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(44, 26),
        Position = UDim2.new(1, -16, 0.5, 0),
        BackgroundColor3 = self.Value,
        Parent = Head.Hit
    }, { Corner(8), Stroke(C.Outline, 0, 1) })

    BindTap(Window.Maid, Head.Hit, function()
        if not self.Locked then
            Window:PlayClick("Button")
            Window:OpenColorPicker(self)
        end
    end)

    return self:_Finish(Head.Frame, Head.Divider)
end

function UIColorPicker:Set(Value, Silent)
    local Color = ParseColor(Value)
    if Color then
        local Changed = Color ~= self.Value
        self.Value = Color
        self.Swatch.BackgroundColor3 = Color
        self.HexLabel.Text = ColorToHex(Color)
        self:_SyncFlag()
        if Changed and not Silent then
            self:_Emit(self.Value)
        end
    end
end

function UIColorPicker:Get()
    return self.Value
end

function UIColorPicker:GetHex()
    return ColorToHex(self.Value)
end

local UISegmented = Element.extend()

function UISegmented.new(section, config)
    local self = setmetatable({}, UISegmented)
    self:_Init(section, config, "Segmented")
    self.Value = config.Default
    self.Entries = {}

    local Window = self.Window
    local Options = config.Options or {}
    local Count = math.max(#Options, 1)
    local HasTitle = config.Title ~= nil
    local Head = self:_CreateHead(section.Card, HasTitle and 82 or 58, section:NextOrder(), nil)

    if HasTitle then
        local TitleLabel = New("TextLabel", {
            Position = UDim2.fromOffset(16, 12),
            Size = UDim2.new(1, -32, 0, 18),
            TextSize = 11,
            Weight = "SemiBold",
            TextColor3 = C.SubText,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Head.Frame
        })
        Locale:Bind(TitleLabel, "Text", self.TitleSource)
    end

    local Holder = New("Frame", {
        Position = UDim2.fromOffset(16, HasTitle and 36 or 11),
        Size = UDim2.new(1, -32, 0, 38),
        BackgroundTransparency = 1,
        Parent = Head.Frame
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    })

    for Index, Option in ipairs(Options) do
        local Key = type(Option) == "table" and Option.Key or Option
        local Text = type(Option) == "table" and (Option.Text or Option.Key) or Option
        local Button = New("TextButton", {
            Size = UDim2.new(1 / Count, -8 * (Count - 1) / Count, 1, 0),
            BackgroundTransparency = 0,
            BackgroundColor3 = C.Background,
            LayoutOrder = Index,
            Parent = Holder
        }, { Corner(12), Stroke(C.Outline, 0.4, 1) })

        local Selected = New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Parent = Button
        }, { Corner(12), Aura.Make("Fill") })

        local Label = New("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            TextSize = 13,
            Weight = "SemiBold",
            TextColor3 = Theme.SubText,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = Button
        })
        Locale:Bind(Label, "Text", Text)

        table.insert(self.Entries, { Key = Key, Selected = Selected, Label = Label })

        BindTap(Window.Maid, Button, function()
            if not self.Locked then
                Window:PlayClick("Button")
                self:Set(Key)
            end
        end)
    end

    Window.Maid:Give(OnTheme(function()
        self:_Render(true)
    end))

    self:_Render(true)
    return self:_Finish(Head.Frame, Head.Divider)
end

function UISegmented:_ApplyLabels()
end

function UISegmented:_Layout()
end

function UISegmented:_Render(Instant)
    for _, Entry in ipairs(self.Entries) do
        local Active = Entry.Key == self.Value
        local Goal = Active and Theme.OnAccent or Theme.SubText
        if Instant then
            Entry.Selected.BackgroundTransparency = Active and 0 or 1
            Entry.Label.TextColor3 = Goal
        else
            Tween(Entry.Selected, 0.22, { BackgroundTransparency = Active and 0 or 1 })
            Tween(Entry.Label, 0.22, { TextColor3 = Goal })
        end
    end
end

function UISegmented:Set(Key, Silent)
    local Changed = Key ~= self.Value
    self.Value = Key
    self:_Render(false)
    self:_SyncFlag()
    if Changed and Key ~= nil and not Silent then
        self:_Emit(Key)
    end
end

function UISegmented:Get()
    return self.Value
end

local UIPalette = Element.extend()

function UIPalette.new(section, config)
    local self = setmetatable({}, UIPalette)
    self:_Init(section, config, "Palette")
    self.Chips = {}

    local Window = self.Window
    local Colors = config.Colors or ACCENT_PRESETS
    local Columns = config.Columns or 5
    local Rows = math.ceil(#Colors / Columns)
    local HasTitle = config.Title ~= nil
    local Top = HasTitle and 36 or 12
    local Head = self:_CreateHead(section.Card, Top + Rows * 42 + 6, section:NextOrder(), nil)

    if HasTitle then
        local TitleLabel = New("TextLabel", {
            Position = UDim2.fromOffset(16, 12),
            Size = UDim2.new(1, -32, 0, 18),
            TextSize = 11,
            Weight = "SemiBold",
            TextColor3 = C.SubText,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Head.Frame
        })
        Locale:Bind(TitleLabel, "Text", self.TitleSource)
    end

    local Grid = New("Frame", {
        Position = UDim2.fromOffset(16, Top),
        Size = UDim2.new(1, -32, 0, Rows * 42),
        BackgroundTransparency = 1,
        Parent = Head.Frame
    }, {
        New("UIGridLayout", {
            CellSize = UDim2.new(1 / Columns, -8 * (Columns - 1) / Columns, 0, 34),
            CellPadding = UDim2.fromOffset(8, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    })

    for Index, Color in ipairs(Colors) do
        local ChipStroke = Stroke(Color3.new(1, 1, 1), 1, 2)
        local Chip = New("TextButton", {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color,
            LayoutOrder = Index,
            Parent = Grid
        }, { Corner(10), ChipStroke })
        local ChipScale = New("UIScale", { Scale = 1, Parent = Chip })
        table.insert(self.Chips, { Stroke = ChipStroke, Color = Color })

        BindTap(Window.Maid, Chip, function()
            if not self.Locked then
                Window:PlayClick("Button")
                for _, Other in ipairs(self.Chips) do
                    Tween(Other.Stroke, 0.2, { Transparency = Other.Stroke == ChipStroke and 0.1 or 1 })
                end
                Tween(ChipScale, 0.1, { Scale = 0.9 }, Enum.EasingStyle.Sine)
                task.delay(0.1, function()
                    Tween(ChipScale, 0.25, { Scale = 1 }, Enum.EasingStyle.Back)
                end)
                self:_Emit(Color, Index)
            end
        end)
    end

    return self:_Finish(Head.Frame, Head.Divider)
end

function UIPalette:_ApplyLabels()
end

function UIPalette:_Layout()
end

function UIPalette:Get()
    return nil
end

local UIKeybind = Element.extend()

local function ParseKey(Value)
    local Kind = typeof(Value)
    local Result = nil
    if Kind == "EnumItem" and Value.EnumType == Enum.KeyCode then
        Result = Value
    elseif Kind == "string" then
        local Ok, Key = pcall(function()
            return Enum.KeyCode[Value]
        end)
        Result = Ok and Key or nil
    end
    return Result
end

function UIKeybind.new(section, config)
    local self = setmetatable({}, UIKeybind)
    self:_Init(section, config, "Keybind")
    self.Value = ParseKey(Pick(config.Default, config.Value)) or Enum.KeyCode.Unknown
    self.Listening = false

    local Window = self.Window
    local Head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "tint")
    self:_CreateLabels(Head.Hit, 16, 130)

    self.ButtonStroke = Stroke(C.Outline, 0, 1)
    self.Button = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -16, 0.5, 0),
        Size = UDim2.fromOffset(100, 30),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Background,
        TextSize = 12,
        Weight = "SemiBold",
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = Head.Hit
    }, { Corner(8), self.ButtonStroke })

    BindTap(Window.Maid, self.Button, function()
        if not self.Locked then
            Window:PlayClick("Button")
            self:_Listen(not self.Listening)
        end
    end)

    self:_Render()
    return self:_Finish(Head.Frame, Head.Divider)
end

function UIKeybind:_Render()
    local Name = self.Value == Enum.KeyCode.Unknown and "None" or self.Value.Name
    self.Button.Text = self.Listening and "..." or Name
    Tween(self.ButtonStroke, 0.2, { Color = self.Listening and Theme.AccentGlow or Theme.Outline })
end

function UIKeybind:_Listen(State)
    self.Listening = State
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if State then
        self.Connection = UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.Keyboard then
                local Choice = {
                    [Enum.KeyCode.Escape] = self.Value,
                    [Enum.KeyCode.Backspace] = Enum.KeyCode.Unknown
                }
                self:_Listen(false)
                self:Set(Choice[Input.KeyCode] or Input.KeyCode)
            end
        end)
    end
    self:_Render()
end

function UIKeybind:Set(Value, Silent)
    local Key = ParseKey(Value)
    if Key then
        local Changed = Key ~= self.Value
        self.Value = Key
        self:_Render()
        self:_SyncFlag()
        if Changed and not Silent then
            self:_Emit(Key)
        end
    end
end

function UIKeybind:Get()
    return self.Value
end

local function SmoothScroll(Maid, Scroller)
    local Target = 0
    local Current = 0
    local Active = false

    Maid:Give(Scroller.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseWheel then
            local Limit = math.max(Scroller.AbsoluteCanvasSize.Y - Scroller.AbsoluteWindowSize.Y, 0)
            Current = Active and Current or Scroller.CanvasPosition.Y
            Target = math.clamp((Active and Target or Current) - Input.Position.Z * 110, 0, Limit)
            Active = true
        end
    end))

    Maid:Give(RunService.RenderStepped:Connect(function(Dt)
        if Active then
            Current = Current + (Target - Current) * (1 - math.exp(-Dt * 12))
            Active = math.abs(Target - Current) > 0.5
            Current = Active and Current or Target
            Scroller.CanvasPosition = Vector2.new(0, Current)
        end
    end))
end

local function AutoHideBar(Maid, Scroller, Thickness)
    local Token = 0
    Scroller.ScrollBarThickness = Thickness
    Scroller.ScrollBarImageTransparency = 1
    Maid:Give(Scroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        Token = Token + 1
        local Mine = Token
        Tween(Scroller, 0.15, { ScrollBarImageTransparency = 0.1 })
        task.delay(0.9, function()
            if Mine == Token and Scroller.Parent then
                Tween(Scroller, 0.4, { ScrollBarImageTransparency = 1 })
            end
        end)
    end))
end

local UIDropdown = Element.extend()


function UIDropdown.new(section, config)
    local self = setmetatable({}, UIDropdown)
    self:_Init(section, config, "Dropdown")

    local window = self.Window
    self.OptionsSource = config.Options or {}
    self.Options = self:_ResolveOptions()
    self.Multi = config.Multi == true
    self.Searchable = config.Search ~= false
    self.Chosen = {}
    self.Entries = {}
    self.IsOpen = false
    self.PanelHeight = 0
    self.Query = ""
    self.VisibleCount = 0
    self.ListTop = self.Searchable and 46 or 0

    if self.Multi then
        if type(config.Default) == "table" then
            for _, value in ipairs(config.Default) do
                self.Chosen[value] = true
            end
        end
    else
        local default = config.Default
        if default ~= nil then
            self.Chosen[default] = true
        end
    end

    self.Row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = section:NextOrder(),
        Parent = section.Card
    }, {
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })
    })

    local head = self:_CreateHead(self.Row, self:_RowHeight(), 1, "tint")
    self:_CreateLabels(head.Hit, 16, 190)

    self.BoxStroke = Stroke(C.Outline, 0, 1)
    self.ValueBox = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(150, 30),
        Position = UDim2.new(1, -16, 0.5, 0),
        BackgroundColor3 = C.Background,
        Parent = head.Hit
    }, { Corner(8), self.BoxStroke })

    self.ValueLabel = New("TextLabel", {
        Size = UDim2.new(1, -38, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        TextSize = 11,
        Weight = "Medium",
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.ValueBox
    })

    self.Arrow = New("ImageLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -8, 0.5, 0),
        Image = IconList.chevronDown,
        ImageColor3 = C.SubText,
        Parent = self.ValueBox
    })

    head.OnHover = function(state)
        if not self.IsOpen then
            Tween(self.BoxStroke, 0.2, {
                Color = state and Theme.AccentGlow or Theme.Outline,
                Transparency = state and 0.35 or 0
            })
        end
        Tween(self.Arrow, 0.2, { ImageColor3 = state and Theme.Text or Theme.SubText })
        Tween(self.ValueLabel, 0.2, { TextColor3 = state and Theme.Text or Theme.SubText })
        if self.IconImage then
            Tween(self.IconImage, 0.2, { ImageColor3 = state and Theme.Text or Theme.SubText })
        end
    end

    self.PanelWidth = 240
    self.Space = 400
    self.PanelScale = New("UIScale", { Scale = 1 })
    self.Panel = New("Frame", {
        Name = "DropdownPanel",
        Size = UDim2.fromOffset(240, 0),
        BackgroundColor3 = C.Background,
        ClipsDescendants = true,
        Active = true,
        ZIndex = 2,
        Visible = false,
        Parent = window.Overlay
    }, { Corner(12), Stroke(C.Outline, 0, 1), self.PanelScale })

    if self.Searchable then
        local searchStroke = Stroke(C.Outline, 0, 1)
        local searchFrame = New("Frame", {
            Position = UDim2.fromOffset(12, 8),
            Size = UDim2.new(1, -24, 0, 30),
            BackgroundColor3 = C.Card,
            Parent = self.Panel
        }, { Corner(8), searchStroke })

        New("ImageLabel", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(0, 10, 0.5, -7),
            Image = IconList.search,
            ImageColor3 = C.SubText,
            Parent = searchFrame
        })

        self.Search = New("TextBox", {
            Position = UDim2.fromOffset(32, 0),
            Size = UDim2.new(1, -40, 1, 0),
            PlaceholderColor3 = C.SubText,
            ClearTextOnFocus = false,
            Parent = searchFrame
        })
        Locale:Bind(self.Search, "PlaceholderText", Builtin("Search"))

        window.Maid:Give(self.Search.Focused:Connect(function()
            Tween(searchStroke, 0.2, { Color = Theme.AccentGlow })
        end))
        window.Maid:Give(self.Search.FocusLost:Connect(function()
            Tween(searchStroke, 0.2, { Color = Theme.Outline })
        end))
        window.Maid:Give(self.Search:GetPropertyChangedSignal("Text"):Connect(function()
            self.Query = string.lower(self.Search.Text)
            self:_ApplyFilter()
        end))
    end

    self.Scroll = New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, self.ListTop),
        Size = UDim2.new(1, 0, 1, -self.ListTop),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Accent,
        Active = true,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Panel
    }, {
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 8)
        })
    })

    SmoothScroll(window.Maid, self.Scroll)
    AutoHideBar(window.Maid, self.Scroll, 3)
    window.Maid:Give(self.Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self.Panel.Visible and self.Scroll.AbsoluteWindowSize.Y > 0 then
            self.SavedScroll = self.Scroll.CanvasPosition.Y
        end
    end))

    self.Empty = New("TextLabel", {
        Position = UDim2.fromOffset(0, self.ListTop),
        Size = UDim2.new(1, 0, 1, -self.ListTop),
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        Parent = self.Panel
    })
    Locale:Bind(self.Empty, "Text", Builtin("NoResults"))

    BindTap(window.Maid, head.Hit, function()
        if self.Locked then
            return
        end
        window:PlayClick("Toggle")
        self:SetOpen(not self.IsOpen)
    end)

    window.Maid:Give(function()
        if self.OutsideConnection then
            self.OutsideConnection:Disconnect()
            self.OutsideConnection = nil
        end
    end)

    window.Maid:Give(Locale:Listen(function()
        self:_Reindex()
        self:_Refresh(true)
        self:_ApplyFilter()
    end))

    window.Maid:Give(OnTheme(function()
        for _, entry in ipairs(self.Entries) do
            self:_StyleEntry(entry)
        end
    end))

    self:_BuildOptions()
    self:_Refresh(true)

    return self:_Finish(self.Row, head.Divider)
end

function UIDropdown:_ResolveOptions()
    local source = self.OptionsSource
    if type(source) == "function" then
        local ok, list = pcall(source)
        source = ok and list or {}
    end
    return type(source) == "table" and source or {}
end

function UIDropdown:_OnLocked(state)
    if state then
        self:SetOpen(false)
    end
end

function UIDropdown:_Cleanup()
    self:SetOpen(false)
    if self.OutsideConnection then
        self.OutsideConnection:Disconnect()
        self.OutsideConnection = nil
    end
    self.Panel:Destroy()
end

function UIDropdown:_StyleEntry(entry, instant)
    local selected = self.Chosen[entry.Option] == true
    local lit = selected or entry.Hovered
    local transparency = selected and 0.88 or (entry.Hovered and 0.945 or 1)
    local textColor = lit and Theme.Text or Theme.SubText
    local labelPosition = UDim2.new(0, selected and 30 or 14, 0, 0)
    local dotSize = selected and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0)

    if instant then
        entry.Button.BackgroundTransparency = transparency
        entry.Label.TextColor3 = textColor
        entry.Label.Position = labelPosition
        entry.Dot.Size = dotSize
        return
    end

    Tween(entry.Button, 0.18, { BackgroundTransparency = transparency })
    Tween(entry.Label, 0.2, { TextColor3 = textColor, Position = labelPosition })
    Tween(entry.Dot, 0.2, { Size = dotSize })
end

function UIDropdown:_BuildOptions()
    for _, entry in ipairs(self.Entries) do
        entry.Button:Destroy()
    end
    table.clear(self.Entries)
    self.Lookup = {}

    for index, option in ipairs(self.Options) do
        local button = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Color3.new(1, 1, 1),
            LayoutOrder = index,
            Parent = self.Scroll
        }, { Corner(8), Aura.Make("Fill", { Rotation = 20 }) })

        local dot = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0),
            Position = UDim2.new(0, 16, 0.5, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            Parent = button
        }, { Corner(nil, true), Aura.Make("Fill") })

        local label = New("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            TextSize = 12,
            Weight = "Medium",
            TextColor3 = C.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = button
        })
        Locale:Bind(label, "Text", tostring(option))

        local entry = {
            Option = option,
            Button = button,
            Label = label,
            Dot = dot,
            Hovered = false,
            Key = string.lower(tostring(Locale:Resolve(tostring(option))))
        }
        table.insert(self.Entries, entry)
        self.Lookup[option] = entry

        BindPointer(self.Window.Maid, button, {
            Hover = function(state)
                entry.Hovered = state
                self:_StyleEntry(entry)
            end
        })

        BindTap(self.Window.Maid, button, function()
            self.Window:PlayClick("Toggle")
            self:_Choose(option)
        end)

        self:_StyleEntry(entry, true)
    end

    self:_ApplyFilter()
end

function UIDropdown:_RestoreScroll()
    task.defer(function()
        task.wait()
        if not self.Destroyed and self.Panel.Visible then
            local Limit = math.max(self.Scroll.AbsoluteCanvasSize.Y - self.Scroll.AbsoluteWindowSize.Y, 0)
            self.Scroll.CanvasPosition = Vector2.new(0, math.min(self.SavedScroll or 0, Limit))
        end
    end)
end

function UIDropdown:_Reindex()
    for _, entry in ipairs(self.Entries) do
        entry.Key = string.lower(tostring(Locale:Resolve(tostring(entry.Option))))
    end
end

function UIDropdown:_ApplyFilter()
    local query = self.Query or ""
    local visible = 0
    for _, entry in ipairs(self.Entries) do
        local match = query == "" or string.find(entry.Key, query, 1, true) ~= nil
        entry.Button.Visible = match
        if match then
            visible = visible + 1
        end
    end
    self.VisibleCount = visible
    self:_Resize(self.IsOpen)
end

function UIDropdown:_Resize(animate)
    local count = self.VisibleCount
    local content = count * 36 + math.max(count - 1, 0) * 3 + 8
    local listHeight = math.clamp(content, 44, 170)
    self.PanelHeight = self.ListTop + listHeight
    self.Empty.Visible = count == 0 and #self.Options > 0

    local size = UDim2.fromOffset(self.PanelWidth, math.min(self.PanelHeight, self.Space))
    if self.ResizeTween then
        self.ResizeTween:Cancel()
        self.ResizeTween = nil
    end
    if animate then
        self.ResizeTween = Tween(self.Panel, 0.2, { Size = size })
    else
        self.Panel.Size = size
    end
end

function UIDropdown:_Place()
    local main = self.Window.Main
    local frame = self.Head.Frame
    local scale = main.AbsoluteSize.X / main.Size.X.Offset
    local origin = main.AbsolutePosition
    local mainHeight = main.AbsoluteSize.Y / scale

    local top = math.clamp((frame.AbsolutePosition.Y - origin.Y) / scale, 66, mainHeight)
    local bottom = math.clamp(top + frame.AbsoluteSize.Y / scale, 66, mainHeight)
    local right = (frame.AbsolutePosition.X + frame.AbsoluteSize.X - origin.X) / scale - 14

    self:_Resize(false)

    local below = mainHeight - bottom - 12
    local above = top - 12
    local openDown = below >= self.PanelHeight or below >= above

    self.Space = math.max(openDown and below or above, 110)
    self.PanelWidth = math.clamp(frame.AbsoluteSize.X / scale - 28, 170, 280)
    self.Panel.AnchorPoint = Vector2.new(1, openDown and 0 or 1)
    self.Panel.Position = UDim2.fromOffset(right, openDown and bottom + 6 or top - 6)
    self:_Resize(false)
end

function UIDropdown:_Choose(option)
    local touched = { option }
    if self.Multi then
        self.Chosen[option] = not self.Chosen[option] or nil
    else
        for key in pairs(self.Chosen) do
            table.insert(touched, key)
        end
        self.Chosen = { [option] = true }
    end
    for _, key in ipairs(touched) do
        local entry = self.Lookup[key]
        if entry then
            self:_StyleEntry(entry)
        end
    end
    self:_Refresh(false)
    if not self.Multi then
        task.delay(0.12, function()
            if not self.Destroyed then
                self:SetOpen(false)
            end
        end)
    end
end

function UIDropdown:_Refresh(silent)
    local value = self:Get()
    if self.Multi then
        local names = {}
        for index, item in ipairs(value) do
            names[index] = Locale:Resolve(tostring(item))
        end
        self.ValueLabel.Text = #names > 0 and table.concat(names, ", ") or ""
    else
        self.ValueLabel.Text = value ~= nil and Locale:Resolve(tostring(value)) or ""
    end
    self:_SyncFlag()
    if not silent then
        self:_Emit(value)
    end
end

function UIDropdown:Get()
    if self.Multi then
        local list = {}
        for _, option in ipairs(self.Options) do
            if self.Chosen[option] then
                table.insert(list, option)
            end
        end
        return list
    end
    for _, option in ipairs(self.Options) do
        if self.Chosen[option] then
            return option
        end
    end
    return nil
end

function UIDropdown:Set(value, silent)
    self.Chosen = {}
    if self.Multi and type(value) == "table" then
        for _, item in ipairs(value) do
            self.Chosen[item] = true
        end
    elseif value ~= nil then
        self.Chosen[value] = true
    end
    for _, entry in ipairs(self.Entries) do
        self:_StyleEntry(entry)
    end
    self:_Refresh(silent)
end

function UIDropdown:Refresh()
    self.Options = self:_ResolveOptions()
    local pruned = false
    for option in pairs(self.Chosen) do
        if not table.find(self.Options, option) then
            self.Chosen[option] = nil
            pruned = true
        end
    end
    self:_BuildOptions()
    self:_Refresh(not pruned)
end

function UIDropdown:SetOptions(options, keepSelection)
    self.OptionsSource = options or {}
    if keepSelection == false then
        self.Chosen = {}
    end
    self:Refresh()
end

function UIDropdown:GetOptions()
    return table.clone(self.Options)
end

function UIDropdown:AddOption(option, index)
    if table.find(self.Options, option) then
        return
    end
    local list = table.clone(self.Options)
    table.insert(list, math.clamp(index or (#list + 1), 1, #list + 1), option)
    self:SetOptions(list)
end

function UIDropdown:RemoveOption(option)
    local index = table.find(self.Options, option)
    if not index then
        return
    end
    local list = table.clone(self.Options)
    table.remove(list, index)
    self:SetOptions(list)
end

function UIDropdown:IsSelected(option)
    return self.Chosen[option] == true
end

function UIDropdown:Select(value, silent)
    local list = (type(value) == "table") and value or { value }
    local changed = false
    if not self.Multi then
        local single = list[1]
        if single ~= nil and table.find(self.Options, single) and not self.Chosen[single] then
            self.Chosen = { [single] = true }
            changed = true
        end
    else
        for _, item in ipairs(list) do
            if table.find(self.Options, item) and not self.Chosen[item] then
                self.Chosen[item] = true
                changed = true
            end
        end
    end
    if changed then
        for _, entry in ipairs(self.Entries) do
            self:_StyleEntry(entry)
        end
        self:_Refresh(silent)
    end
    return changed
end

function UIDropdown:Deselect(value, silent)
    local list = (type(value) == "table") and value or { value }
    local changed = false
    for _, item in ipairs(list) do
        if self.Chosen[item] then
            self.Chosen[item] = nil
            changed = true
        end
    end
    if changed then
        for _, entry in ipairs(self.Entries) do
            self:_StyleEntry(entry)
        end
        self:_Refresh(silent)
    end
    return changed
end

function UIDropdown:Clear(silent)
    self.Chosen = {}
    for _, entry in ipairs(self.Entries) do
        self:_StyleEntry(entry)
    end
    self:_Refresh(silent)
end

function UIDropdown:SelectAll(silent)
    if self.Multi then
        self:Select(self.Options, silent)
    end
end

function UIDropdown:Open()
    self:SetOpen(true)
end

function UIDropdown:Close()
    self:SetOpen(false)
end

function UIDropdown:SetOpen(state)
    if state and self.Locked then
        return
    end
    if self.IsOpen == state then
        return
    end
    self.IsOpen = state
    local page = self.Section and self.Section.Tab and self.Section.Tab.Content
    if page and page.Parent then
        page.ScrollingEnabled = not state
    end
    Tween(self.Arrow, 0.25, { Rotation = state and 180 or 0 })
    Tween(self.BoxStroke, 0.2, {
        Color = state and Theme.AccentGlow or Theme.Outline,
        Transparency = state and 0.25 or 0
    })

    if self.OutsideConnection then
        self.OutsideConnection:Disconnect()
        self.OutsideConnection = nil
    end

    if state then
        self.Window:ActivateDropdown(self)
        self:_Place()
        self:_RestoreScroll()
        self.PanelScale.Scale = 0.92
        self.Panel.Visible = true
        Tween(self.PanelScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)

        self.OutsideConnection = UserInputService.InputBegan:Connect(function(input)
            if not PressTypes[input.UserInputType] or not self.IsOpen then
                return
            end
            if PointInside(self.Panel, input.Position, true) or PointInside(self.Head.Frame, input.Position, true) then
                return
            end
            self:SetOpen(false)
        end)
    else
        self.Window:ReleaseDropdown(self)
        if self.Search then
            self.Search:ReleaseFocus()
        end
        local tween = Tween(self.PanelScale, 0.16, { Scale = 0.94 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween.Completed:Connect(function()
            if not self.IsOpen and self.Panel.Parent then
                self.Panel.Visible = false
                if self.Search and self.Search.Text ~= "" then
                    self.Search.Text = ""
                end
            end
        end)
    end
end

local UISlider = Element.extend()

function UISlider.new(section, config)
    local self = setmetatable({}, UISlider)
    self:_Init(section, config, "Slider")

    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Step = config.Step or config.Increment or 1
    self.Suffix = config.Suffix or ""
    self.Decimals = CountDecimals(self.Step)
    self.Value = self:_Snap(config.Default or self.Min)
    self.DisplayAlpha = self:_ToAlpha(self.Value)
    self.TargetAlpha = self.DisplayAlpha

    local window = self.Window
    local trackY = self.HasDesc and 70 or 52
    self.TrackY = trackY
    local head = self:_CreateHead(section.Card, trackY + 16, section:NextOrder(), nil)
    self:_CreateLabels(head.Hit, 16, 160)

    local boxStroke = Stroke(C.Outline, 0, 1)
    self.Box = New("TextBox", {
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(60, 28),
        Position = UDim2.new(1, -52, 0, 10),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Background,
        Text = self:_Format(self.Value),
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        Parent = head.Hit
    }, { Corner(7), boxStroke })

    local function StepButton(Text, OffsetX, Direction)
        local Button = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0),
            Size = UDim2.fromOffset(30, 28),
            Position = UDim2.new(1, OffsetX, 0, 10),
            BackgroundTransparency = 0,
            BackgroundColor3 = C.Background,
            Text = Text,
            TextSize = 18,
            Weight = "SemiBold",
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = head.Hit
        }, { Corner(8), Stroke(C.Outline, 0, 1) })

        window.Maid:Give(Button.InputBegan:Connect(function(Input)
            if PressTypes[Input.UserInputType] and not self.Locked then
                self.StepToken = (self.StepToken or 0) + 1
                local Token = self.StepToken
                window:PlayClick("Button")
                self:Set(self.Value + Direction * self.Step)
                local Ended
                Ended = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        self.StepToken = Token + 1
                        Ended:Disconnect()
                    end
                end)
                task.spawn(function()
                    task.wait(0.4)
                    while self.StepToken == Token and not self.Destroyed do
                        self:Set(self.Value + Direction * self.Step)
                        task.wait(0.08)
                    end
                end)
            end
        end))
    end

    StepButton("-", -118, -1)
    StepButton("+", -16, 1)

    self.Track = New("Frame", {
        Position = UDim2.fromOffset(16, trackY - 4),
        Size = UDim2.new(1, -32, 0, 8),
        BackgroundColor3 = C.ToggleOff,
        Parent = head.Frame
    }, { Corner(nil, true) })

    self.Fill = New("Frame", {
        Size = UDim2.fromScale(self.DisplayAlpha, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = self.Track
    }, { Corner(nil, true), Aura.Make("Fill") })

    self.Knob = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.fromScale(self.DisplayAlpha, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = self.Track
    }, { Corner(nil, true), Stroke(C.AccentGlow, 0.3, 1.5) })

    local zone = New("TextButton", {
        Position = UDim2.fromOffset(8, trackY - 16),
        Size = UDim2.new(1, -16, 0, 32),
        Parent = head.Frame
    })

    self.Zone = zone
    window.Maid:Give(zone.InputBegan:Connect(function(input)
        if PressTypes[input.UserInputType] and not self.Locked then
            self:_BeginDrag(input)
        end
    end))

    window.Maid:Give(self.Box.Focused:Connect(function()
        self.Box.Text = self:_FormatNumber(self.Value)
        Tween(boxStroke, 0.2, { Color = Theme.AccentGlow })
    end))

    window.Maid:Give(self.Box.FocusLost:Connect(function()
        Tween(boxStroke, 0.2, { Color = Theme.Outline })
        local typed = tonumber(string.match(self.Box.Text, "%-?%d+%.?%d*"))
        if typed then
            self:Set(typed)
        else
            self.Box.Text = self:_Format(self.Value)
        end
    end))

    return self:_Finish(head.Frame, head.Divider)
end

function UISlider:_OnLocked(state)
    self.Box.TextEditable = not state
end

function UISlider:_Layout()
    self:_ApplyLabels()
    local trackY = self.HasDesc and 70 or 52
    self.TrackY = trackY
    self.Head.Frame.Size = UDim2.new(1, 0, 0, trackY + 16)
    self.Track.Position = UDim2.fromOffset(16, trackY - 3)
    self.Zone.Position = UDim2.fromOffset(8, trackY - 16)
end

function UISlider:_Snap(raw)
    local snapped = self.Min + math.floor((raw - self.Min) / self.Step + 0.5) * self.Step
    snapped = math.clamp(snapped, self.Min, self.Max)
    local factor = 10 ^ self.Decimals
    return math.floor(snapped * factor + 0.5) / factor
end

function UISlider:_ToAlpha(value)
    local range = self.Max - self.Min
    if range <= 0 then
        return 0
    end
    return math.clamp((value - self.Min) / range, 0, 1)
end

function UISlider:_FormatNumber(value)
    return string.format("%." .. self.Decimals .. "f", value)
end

function UISlider:_Format(value)
    return self:_FormatNumber(value) .. self.Suffix
end

function UISlider:_Paint(alpha, duration)
    self.DisplayAlpha = alpha
    if duration then
        Tween(self.Fill, duration, { Size = UDim2.fromScale(alpha, 1) })
        Tween(self.Knob, duration, { Position = UDim2.fromScale(alpha, 0.5) })
    else
        self.Fill.Size = UDim2.fromScale(alpha, 1)
        self.Knob.Position = UDim2.fromScale(alpha, 0.5)
    end
end

function UISlider:_Commit(alpha)
    local value = self:_Snap(self.Min + alpha * (self.Max - self.Min))
    if value ~= self.Value then
        self.Value = value
        self.Box.Text = self:_Format(value)
        self:_Emit(value)
    end
end

function UISlider:_BeginDrag(input)
    local scroller = self.Section.Tab.Content
    local track = self.Track
    local beatConnection

    local function Follow(positionX)
        local width = track.AbsoluteSize.X
        if width <= 0 then
            return
        end
        local alpha = math.clamp((positionX - track.AbsolutePosition.X) / width, 0, 1)
        self.TargetAlpha = alpha
        self:_Commit(alpha)
    end

    scroller.ScrollingEnabled = false
    Tween(self.Knob, 0.2, { Size = UDim2.fromOffset(19, 19) }, Enum.EasingStyle.Back)
    Follow(input.Position.X)

    beatConnection = RunService.Heartbeat:Connect(function(delta)
        local blend = math.min(1, delta * 24)
        self:_Paint(self.DisplayAlpha + (self.TargetAlpha - self.DisplayAlpha) * blend)
    end)

    TrackPointer(input, function(position)
        Follow(position.X)
    end, function()
        beatConnection:Disconnect()
        scroller.ScrollingEnabled = true
        Tween(self.Knob, 0.25, { Size = UDim2.fromOffset(14, 14) }, Enum.EasingStyle.Back)
        self:_Paint(self:_ToAlpha(self.Value), 0.18)
    end)
end

function UISlider:Set(value, silent)
    value = tonumber(value)
    if value == nil then
        return
    end
    local snapped = self:_Snap(value)
    local changed = snapped ~= self.Value
    self.Value = snapped
    self.TargetAlpha = self:_ToAlpha(snapped)
    self.Box.Text = self:_Format(snapped)
    self:_Paint(self.TargetAlpha, 0.2)
    self:_SyncFlag()
    if changed and not silent then
        self:_Emit(snapped)
    end
end

function UISlider:Get()
    return self.Value
end

function UISlider:_Reconfigure(silent)
    if self.Step <= 0 then
        self.Step = 1
    end
    if self.Max < self.Min then
        self.Max = self.Min
    end
    self.Decimals = CountDecimals(self.Step)
    self:Set(self.Value, silent)
    self.Box.Text = self:_Format(self.Value)
end

function UISlider:SetMin(value, silent)
    self.Min = value
    self:_Reconfigure(silent)
end

function UISlider:SetMax(value, silent)
    self.Max = value
    self:_Reconfigure(silent)
end

function UISlider:SetRange(min, max, silent)
    self.Min = min
    self.Max = max
    self:_Reconfigure(silent)
end

function UISlider:SetStep(step, silent)
    self.Step = step
    self:_Reconfigure(silent)
end

function UISlider:SetSuffix(suffix)
    self.Suffix = suffix or ""
    self.Box.Text = self:_Format(self.Value)
end

function UISlider:Refresh()
    Element.Refresh(self)
    self:_Reconfigure(true)
end

local UIInput = Element.extend()

function UIInput.new(section, config)
    local self = setmetatable({}, UIInput)
    self:_Init(section, config, "Input")

    self.Numeric = config.Numeric == true
    self.Live = config.Live == true
    self.Value = config.Default ~= nil and tostring(config.Default) or ""

    local window = self.Window
    local head = self:_CreateHead(section.Card, self:_RowHeight(), section:NextOrder(), "tint")
    self:_CreateLabels(head.Hit, 16, 180)

    head.OnHover = function(state)
        if self.IconImage then
            Tween(self.IconImage, 0.2, { ImageColor3 = state and Theme.Text or Theme.SubText })
        end
    end

    local boxStroke = Stroke(C.Outline, 0, 1)
    local boxFrame = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(150, 28),
        Position = UDim2.new(1, -16, 0.5, 0),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Background,
        ClipsDescendants = true,
        Parent = head.Hit
    }, { Corner(7), boxStroke })

    self.Box = New("TextBox", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Text = self.Value,
        PlaceholderColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        Parent = boxFrame
    })
    Locale:Bind(self.Box, "PlaceholderText", config.Placeholder or "")

    local maxLength = config.MaxLength

    window.Maid:Give(self.Box:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.Box.Text
        local cleaned = text
        if self.Numeric then
            cleaned = string.gsub(cleaned, "[^%d%.%-]", "")
        end
        if maxLength and #cleaned > maxLength then
            cleaned = string.sub(cleaned, 1, maxLength)
        end
        if cleaned ~= text then
            self.Box.Text = cleaned
            return
        end
        if self.Live and self.Box:IsFocused() then
            if self.Numeric then
                local number = tonumber(cleaned)
                if number ~= nil then
                    self.Value = cleaned
                    self:_Emit(number, false)
                end
            else
                self.Value = cleaned
                self:_Emit(cleaned, false)
            end
        end
    end))

    window.Maid:Give(self.Box.Focused:Connect(function()
        Tween(boxStroke, 0.2, { Color = Theme.AccentGlow })
    end))

    window.Maid:Give(self.Box.FocusLost:Connect(function(enterPressed)
        Tween(boxStroke, 0.2, { Color = Theme.Outline })
        if self.Numeric then
            local number = tonumber(self.Box.Text)
            if number == nil then
                self.Box.Text = self.Value
                return
            end
            self.Value = self.Box.Text
            self:_Emit(number, enterPressed)
        else
            self.Value = self.Box.Text
            self:_Emit(self.Value, enterPressed)
        end
    end))

    BindTap(window.Maid, head.Hit, function()
        if not self.Locked then
            self.Box:CaptureFocus()
        end
    end)

    self.PlaceholderSource = config.Placeholder or ""
    return self:_Finish(head.Frame, head.Divider)
end

function UIInput:_OnLocked(state)
    self.Box.TextEditable = not state
end

function UIInput:SetPlaceholder(source)
    self.PlaceholderSource = source or ""
    Locale:Bind(self.Box, "PlaceholderText", self.PlaceholderSource)
end

function UIInput:Focus()
    if not self.Locked then
        self.Box:CaptureFocus()
    end
end

function UIInput:Clear(silent)
    self:Set("", silent)
end

function UIInput:Refresh()
    Element.Refresh(self)
    self.Box.Text = self.Value
    Locale:Bind(self.Box, "PlaceholderText", self.PlaceholderSource or "")
end

function UIInput:Get()
    if self.Numeric then
        return tonumber(self.Value)
    end
    return self.Value
end

function UIInput:Set(value, silent)
    self.Value = value ~= nil and tostring(value) or ""
    self.Box.Text = self.Value
    self:_SyncFlag()
    if not silent then
        self:_Emit(self:Get(), false)
    end
end

local UISection = {}
UISection.__index = UISection

function UISection.new(tab, config)
    local self = setmetatable({}, UISection)
    local hasDesc = config.Desc ~= nil and config.Desc ~= ""

    self.Tab = tab
    self.Window = tab.Window
    self.TitleSource = config.Title or "Section"
    self.Rows = {}
    self.Order = 0
    self.Collapsed = config.Collapsed == true or config.DefaultOpen == false

    self.Frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = tab:NextOrder(),
        Parent = tab.Content
    }, {
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    })

    local header = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = self.Frame
    })

    self.IconSource = config.Icon
    self.DescSource = config.Desc
    self.HasDesc = hasDesc
    self.Hidden = config.Visible == false

    self.IconBox = New("Frame", {
        Size = UDim2.fromOffset(38, 38),
        Position = UDim2.fromOffset(0, 3),
        BackgroundColor3 = config.Color or Color3.new(1, 1, 1),
        Parent = header
    }, { Corner(10), Aura.Make(config.Color and "Shade" or "Fill", { Rotation = 45 }) })

    self.IconImage = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromScale(0.5, 0.5),
        Image = ResolveIcon(config.Icon, "rbxassetid://6023426915"),
        Parent = self.IconBox
    })

    self.TitleLabel = New("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        TextSize = 13,
        Weight = "SemiBold",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header
    })
    Locale:Bind(self.TitleLabel, "Text", self.TitleSource)

    self.DescLabel = New("TextLabel", {
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.fromOffset(50, 25),
        TextSize = 11,
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Visible = hasDesc,
        Parent = header
    })
    Locale:Bind(self.DescLabel, "Text", config.Desc or "")
    self:_ApplyHeader()

    local toggleButton = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        Parent = header
    })

    self.Indicator = New("ImageLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -8, 0.5, 0),
        Rotation = self.Collapsed and -90 or 0,
        Image = IconList.chevronDown,
        ImageColor3 = C.SubText,
        Parent = header
    })

    self.Card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.Card,
        BackgroundTransparency = self.Window:_AcrylicAlpha() * 0.7,
        Visible = not self.Collapsed,
        LayoutOrder = 2,
        Parent = self.Frame
    }, {
        Corner(10),
        Stroke(C.Outline, 0, 1),
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })
    })
    table.insert(self.Window.AcrylicCards, self.Card)

    BindTap(self.Window.Maid, toggleButton, function()
        self.Window:PlayClick("Toggle")
        self:SetCollapsed(not self.Collapsed)
    end)

    return self
end

function UISection:_ApplyHeader()
    self.TitleLabel.Position = UDim2.fromOffset(50, self.HasDesc and 3 or 12)
    self.DescLabel.Visible = self.HasDesc
end

function UISection:SetCollapsed(state)
    self.Collapsed = state == true
    self.Card.Visible = not self.Collapsed
    Tween(self.Indicator, 0.2, { Rotation = self.Collapsed and -90 or 0 })
end

function UISection:Collapse()
    self:SetCollapsed(true)
end

function UISection:Expand()
    self:SetCollapsed(false)
end

function UISection:ToggleCollapsed()
    self:SetCollapsed(not self.Collapsed)
end

function UISection:NextOrder()
    self.Order = self.Order + 1
    return self.Order
end

function UISection:_Register(element, row, divider)
    table.insert(self.Rows, { Element = element, Row = row, Divider = divider })
    divider.Visible = #self.Rows > 1
end

function UISection:_Unregister(element)
    for index, entry in ipairs(self.Rows) do
        if entry.Element == element then
            table.remove(self.Rows, index)
            break
        end
    end
    self:_Refresh()
end

function UISection:_Refresh()
    local query = self.Query or ""
    local sectionTitle = string.lower(tostring(Locale:Resolve(self.TitleSource)))
    local sectionMatch = query ~= "" and string.find(sectionTitle, query, 1, true) ~= nil
    local anyVisible = false

    for _, entry in ipairs(self.Rows) do
        local show = not entry.Element.Hidden
        if show and query ~= "" and not sectionMatch then
            local title = string.lower(tostring(Locale:Resolve(entry.Element.TitleSource)))
            show = string.find(title, query, 1, true) ~= nil
        end
        entry.Row.Visible = show
        entry.Divider.Visible = show and anyVisible
        if show then
            anyVisible = true
        end
    end

    self.Frame.Visible = not self.Hidden and (anyVisible or #self.Rows == 0 or query == "")
end

function UISection:Filter(query)
    self.Query = query or ""
    self:_Refresh()
end

function UISection:SetTitle(source)
    self.TitleSource = source
    Locale:Bind(self.TitleLabel, "Text", source)
    self:_Refresh()
end

function UISection:SetDesc(source)
    self.DescSource = source
    self.HasDesc = source ~= nil and source ~= ""
    Locale:Bind(self.DescLabel, "Text", source or "")
    self:_ApplyHeader()
end

function UISection:SetIcon(icon)
    self.IconSource = icon
    self.IconImage.Image = ResolveIcon(icon, "rbxassetid://6023426915")
end

function UISection:SetColor(color)
    self.IconBox.BackgroundColor3 = color
end

function UISection:SetVisible(state)
    self.Hidden = state == false
    self:_Refresh()
end

function UISection:Show()
    self:SetVisible(true)
end

function UISection:Hide()
    self:SetVisible(false)
end

function UISection:GetElements()
    local list = {}
    for _, entry in ipairs(self.Rows) do
        table.insert(list, entry.Element)
    end
    return list
end

function UISection:Refresh()
    Locale:Bind(self.TitleLabel, "Text", self.TitleSource)
    Locale:Bind(self.DescLabel, "Text", self.DescSource or "")
    self:_ApplyHeader()
    for _, entry in ipairs(self.Rows) do
        entry.Element:Refresh()
    end
    self:_Refresh()
end

function UISection:Clear()
    for _, element in ipairs(self:GetElements()) do
        element:Destroy()
    end
end

function UISection:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    self:Clear()
    for index, section in ipairs(self.Tab.Sections) do
        if section == self then
            table.remove(self.Tab.Sections, index)
            break
        end
    end
    self.Frame:Destroy()
end

function UISection:AddButton(config)
    return UIButton.new(self, config or {})
end

function UISection:AddToggle(config)
    return UIToggle.new(self, config or {})
end

function UISection:AddDropdown(config)
    return UIDropdown.new(self, config or {})
end

function UISection:AddSlider(config)
    return UISlider.new(self, config or {})
end

function UISection:AddInput(config)
    return UIInput.new(self, config or {})
end

function UISection:AddColorPicker(config)
    return UIColorPicker.new(self, config or {})
end

function UISection:AddSegmented(config)
    return UISegmented.new(self, config or {})
end

function UISection:AddPalette(config)
    return UIPalette.new(self, config or {})
end

function UISection:AddKeybind(config)
    return UIKeybind.new(self, config or {})
end

UISection.AddColorpicker = UISection.AddColorPicker

function UISection:AddLabel(config)
    if type(config) == "string" then
        config = { Title = config }
    end
    return UILabel.new(self, config or {})
end

UISection.CreateButton = UISection.AddButton
UISection.CreateToggle = UISection.AddToggle
UISection.CreateDropdown = UISection.AddDropdown
UISection.CreateSlider = UISection.AddSlider
UISection.CreateInput = UISection.AddInput
UISection.CreateLabel = UISection.AddLabel

local UITab = {}
UITab.__index = UITab

function UITab.new(window, config)
    local self = setmetatable({}, UITab)

    self.Window = window
    self.TitleSource = config.Title or "Tab"
    self.DescSource = config.Desc or self:_DefaultDesc()
    self.IconSource = config.Icon
    self.Hidden = config.Visible == false
    self.Destroyed = false
    self.Sections = {}
    self.Order = 0
    self.IsActive = false
    self.Hovered = false

    self.SavedScroll = 0
    self.Content = New("ScrollingFrame", {
        Name = "TabContent",
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = window.Pages
    }, {
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 16) }),
        New("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 22),
            PaddingRight = UDim.new(0, 22),
            PaddingBottom = UDim.new(0, 22)
        })
    })

    SmoothScroll(window.Maid, self.Content)
    AutoHideBar(window.Maid, self.Content, 3)
    window.Maid:Give(self.Content:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self.IsActive and window.Visible and self.Content.AbsoluteWindowSize.Y > 0 then
            self.SavedScroll = self.Content.CanvasPosition.Y
        end
    end))

    self.Stroke = Stroke(C.Outline, 1, 1)
    self.Button = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.Selected,
        BackgroundTransparency = 1,
        LayoutOrder = config.Order or (#window.Tabs + 1),
        Parent = window.TabList
    }, { Corner(9), self.Stroke })

    self.IconBox = New("Frame", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(0, 10, 0.5, -13),
        BackgroundColor3 = config.Color or Color3.new(1, 1, 1),
        Parent = self.Button
    }, { Corner(7), Aura.Make(config.Color and "Shade" or "Fill", { Rotation = 45 }) })

    self.IconImage = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromScale(0.5, 0.5),
        Image = ResolveIcon(config.Icon, "rbxassetid://6023426915"),
        Parent = self.IconBox
    })

    self.Label = New("TextLabel", {
        Size = UDim2.new(1, -52, 1, 0),
        Position = UDim2.fromOffset(46, 0),
        TextColor3 = C.SubText,
        Weight = "Medium",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.Button
    })
    Locale:Bind(self.Label, "Text", self.TitleSource)

    self.Indicator = New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(3, 0),
        Position = UDim2.new(0, -8, 0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Parent = self.Button
    }, { Corner(2), Aura.Make("Fill", { Rotation = 90 }) })

    self.Button.Visible = not self.Hidden

    BindTap(window.Maid, self.Button, function()
        window:PlayClick("Button")
        window:Select(self)
    end)

    BindPointer(window.Maid, self.Button, {
        Hover = function(state)
            self.Hovered = state
            self:_Render()
        end
    })

    window.Maid:Give(OnTheme(function()
        self:_Render()
    end))

    return self
end

function UITab:_DefaultDesc()
    return function()
        return string.format(Locale:Builtin("ManageFor"), tostring(Locale:Resolve(self.TitleSource)))
    end
end

function UITab:NextOrder()
    self.Order = self.Order + 1
    return self.Order
end

function UITab:_Render()
    local background = 1
    if self.IsActive then
        background = 0
    elseif self.Hovered then
        background = 0.6
    end
    local lit = self.IsActive or self.Hovered
    Tween(self.Button, 0.2, { BackgroundTransparency = background })
    Tween(self.Stroke, 0.2, { Transparency = self.IsActive and 0 or 1 })
    Tween(self.Label, 0.2, {
        TextColor3 = lit and Theme.Text or Theme.SubText,
        Position = UDim2.fromOffset(self.IsActive and 49 or 46, 0)
    })
end

function UITab:_RestoreScroll()
    task.defer(function()
        task.wait()
        if not self.Destroyed and self.IsActive then
            local Limit = math.max(self.Content.AbsoluteCanvasSize.Y - self.Content.AbsoluteWindowSize.Y, 0)
            self.Content.CanvasPosition = Vector2.new(0, math.min(self.SavedScroll, Limit))
        end
    end)
end

function UITab:SetActive(state)
    self.IsActive = state
    self.Content.Visible = state
    if state then
        self:_RestoreScroll()
        self.Indicator.Size = UDim2.fromOffset(3, 0)
        self.Indicator.BackgroundTransparency = 0
        Tween(self.Indicator, 0.4, { Size = UDim2.fromOffset(3, 20) }, Enum.EasingStyle.Back)
    else
        Tween(self.Indicator, 0.2, { Size = UDim2.fromOffset(3, 0), BackgroundTransparency = 1 })
    end
    self:_Render()
end

function UITab:AddSection(config)
    local section = UISection.new(self, config or {})
    table.insert(self.Sections, section)
    return section
end

UITab.CreateSection = UITab.AddSection

function UITab:SetTitle(source)
    self.TitleSource = source
    Locale:Bind(self.Label, "Text", source)
    if self.Window.Active == self then
        Locale:Bind(self.Window.PageTitle, "Text", source)
    end
end

function UITab:SetDesc(source)
    self.DescSource = source or self:_DefaultDesc()
    if self.Window.Active == self then
        Locale:Bind(self.Window.PageDesc, "Text", self.DescSource)
    end
end

function UITab:SetIcon(icon)
    self.IconSource = icon
    self.IconImage.Image = ResolveIcon(icon, "rbxassetid://6023426915")
end

function UITab:SetColor(color)
    self.IconBox.BackgroundColor3 = color
end

function UITab:Select(silent)
    self.Window:Select(self, silent)
end

function UITab:SetVisible(state)
    self.Hidden = state == false
    self.Button.Visible = not self.Hidden
    if self.Hidden and self.Window.Active == self then
        self.Window:_SelectFallback(self)
    end
end

function UITab:Show()
    self:SetVisible(true)
end

function UITab:Hide()
    self:SetVisible(false)
end

function UITab:GetSections()
    return table.clone(self.Sections)
end

function UITab:Refresh()
    for _, section in ipairs(self.Sections) do
        section:Refresh()
    end
end

function UITab:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    local window = self.Window
    for _, section in ipairs(table.clone(self.Sections)) do
        section:Destroy()
    end
    for index, tab in ipairs(window.Tabs) do
        if tab == self then
            table.remove(window.Tabs, index)
            break
        end
    end
    if window.Active == self then
        window.Active = nil
        window:_SelectFallback(self)
    end
    self.Content:Destroy()
    self.Button:Destroy()
end

local UIWindow = {}
UIWindow.__index = UIWindow

local Windows = {}

function UIWindow.new(config)
    local self = setmetatable({}, UIWindow)
    config = table.clone(config or {})
    self.Config = config

    self.Maid = Maid.new()
    self.Tabs = {}
    self.UserTabs = 0
    self.Active = nil
    self.Visible = true
    self.Destroyed = false
    self.UserScale = math.clamp(tonumber(config.Scale) or 1, 0.5, 1.5)
    self.SoundEnabled = config.Sound ~= false
    self.ToggleKey = nil
    self.Transition = 0
    self.FitScale = 1
    self.ActiveDropdown = nil
    self.LogoImages = {}
    self.AcrylicCards = {}
    self.IconSource = config.Icon or config.Logo or "rbxassetid://10723415393"
    self.TitleSource = config.Title or "Fracture Hub"
    self.SubTitleSource = config.SubTitle or "by Fracture"
    self.ToggleTextSource = config.ToggleText
    self.ConfigFolder = config.ConfigFolder or "Fracture UI"
    self.ConfigMap = config.MapName ~= nil and CleanName(config.MapName) or nil
    self.AutoSave = config.AutoSave == true
    self.OnOpen = config.OnOpen
    self.OnClose = config.OnClose
    self.OnDestroy = config.OnDestroy
    self.Flags = Flags
    self.SettingsReady = false

    local Saved = self:_ReadSettings()
    self:_ApplyCustomData(Saved.Custom)
    local AcrylicConfig = config.Acrylic
    self.AcrylicOn = Pick(Saved.AcrylicOn, AcrylicConfig == true or (type(AcrylicConfig) == "number" and AcrylicConfig > 0))
    self.Transparency = math.clamp(tonumber(Pick(Saved.Transparency, type(AcrylicConfig) == "number" and AcrylicConfig or config.Transparency)) or 0.25, 0, 0.85)
    self.BlurSize = math.clamp(tonumber(Pick(Saved.BlurSize, config.BlurSize)) or 16, 0, 40)
    AccentSolid = Pick(Saved.AccentStyle, config.AccentStyle) == "Solid"
    self.NotifyTimer = Pick(Saved.NotifyTimer, config.NotifyTimer ~= false)
    self.NotifyLineColor = ParseColor(Pick(Saved.NotifyLine, config.NotifyLineColor))
    config.Language = Pick(Saved.Language, config.Language)
    config.Theme = Pick(Saved.Theme, config.Theme)
    config.HideName = Pick(Saved.HideName, config.HideName)
    config.HideProfile = Pick(Saved.HideProfile, config.HideProfile)
    config.ToggleKey = Pick(Saved.ToggleKey, config.ToggleKey)
    self.SoundEnabled = Pick(Saved.Sound, self.SoundEnabled)
    self.Volume = math.clamp(tonumber(Pick(Saved.Volume, config.Volume)) or 1, 0, 2)
    self.UserScale = math.clamp(tonumber(Pick(Saved.Scale, self.UserScale)) or 1, 0.5, 1.5)

    if config.Translations then
        Locale:AddTranslations(config.Translations)
    end
    if config.Patterns then
        Locale:AddPatterns(config.Patterns)
    end
    if config.Language then
        Locale:SetLanguage(config.Language)
    end
    if config.Theme and Palettes[config.Theme] then
        SetTheme(config.Theme)
    elseif AccentSolid then
        SetTheme(CurrentTheme)
    end

    if config.ToggleKey == nil then
        self:SetToggleKey(Enum.KeyCode.RightControl)
    else
        self:SetToggleKey(config.ToggleKey)
    end

    self:_Build(config)
    self:_BindInput()
    self:SetPillVisible(config.Pill ~= false and config.ShowToggle ~= false)
    local WantOpen = config.Open ~= false
    local ShowSplash = config.Splash ~= false
    self:SetVisible(WantOpen and not ShowSplash, true)
    if ShowSplash then
        self:_RunSplash(config, WantOpen)
    elseif WantOpen then
        self:PlayOpenSound()
    end

    if config.HideName then
        self:SetHideName(true)
    end
    if config.HideProfile then
        self:SetHideProfile(true)
    end

    self.Maid:Give(Locale:Listen(function()
        self:_QueueSettingsSave()
    end))
    self.Maid:Give(OnTheme(function()
        self:_QueueSettingsSave()
    end))
    self.SettingsReady = true

    table.insert(Windows, self)
    return self
end

function UIWindow:_Build(config)
    local requested = config.Size or UDim2.fromOffset(640, 440)
    local logo = self.IconSource
    local guiName = config.Name or "FractureUI"

    if typeof(requested) == "Vector2" then
        self.RequestedSize = requested
    else
        self.RequestedSize = Vector2.new(requested.X.Offset, requested.Y.Offset)
    end
    self.DefaultPosition = config.Position or UDim2.fromScale(0.5, 0.5)
    local width, height = self:_FitSize()

    local parent = ResolveParent()
    local old = parent:FindFirstChild(guiName)
    if old then
        old:Destroy()
    end

    self.Gui = self.Maid:Give(New("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = config.DisplayOrder or 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = parent
    }))

    self.Sounds = {}
    local SoundOverrides = {
        Open = config.OpenSound,
        Toggle = config.ToggleSound,
        Key = config.KeySound,
        Button = config.ButtonSound
    }
    local Preload = {}
    for Kind, Id in pairs(SOUND_IDS) do
        local Sound = New("Sound", { SoundId = SoundOverrides[Kind] or Id, Volume = 0, Parent = self.Gui })
        self.Sounds[Kind] = Sound
        table.insert(Preload, Sound)
    end
    task.spawn(function()
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(Preload)
        end)
    end)

    self.Maid:Give(UserInputService.TextBoxFocused:Connect(function(Box)
        if Box:IsDescendantOf(self.Gui) then
            local Typing = Box:GetPropertyChangedSignal("Text"):Connect(function()
                self:PlayClick("Key")
            end)
            Box.FocusLost:Once(function()
                Typing:Disconnect()
            end)
        end
    end))

    self.Scale = New("UIScale", { Scale = 1 })
    self.Gradient = New("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Theme.BackgroundTop, Theme.Background)
    })
    self.Maid:Give(OnTheme(function()
        self.Gradient.Color = ColorSequence.new(Theme.BackgroundTop, Theme.Background)
    end))

    local rim = New("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, { Aura.Make("Rim", { Rotation = 35 }) })

    self.Main = New("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(width, height),
        Position = self.DefaultPosition,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = self:_AcrylicAlpha(),
        ClipsDescendants = true,
        Parent = self.Gui
    }, {
        Corner(12),
        rim,
        self.Scale,
        self.Gradient
    })

    self:_BuildOverlay()
    self:_BuildPill(config, logo)

    local sidebar = self:_BuildSidebar(config, logo)
    self:_BuildProfile(sidebar)
    self:_BuildContent()
    self:_BuildControls()
    self:_BuildDragHandle()
    self:_BuildSettings()
    self:_BuildNotifications()
    self:_BindViewport()

    self:_PaintIcons()
    self.Maid:Give(Locale:Listen(function()
        self:_PaintIcons()
    end))
    self.Maid:Give(OnTheme(function()
        self:_PaintIcons()
    end))

    self.Maid:Give(self.Gui.Destroying:Connect(function()
        self:Destroy()
    end))
end

function UIWindow:_BuildSidebar(config, logo)
    local sidebar = New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    New("Frame", {
        Size = UDim2.new(0, 1, 1, -36),
        Position = UDim2.new(1, 0, 0, 18),
        BackgroundColor3 = C.Divider,
        Parent = sidebar
    })

    local header = New("Frame", {
        Size = UDim2.new(1, -24, 0, 44),
        Position = UDim2.fromOffset(14, 16),
        BackgroundTransparency = 1,
        Parent = sidebar
    })

    local logoImage = New("ImageLabel", {
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.new(0, 0, 0.5, -18),
        ScaleType = Enum.ScaleType.Fit,
        Parent = header
    })
    table.insert(self.LogoImages, logoImage)

    local title = New("TextLabel", {
        Size = UDim2.new(1, -46, 0, 20),
        Position = UDim2.fromOffset(46, 3),
        TextSize = 14,
        Weight = "SemiBold",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header
    })
    self.SidebarTitle = title
    Locale:Bind(title, "Text", self.TitleSource)

    local subtitle = New("TextLabel", {
        Size = UDim2.new(1, -46, 0, 16),
        Position = UDim2.fromOffset(46, 25),
        TextSize = 10,
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header
    })
    self.SidebarSubTitle = subtitle
    Locale:Bind(subtitle, "Text", self.SubTitleSource)

    local searchStroke = Stroke(C.Outline, 0, 1)
    local searchBox = New("Frame", {
        Size = UDim2.new(1, -24, 0, 32),
        Position = UDim2.fromOffset(12, 72),
        BackgroundColor3 = C.Card,
        Parent = sidebar
    }, { Corner(8), searchStroke })

    local magnifier = New("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, 10, 0.5, -8),
        BackgroundTransparency = 1,
        Parent = searchBox
    })
    New("Frame", {
        Size = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        Parent = magnifier
    }, { Corner(5), Stroke(C.SubText, 0, 1.5) })
    New("Frame", {
        Size = UDim2.fromOffset(6, 2),
        Position = UDim2.fromOffset(9, 12),
        Rotation = 45,
        BackgroundColor3 = C.SubText,
        Parent = magnifier
    })

    local searchInput = New("TextBox", {
        Size = UDim2.new(1, -38, 1, 0),
        Position = UDim2.fromOffset(32, 0),
        PlaceholderColor3 = C.SubText,
        ClearTextOnFocus = false,
        Parent = searchBox
    })
    Locale:Bind(searchInput, "PlaceholderText", Builtin("Search"))

    self.Maid:Give(searchInput.Focused:Connect(function()
        Tween(searchStroke, 0.2, { Color = Theme.AccentGlow })
    end))
    self.Maid:Give(searchInput.FocusLost:Connect(function()
        Tween(searchStroke, 0.2, { Color = Theme.Outline })
    end))
    self.Maid:Give(searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        self:Filter(string.lower(searchInput.Text))
    end))

    self.TabList = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -192),
        Position = UDim2.fromOffset(0, 118),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    }, {
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 4)
        })
    })

    return sidebar
end

function UIWindow:_BuildProfile(sidebar)
    local player = Players.LocalPlayer
    if not player then
        return
    end

    local card = New("Frame", {
        Name = "Profile",
        Size = UDim2.new(1, -24, 0, 50),
        Position = UDim2.new(0, 12, 1, -62),
        BackgroundColor3 = C.Card,
        Parent = sidebar
    }, { Corner(10), Stroke(C.Outline, 0, 1) })

    self.ProfileCard = card
    self.ProfileDisplayName = player.DisplayName
    self.ProfileUserName = player.Name

    local avatar = New("ImageLabel", {
        Size = UDim2.fromOffset(34, 34),
        Position = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Selected,
        Parent = card
    }, { Corner(nil, true) })

    New("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.fromOffset(10, 10),
        Position = UDim2.fromOffset(44, 44),
        BackgroundColor3 = C.Green,
        Parent = card
    }, { Corner(nil, true), Stroke(C.Card, 0, 2) })

    self.ProfileName = New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.fromOffset(52, 9),
        Text = player.DisplayName,
        Weight = "Medium",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = card
    })

    self.ProfileUser = New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 14),
        Position = UDim2.fromOffset(52, 26),
        Text = "@" .. player.Name,
        TextSize = 10,
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = card
    })

    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and avatar.Parent then
            avatar.Image = content
        end
    end)
end

function UIWindow:_BuildContent()
    local container = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -180, 1, 0),
        Position = UDim2.fromOffset(180, 0),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    self.PageTitle = New("TextLabel", {
        Size = UDim2.new(1, -120, 0, 26),
        Position = UDim2.fromOffset(24, 13),
        TextSize = 18,
        Weight = "SemiBold",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = container
    })

    self.PageDesc = New("TextLabel", {
        Size = UDim2.new(1, -120, 0, 18),
        Position = UDim2.fromOffset(24, 42),
        TextSize = 11,
        TextColor3 = C.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = container
    })

    self.Pages = New("Frame", {
        Size = UDim2.new(1, 0, 1, -66),
        Position = UDim2.fromOffset(0, 66),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = container
    })
end

function UIWindow:_BuildControls()
    local controls = New("Frame", {
        Name = "Controls",
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(52, 12),
        Position = UDim2.new(1, -18, 0, 18),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = self.Main
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
    })

    local actions = {
        { Color = Theme.Red, Action = function() self:Destroy() end },
        { Color = Theme.Yellow, Action = function() self:SetVisible(false) end },
        { Color = Theme.Green, Action = function() self:ResetPosition() end }
    }

    for index, data in ipairs(actions) do
        local dot = New("TextButton", {
            Size = UDim2.fromOffset(12, 12),
            BackgroundTransparency = 0,
            BackgroundColor3 = data.Color,
            LayoutOrder = index,
            Parent = controls
        }, { Corner(nil, true) })

        BindPointer(self.Maid, dot, {
            Hover = function(state)
                Tween(dot, 0.15, { Size = state and UDim2.fromOffset(14, 14) or UDim2.fromOffset(12, 12) })
            end
        })
        self.Maid:Give(dot.MouseButton1Click:Connect(function()
            self:PlayClick("Button")
            data.Action()
        end))
    end
end

function UIWindow:_BuildDragHandle()
    local handle = New("Frame", {
        Name = "DragHandle",
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 2,
        Parent = self.Main
    })

    self.Maid:Give(handle.InputBegan:Connect(function(input)
        if not PressTypes[input.UserInputType] then
            return
        end

        local origin = input.Position
        local start = self.Main.Position

        TrackPointer(input, function(position)
            local delta = position - origin
            self.Main.Position = UDim2.new(
                start.X.Scale, start.X.Offset + delta.X,
                start.Y.Scale, start.Y.Offset + delta.Y
            )
        end)
    end))
end

function UIWindow:_BuildSettings()
    local tab = UITab.new(self, {
        Title = Builtin("Settings"),
        Desc = Builtin("SettingsDesc"),
        Icon = IconList.settings,
        Color = Color3.fromRGB(70, 70, 76),
        Order = 1000
    })
    table.insert(self.Tabs, tab)
    self.SettingsTab = tab

    local languageSection = tab:AddSection({
        Title = Builtin("Language"),
        Desc = Builtin("LanguageDesc"),
        Icon = IconList.settings,
        Color = Color3.fromRGB(46, 108, 214)
    })

    local function LanguageNames()
        local names = {}
        for _, entry in ipairs(Locale:GetLanguages()) do
            table.insert(names, entry.Name)
        end
        return names
    end

    local dropdown = languageSection:AddDropdown({
        Title = Builtin("Language"),
        Desc = Builtin("LanguageDesc"),
        Options = LanguageNames(),
        Default = Locale:GetName(Locale.Language),
        Callback = function(name)
            local code = Locale:GetCode(name)
            if code and code ~= Locale.Language then
                Locale:SetLanguage(code)
            end
        end
    })
    self.LanguageDropdown = dropdown

    self.Maid:Give(Locale:Listen(function()
        dropdown:SetOptions(LanguageNames())
        dropdown:Set(Locale:GetName(Locale.Language), true)
    end))

    local appearanceSection = tab:AddSection({
        Title = Builtin("Appearance"),
        Desc = Builtin("AppearanceDesc"),
        Icon = "palette",
        Color = Color3.fromRGB(150, 80, 220)
    })

    local function ThemeNames()
        local names = {}
        for _, key in ipairs(THEME_ORDER) do
            table.insert(names, Locale:Builtin("Theme" .. key))
        end
        return names
    end

    local function ThemeName(key)
        return Locale:Builtin("Theme" .. key)
    end

    local function ThemeKey(name)
        for _, key in ipairs(THEME_ORDER) do
            if Locale:Builtin("Theme" .. key) == name then
                return key
            end
        end
        return nil
    end

    self.StyleSegmented = appearanceSection:AddSegmented({
        Title = Builtin("AccentStyle"),
        Options = {
            { Key = "Gradient", Text = Builtin("StyleGradient") },
            { Key = "Solid", Text = Builtin("StyleSolid") }
        },
        Default = AccentSolid and "Solid" or "Gradient",
        Callback = function(Key)
            SetAccentStyle(Key)
            self:_QueueSettingsSave()
        end
    })

    local themeDropdown = appearanceSection:AddDropdown({
        Title = Builtin("Theme"),
        Desc = Builtin("ThemeDesc"),
        Options = ThemeNames(),
        Default = ThemeName(CurrentTheme),
        Search = false,
        Callback = function(name)
            local key = ThemeKey(name)
            if key and key ~= CurrentTheme then
                SetTheme(key)
            end
        end
    })
    self.ThemeDropdown = themeDropdown

    self.Maid:Give(Locale:Listen(function()
        themeDropdown:SetOptions(ThemeNames())
        themeDropdown:Set(ThemeName(CurrentTheme), true)
    end))

    self.Maid:Give(OnTheme(function()
        themeDropdown:Set(ThemeName(CurrentTheme), true)
    end))

    self.CustomPickers = {}

    local function MakePicker(Section, Key, TitleKey)
        self.CustomPickers[Key] = Section:AddColorPicker({
            Title = Builtin(TitleKey),
            Default = Palettes[CurrentTheme][Key],
            Callback = function(Color)
                self:_PrepareCustom()
                CustomColors[Key] = Color
                ApplyCustomColors()
                self:_QueueSettingsSave()
            end
        })
    end

    appearanceSection:AddPalette({
        Title = Builtin("QuickPalettes"),
        Colors = ACCENT_PRESETS,
        Columns = 5,
        Callback = function(Color)
            self:_PrepareCustom()
            CustomColors.Accent = Color
            CustomColors.AccentAlt = Color:Lerp(Color3.new(1, 1, 1), 0.35)
            ApplyCustomColors()
            self:_QueueSettingsSave()
        end
    })

    MakePicker(appearanceSection, "Accent", "PrimaryAccent")
    MakePicker(appearanceSection, "AccentAlt", "SecondaryAccent")

    self.Maid:Give(OnTheme(function()
        self:_SyncCustomPickers()
    end))

    local interfaceSection = tab:AddSection({
        Title = Builtin("Interface"),
        Desc = Builtin("InterfaceDesc"),
        Icon = IconList.sliders,
        Color = Color3.fromRGB(70, 70, 76)
    })

    self.SoundToggle = interfaceSection:AddToggle({
        Title = Builtin("Sound"),
        Desc = Builtin("SoundDesc"),
        Default = self.SoundEnabled,
        Callback = function(state)
            self:SetSound(state)
        end
    })

    self.VolumeSlider = interfaceSection:AddSlider({
        Title = Builtin("Volume"),
        Desc = Builtin("VolumeDesc"),
        Min = 0,
        Max = 200,
        Step = 5,
        Default = math.floor(self.Volume * 100 + 0.5),
        Suffix = "%",
        Callback = function(Value)
            self:SetVolume(Value / 100)
        end
    })

    self.ScaleSlider = interfaceSection:AddSlider({
        Title = Builtin("Scale"),
        Desc = Builtin("ScaleDesc"),
        Min = 70,
        Max = 130,
        Step = 5,
        Default = math.floor(self.UserScale * 100 + 0.5),
        Suffix = "%",
        Callback = function(value)
            self:SetUserScale(value / 100)
        end
    })

    self.AcrylicToggle = interfaceSection:AddToggle({
        Title = Builtin("Acrylic"),
        Desc = Builtin("AcrylicDesc"),
        Default = self.AcrylicOn,
        Callback = function(State)
            self:SetAcrylic(State)
        end
    })

    self.TransparencySlider = interfaceSection:AddSlider({
        Title = Builtin("Transparency"),
        Desc = Builtin("TransparencyDesc"),
        Min = 0,
        Max = 85,
        Step = 5,
        Default = math.floor(self.Transparency * 100 + 0.5),
        Suffix = "%",
        Callback = function(Value)
            self:SetTransparency(Value / 100)
            if not self.AcrylicOn then
                self:SetAcrylic(true)
            end
        end
    })

    self.BlurSlider = interfaceSection:AddSlider({
        Title = Builtin("Blur"),
        Desc = Builtin("BlurDesc"),
        Min = 0,
        Max = 40,
        Step = 2,
        Default = math.floor(self.BlurSize + 0.5),
        Callback = function(Value)
            self:SetBlur(Value)
        end
    })

    interfaceSection:AddKeybind({
        Title = Builtin("ToggleKey"),
        Desc = Builtin("ToggleKeyDesc"),
        Default = self.ToggleKey,
        Callback = function(Key)
            self:SetToggleKey(Key ~= Enum.KeyCode.Unknown and Key or nil)
        end
    })

    interfaceSection:AddButton({
        Title = Builtin("Reset"),
        Desc = Builtin("ResetDesc"),
        Icon = IconList.refresh,
        Callback = function()
            self:ResetPosition()
        end
    })

    interfaceSection:AddButton({
        Title = Builtin("ResetAll"),
        Desc = Builtin("ResetAllDesc"),
        Icon = IconList.refresh,
        Callback = function()
            self:ResetSettings()
        end
    })

    local privacySection = tab:AddSection({
        Title = Builtin("Privacy"),
        Desc = Builtin("PrivacyDesc"),
        Icon = "eye-off",
        Color = Color3.fromRGB(46, 150, 120)
    })

    privacySection:AddToggle({
        Title = Builtin("HideName"),
        Desc = Builtin("HideNameDesc"),
        Default = self.Config.HideName == true,
        Callback = function(state)
            self:SetHideName(state)
        end
    })

    privacySection:AddToggle({
        Title = Builtin("HideProfile"),
        Desc = Builtin("HideProfileDesc"),
        Default = self.Config.HideProfile == true,
        Callback = function(state)
            self:SetHideProfile(state)
        end
    })
end

function UIWindow:SetHideName(state)
    self.NameHidden = state == true
    self:_QueueSettingsSave()
    if self.ProfileName then
        self.ProfileName.Text = self.NameHidden and "••••••" or self.ProfileDisplayName
    end
    if self.ProfileUser then
        self.ProfileUser.Text = "@" .. (self.NameHidden and "••••••" or self.ProfileUserName)
    end
end

function UIWindow:SetHideProfile(state)
    self.ProfileHidden = state == true
    self:_QueueSettingsSave()
    if self.ProfileCard then
        self.ProfileCard.Visible = not self.ProfileHidden
    end
end

function UIWindow:_BindInput()
    self.Maid:Give(UserInputService.InputBegan:Connect(function(input, processed)
        if processed or not self.ToggleKey then
            return
        end
        if input.KeyCode == self.ToggleKey then
            self:SetVisible(not self.Visible)
        end
    end))
end


function UIWindow:_Viewport()
    local camera = workspace.CurrentCamera
    local size = camera and camera.ViewportSize or Vector2.new(1280, 720)
    if size.X <= 0 or size.Y <= 0 then
        size = Vector2.new(1280, 720)
    end
    return size
end

function UIWindow:_FitSize()
    local viewport = self:_Viewport()
    local width = math.max(math.min(self.RequestedSize.X, viewport.X - 24), 440)
    local height = math.max(math.min(self.RequestedSize.Y, viewport.Y - 24), 300)
    self.FitScale = math.min(1, (viewport.X - 16) / width, (viewport.Y - 16) / height)
    return width, height
end

function UIWindow:_TargetScale()
    return self.UserScale * self.FitScale
end

function UIWindow:_BindViewport()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end
    self.Maid:Give(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:_Refit()
    end))
end

function UIWindow:_Refit()
    local width, height = self:_FitSize()
    self.Main.Size = UDim2.fromOffset(width, height)
    if self.Visible then
        Tween(self.Scale, 0.2, { Scale = self:_TargetScale() })
    end
    local position = self.Pill.Position
    self:_PlacePill(position.X.Offset, position.Y.Offset)
end

function UIWindow:_BuildOverlay()
    self.Overlay = New("Frame", {
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 50,
        Parent = self.Main
    })

    self.Blocker = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = self.Overlay
    })

    self.Maid:Give(self.Blocker.MouseButton1Click:Connect(function()
        self:CloseDropdown()
    end))
end

function UIWindow:ActivateDropdown(dropdown)
    if self.ActiveDropdown and self.ActiveDropdown ~= dropdown then
        self.ActiveDropdown:SetOpen(false)
    end
    self.ActiveDropdown = dropdown
    self.Blocker.Visible = true
end

function UIWindow:ReleaseDropdown(dropdown)
    if self.ActiveDropdown == dropdown then
        self.ActiveDropdown = nil
        self.Blocker.Visible = false
    end
end

function UIWindow:CloseDropdown()
    if self.ActiveDropdown then
        self.ActiveDropdown:SetOpen(false)
    end
end

function UIWindow:_PillHome()
    return Vector2.new(self:_Viewport().X / 2, 12)
end

function UIWindow:_ClampPill(x, y)
    local viewport = self:_Viewport()
    local size = self.Pill.AbsoluteSize
    local halfWidth = size.X / 2
    local minX = halfWidth + 8
    local maxX = math.max(viewport.X - halfWidth - 8, minX)
    local maxY = math.max(viewport.Y - size.Y - 8, 8)
    return Vector2.new(math.clamp(x, minX, maxX), math.clamp(y, 8, maxY))
end

function UIWindow:_PlacePill(x, y)
    local point = self:_ClampPill(x, y)
    self.Pill.Position = UDim2.fromOffset(point.X, point.Y)
end

function UIWindow:_BuildPill(config, logo)
    local home = self:_PillHome()
    local text = self.ToggleTextSource or self.TitleSource

    self.PillScale = New("UIScale", { Scale = 1 })
    self.PillStroke = Stroke(C.Outline, 0, 1)

    self.Pill = New("TextButton", {
        Name = "TogglePill",
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.fromOffset(0, 40),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.fromOffset(home.X, home.Y),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Card,
        ZIndex = 100,
        Parent = self.Gui
    }, {
        Corner(12),
        self.PillStroke,
        self.PillScale,
        New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 16) }),
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 9)
        })
    })

    self.PillDot = New("Frame", {
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = Theme.Green,
        LayoutOrder = 1,
        Parent = self.Pill
    }, { Corner(nil, true) })

    local icon = New("ImageLabel", {
        Size = UDim2.fromOffset(22, 22),
        ScaleType = Enum.ScaleType.Fit,
        LayoutOrder = 2,
        Parent = self.Pill
    })
    table.insert(self.LogoImages, icon)

    self.PillLabel = New("TextLabel", {
        Size = UDim2.fromOffset(0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        Weight = "Medium",
        TextSize = 12,
        TextColor3 = Theme.Text,
        LayoutOrder = 3,
        Parent = self.Pill
    })
    Locale:Bind(self.PillLabel, "Text", text)

    self.Maid:Give(OnTheme(function()
        self:_RenderPill(true)
    end))

    self:_BindPillInput()
end

function UIWindow:_RenderPill(animate)
    if not self.Pill then
        return
    end
    local open = self.Visible
    local goals = {
        { self.PillDot, { BackgroundColor3 = open and Theme.Green or Theme.SubText } },
        { self.PillLabel, { TextColor3 = open and Theme.Text or Theme.SubText } },
        { self.PillStroke, { Color = open and Theme.AccentGlow or Theme.Outline, Transparency = open and 0.55 or 0 } }
    }
    for _, goal in ipairs(goals) do
        if animate then
            Tween(goal[1], 0.25, goal[2])
        else
            for property, value in pairs(goal[2]) do
                goal[1][property] = value
            end
        end
    end
end


function UIWindow:_BindPillInput()
    local pill = self.Pill

    self.Maid:Give(pill.InputBegan:Connect(function(input)
        if not PressTypes[input.UserInputType] then
            return
        end

        local origin = input.Position
        local start = Vector2.new(pill.Position.X.Offset, pill.Position.Y.Offset)
        local goal = start
        local current = start
        local dragged = false

        Tween(self.PillScale, 0.1, { Scale = 0.95 })

        local beatConnection = RunService.Heartbeat:Connect(function(delta)
            if not dragged then
                return
            end
            current = current:Lerp(goal, 1 - math.exp(-delta * 28))
            self:_PlacePill(current.X, current.Y)
        end)

        TrackPointer(input, function(position)
            local offset = position - origin
            if not dragged and offset.Magnitude > 12 then
                dragged = true
            end
            if dragged then
                goal = self:_ClampPill(start.X + offset.X, start.Y + offset.Y)
            end
        end, function(_, cancelled)
            beatConnection:Disconnect()
            Tween(self.PillScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
            if dragged then
                Tween(pill, 0.18, { Position = UDim2.fromOffset(goal.X, goal.Y) }, Enum.EasingStyle.Quint)
            elseif not cancelled then
                self:SetVisible(not self.Visible)
            end
        end)
    end))
end

function UIWindow:SetToggleKey(key)
    if type(key) == "string" then
        local ok, value = pcall(function()
            return Enum.KeyCode[key]
        end)
        key = ok and value or nil
    end
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        self.ToggleKey = key
    else
        self.ToggleKey = nil
    end
    self:_QueueSettingsSave()
end

function UIWindow:PlayClick(Kind)
    local Sound = self.Sounds and self.Sounds[Kind]
    if self.SoundEnabled and Sound and self.Volume > 0 then
        Sound.Volume = math.min(SOUND_LEVELS[Kind] * self.Volume, 10)
        Sound.TimePosition = 0
        Sound:Play()
    end
end

function UIWindow:PlayOpenSound()
    self:PlayClick("Open")
end

function UIWindow:SetVolume(Value)
    self.Volume = math.clamp(tonumber(Value) or 1, 0, 2)
    local Now = os.clock()
    if Now - (self.LastVolumePreview or 0) > 0.2 then
        self.LastVolumePreview = Now
        self:PlayClick("Button")
    end
    self:_QueueSettingsSave()
end

function UIWindow:_AcrylicAlpha()
    return self.AcrylicOn and self.Transparency or 0
end

function UIWindow:_UpdateBlur()
    local Active = self.AcrylicOn and self.Visible and not self.Destroyed
    local Goal = Active and self.BlurSize or 0
    if Goal > 0 and not self.BlurEffect then
        self.BlurEffect = New("BlurEffect", {
            Name = "FractureUIBlur",
            Size = 0,
            Parent = game:GetService("Lighting")
        })
    end
    if self.BlurEffect then
        Tween(self.BlurEffect, 0.35, { Size = Goal })
    end
end

function UIWindow:SetBlur(Value)
    self.BlurSize = math.clamp(tonumber(Value) or 0, 0, 40)
    self:_UpdateBlur()
    self:_QueueSettingsSave()
end

function UIWindow:_ApplyAcrylic()
    self:_UpdateBlur()
    local Alpha = self:_AcrylicAlpha()
    Tween(self.Main, 0.2, { BackgroundTransparency = Alpha })
    for Index = #self.AcrylicCards, 1, -1 do
        local Card = self.AcrylicCards[Index]
        if Card.Parent then
            Tween(Card, 0.2, { BackgroundTransparency = Alpha * 0.7 })
        else
            table.remove(self.AcrylicCards, Index)
        end
    end
    self:_QueueSettingsSave()
end

function UIWindow:SetAcrylic(State)
    self.AcrylicOn = State == true
    if self.AcrylicToggle then
        self.AcrylicToggle:Set(self.AcrylicOn, true)
    end
    self:_ApplyAcrylic()
end

function UIWindow:SetTransparency(Value)
    self.Transparency = math.clamp(tonumber(Value) or 0, 0, 0.85)
    self:_ApplyAcrylic()
end

function UIWindow:_PrepareCustom()
    if CurrentTheme ~= "Custom" then
        for _, Key in ipairs(CUSTOM_KEYS) do
            local Color = Palettes[CurrentTheme][Key]
            CustomColors[Key] = Color
            local Picker = self.CustomPickers and self.CustomPickers[Key]
            if Picker then
                Picker:Set(Color, true)
            end
        end
    end
end

function UIWindow:_SyncCustomPickers()
    local Palette = Palettes[CurrentTheme]
    for _, Key in ipairs(CUSTOM_KEYS) do
        local Picker = self.CustomPickers and self.CustomPickers[Key]
        if Picker and Palette then
            Picker:Set(Palette[Key], true)
        end
    end
end

function UIWindow:ResetSettings()
    for _, Key in ipairs(CUSTOM_KEYS) do
        CustomColors[Key] = Palettes.Dark[Key]
    end
    Palettes.Custom = BuildCustomPalette()
    AccentSolid = false
    self.StyleSegmented:Set("Gradient", true)
    self.AcrylicOn = false
    self.Transparency = 0.25
    self.AcrylicToggle:Set(false, true)
    self.TransparencySlider:Set(25, true)
    self.BlurSize = 16
    self.BlurSlider:Set(16, true)
    self:_ApplyAcrylic()
    self.UserScale = 1
    self.ScaleSlider:Set(100, true)
    Tween(self.Scale, 0.25, { Scale = self:_TargetScale() }, Enum.EasingStyle.Back)
    self.SoundEnabled = true
    self.SoundToggle:Set(true, true)
    self.NotifyTimer = true
    self.NotifyLineColor = nil
    if self.NotifyToggle then
        self.NotifyToggle:Set(true, true)
    end
    if self.NotifyLinePicker then
        self.NotifyLinePicker:Set(Theme.AccentGlow, true)
    end
    self.Volume = 1
    self.VolumeSlider:Set(100, true)
    SetTheme("Dark")
    self:_QueueSettingsSave()
end

function UIWindow:OpenColorPicker(Owner)
    if not self.Modal then
        self:_BuildColorModal()
    end
    local Modal = self.Modal
    local Color = Owner:Get()
    local Hue, Sat, Bri = Color:ToHSV()
    Modal.Owner = Owner
    Modal.Original = Color
    Modal.Color = Color
    Modal.Hue = Sat > 0 and Hue or Modal.Hue
    Modal.Sat = Sat
    Modal.Bri = Bri
    Modal.Title.Text = tostring(Locale:Resolve(Owner.TitleSource))
    Modal.OldSwatch.BackgroundColor3 = Color
    Modal.Fit = math.min(1, (self.Main.Size.X.Offset - 24) / 520, (self.Main.Size.Y.Offset - 24) / 340)
    Modal.Scale.Scale = Modal.Fit * 0.92
    Modal.Dimmer.BackgroundTransparency = 1
    Modal.Root.Visible = true
    Tween(Modal.Scale, 0.3, { Scale = Modal.Fit }, Enum.EasingStyle.Back)
    Tween(Modal.Dimmer, 0.2, { BackgroundTransparency = 0.45 })
    self:_ModalRender()
end

function UIWindow:CloseColorPicker(Keep)
    local Modal = self.Modal
    if Modal and Modal.Owner then
        local Owner = Modal.Owner
        Modal.Owner = nil
        Owner:Set(Keep and Modal.Color or Modal.Original)
        Tween(Modal.Scale, 0.15, { Scale = Modal.Fit * 0.94 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        Tween(Modal.Dimmer, 0.15, { BackgroundTransparency = 1 })
        task.delay(0.17, function()
            if not Modal.Owner then
                Modal.Root.Visible = false
            end
        end)
    end
end

function UIWindow:_ModalRender()
    local Modal = self.Modal
    local Color = Modal.Color
    Modal.SV.BackgroundColor3 = Color3.fromHSV(Modal.Hue, 1, 1)
    Modal.Cursor.Position = UDim2.fromScale(Modal.Sat, 1 - Modal.Bri)
    Modal.HueKnob.Position = UDim2.fromScale(0.5, Modal.Hue)
    Modal.HueKnob.BackgroundColor3 = Color3.fromHSV(Modal.Hue, 1, 1)
    Modal.NewSwatch.BackgroundColor3 = Color
    Modal.Hex.Text = ColorToHex(Color)
    Modal.Red.Text = tostring(math.floor(Color.R * 255 + 0.5))
    Modal.Green.Text = tostring(math.floor(Color.G * 255 + 0.5))
    Modal.Blue.Text = tostring(math.floor(Color.B * 255 + 0.5))
end

function UIWindow:_ModalApply(Final)
    local Modal = self.Modal
    local Now = os.clock()
    if Modal.Owner and (Final or Now - Modal.LastApply > 0.12) then
        Modal.LastApply = Now
        Modal.Owner:Set(Modal.Color)
    end
end

function UIWindow:_ModalSetColor(Color)
    local Modal = self.Modal
    local Hue, Sat, Bri = Color:ToHSV()
    Modal.Color = Color
    Modal.Hue = Sat > 0 and Hue or Modal.Hue
    Modal.Sat = Sat
    Modal.Bri = Bri
    self:_ModalRender()
    self:_ModalApply(true)
end

function UIWindow:_ModalDrag(Input, Zone, Target, Handler)
    local Modal = self.Modal
    local Offset = GuiInset()
    local From = Zone.AbsolutePosition
    local To = From + Zone.AbsoluteSize
    local Probe = Vector2.new(Input.Position.X, Input.Position.Y) + Offset
    local Inside = Probe.X >= From.X and Probe.X <= To.X and Probe.Y >= From.Y and Probe.Y <= To.Y
    Offset = Inside and Offset or Vector2.zero

    local function Follow(Position)
        local Size = Target.AbsoluteSize
        local Origin = Target.AbsolutePosition
        local X = math.clamp((Position.X + Offset.X - Origin.X) / math.max(Size.X, 1), 0, 1)
        local Y = math.clamp((Position.Y + Offset.Y - Origin.Y) / math.max(Size.Y, 1), 0, 1)
        Handler(X, Y)
        Modal.Color = Color3.fromHSV(Modal.Hue, Modal.Sat, Modal.Bri)
        self:_ModalRender()
        self:_ModalApply(false)
    end

    Follow(Input.Position)
    TrackPointer(Input, Follow, function()
        self:_ModalApply(true)
    end)
end

function UIWindow:_BuildColorModal()
    local Modal = { Hue = 0, Sat = 1, Bri = 1, Color = Color3.new(1, 1, 1), LastApply = 0, Fit = 1 }
    self.Modal = Modal

    Modal.Root = New("Frame", {
        Name = "ColorModal",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 80,
        Parent = self.Main
    })

    Modal.Dimmer = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Parent = Modal.Root
    })

    Modal.Panel = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(520, 340),
        BackgroundColor3 = C.Background,
        Parent = Modal.Root
    }, { Corner(16), Stroke(C.Outline, 0, 1) })

    Modal.Scale = New("UIScale", { Scale = 1, Parent = Modal.Panel })
    local Panel = Modal.Panel

    Modal.Title = New("TextLabel", {
        Position = UDim2.fromOffset(20, 14),
        Size = UDim2.fromOffset(420, 26),
        TextSize = 15,
        Weight = "Bold",
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Panel
    })

    local Close = New("TextButton", {
        Position = UDim2.fromOffset(474, 12),
        Size = UDim2.fromOffset(32, 32),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Card,
        Text = "x",
        TextSize = 16,
        Weight = "SemiBold",
        TextColor3 = C.SubText,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = Panel
    }, { Corner(16) })

    Modal.SV = New("TextButton", {
        Position = UDim2.fromOffset(20, 56),
        Size = UDim2.fromOffset(250, 164),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(1, 0, 0),
        ClipsDescendants = true,
        Parent = Panel
    }, { Corner(12), Stroke(C.Outline, 0, 1) })

    New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = Modal.SV
    }, { New("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })

    New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        Parent = Modal.SV
    }, { New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })

    Modal.Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(22, 22),
        BackgroundTransparency = 1,
        Parent = Modal.SV
    }, { Corner(nil, true), Stroke(Color3.new(1, 1, 1), 0, 3) })

    Modal.HueBar = New("Frame", {
        Position = UDim2.fromOffset(282, 56),
        Size = UDim2.fromOffset(22, 164),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = Panel
    }, { Corner(nil, true), New("UIGradient", { Rotation = 90, Color = ColorSequence.new(HUE_KEYS) }) })

    Modal.HueKnob = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(34, 16),
        Parent = Modal.HueBar
    }, { Corner(nil, true), Stroke(Color3.new(1, 1, 1), 0, 3) })

    Modal.HueZone = New("TextButton", {
        Position = UDim2.fromOffset(274, 48),
        Size = UDim2.fromOffset(38, 180),
        Parent = Panel
    })

    local function Field(Y, LabelText)
        local BoxStroke = Stroke(C.Outline, 0, 1)
        local Box = New("TextBox", {
            Position = UDim2.fromOffset(324, Y),
            Size = UDim2.fromOffset(120, 34),
            BackgroundTransparency = 0,
            BackgroundColor3 = C.Card,
            TextSize = 14,
            Weight = "SemiBold",
            TextXAlignment = Enum.TextXAlignment.Center,
            ClearTextOnFocus = false,
            Parent = Panel
        }, { Corner(9), BoxStroke })
        New("TextLabel", {
            Position = UDim2.fromOffset(454, Y),
            Size = UDim2.fromOffset(50, 34),
            TextSize = 12,
            TextColor3 = C.SubText,
            Text = LabelText,
            Parent = Panel
        })
        self.Maid:Give(Box.Focused:Connect(function()
            Tween(BoxStroke, 0.2, { Color = Theme.AccentGlow })
        end))
        self.Maid:Give(Box.FocusLost:Connect(function()
            Tween(BoxStroke, 0.2, { Color = Theme.Outline })
        end))
        return Box
    end

    Modal.Hex = Field(56, "Hex")
    Modal.Red = Field(98, "R")
    Modal.Green = Field(140, "G")
    Modal.Blue = Field(182, "B")

    Modal.OldSwatch = New("Frame", {
        Position = UDim2.fromOffset(20, 232),
        Size = UDim2.fromOffset(112, 56),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = Panel
    }, { Corner(12), Stroke(C.Outline, 0, 1) })

    Modal.NewSwatch = New("Frame", {
        Position = UDim2.fromOffset(138, 232),
        Size = UDim2.fromOffset(112, 56),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = Panel
    }, { Corner(12), Stroke(C.Outline, 0, 1) })

    for Index, Preset in ipairs(ACCENT_PRESETS) do
        local Column = (Index - 1) % 5
        local Row = math.floor((Index - 1) / 5)
        local Chip = New("TextButton", {
            Position = UDim2.fromOffset(274 + Column * 46, 232 + Row * 30),
            Size = UDim2.fromOffset(38, 26),
            BackgroundTransparency = 0,
            BackgroundColor3 = Preset,
            Parent = Panel
        }, { Corner(8) })
        BindTap(self.Maid, Chip, function()
            self:PlayClick("Button")
            self:_ModalSetColor(Preset)
        end)
    end

    local Done = New("TextButton", {
        Position = UDim2.fromOffset(20, 298),
        Size = UDim2.fromOffset(238, 34),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        TextSize = 14,
        Weight = "SemiBold",
        TextColor3 = C.OnAccent,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = Panel
    }, { Corner(10), Aura.Make("Fill") })
    Locale:Bind(Done, "Text", Builtin("ColorDone"))

    local Cancel = New("TextButton", {
        Position = UDim2.fromOffset(266, 298),
        Size = UDim2.fromOffset(238, 34),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Card,
        TextSize = 14,
        Weight = "SemiBold",
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = Panel
    }, { Corner(10) })
    Locale:Bind(Cancel, "Text", Builtin("ColorCancel"))

    self.Maid:Give(Modal.SV.InputBegan:Connect(function(Input)
        if PressTypes[Input.UserInputType] then
            self:_ModalDrag(Input, Modal.SV, Modal.SV, function(X, Y)
                Modal.Sat = X
                Modal.Bri = 1 - Y
            end)
        end
    end))

    self.Maid:Give(Modal.HueZone.InputBegan:Connect(function(Input)
        if PressTypes[Input.UserInputType] then
            self:_ModalDrag(Input, Modal.HueZone, Modal.HueBar, function(_, Y)
                Modal.Hue = Y
            end)
        end
    end))

    self.Maid:Give(Modal.Hex.FocusLost:Connect(function()
        local Typed = ParseColor(Modal.Hex.Text)
        if Typed then
            self:_ModalSetColor(Typed)
        else
            self:_ModalRender()
        end
    end))

    local function ChannelLost()
        local Red = tonumber(Modal.Red.Text)
        local Green = tonumber(Modal.Green.Text)
        local Blue = tonumber(Modal.Blue.Text)
        if Red and Green and Blue then
            self:_ModalSetColor(Color3.fromRGB(math.clamp(Red, 0, 255), math.clamp(Green, 0, 255), math.clamp(Blue, 0, 255)))
        else
            self:_ModalRender()
        end
    end

    self.Maid:Give(Modal.Red.FocusLost:Connect(ChannelLost))
    self.Maid:Give(Modal.Green.FocusLost:Connect(ChannelLost))
    self.Maid:Give(Modal.Blue.FocusLost:Connect(ChannelLost))

    BindTap(self.Maid, Done, function()
        self:PlayClick("Button")
        self:CloseColorPicker(true)
    end)
    BindTap(self.Maid, Cancel, function()
        self:PlayClick("Button")
        self:CloseColorPicker(false)
    end)
    BindTap(self.Maid, Close, function()
        self:PlayClick("Button")
        self:CloseColorPicker(false)
    end)
    self.Maid:Give(Modal.Dimmer.MouseButton1Click:Connect(function()
        self:CloseColorPicker(false)
    end))
end

function UIWindow:_RunSplash(Config, WantOpen)
    local Hold = math.max(tonumber(Config.SplashTime) or 2, 0.2)

    local Logo = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Image = Config.SplashImage or "rbxassetid://114198745266866",
        ZIndex = 9999,
        Parent = self.Gui
    }, { Corner(nil, true) })

    Tween(Logo, 0.6, { Size = UDim2.fromOffset(180, 180), ImageTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.spawn(function()
        task.wait(0.6 + Hold)
        if not self.Destroyed then
            Tween(Logo, 0.5, { Size = UDim2.fromOffset(130, 130), ImageTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.5)
            Logo:Destroy()
            if WantOpen and not self.Destroyed then
                self:SetVisible(true)
                self:PlayOpenSound()
            end
        end
    end)
end

function UIWindow:SetUserScale(value)
    self.UserScale = math.clamp(value, 0.5, 1.5)
    self:_QueueSettingsSave()
    if self.Visible then
        Tween(self.Scale, 0.25, { Scale = self:_TargetScale() }, Enum.EasingStyle.Back)
    end
end

function UIWindow:SetVisible(state, instant)
    state = state == true
    local changed = self.Visible ~= state
    self.Visible = state
    self.Transition = self.Transition + 1
    local token = self.Transition
    local target = self:_TargetScale()
    self:_RenderPill(not instant)

    if state then
        self.Main.Visible = true
        if self.Active then
            self.Active:_RestoreScroll()
        end
        if instant then
            self.Scale.Scale = target
        else
            self.Scale.Scale = target * 0.9
            Tween(self.Scale, 0.35, { Scale = target }, Enum.EasingStyle.Back)
        end
    else
        self:CloseDropdown()
        if instant then
            self.Scale.Scale = target * 0.9
            self.Main.Visible = false
        else
            local tween = Tween(self.Scale, 0.2, { Scale = target * 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tween.Completed:Connect(function()
                if self.Transition == token and not self.Visible and self.Main.Parent then
                    self.Main.Visible = false
                end
            end)
        end
    end

    self:_UpdateBlur()

    if changed and not instant then
        SafeCall(state and self.OnOpen or self.OnClose, self)
    end
end

function UIWindow:Toggle()
    self:SetVisible(not self.Visible)
end

function UIWindow:ResetPosition()
    Tween(self.Main, 0.35, { Position = self.DefaultPosition }, Enum.EasingStyle.Back)
    local home = self:_PillHome()
    Tween(self.Pill, 0.35, { Position = UDim2.fromOffset(home.X, home.Y) }, Enum.EasingStyle.Back)
end

function UIWindow:Filter(query)
    for _, tab in ipairs(self.Tabs) do
        for _, section in ipairs(tab.Sections) do
            section:Filter(query)
        end
    end
end

function UIWindow:GetTab(reference)
    if type(reference) == "table" then
        return reference
    end
    local count = 0
    for _, tab in ipairs(self.Tabs) do
        if tab ~= self.SettingsTab then
            count = count + 1
            if type(reference) == "number" and count == reference then
                return tab
            end
        end
        if type(reference) == "string" and (tab.TitleSource == reference or Locale:Resolve(tab.TitleSource) == reference) then
            return tab
        end
    end
    return nil
end

function UIWindow:Select(reference, silent)
    local tab = self:GetTab(reference)
    if not tab or tab.Destroyed or self.Active == tab then
        return
    end
    self:CloseDropdown()
    if self.Active then
        self.Active:SetActive(false)
    end
    self.Active = tab
    Locale:Bind(self.PageTitle, "Text", tab.TitleSource)
    Locale:Bind(self.PageDesc, "Text", tab.DescSource)
    tab:SetActive(true)
end

function UIWindow:_SelectFallback(skip)
    for _, tab in ipairs(self.Tabs) do
        if tab ~= skip and not tab.Hidden and not tab.Destroyed then
            self.Active = nil
            self:Select(tab, true)
            return
        end
    end
end

function UIWindow:AddTab(config)
    local tab = UITab.new(self, config or {})
    table.insert(self.Tabs, tab)
    self.UserTabs = self.UserTabs + 1
    if self.UserTabs == 1 then
        self:Select(tab, true)
    end
    return tab
end

function UIWindow:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    if self.BlurEffect then
        self.BlurEffect:Destroy()
        self.BlurEffect = nil
    end
    SafeCall(self.OnDestroy, self)
    for flag, element in pairs(FlagElements) do
        if element.Window == self then
            FlagElements[flag] = nil
            Flags[flag] = nil
        end
    end
    for index, window in ipairs(Windows) do
        if window == self then
            table.remove(Windows, index)
            break
        end
    end
    self.Maid:Destroy()
end

UIWindow.CreateTab = UIWindow.AddTab

local function IsLucide(value)
    return type(value) == "string" and (IconList[value] or IconList[NormalizeIconName(value)]) ~= nil
end

function UIWindow:_PaintIcons()
    local source = self.IconSource
    if type(source) == "string" then
        source = Locale:Resolve(source)
    end
    local image = ResolveIcon(source, "rbxassetid://10723415393")
    local tint = IsLucide(source) and Theme.Text or Color3.fromRGB(255, 255, 255)
    for _, label in ipairs(self.LogoImages) do
        label.Image = image
        label.ImageColor3 = tint
    end
end

function UIWindow:SetIcon(icon)
    self.IconSource = icon or "rbxassetid://10723415393"
    self:_PaintIcons()
end

function UIWindow:GetIcon()
    return self.IconSource
end

UIWindow.SetLogo = UIWindow.SetIcon

function UIWindow:SetTitle(source)
    self.TitleSource = source
    Locale:Bind(self.SidebarTitle, "Text", source)
    if not self.ToggleTextSource then
        Locale:Bind(self.PillLabel, "Text", source)
    end
end

function UIWindow:SetSubTitle(source)
    self.SubTitleSource = source
    Locale:Bind(self.SidebarSubTitle, "Text", source)
end

function UIWindow:SetToggleText(source)
    self.ToggleTextSource = source
    Locale:Bind(self.PillLabel, "Text", source or self.TitleSource)
end

function UIWindow:SetPillVisible(state)
    self.PillShown = state ~= false
    self.Pill.Visible = self.PillShown
end

function UIWindow:SetSize(size)
    if typeof(size) == "UDim2" then
        size = Vector2.new(size.X.Offset, size.Y.Offset)
    end
    self.RequestedSize = size
    self:_Refit()
end

function UIWindow:SetPosition(position)
    self.DefaultPosition = position
    self.Main.Position = position
end

UIWindow.SetScale = UIWindow.SetUserScale

function UIWindow:SetSound(state)
    self.SoundEnabled = state == true
    self:PlayClick("Toggle")
    self:_QueueSettingsSave()
end

function UIWindow:Open()
    self:SetVisible(true)
end

function UIWindow:Close()
    self:SetVisible(false)
end

UIWindow.Show = UIWindow.Open
UIWindow.Hide = UIWindow.Close

function UIWindow:IsVisible()
    return self.Visible
end

function UIWindow:SetTheme(name)
    return SetTheme(name)
end

function UIWindow:GetTheme()
    return CurrentTheme
end

function UIWindow:SetLanguage(code)
    Locale:SetLanguage(code)
end

function UIWindow:GetLanguage()
    return Locale.Language
end

function UIWindow:AddLanguage(code, pack, name)
    local entry = { [code] = pack }
    if name then
        entry[code].LanguageName = name
    end
    Locale:AddTranslations(entry)
    Locale:_Apply()
end

function UIWindow:Refresh()
    self:_Refit()
    self:_PaintIcons()
    Locale:_Apply()
    for _, tab in ipairs(self.Tabs) do
        tab:Refresh()
    end
    self:Filter("")
end

function UIWindow:_BuildNotifications()
    self.NotifyList = New("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 272, 1, -32),
        Position = UDim2.new(1, -16, 1, -16),
        BackgroundTransparency = 1,
        ZIndex = 200,
        Parent = self.Gui
    }, {
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 6)
        })
    })
    self.NotifyCount = 0
end

local NOTIFY_COLORS = {
    success = "Green",
    warning = "Yellow",
    error = "Red"
}

local NOTIFY_ICONS = {
    success = { "check", "circle-check" },
    warning = { "triangle-alert", "alert-triangle" },
    error = { "circle-x", "x-circle", "x" },
    info = { "info", "bell" }
}

local function FindIcon(Names)
    local Found
    for _, Name in ipairs(Names) do
        Found = Found or ResolveIcon(Name)
    end
    return Found
end

function UIWindow:Notify(config)
    if type(config) == "string" then
        config = { Content = config }
    end
    config = config or {}
    self.NotifyCount = self.NotifyCount + 1

    local Duration = config.Duration or 4
    local Kind = NOTIFY_ICONS[config.Type] and config.Type or "info"
    local Tint = NOTIFY_COLORS[Kind]
    local Accent = config.LineColor or config.Color or (Tint and Theme[Tint]) or self.NotifyLineColor or Theme.AccentGlow
    local IconImage = (config.Icon and ResolveIcon(config.Icon)) or FindIcon(NOTIFY_ICONS[Kind])
    local HasContent = config.Content ~= nil and config.Content ~= ""

    local Slot = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = self.NotifyCount,
        Parent = self.NotifyList
    })

    local Card = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 300, 0, 0),
        BackgroundTransparency = 0,
        BackgroundColor3 = C.Card,
        ClipsDescendants = true,
        ZIndex = 200,
        Parent = Slot
    }, {
        Corner(12),
        Stroke(Accent, 0.6, 1)
    })

    New("Frame", {
        Name = "Glow",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Accent,
        BackgroundTransparency = 0,
        Parent = Card
    }, {
        Corner(12),
        New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.84),
                NumberSequenceKeypoint.new(0.55, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
    })

    local Body = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = Card
    }, {
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        }),
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
    })

    local Row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        AutomaticSize = HasContent and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = Body
    })

    local Badge = New("Frame", {
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Accent,
        BackgroundTransparency = 0.82,
        Parent = Row
    }, { Corner(9), Stroke(Accent, 0.65, 1) })

    New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromScale(0.5, 0.5),
        Image = IconImage or "",
        ImageColor3 = Accent,
        Visible = IconImage ~= nil,
        Parent = Badge
    })

    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Accent,
        Visible = IconImage == nil,
        Parent = Badge
    }, { Corner(nil, true) })

    local TextHolder = New("Frame", {
        Position = UDim2.fromOffset(38, 0),
        Size = UDim2.new(1, -38, HasContent and 0 or 1, 0),
        AutomaticSize = HasContent and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
        BackgroundTransparency = 1,
        Parent = Row
    }, {
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = HasContent and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 2)
        })
    })

    local Title = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Weight = "SemiBold",
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = TextHolder
    })
    Locale:Bind(Title, "Text", config.Title or self.TitleSource)

    if HasContent then
        local Message = New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = C.SubText,
            LineHeight = 1.2,
            LayoutOrder = 2,
            Parent = TextHolder
        })
        Locale:Bind(Message, "Text", config.Content)
    end

    local ShowTimer = Duration > 0 and Pick(config.Timer, self.NotifyTimer) == true
    if ShowTimer then
        local Track = New("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = Accent,
            BackgroundTransparency = 0.85,
            LayoutOrder = 2,
            Parent = Body
        }, { Corner(nil, true) })
        local Fill = New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Accent,
            Parent = Track
        }, { Corner(nil, true) })
        Tween(Fill, Duration, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Linear)
    end

    local Closed = false
    local function Close()
        if not Closed then
            Closed = true
            local Out = Tween(Card, 0.22, { Position = UDim2.new(0, 300, 0, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            Out.Completed:Connect(function()
                Slot:Destroy()
            end)
        end
    end

    Tween(Card, 0.4, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quint)

    BindTap(self.Maid, Card, function()
        self:PlayClick("Button")
        Close()
        SafeCall(config.Callback)
    end)

    if Duration > 0 then
        task.delay(Duration, Close)
    end

    return { Close = Close }
end

function UIWindow:GetConfig()
    local data = {}
    for flag, element in pairs(FlagElements) do
        if element.Window == self and not element.Destroyed then
            local Value = element:Get()
            local Kind = typeof(Value)
            data[flag] = Kind == "Color3" and ColorToHex(Value) or (Kind == "EnumItem" and Value.Name or Value)
        end
    end
    return data
end

function UIWindow:LoadConfig(data, silent)
    if type(data) == "string" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if not ok then
            return false, decoded
        end
        data = decoded
    end
    if type(data) ~= "table" then
        return false, "invalid config"
    end
    for flag, value in pairs(data) do
        local element = FlagElements[flag]
        if element and element.Window == self and not element.Destroyed then
            element:Set(value, silent)
        end
    end
    return true
end

function UIWindow:SetMap(name)
    self.ConfigMap = name ~= nil and CleanName(name) or nil
end

function UIWindow:GetMap()
    return self.ConfigMap or tostring(game.PlaceId)
end

function UIWindow:_ConfigPath(name)
    local file = CleanName(name or Players.LocalPlayer.Name)
    return {
        Folders = { CleanName(self.ConfigFolder), self:GetMap() },
        File = file .. ".json"
    }
end

function UIWindow:ConfigFilePath(name)
    local info = self:_ConfigPath(name)
    return table.concat(info.Folders, "/") .. "/" .. info.File
end

function UIWindow:SaveConfig(name)
    if not (writefile and makefolder) then
        return false, "this executor has no file API"
    end
    local ok, err = pcall(function()
        local info = self:_ConfigPath(name)
        local path = ""
        for _, folder in ipairs(info.Folders) do
            path = path == "" and folder or (path .. "/" .. folder)
            if not (isfolder and isfolder(path)) then
                makefolder(path)
            end
        end
        writefile(path .. "/" .. info.File, HttpService:JSONEncode(self:GetConfig()))
    end)
    return ok, err
end

function UIWindow:SetAutoSave(state)
    self.AutoSave = state == true
end

function UIWindow:_QueueSave()
    if not self.AutoSave or self.Destroyed then
        return
    end
    self.SaveToken = (self.SaveToken or 0) + 1
    local token = self.SaveToken
    task.delay(1.5, function()
        if token == self.SaveToken and not self.Destroyed then
            self:SaveConfig()
        end
    end)
end

function UIWindow:LoadConfigFile(name, silent)
    local path = self:ConfigFilePath(name)
    if not (readfile and isfile and isfile(path)) then
        return false, "config not found"
    end
    local ok, content = pcall(readfile, path)
    if not ok then
        return false, content
    end
    return self:LoadConfig(content, silent)
end

function UIWindow:SettingsFilePath()
    return CleanName(self.ConfigFolder) .. "/Settings.json"
end

function UIWindow:GetSettings()
    return {
        Language = Locale.Language,
        Theme = CurrentTheme,
        Sound = self.SoundEnabled,
        Volume = self.Volume,
        Scale = self.UserScale,
        AcrylicOn = self.AcrylicOn,
        Transparency = self.Transparency,
        BlurSize = self.BlurSize,
        AccentStyle = AccentSolid and "Solid" or "Gradient",
        HideName = self.NameHidden == true,
        HideProfile = self.ProfileHidden == true,
        ToggleKey = self.ToggleKey and self.ToggleKey.Name or "",
        Custom = self:_CustomData()
    }
end

function UIWindow:_CustomData()
    local Data = {}
    for _, Key in ipairs(CUSTOM_KEYS) do
        Data[Key] = ColorToHex(CustomColors[Key])
    end
    return Data
end

function UIWindow:_ApplyCustomData(Data)
    local Source = type(Data) == "table" and Data or {}
    for _, Key in ipairs(CUSTOM_KEYS) do
        local Color = ParseColor(Source[Key])
        CustomColors[Key] = Color or CustomColors[Key]
        local Picker = self.CustomPickers and self.CustomPickers[Key]
        if Picker and Color then
            Picker:Set(Color, true)
        end
    end
    Palettes.Custom = BuildCustomPalette()
end

function UIWindow:_ReadSettings()
    local Result = {}
    local Path = self:SettingsFilePath()
    if readfile and isfile and isfile(Path) then
        local Ok, Decoded = pcall(function()
            return HttpService:JSONDecode(readfile(Path))
        end)
        if Ok and type(Decoded) == "table" then
            Result = Decoded
        end
    end
    return Result
end

function UIWindow:SaveSettings()
    local Ok, Err = false, "this executor has no file API"
    if writefile and makefolder then
        Ok, Err = pcall(function()
            local Folder = CleanName(self.ConfigFolder)
            if not (isfolder and isfolder(Folder)) then
                makefolder(Folder)
            end
            writefile(self:SettingsFilePath(), HttpService:JSONEncode(self:GetSettings()))
        end)
    end
    return Ok, Err
end

function UIWindow:LoadSettings()
    local Data = self:_ReadSettings()
    local Found = next(Data) ~= nil
    if Found then
        self:_ApplyCustomData(Data.Custom)
        self.NotifyTimer = Pick(Data.NotifyTimer, self.NotifyTimer)
        self.NotifyLineColor = ParseColor(Pick(Data.NotifyLine, self.NotifyLineColor))
        Locale:SetLanguage(Data.Language)
        SetTheme(Data.Theme)
        self.Volume = math.clamp(tonumber(Pick(Data.Volume, self.Volume)) or 1, 0, 2)
        self:SetSound(Pick(Data.Sound, self.SoundEnabled))
        self:SetUserScale(tonumber(Pick(Data.Scale, self.UserScale)) or 1)
        self.Transparency = math.clamp(tonumber(Pick(Data.Transparency, self.Transparency)) or 0.25, 0, 0.85)
        self.BlurSize = math.clamp(tonumber(Pick(Data.BlurSize, self.BlurSize)) or 16, 0, 40)
        self:SetAcrylic(Pick(Data.AcrylicOn, self.AcrylicOn))
        AccentSolid = Pick(Data.AccentStyle, AccentSolid and "Solid" or "Gradient") == "Solid"
        self:SetHideName(Pick(Data.HideName, self.NameHidden))
        self:SetHideProfile(Pick(Data.HideProfile, self.ProfileHidden))
        self:SetToggleKey(Pick(Data.ToggleKey, self.ToggleKey))
    end
    return Found
end

function UIWindow:_QueueSettingsSave()
    if self.SettingsReady and not self.Destroyed then
        self.SettingsToken = (self.SettingsToken or 0) + 1
        local Token = self.SettingsToken
        task.delay(1, function()
            if Token == self.SettingsToken and not self.Destroyed then
                self:SaveSettings()
            end
        end)
    end
end

function UIWindow:HasConfig(name)
    return isfile ~= nil and isfile(self:ConfigFilePath(name)) == true
end

local FractureUI = {
    Version = "2.0.0",
    Theme = Theme,
    Icons = IconList,
    Themes = THEME_ORDER,
    Flags = Flags,
    Elements = FlagElements,
    Windows = Windows
}

function FractureUI:SetTheme(name)
    return SetTheme(name)
end

function FractureUI:GetTheme()
    return CurrentTheme
end

function FractureUI:ResolveIcon(icon)
    return ResolveIcon(icon, "rbxassetid://6023426915")
end

function FractureUI:AddIcon(name, asset)
    if type(asset) == "number" then
        asset = "rbxassetid://" .. asset
    end
    IconList[name] = asset
end

function FractureUI:CreateWindow(config)
    return UIWindow.new(config)
end

function FractureUI:Localization(config)
    Locale:Configure(config)
end

FractureUI.AutoTranslate = true

function FractureUI:AddTranslations(translations)
    Locale:AddTranslations(translations)
    Locale:_Apply()
end

function FractureUI:SetLanguage(code)
    Locale:SetLanguage(code)
end

function FractureUI:GetLanguage()
    return Locale.Language
end

function FractureUI:GetLanguages()
    return Locale:GetLanguages()
end

function FractureUI:Notify(config)
    local window = Windows[#Windows]
    if window then
        return window:Notify(config)
    end
end

function FractureUI:GetWindows()
    return table.clone(Windows)
end

function FractureUI:Destroy()
    for _, window in ipairs(table.clone(Windows)) do
        window:Destroy()
    end
end

return FractureUI
