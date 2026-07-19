local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = Workspace.CurrentCamera

local Library = {}
Library.Translations = {}

local Fonts = {
    ["Gotham"] = {Regular = Enum.Font.Gotham, Medium = Enum.Font.GothamMedium, Bold = Enum.Font.GothamBold},
    ["Source Sans"] = {Regular = Enum.Font.SourceSans, Medium = Enum.Font.SourceSansSemibold, Bold = Enum.Font.SourceSansBold},
    ["Arial"] = {Regular = Enum.Font.Arial, Medium = Enum.Font.Arial, Bold = Enum.Font.ArialBold},
    ["Legacy"] = {Regular = Enum.Font.Legacy, Medium = Enum.Font.Legacy, Bold = Enum.Font.Legacy},
    ["Roboto"] = {Regular = Enum.Font.Roboto, Medium = Enum.Font.Roboto, Bold = Enum.Font.RobotoCondensed},
    ["Roboto Mono"] = {Regular = Enum.Font.RobotoMono, Medium = Enum.Font.RobotoMono, Bold = Enum.Font.RobotoMono},
    ["Oswald"] = {Regular = Enum.Font.Oswald, Medium = Enum.Font.Oswald, Bold = Enum.Font.Oswald},
    ["Ubuntu"] = {Regular = Enum.Font.Ubuntu, Medium = Enum.Font.Ubuntu, Bold = Enum.Font.Ubuntu},
    ["Nunito"] = {Regular = Enum.Font.Nunito, Medium = Enum.Font.Nunito, Bold = Enum.Font.Nunito},
    ["Merriweather"] = {Regular = Enum.Font.Merriweather, Medium = Enum.Font.Merriweather, Bold = Enum.Font.Merriweather},
    ["Michroma"] = {Regular = Enum.Font.Michroma, Medium = Enum.Font.Michroma, Bold = Enum.Font.Michroma},
    ["Kalam"] = {Regular = Enum.Font.Kalam, Medium = Enum.Font.Kalam, Bold = Enum.Font.Kalam},
    ["Indie Flower"] = {Regular = Enum.Font.IndieFlower, Medium = Enum.Font.IndieFlower, Bold = Enum.Font.IndieFlower},
    ["Patrick Hand"] = {Regular = Enum.Font.PatrickHand, Medium = Enum.Font.PatrickHand, Bold = Enum.Font.PatrickHand},
    ["Permanent Marker"] = {Regular = Enum.Font.PermanentMarker, Medium = Enum.Font.PermanentMarker, Bold = Enum.Font.PermanentMarker},
    ["Luckiest Guy"] = {Regular = Enum.Font.LuckiestGuy, Medium = Enum.Font.LuckiestGuy, Bold = Enum.Font.LuckiestGuy},
    ["Fredoka One"] = {Regular = Enum.Font.FredokaOne, Medium = Enum.Font.FredokaOne, Bold = Enum.Font.FredokaOne},
    ["Bangers"] = {Regular = Enum.Font.Bangers, Medium = Enum.Font.Bangers, Bold = Enum.Font.Bangers},
    ["Titillium Web"] = {Regular = Enum.Font.TitilliumWeb, Medium = Enum.Font.TitilliumWeb, Bold = Enum.Font.TitilliumWeb},
    ["Code"] = {Regular = Enum.Font.Code, Medium = Enum.Font.Code, Bold = Enum.Font.Code}
}

local CurrentFontName = "Gotham"
local CurrentFontFamily = Fonts[CurrentFontName]
local FontRegistry = {}

local function SetInterFont(instance, weight)
    FontRegistry[instance] = weight
    instance.Font = CurrentFontFamily[weight] or CurrentFontFamily.Regular
end

local Themes = {
    ["Midnight"] = {
        Background = Color3.fromRGB(9, 10, 15),
        Sidebar = Color3.fromRGB(14, 16, 24),
        ElementBg = Color3.fromRGB(20, 23, 34),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(243, 244, 246),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(31, 41, 55),
        ToggleOn = Color3.fromRGB(99, 102, 241),
        ToggleOff = Color3.fromRGB(37, 40, 52)
    },
    ["Carbon"] = {
        Background = Color3.fromRGB(18, 18, 18),
        Sidebar = Color3.fromRGB(26, 26, 26),
        ElementBg = Color3.fromRGB(34, 34, 34),
        Accent = Color3.fromRGB(220, 252, 19),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(140, 140, 140),
        Border = Color3.fromRGB(48, 48, 48),
        ToggleOn = Color3.fromRGB(220, 252, 19),
        ToggleOff = Color3.fromRGB(44, 44, 44)
    },
    ["Onyx"] = {
        Background = Color3.fromRGB(10, 11, 12),
        Sidebar = Color3.fromRGB(17, 18, 20),
        ElementBg = Color3.fromRGB(24, 25, 28),
        Accent = Color3.fromRGB(139, 92, 246),
        Text = Color3.fromRGB(249, 250, 251),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(31, 41, 55),
        ToggleOn = Color3.fromRGB(139, 92, 246),
        ToggleOff = Color3.fromRGB(38, 38, 38)
    },
    ["Obsidian"] = {
        Background = Color3.fromRGB(11, 11, 14),
        Sidebar = Color3.fromRGB(19, 19, 24),
        ElementBg = Color3.fromRGB(27, 27, 34),
        Accent = Color3.fromRGB(236, 72, 153),
        Text = Color3.fromRGB(253, 244, 245),
        SubText = Color3.fromRGB(161, 161, 170),
        Border = Color3.fromRGB(43, 43, 53),
        ToggleOn = Color3.fromRGB(236, 72, 153),
        ToggleOff = Color3.fromRGB(44, 44, 52)
    },
    ["Slate"] = {
        Background = Color3.fromRGB(15, 23, 42),
        Sidebar = Color3.fromRGB(30, 41, 59),
        ElementBg = Color3.fromRGB(47, 62, 86),
        Accent = Color3.fromRGB(56, 189, 248),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
        ToggleOn = Color3.fromRGB(56, 189, 248),
        ToggleOff = Color3.fromRGB(55, 65, 81)
    },
    ["Arctic"] = {
        Background = Color3.fromRGB(241, 245, 249),
        Sidebar = Color3.fromRGB(226, 232, 240),
        ElementBg = Color3.fromRGB(203, 213, 225),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(15, 23, 42),
        SubText = Color3.fromRGB(71, 85, 105),
        Border = Color3.fromRGB(148, 163, 184),
        ToggleOn = Color3.fromRGB(14, 165, 233),
        ToggleOff = Color3.fromRGB(186, 195, 205)
    },
    ["Frost"] = {
        Background = Color3.fromRGB(224, 242, 254),
        Sidebar = Color3.fromRGB(186, 230, 253),
        ElementBg = Color3.fromRGB(125, 211, 252),
        Accent = Color3.fromRGB(3, 105, 161),
        Text = Color3.fromRGB(8, 47, 73),
        SubText = Color3.fromRGB(14, 116, 144),
        Border = Color3.fromRGB(56, 189, 248),
        ToggleOn = Color3.fromRGB(3, 105, 161),
        ToggleOff = Color3.fromRGB(150, 200, 230)
    },
    ["Glacier"] = {
        Background = Color3.fromRGB(24, 37, 45),
        Sidebar = Color3.fromRGB(35, 52, 63),
        ElementBg = Color3.fromRGB(48, 71, 86),
        Accent = Color3.fromRGB(130, 205, 240),
        Text = Color3.fromRGB(240, 246, 250),
        SubText = Color3.fromRGB(160, 185, 200),
        Border = Color3.fromRGB(60, 85, 102),
        ToggleOn = Color3.fromRGB(130, 205, 240),
        ToggleOff = Color3.fromRGB(46, 60, 71)
    },
    ["Iceberg"] = {
        Background = Color3.fromRGB(16, 26, 36),
        Sidebar = Color3.fromRGB(25, 39, 54),
        ElementBg = Color3.fromRGB(36, 55, 75),
        Accent = Color3.fromRGB(100, 210, 255),
        Text = Color3.fromRGB(245, 250, 255),
        SubText = Color3.fromRGB(150, 175, 195),
        Border = Color3.fromRGB(48, 72, 96),
        ToggleOn = Color3.fromRGB(100, 210, 255),
        ToggleOff = Color3.fromRGB(30, 48, 66)
    },
    ["Nimbus"] = {
        Background = Color3.fromRGB(31, 33, 40),
        Sidebar = Color3.fromRGB(41, 45, 54),
        ElementBg = Color3.fromRGB(52, 57, 69),
        Accent = Color3.fromRGB(245, 158, 11),
        Text = Color3.fromRGB(249, 250, 251),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(75, 85, 99),
        ToggleOn = Color3.fromRGB(245, 158, 11),
        ToggleOff = Color3.fromRGB(43, 47, 56)
    },
    ["Horizon"] = {
        Background = Color3.fromRGB(28, 13, 26),
        Sidebar = Color3.fromRGB(41, 18, 38),
        ElementBg = Color3.fromRGB(56, 24, 51),
        Accent = Color3.fromRGB(244, 63, 94),
        Text = Color3.fromRGB(255, 241, 242),
        SubText = Color3.fromRGB(244, 114, 182),
        Border = Color3.fromRGB(76, 29, 69),
        ToggleOn = Color3.fromRGB(244, 63, 94),
        ToggleOff = Color3.fromRGB(43, 19, 39)
    },
    ["Eclipse"] = {
        Background = Color3.fromRGB(8, 8, 12),
        Sidebar = Color3.fromRGB(14, 14, 20),
        ElementBg = Color3.fromRGB(21, 21, 30),
        Accent = Color3.fromRGB(190, 24, 74),
        Text = Color3.fromRGB(253, 244, 245),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(31, 41, 55),
        ToggleOn = Color3.fromRGB(190, 24, 74),
        ToggleOff = Color3.fromRGB(28, 28, 38)
    },
    ["Ember"] = {
        Background = Color3.fromRGB(24, 10, 6),
        Sidebar = Color3.fromRGB(38, 15, 9),
        ElementBg = Color3.fromRGB(54, 21, 12),
        Accent = Color3.fromRGB(249, 115, 22),
        Text = Color3.fromRGB(255, 247, 237),
        SubText = Color3.fromRGB(253, 186, 116),
        Border = Color3.fromRGB(79, 26, 14),
        ToggleOn = Color3.fromRGB(249, 115, 22),
        ToggleOff = Color3.fromRGB(43, 17, 10)
    },
    ["Crimson"] = {
        Background = Color3.fromRGB(20, 8, 10),
        Sidebar = Color3.fromRGB(31, 11, 14),
        ElementBg = Color3.fromRGB(46, 16, 20),
        Accent = Color3.fromRGB(225, 29, 72),
        Text = Color3.fromRGB(255, 241, 242),
        SubText = Color3.fromRGB(251, 113, 133),
        Border = Color3.fromRGB(64, 15, 22),
        ToggleOn = Color3.fromRGB(225, 29, 72),
        ToggleOff = Color3.fromRGB(36, 13, 16)
    },
    ["Ruby"] = {
        Background = Color3.fromRGB(26, 10, 15),
        Sidebar = Color3.fromRGB(41, 15, 23),
        ElementBg = Color3.fromRGB(56, 20, 31),
        Accent = Color3.fromRGB(219, 39, 119),
        Text = Color3.fromRGB(253, 244, 245),
        SubText = Color3.fromRGB(244, 114, 182),
        Border = Color3.fromRGB(83, 24, 43),
        ToggleOn = Color3.fromRGB(219, 39, 119),
        ToggleOff = Color3.fromRGB(43, 15, 22)
    },
    ["Cherry"] = {
        Background = Color3.fromRGB(25, 12, 16),
        Sidebar = Color3.fromRGB(40, 18, 25),
        ElementBg = Color3.fromRGB(55, 25, 34),
        Accent = Color3.fromRGB(244, 63, 128),
        Text = Color3.fromRGB(254, 242, 244),
        SubText = Color3.fromRGB(249, 168, 192),
        Border = Color3.fromRGB(78, 30, 46),
        ToggleOn = Color3.fromRGB(244, 63, 128),
        ToggleOff = Color3.fromRGB(42, 19, 26)
    },
    ["Scarlet"] = {
        Background = Color3.fromRGB(28, 10, 10),
        Sidebar = Color3.fromRGB(43, 14, 14),
        ElementBg = Color3.fromRGB(58, 20, 20),
        Accent = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(254, 242, 242),
        SubText = Color3.fromRGB(252, 165, 165),
        Border = Color3.fromRGB(82, 24, 24),
        ToggleOn = Color3.fromRGB(239, 68, 68),
        ToggleOff = Color3.fromRGB(45, 15, 15)
    },
    ["Inferno"] = {
        Background = Color3.fromRGB(15, 6, 6),
        Sidebar = Color3.fromRGB(26, 9, 9),
        ElementBg = Color3.fromRGB(38, 12, 12),
        Accent = Color3.fromRGB(220, 38, 38),
        Text = Color3.fromRGB(254, 242, 242),
        SubText = Color3.fromRGB(248, 113, 113),
        Border = Color3.fromRGB(56, 14, 14),
        ToggleOn = Color3.fromRGB(220, 38, 38),
        ToggleOff = Color3.fromRGB(28, 9, 9)
    },
    ["Sunset"] = {
        Background = Color3.fromRGB(26, 15, 15),
        Sidebar = Color3.fromRGB(38, 20, 18),
        ElementBg = Color3.fromRGB(52, 27, 24),
        Accent = Color3.fromRGB(249, 115, 22),
        Text = Color3.fromRGB(255, 247, 237),
        SubText = Color3.fromRGB(253, 186, 116),
        Border = Color3.fromRGB(73, 35, 30),
        ToggleOn = Color3.fromRGB(249, 115, 22),
        ToggleOff = Color3.fromRGB(42, 21, 19)
    },
    ["Aurora"] = {
        Background = Color3.fromRGB(10, 20, 18),
        Sidebar = Color3.fromRGB(15, 32, 28),
        ElementBg = Color3.fromRGB(21, 44, 38),
        Accent = Color3.fromRGB(52, 211, 153),
        Text = Color3.fromRGB(240, 253, 250),
        SubText = Color3.fromRGB(110, 231, 183),
        Border = Color3.fromRGB(30, 60, 52),
        ToggleOn = Color3.fromRGB(52, 211, 153),
        ToggleOff = Color3.fromRGB(16, 34, 30)
    },
    ["Forest"] = {
        Background = Color3.fromRGB(10, 20, 12),
        Sidebar = Color3.fromRGB(15, 30, 18),
        ElementBg = Color3.fromRGB(21, 42, 25),
        Accent = Color3.fromRGB(34, 197, 94),
        Text = Color3.fromRGB(240, 253, 244),
        SubText = Color3.fromRGB(134, 239, 172),
        Border = Color3.fromRGB(30, 58, 35),
        ToggleOn = Color3.fromRGB(34, 197, 94),
        ToggleOff = Color3.fromRGB(16, 32, 20)
    },
    ["Moss"] = {
        Background = Color3.fromRGB(18, 22, 15),
        Sidebar = Color3.fromRGB(26, 32, 22),
        ElementBg = Color3.fromRGB(35, 43, 30),
        Accent = Color3.fromRGB(163, 230, 53),
        Text = Color3.fromRGB(247, 254, 231),
        SubText = Color3.fromRGB(190, 242, 75),
        Border = Color3.fromRGB(48, 59, 41),
        ToggleOn = Color3.fromRGB(163, 230, 53),
        ToggleOff = Color3.fromRGB(27, 33, 23)
    },
    ["Olive"] = {
        Background = Color3.fromRGB(19, 20, 13),
        Sidebar = Color3.fromRGB(28, 30, 19),
        ElementBg = Color3.fromRGB(38, 40, 25),
        Accent = Color3.fromRGB(132, 204, 22),
        Text = Color3.fromRGB(250, 252, 242),
        SubText = Color3.fromRGB(163, 230, 53),
        Border = Color3.fromRGB(53, 56, 35),
        ToggleOn = Color3.fromRGB(132, 204, 22),
        ToggleOff = Color3.fromRGB(29, 31, 19)
    },
    ["Emerald"] = {
        Background = Color3.fromRGB(8, 22, 16),
        Sidebar = Color3.fromRGB(12, 34, 24),
        ElementBg = Color3.fromRGB(17, 47, 33),
        Accent = Color3.fromRGB(16, 185, 129),
        Text = Color3.fromRGB(236, 253, 245),
        SubText = Color3.fromRGB(110, 231, 183),
        Border = Color3.fromRGB(24, 67, 47),
        ToggleOn = Color3.fromRGB(16, 185, 129),
        ToggleOff = Color3.fromRGB(13, 37, 26)
    },
    ["Jade"] = {
        Background = Color3.fromRGB(12, 24, 20),
        Sidebar = Color3.fromRGB(18, 36, 30),
        ElementBg = Color3.fromRGB(25, 49, 41),
        Accent = Color3.fromRGB(5, 150, 105),
        Text = Color3.fromRGB(236, 253, 245),
        SubText = Color3.fromRGB(52, 211, 153),
        Border = Color3.fromRGB(35, 68, 57),
        ToggleOn = Color3.fromRGB(5, 150, 105),
        ToggleOff = Color3.fromRGB(19, 37, 31)
    },
    ["Ocean"] = {
        Background = Color3.fromRGB(12, 20, 30),
        Sidebar = Color3.fromRGB(17, 29, 44),
        ElementBg = Color3.fromRGB(23, 39, 59),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(240, 249, 255),
        SubText = Color3.fromRGB(125, 211, 252),
        Border = Color3.fromRGB(32, 54, 82),
        ToggleOn = Color3.fromRGB(14, 165, 233),
        ToggleOff = Color3.fromRGB(18, 30, 45)
    },
    ["Abyss"] = {
        Background = Color3.fromRGB(5, 8, 14),
        Sidebar = Color3.fromRGB(8, 13, 24),
        ElementBg = Color3.fromRGB(12, 19, 34),
        Accent = Color3.fromRGB(37, 99, 235),
        Text = Color3.fromRGB(242, 247, 255),
        SubText = Color3.fromRGB(147, 197, 253),
        Border = Color3.fromRGB(18, 29, 52),
        ToggleOn = Color3.fromRGB(37, 99, 235),
        ToggleOff = Color3.fromRGB(9, 14, 26)
    },
    ["Sapphire"] = {
        Background = Color3.fromRGB(10, 18, 31),
        Sidebar = Color3.fromRGB(15, 27, 46),
        ElementBg = Color3.fromRGB(20, 37, 63),
        Accent = Color3.fromRGB(29, 78, 216),
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(147, 197, 253),
        Border = Color3.fromRGB(28, 52, 89),
        ToggleOn = Color3.fromRGB(29, 78, 216),
        ToggleOff = Color3.fromRGB(16, 29, 49)
    },
    ["Cobalt"] = {
        Background = Color3.fromRGB(14, 16, 26),
        Sidebar = Color3.fromRGB(21, 24, 39),
        ElementBg = Color3.fromRGB(29, 33, 54),
        Accent = Color3.fromRGB(59, 130, 246),
        Text = Color3.fromRGB(243, 244, 246),
        SubText = Color3.fromRGB(147, 197, 253),
        Border = Color3.fromRGB(41, 46, 75),
        ToggleOn = Color3.fromRGB(59, 130, 246),
        ToggleOff = Color3.fromRGB(22, 25, 41)
    },
    ["Azure"] = {
        Background = Color3.fromRGB(11, 21, 31),
        Sidebar = Color3.fromRGB(16, 31, 46),
        ElementBg = Color3.fromRGB(22, 43, 64),
        Accent = Color3.fromRGB(0, 140, 255),
        Text = Color3.fromRGB(240, 248, 255),
        SubText = Color3.fromRGB(135, 206, 250),
        Border = Color3.fromRGB(31, 60, 89),
        ToggleOn = Color3.fromRGB(0, 140, 255),
        ToggleOff = Color3.fromRGB(17, 33, 49)
    },
    ["Indigo"] = {
        Background = Color3.fromRGB(15, 15, 28),
        Sidebar = Color3.fromRGB(22, 22, 41),
        ElementBg = Color3.fromRGB(30, 30, 56),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(244, 245, 254),
        SubText = Color3.fromRGB(165, 180, 252),
        Border = Color3.fromRGB(42, 42, 78),
        ToggleOn = Color3.fromRGB(99, 102, 241),
        ToggleOff = Color3.fromRGB(23, 23, 43)
    },
    ["Violet"] = {
        Background = Color3.fromRGB(19, 14, 28),
        Sidebar = Color3.fromRGB(28, 21, 41),
        ElementBg = Color3.fromRGB(38, 29, 56),
        Accent = Color3.fromRGB(139, 92, 246),
        Text = Color3.fromRGB(245, 243, 255),
        SubText = Color3.fromRGB(196, 181, 253),
        Border = Color3.fromRGB(53, 41, 78),
        ToggleOn = Color3.fromRGB(139, 92, 246),
        ToggleOff = Color3.fromRGB(29, 22, 43)
    },
    ["Lavender"] = {
        Background = Color3.fromRGB(22, 18, 31),
        Sidebar = Color3.fromRGB(32, 26, 45),
        ElementBg = Color3.fromRGB(44, 36, 61),
        Accent = Color3.fromRGB(167, 139, 250),
        Text = Color3.fromRGB(245, 243, 255),
        SubText = Color3.fromRGB(196, 181, 253),
        Border = Color3.fromRGB(61, 50, 85),
        ToggleOn = Color3.fromRGB(167, 139, 250),
        ToggleOff = Color3.fromRGB(33, 27, 46)
    },
    ["Orchid"] = {
        Background = Color3.fromRGB(25, 14, 25),
        Sidebar = Color3.fromRGB(37, 21, 37),
        ElementBg = Color3.fromRGB(51, 29, 51),
        Accent = Color3.fromRGB(217, 70, 239),
        Text = Color3.fromRGB(253, 242, 253),
        SubText = Color3.fromRGB(240, 171, 252),
        Border = Color3.fromRGB(71, 40, 71),
        ToggleOn = Color3.fromRGB(217, 70, 239),
        ToggleOff = Color3.fromRGB(39, 22, 39)
    },
    ["Royal"] = {
        Background = Color3.fromRGB(13, 13, 31),
        Sidebar = Color3.fromRGB(19, 19, 46),
        ElementBg = Color3.fromRGB(26, 26, 63),
        Accent = Color3.fromRGB(67, 56, 202),
        Text = Color3.fromRGB(238, 242, 255),
        SubText = Color3.fromRGB(180, 198, 252),
        Border = Color3.fromRGB(36, 36, 88),
        ToggleOn = Color3.fromRGB(67, 56, 202),
        ToggleOff = Color3.fromRGB(19, 19, 45)
    },
    ["Amethyst"] = {
        Background = Color3.fromRGB(20, 12, 28),
        Sidebar = Color3.fromRGB(30, 18, 42),
        ElementBg = Color3.fromRGB(41, 25, 57),
        Accent = Color3.fromRGB(168, 85, 247),
        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(216, 180, 254),
        Border = Color3.fromRGB(57, 35, 80),
        ToggleOn = Color3.fromRGB(168, 85, 247),
        ToggleOff = Color3.fromRGB(31, 19, 43)
    },
    ["Cyber"] = {
        Background = Color3.fromRGB(10, 10, 15),
        Sidebar = Color3.fromRGB(16, 16, 24),
        ElementBg = Color3.fromRGB(22, 22, 33),
        Accent = Color3.fromRGB(0, 255, 170),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(0, 180, 255),
        Border = Color3.fromRGB(0, 120, 255),
        ToggleOn = Color3.fromRGB(0, 255, 170),
        ToggleOff = Color3.fromRGB(30, 30, 45)
    },
    ["Neon"] = {
        Background = Color3.fromRGB(12, 12, 12),
        Sidebar = Color3.fromRGB(18, 18, 18),
        ElementBg = Color3.fromRGB(24, 24, 24),
        Accent = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(163, 230, 53),
        Border = Color3.fromRGB(59, 130, 246),
        ToggleOn = Color3.fromRGB(239, 68, 68),
        ToggleOff = Color3.fromRGB(30, 30, 30)
    },
    ["Matrix"] = {
        Background = Color3.fromRGB(5, 12, 6),
        Sidebar = Color3.fromRGB(8, 18, 9),
        ElementBg = Color3.fromRGB(11, 25, 13),
        Accent = Color3.fromRGB(34, 197, 94),
        Text = Color3.fromRGB(220, 252, 231),
        SubText = Color3.fromRGB(74, 222, 128),
        Border = Color3.fromRGB(21, 48, 25),
        ToggleOn = Color3.fromRGB(34, 197, 94),
        ToggleOff = Color3.fromRGB(9, 20, 10)
    },
    ["Terminal"] = {
        Background = Color3.fromRGB(10, 12, 10),
        Sidebar = Color3.fromRGB(15, 18, 15),
        ElementBg = Color3.fromRGB(20, 24, 20),
        Accent = Color3.fromRGB(242, 252, 30),
        Text = Color3.fromRGB(240, 255, 240),
        SubText = Color3.fromRGB(140, 200, 140),
        Border = Color3.fromRGB(30, 45, 30),
        ToggleOn = Color3.fromRGB(242, 252, 30),
        ToggleOff = Color3.fromRGB(25, 30, 25)
    },
    ["Graphite"] = {
        Background = Color3.fromRGB(28, 28, 30),
        Sidebar = Color3.fromRGB(44, 44, 46),
        ElementBg = Color3.fromRGB(63, 63, 66),
        Accent = Color3.fromRGB(142, 142, 147),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(174, 174, 178),
        Border = Color3.fromRGB(72, 72, 74),
        ToggleOn = Color3.fromRGB(142, 142, 147),
        ToggleOff = Color3.fromRGB(48, 48, 50)
    },
    ["Steel"] = {
        Background = Color3.fromRGB(20, 24, 28),
        Sidebar = Color3.fromRGB(29, 35, 41),
        ElementBg = Color3.fromRGB(39, 47, 55),
        Accent = Color3.fromRGB(148, 163, 184),
        Text = Color3.fromRGB(241, 245, 249),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
        ToggleOn = Color3.fromRGB(148, 163, 184),
        ToggleOff = Color3.fromRGB(31, 38, 44)
    },
    ["Titanium"] = {
        Background = Color3.fromRGB(24, 26, 27),
        Sidebar = Color3.fromRGB(36, 39, 41),
        ElementBg = Color3.fromRGB(49, 53, 56),
        Accent = Color3.fromRGB(203, 213, 225),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(64, 69, 73),
        ToggleOn = Color3.fromRGB(203, 213, 225),
        ToggleOff = Color3.fromRGB(38, 41, 43)
    },
    ["Platinum"] = {
        Background = Color3.fromRGB(245, 245, 247),
        Sidebar = Color3.fromRGB(229, 229, 234),
        ElementBg = Color3.fromRGB(209, 209, 214),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(29, 29, 31),
        SubText = Color3.fromRGB(142, 142, 147),
        Border = Color3.fromRGB(199, 199, 204),
        ToggleOn = Color3.fromRGB(0, 122, 255),
        ToggleOff = Color3.fromRGB(180, 180, 185)
    },
    ["Sand"] = {
        Background = Color3.fromRGB(250, 247, 242),
        Sidebar = Color3.fromRGB(235, 228, 216),
        ElementBg = Color3.fromRGB(215, 204, 186),
        Accent = Color3.fromRGB(180, 140, 90),
        Text = Color3.fromRGB(60, 50, 40),
        SubText = Color3.fromRGB(130, 115, 95),
        Border = Color3.fromRGB(190, 175, 150),
        ToggleOn = Color3.fromRGB(180, 140, 90),
        ToggleOff = Color3.fromRGB(195, 185, 170)
    },
    ["Desert"] = {
        Background = Color3.fromRGB(28, 20, 14),
        Sidebar = Color3.fromRGB(41, 29, 20),
        ElementBg = Color3.fromRGB(56, 40, 27),
        Accent = Color3.fromRGB(245, 158, 11),
        Text = Color3.fromRGB(254, 243, 199),
        SubText = Color3.fromRGB(251, 191, 36),
        Border = Color3.fromRGB(78, 55, 38),
        ToggleOn = Color3.fromRGB(245, 158, 11),
        ToggleOff = Color3.fromRGB(43, 30, 21)
    },
    ["Mocha"] = {
        Background = Color3.fromRGB(21, 16, 14),
        Sidebar = Color3.fromRGB(31, 24, 21),
        ElementBg = Color3.fromRGB(42, 33, 29),
        Accent = Color3.fromRGB(180, 130, 100),
        Text = Color3.fromRGB(245, 240, 235),
        SubText = Color3.fromRGB(160, 140, 130),
        Border = Color3.fromRGB(58, 46, 40),
        ToggleOn = Color3.fromRGB(180, 130, 100),
        ToggleOff = Color3.fromRGB(32, 25, 22)
    },
    ["Coffee"] = {
        Background = Color3.fromRGB(15, 11, 9),
        Sidebar = Color3.fromRGB(24, 18, 15),
        ElementBg = Color3.fromRGB(34, 26, 22),
        Accent = Color3.fromRGB(214, 170, 131),
        Text = Color3.fromRGB(249, 246, 244),
        SubText = Color3.fromRGB(176, 150, 133),
        Border = Color3.fromRGB(48, 37, 31),
        ToggleOn = Color3.fromRGB(214, 170, 131),
        ToggleOff = Color3.fromRGB(26, 20, 17)
    },
    ["Chocolate"] = {
        Background = Color3.fromRGB(12, 8, 6),
        Sidebar = Color3.fromRGB(20, 13, 10),
        ElementBg = Color3.fromRGB(28, 18, 14),
        Accent = Color3.fromRGB(145, 90, 60),
        Text = Color3.fromRGB(250, 242, 238),
        SubText = Color3.fromRGB(175, 145, 130),
        Border = Color3.fromRGB(40, 26, 20),
        ToggleOn = Color3.fromRGB(145, 90, 60),
        ToggleOff = Color3.fromRGB(22, 14, 11)
    },
    ["Rose Gold"] = {
        Background = Color3.fromRGB(26, 18, 20),
        Sidebar = Color3.fromRGB(38, 26, 29),
        ElementBg = Color3.fromRGB(51, 35, 39),
        Accent = Color3.fromRGB(244, 172, 183),
        Text = Color3.fromRGB(255, 245, 247),
        SubText = Color3.fromRGB(224, 141, 156),
        Border = Color3.fromRGB(71, 49, 54),
        ToggleOn = Color3.fromRGB(244, 172, 183),
        ToggleOff = Color3.fromRGB(41, 28, 31)
    },
    ["Copper"] = {
        Background = Color3.fromRGB(22, 13, 10),
        Sidebar = Color3.fromRGB(33, 19, 15),
        ElementBg = Color3.fromRGB(46, 26, 21),
        Accent = Color3.fromRGB(230, 110, 75),
        Text = Color3.fromRGB(255, 243, 240),
        SubText = Color3.fromRGB(220, 160, 140),
        Border = Color3.fromRGB(64, 36, 29),
        ToggleOn = Color3.fromRGB(230, 110, 75),
        ToggleOff = Color3.fromRGB(35, 20, 16)
    },
    ["Pearl"] = {
        Background = Color3.fromRGB(248, 249, 250),
        Sidebar = Color3.fromRGB(233, 236, 239),
        ElementBg = Color3.fromRGB(218, 224, 230),
        Accent = Color3.fromRGB(200, 180, 195),
        Text = Color3.fromRGB(33, 37, 41),
        SubText = Color3.fromRGB(108, 117, 125),
        Border = Color3.fromRGB(173, 181, 189),
        ToggleOn = Color3.fromRGB(200, 180, 195),
        ToggleOff = Color3.fromRGB(195, 200, 205)
    },
    ["Ivory"] = {
        Background = Color3.fromRGB(254, 253, 250),
        Sidebar = Color3.fromRGB(245, 242, 232),
        ElementBg = Color3.fromRGB(232, 227, 211),
        Accent = Color3.fromRGB(175, 160, 120),
        Text = Color3.fromRGB(50, 48, 42),
        SubText = Color3.fromRGB(120, 115, 95),
        Border = Color3.fromRGB(204, 197, 175),
        ToggleOn = Color3.fromRGB(175, 160, 120),
        ToggleOff = Color3.fromRGB(215, 210, 195)
    },
    ["Snow"] = {
        Background = Color3.fromRGB(255, 255, 255),
        Sidebar = Color3.fromRGB(240, 244, 248),
        ElementBg = Color3.fromRGB(225, 232, 240),
        Accent = Color3.fromRGB(100, 150, 200),
        Text = Color3.fromRGB(30, 41, 59),
        SubText = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(200, 210, 220),
        ToggleOn = Color3.fromRGB(100, 150, 200),
        ToggleOff = Color3.fromRGB(210, 215, 220)
    },
    ["Mint"] = {
        Background = Color3.fromRGB(12, 24, 21),
        Sidebar = Color3.fromRGB(18, 36, 31),
        ElementBg = Color3.fromRGB(25, 49, 42),
        Accent = Color3.fromRGB(52, 211, 153),
        Text = Color3.fromRGB(236, 253, 245),
        SubText = Color3.fromRGB(110, 231, 183),
        Border = Color3.fromRGB(35, 68, 58),
        ToggleOn = Color3.fromRGB(52, 211, 153),
        ToggleOff = Color3.fromRGB(19, 37, 32)
    },
    ["Aqua"] = {
        Background = Color3.fromRGB(8, 20, 24),
        Sidebar = Color3.fromRGB(12, 30, 36),
        ElementBg = Color3.fromRGB(17, 42, 51),
        Accent = Color3.fromRGB(45, 212, 191),
        Text = Color3.fromRGB(240, 253, 250),
        SubText = Color3.fromRGB(94, 234, 212),
        Border = Color3.fromRGB(24, 60, 73),
        ToggleOn = Color3.fromRGB(45, 212, 191),
        ToggleOff = Color3.fromRGB(13, 31, 38)
    },
    ["Deep Sea"] = {
        Background = Color3.fromRGB(8, 14, 24),
        Sidebar = Color3.fromRGB(12, 21, 36),
        ElementBg = Color3.fromRGB(17, 29, 50),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(240, 249, 255),
        SubText = Color3.fromRGB(125, 211, 252),
        Border = Color3.fromRGB(24, 41, 71),
        ToggleOn = Color3.fromRGB(14, 165, 233),
        ToggleOff = Color3.fromRGB(13, 22, 38)
    },
    ["Storm"] = {
        Background = Color3.fromRGB(14, 18, 24),
        Sidebar = Color3.fromRGB(21, 27, 36),
        ElementBg = Color3.fromRGB(29, 37, 50),
        Accent = Color3.fromRGB(96, 165, 250),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(41, 52, 71),
        ToggleOn = Color3.fromRGB(96, 165, 250),
        ToggleOff = Color3.fromRGB(22, 28, 38)
    },
    ["Thunder"] = {
        Background = Color3.fromRGB(14, 12, 20),
        Sidebar = Color3.fromRGB(21, 18, 30),
        ElementBg = Color3.fromRGB(29, 25, 41),
        Accent = Color3.fromRGB(234, 179, 8),
        Text = Color3.fromRGB(254, 252, 242),
        SubText = Color3.fromRGB(216, 180, 254),
        Border = Color3.fromRGB(41, 35, 58),
        ToggleOn = Color3.fromRGB(234, 179, 8),
        ToggleOff = Color3.fromRGB(22, 19, 31)
    },
    ["Phantom"] = {
        Background = Color3.fromRGB(12, 10, 16),
        Sidebar = Color3.fromRGB(19, 16, 26),
        ElementBg = Color3.fromRGB(27, 23, 37),
        Accent = Color3.fromRGB(168, 85, 247),
        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(140, 120, 160),
        Border = Color3.fromRGB(40, 34, 55),
        ToggleOn = Color3.fromRGB(168, 85, 247),
        ToggleOff = Color3.fromRGB(20, 17, 28)
    }
}

local CurrentThemeName = "Midnight"
local CurrentTheme = Themes[CurrentThemeName]
local CurrentTransparency = 0
local CurrentLanguage = "EN"

local InstancesToTheme = {}
local TogglesRegistry = {}
local DropdownsRegistry = {}
local LocaleRegistry = {}
local ActiveDropdown = nil
local NotifyHolder = nil
local GlobalScreenGui = nil

local MainFrameRef = nil
local SidebarRef = nil
local SidebarCoverRef = nil

local HttpService = game:GetService("HttpService")
local ConfigFolder = "FractureHub/UI/config"
local ConfigFile = ConfigFolder .. "/settings.json"
local ConfigData = {}
local ToggleProfile = {}

local function ApplyTheme(themeName)
    if not Themes[themeName] then return end
    CurrentThemeName = themeName
    CurrentTheme = Themes[themeName]
    
    for instance, properties in pairs(InstancesToTheme) do
        if instance and instance.Parent then
            local targetProps = {}
            for prop, key in pairs(properties) do
                if type(key) == "function" then
                    targetProps[prop] = key()
                else
                    targetProps[prop] = CurrentTheme[key]
                end
            end
            
            local overrideBgTransparency = nil
            if instance == MainFrameRef or instance == SidebarRef or instance == SidebarCoverRef then
                overrideBgTransparency = CurrentTransparency
            end
            
            local tweenProps = {
                TextColor3 = targetProps.TextColor3, 
                BackgroundColor3 = targetProps.BackgroundColor3, 
                Color = targetProps.Color,
                ImageColor3 = targetProps.ImageColor3
            }
            if overrideBgTransparency then
                tweenProps.BackgroundTransparency = overrideBgTransparency
            end

            TweenService:Create(instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tweenProps):Play()
        else
            InstancesToTheme[instance] = nil
        end
    end

    for switchFrame, info in pairs(TogglesRegistry) do
        if switchFrame and switchFrame.Parent then
            local targetColor = info.GetToggled() and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff
            TweenService:Create(switchFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
            
            local thumb = switchFrame:FindFirstChild("Thumb")
            if thumb then
                TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = info.GetToggled() and Color3.fromRGB(255, 255, 255) or CurrentTheme.SubText
                }):Play()
            end
        else
            TogglesRegistry[switchFrame] = nil
        end
    end

    for menu, _ in pairs(DropdownsRegistry) do
        if menu and menu.Parent then
            menu.BackgroundColor3 = CurrentTheme.ElementBg
            local stroke = menu:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = CurrentTheme.Border end
        else
            DropdownsRegistry[menu] = nil
        end
    end
end

local function ApplyTransparency(transparencyValue)
    CurrentTransparency = transparencyValue
    if MainFrameRef then
        TweenService:Create(MainFrameRef, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = transparencyValue}):Play()
    end
    if SidebarRef then
        TweenService:Create(SidebarRef, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = transparencyValue}):Play()
    end
    if SidebarCoverRef then
        TweenService:Create(SidebarCoverRef, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = transparencyValue}):Play()
    end
end

local function RegisterElement(instance, property, themeKey)
    if not InstancesToTheme[instance] then
        InstancesToTheme[instance] = {}
    end
    InstancesToTheme[instance][property] = themeKey
    
    if type(themeKey) == "function" then
        instance[property] = themeKey()
    else
        instance[property] = CurrentTheme[themeKey]
    end
end

local function ApplyFont(fontName)
    if not Fonts[fontName] then return end
    CurrentFontName = fontName
    CurrentFontFamily = Fonts[fontName]

    for instance, weight in pairs(FontRegistry) do
        if instance and instance.Parent then
            instance.Font = CurrentFontFamily[weight] or CurrentFontFamily.Regular
        else
            FontRegistry[instance] = nil
        end
    end
end

function Library:AddTranslation(key, translations)
    Library.Translations[key] = translations
end

local function RegisterLocale(instance, key, isUpper)
    LocaleRegistry[instance] = {Key = key, Upper = isUpper}

    local entry = Library.Translations[key]
    local text = (entry and entry[CurrentLanguage]) or key
    instance.Text = isUpper and text:upper() or text
end

local function ApplyLanguage(langCode)
    CurrentLanguage = langCode

    for instance, data in pairs(LocaleRegistry) do
        if instance and instance.Parent then
            local entry = Library.Translations[data.Key]
            local text = (entry and entry[langCode]) or data.Key
            instance.Text = data.Upper and text:upper() or text
        else
            LocaleRegistry[instance] = nil
        end
    end
end

local function EnsureConfigFolder()
    pcall(function()
        if not isfolder("FractureHub") then makefolder("FractureHub") end
        if not isfolder("FractureHub/UI") then makefolder("FractureHub/UI") end
        if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    end)
end

local function LoadConfig()
    EnsureConfigFolder()
    local success, result = pcall(function()
        if isfile and isfile(ConfigFile) then
            return HttpService:JSONDecode(readfile(ConfigFile))
        end
        return nil
    end)

    if success and type(result) == "table" then
        ConfigData = result
        if type(result.Toggles) == "table" then
            ToggleProfile = result.Toggles
        end
    end
end

local function SaveConfig()
    ConfigData.Toggles = ToggleProfile
    pcall(function()
        EnsureConfigFolder()
        writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
    end)
end

LoadConfig()

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function CreateNotifyHolder(screenGui)
    if NotifyHolder then return end
    NotifyHolder = Instance.new("Frame")
    NotifyHolder.Name = "NotificationHolder"
    NotifyHolder.Size = UDim2.new(0, 300, 1, -20)
    NotifyHolder.Position = UDim2.new(1, -310, 0, 10)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.ZIndex = 99999
    NotifyHolder.Parent = screenGui

    local Layout = Instance.new("UIListLayout")
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = NotifyHolder
end

function Library:Notify(options)
    local title = options.Title or "Notification"
    local desc = options.Content or "Description"
    local icon = options.Image or "rbxassetid://10734952479"
    local duration = options.Duration or 5

    if not NotifyHolder then return end

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 280, 0, 68)
    Box.BackgroundTransparency = 0.05
    Box.Position = UDim2.new(1.5, 0, 0, 0)
    Box.ZIndex = 100000
    Box.Parent = NotifyHolder
    RegisterElement(Box, "BackgroundColor3", "ElementBg")

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 10)
    BoxCorner.Parent = Box

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 1
    BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BoxStroke.Parent = Box
    RegisterElement(BoxStroke, "Color", "Border")

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 36, 0, 36)
    IconImg.Position = UDim2.new(0, 12, 0.5, -18)
    IconImg.BackgroundTransparency = 1
    IconImg.Image = icon
    IconImg.ZIndex = 100001
    IconImg.Parent = Box

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -70, 0, 18)
    TitleLbl.Position = UDim2.new(0, 58, 0, 12)
    TitleLbl.Text = title
    TitleLbl.TextSize = 13
    SetInterFont(TitleLbl, "Bold")
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.ZIndex = 100001
    TitleLbl.Parent = Box
    RegisterElement(TitleLbl, "TextColor3", "Text")

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(1, -70, 0, 26)
    DescLbl.Position = UDim2.new(0, 58, 0, 30)
    DescLbl.Text = desc
    DescLbl.TextSize = 11
    SetInterFont(DescLbl, "Regular")
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.TextWrapped = true
    DescLbl.BackgroundTransparency = 1
    DescLbl.ZIndex = 100001
    DescLbl.Parent = Box
    RegisterElement(DescLbl, "TextColor3", "SubText")

    TweenService:Create(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(duration, function()
        if Box and Box.Parent then
            local fadeOut = TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0)})
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                Box:Destroy()
            end)
        end
    end)
end

function Library:CreateWindow(config)
    local titleText = config.Title or "Fracture Hub"
    local rawSize = config.Size or UDim2.fromOffset(580, 420)
    local minimizeKey = (ConfigData.MinimizeKey and Enum.KeyCode[ConfigData.MinimizeKey]) or config.MinimizeKey or Enum.KeyCode.LeftControl
    local subtitle = config.SubTitle or ""
    local titleLink = config.TitleLink or ""
    local themeDefault = ConfigData.Theme or config.Theme or "Midnight"
    local fontDefault = ConfigData.Font or "Gotham"
    local languageDefault = ConfigData.Language or "EN"
    local profileLook = config.Look ~= false

    local viewportSize = CurrentCamera.ViewportSize
    local safeWidth = math.min(rawSize.X.Offset, viewportSize.X - 20)
    local safeHeight = math.min(rawSize.Y.Offset, viewportSize.Y - 20)
    local size = UDim2.fromOffset(safeWidth, safeHeight)

    local OldUI = PlayerGui:FindFirstChild("FracturePremiumLib")
    if OldUI then OldUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FracturePremiumLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = PlayerGui
    GlobalScreenGui = ScreenGui

    CreateNotifyHolder(ScreenGui)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ZIndex = 10
    MainFrame.Parent = ScreenGui
    RegisterElement(MainFrame, "BackgroundColor3", "Background")
    MainFrameRef = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    RegisterElement(MainStroke, "Color", "Border")

    MakeDraggable(MainFrame)

    local sidebarWidth = math.min(config.TabWidth or 160, safeWidth * 0.35)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, sidebarWidth, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 11
    Sidebar.Parent = MainFrame
    RegisterElement(Sidebar, "BackgroundColor3", "Sidebar")
    SidebarRef = Sidebar

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 20, 1, 0)
    SidebarCover.Position = UDim2.new(1, -20, 0, 0)
    SidebarCover.BorderSizePixel = 0
    SidebarCover.ZIndex = 11
    SidebarCover.Parent = Sidebar
    RegisterElement(SidebarCover, "BackgroundColor3", "Sidebar")
    SidebarCoverRef = SidebarCover

    local ProfileCard = Instance.new("Frame")
    ProfileCard.Name = "ProfileCard"
    ProfileCard.Size = UDim2.new(1, -20, 0, 52)
    ProfileCard.Position = UDim2.new(0, 10, 0, 12)
    ProfileCard.BackgroundTransparency = 0.5
    ProfileCard.ZIndex = 12
    ProfileCard.Parent = Sidebar
    RegisterElement(ProfileCard, "BackgroundColor3", "ElementBg")

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 8)
    ProfileCorner.Parent = ProfileCard

    local ProfileStroke = Instance.new("UIStroke")
    ProfileStroke.Thickness = 1
    ProfileStroke.Parent = ProfileCard
    RegisterElement(ProfileStroke, "Color", "Border")

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Name = "Avatar"
    AvatarImg.Size = UDim2.new(0, 32, 0, 32)
    AvatarImg.Position = UDim2.new(0, 8, 0.5, -16)
    AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.ZIndex = 13
    AvatarImg.Parent = ProfileCard

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = AvatarImg

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "PlayerName"
    NameLabel.Size = UDim2.new(1, -52, 0, 16)
    NameLabel.Position = UDim2.new(0, 46, 0, 10)
    NameLabel.Text = LocalPlayer.Name
    NameLabel.TextSize = 12
    SetInterFont(NameLabel, "Bold")
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.BackgroundTransparency = 1
    NameLabel.ZIndex = 13
    NameLabel.Parent = ProfileCard
    RegisterElement(NameLabel, "TextColor3", "Text")

    local DisplayLabel = Instance.new("TextLabel")
    DisplayLabel.Name = "DisplayName"
    DisplayLabel.Size = UDim2.new(1, -52, 0, 12)
    DisplayLabel.Position = UDim2.new(0, 46, 0, 26)
    DisplayLabel.Text = "@" .. LocalPlayer.DisplayName
    DisplayLabel.TextSize = 9
    SetInterFont(DisplayLabel, "Medium")
    DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayLabel.BackgroundTransparency = 1
    DisplayLabel.ZIndex = 13
    DisplayLabel.Parent = ProfileCard
    RegisterElement(DisplayLabel, "TextColor3", "SubText")

    local EyeToggleBtn = Instance.new("TextButton")
    EyeToggleBtn.Size = UDim2.new(0, 20, 0, 20)
    EyeToggleBtn.Position = UDim2.new(1, -22, 0, 4)
    EyeToggleBtn.BackgroundTransparency = 1
    EyeToggleBtn.Text = profileLook and "👁" or "🙈"
    EyeToggleBtn.TextSize = 12
    EyeToggleBtn.ZIndex = 14
    EyeToggleBtn.Parent = ProfileCard
    RegisterElement(EyeToggleBtn, "TextColor3", "SubText")

    local function updateProfileLook()
        if profileLook then
            NameLabel.Text = LocalPlayer.Name
            DisplayLabel.Text = "@" .. LocalPlayer.DisplayName
            EyeToggleBtn.Text = "👁"
        else
            NameLabel.Text = string.rep("*", string.len(LocalPlayer.Name))
            DisplayLabel.Text = "@" .. string.rep("*", 8)
            EyeToggleBtn.Text = "🙈"
        end
    end
    updateProfileLook()

    EyeToggleBtn.MouseButton1Click:Connect(function()
        profileLook = not profileLook
        updateProfileLook()
    end)

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Name = "NavScroll"
    NavScroll.Size = UDim2.new(1, -12, 1, -135)
    NavScroll.Position = UDim2.new(0, 6, 0, 74)
    NavScroll.BackgroundTransparency = 1
    NavScroll.BorderSizePixel = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.ScrollBarThickness = 0
    NavScroll.ZIndex = 12
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 6)
    NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    local LinkPanel = Instance.new("Frame")
    LinkPanel.Name = "LinkPanel"
    LinkPanel.Size = UDim2.new(1, -16, 0, 40)
    LinkPanel.Position = UDim2.new(0, 8, 1, -48)
    LinkPanel.BackgroundTransparency = 1
    LinkPanel.ZIndex = 12
    LinkPanel.Parent = Sidebar

    local LinkLayout = Instance.new("UIListLayout")
    LinkLayout.FillDirection = Enum.FillDirection.Horizontal
    LinkLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LinkLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LinkLayout.Padding = UDim.new(0, 8)
    LinkLayout.Parent = LinkPanel

    if titleLink ~= "" then
        local DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Name = "DiscordBtn"
        DiscordBtn.Size = UDim2.new(1, 0, 0, 28)
        DiscordBtn.Text = "Join Discord 🔗"
        DiscordBtn.TextSize = 10
        SetInterFont(DiscordBtn, "Bold")
        DiscordBtn.AutoButtonColor = false
        DiscordBtn.ZIndex = 13
        DiscordBtn.Parent = LinkPanel
        RegisterElement(DiscordBtn, "BackgroundColor3", "ElementBg")
        RegisterElement(DiscordBtn, "TextColor3", "SubText")

        local DiscordCorner = Instance.new("UICorner")
        DiscordCorner.CornerRadius = UDim.new(0, 6)
        DiscordCorner.Parent = DiscordBtn

        local DiscordStroke = Instance.new("UIStroke")
        DiscordStroke.Thickness = 1
        DiscordStroke.Parent = DiscordBtn
        RegisterElement(DiscordStroke, "Color", "Border")

        DiscordBtn.MouseEnter:Connect(function()
            TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.Accent}):Play()
        end)
        DiscordBtn.MouseLeave:Connect(function()
            TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.SubText}):Play()
        end)

        DiscordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(titleLink)
            elseif toclipboard then
                toclipboard(titleLink)
            end
            Library:Notify({
                Title = "Copied link!",
                Content = "Discord link copied to clipboard successfully.",
                Image = "rbxassetid://10734952479",
                Duration = 3
            })
        end)
    end

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -sidebarWidth, 0, 56)
    Header.Position = UDim2.new(0, sidebarWidth, 0, 0)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 11
    Header.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -120, 0, 24)
    Title.Position = UDim2.new(0, 20, 0, 6)
    Title.Text = titleText
    Title.TextSize = 16
    SetInterFont(Title, "Bold")
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.ZIndex = 12
    Title.Parent = Header
    RegisterElement(Title, "TextColor3", "Text")

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(1, -120, 0, 14)
    SubTitle.Position = UDim2.new(0, 20, 0, 26)
    SubTitle.Text = subtitle ~= "" and subtitle or "Universal Script System"
    SubTitle.TextSize = 11
    SetInterFont(SubTitle, "Medium")
    SubTitle.TextTruncate = Enum.TextTruncate.AtEnd
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.BackgroundTransparency = 1
    SubTitle.ZIndex = 12
    SubTitle.Parent = Header
    RegisterElement(SubTitle, "TextColor3", "SubText")

    local StatsLabel = Instance.new("TextLabel")
    StatsLabel.Name = "StatsLabel"
    StatsLabel.Size = UDim2.new(1, -120, 0, 14)
    StatsLabel.Position = UDim2.new(0, 20, 0, 40)
    StatsLabel.Text = "FPS: Calculating... | PING: -- ms"
    StatsLabel.TextSize = 10
    SetInterFont(StatsLabel, "Bold")
    StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.ZIndex = 12
    StatsLabel.Parent = Header
    RegisterElement(StatsLabel, "TextColor3", "Accent")

    task.spawn(function()
        local lastUpdate = os.clock()
        local fpsAccumulator = 0
        local frameCount = 0
        
        local runServiceConnection
        runServiceConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if not StatsLabel or not StatsLabel.Parent then
                runServiceConnection:Disconnect()
                return
            end
            
            frameCount = frameCount + 1
            fpsAccumulator = fpsAccumulator + (1 / dt)
            
            local now = os.clock()
            if now - lastUpdate >= 0.3 then
                local averageFps = math.round(fpsAccumulator / frameCount)
                
                local ping = 0
                pcall(function()
                    ping = math.round(Stats:GetNetworkMetricResult(Enum.NetworkMetricType.Ping, Enum.NetworkMetricDataType.Average))
                end)
                if ping <= 0 then
                    pcall(function() ping = math.round(LocalPlayer:GetNetworkPing() * 1000) end)
                end
                
                StatsLabel.Text = string.format("FPS: %d | PING: %d ms", math.clamp(averageFps, 1, 999), ping)
                
                fpsAccumulator = 0
                frameCount = 0
                lastUpdate = now
            end
        end)
    end)

    local CloseConfirmFrame = Instance.new("Frame")
    CloseConfirmFrame.Name = "CloseConfirmFrame"
    CloseConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
    CloseConfirmFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseConfirmFrame.BackgroundTransparency = 0.5
    CloseConfirmFrame.Active = true
    CloseConfirmFrame.Visible = false
    CloseConfirmFrame.ZIndex = 1000100
    CloseConfirmFrame.Parent = GlobalScreenGui

    local ConfirmBox = Instance.new("Frame")
    ConfirmBox.Size = UDim2.new(0, 260, 0, 120)
    ConfirmBox.Position = UDim2.new(0.5, -130, 0.5, -60)
    ConfirmBox.ZIndex = 1000101
    ConfirmBox.Parent = CloseConfirmFrame
    RegisterElement(ConfirmBox, "BackgroundColor3", "ElementBg")

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 10)
    ConfirmCorner.Parent = ConfirmBox

    local ConfirmStroke = Instance.new("UIStroke")
    ConfirmStroke.Thickness = 1
    ConfirmStroke.Parent = ConfirmBox
    RegisterElement(ConfirmStroke, "Color", "Border")

    local ConfirmTitle = Instance.new("TextLabel")
    ConfirmTitle.Size = UDim2.new(1, 0, 0, 40)
    ConfirmTitle.Position = UDim2.new(0, 0, 0, 15)
    ConfirmTitle.Text = "Are you sure you want to close?"
    ConfirmTitle.TextSize = 13
    SetInterFont(ConfirmTitle, "Bold")
    ConfirmTitle.BackgroundTransparency = 1
    ConfirmTitle.ZIndex = 1000102
    ConfirmTitle.Parent = ConfirmBox
    RegisterElement(ConfirmTitle, "TextColor3", "Text")

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0, 105, 0, 32)
    YesBtn.Position = UDim2.new(0, 15, 0, 70)
    YesBtn.Text = "Confirm"
    YesBtn.TextSize = 12
    SetInterFont(YesBtn, "Bold")
    YesBtn.AutoButtonColor = false
    YesBtn.ZIndex = 1000102
    YesBtn.Parent = ConfirmBox
    RegisterElement(YesBtn, "BackgroundColor3", "Accent")
    YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 6)
    YesCorner.Parent = YesBtn

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0, 105, 0, 32)
    NoBtn.Position = UDim2.new(1, -120, 0, 70)
    NoBtn.Text = "Cancel"
    NoBtn.TextSize = 12
    SetInterFont(NoBtn, "Bold")
    NoBtn.AutoButtonColor = false
    NoBtn.ZIndex = 1000102
    NoBtn.Parent = ConfirmBox
    RegisterElement(NoBtn, "BackgroundColor3", "Background")
    RegisterElement(NoBtn, "TextColor3", "Text")

    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 6)
    NoCorner.Parent = NoBtn
    
    local NoStroke = Instance.new("UIStroke")
    NoStroke.Thickness = 1
    NoStroke.Parent = NoBtn
    RegisterElement(NoStroke, "Color", "Border")

    YesBtn.MouseButton1Click:Connect(function()
        GlobalScreenGui:Destroy()
    end)

    NoBtn.MouseButton1Click:Connect(function()
        CloseConfirmFrame.Visible = false
    end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -38, 0, 15)
    CloseBtn.Text = "❌"
    CloseBtn.TextSize = 12
    SetInterFont(CloseBtn, "Bold")
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 12
    CloseBtn.Parent = Header
    RegisterElement(CloseBtn, "BackgroundColor3", "ElementBg")
    RegisterElement(CloseBtn, "TextColor3", "SubText")
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Thickness = 1
    CloseStroke.Parent = CloseBtn
    RegisterElement(CloseStroke, "Color", "Border")

    CloseBtn.MouseButton1Click:Connect(function()
        CloseConfirmFrame.Visible = true
    end)

    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "MaximizeBtn"
    MaximizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MaximizeBtn.Position = UDim2.new(1, -68, 0, 15)
    MaximizeBtn.Text = "➕"
    MaximizeBtn.TextSize = 14
    SetInterFont(MaximizeBtn, "Bold")
    MaximizeBtn.AutoButtonColor = false
    MaximizeBtn.ZIndex = 12
    MaximizeBtn.Parent = Header
    RegisterElement(MaximizeBtn, "BackgroundColor3", "ElementBg")
    RegisterElement(MaximizeBtn, "TextColor3", "SubText")
    local MaxCorner = Instance.new("UICorner")
    MaxCorner.CornerRadius = UDim.new(0, 6)
    MaxCorner.Parent = MaximizeBtn
    local MaxStroke = Instance.new("UIStroke")
    MaxStroke.Thickness = 1
    MaxStroke.Parent = MaximizeBtn
    RegisterElement(MaxStroke, "Color", "Border")

    local isMaximized = false
    local previousSize = MainFrame.Size
    local previousPosition = MainFrame.Position

    MaximizeBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        if isMaximized then
            previousSize = MainFrame.Size
            previousPosition = MainFrame.Position
            local screenVP = CurrentCamera.ViewportSize
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(screenVP.X - 40, screenVP.Y - 40),
                Position = UDim2.new(0, 20, 0, 20)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = previousSize,
                Position = previousPosition
            }):Play()
        end
    end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -98, 0, 15)
    MinimizeBtn.Text = "➖"
    MinimizeBtn.TextSize = 12
    SetInterFont(MinimizeBtn, "Bold")
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.ZIndex = 12
    MinimizeBtn.Parent = Header
    RegisterElement(MinimizeBtn, "BackgroundColor3", "ElementBg")
    RegisterElement(MinimizeBtn, "TextColor3", "SubText")
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn
    local MinStroke = Instance.new("UIStroke")
    MinStroke.Thickness = 1
    MinStroke.Parent = MinimizeBtn
    RegisterElement(MinStroke, "Color", "Border")

    if PlayerGui:FindFirstChild("FractureScreenGui") then
        PlayerGui.FractureScreenGui:Destroy()
    end

    local FractureScreenGui = Instance.new("ScreenGui")
    FractureScreenGui.Name = "FractureScreenGui"
    FractureScreenGui.ResetOnSpawn = false
    FractureScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FractureScreenGui.DisplayOrder = 101
    FractureScreenGui.Enabled = true
    FractureScreenGui.Parent = PlayerGui

    local FloatingFrame = Instance.new("Frame")
    FloatingFrame.Name = "FractureFrame"
    FloatingFrame.Size = UDim2.fromOffset(55, 55)
    FloatingFrame.Position = UDim2.new(0.5, 0, 0.12, 0)
    FloatingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatingFrame.BackgroundTransparency = 1
    FloatingFrame.Parent = FractureScreenGui

    local FloatingButton = Instance.new("ImageButton")
    FloatingButton.Name = "FractureButton"
    FloatingButton.Size = UDim2.fromOffset(55, 55)
    FloatingButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatingButton.Image = "rbxassetid://83542549106889"
    FloatingButton.ScaleType = Enum.ScaleType.Fit
    FloatingButton.AutoButtonColor = false
    FloatingButton.ZIndex = 1
    FloatingButton.Parent = FloatingFrame
    
    RegisterElement(FloatingButton, "BackgroundColor3", "ElementBg")
    RegisterElement(FloatingButton, "ImageColor3", "Text")

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 16)
    ButtonCorner.Parent = FloatingButton

    local buttonTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    FloatingButton.MouseEnter:Connect(function()
        TweenService:Create(FloatingButton, buttonTweenInfo, {Size = UDim2.fromOffset(60, 60)}):Play()
    end)
    FloatingButton.MouseLeave:Connect(function()
        TweenService:Create(FloatingButton, buttonTweenInfo, {Size = UDim2.fromOffset(55, 55)}):Play()
    end)
    FloatingButton.MouseButton1Down:Connect(function()
        TweenService:Create(FloatingButton, buttonTweenInfo, {Size = UDim2.fromOffset(50, 50)}):Play()
    end)
    FloatingButton.MouseButton1Up:Connect(function()
        TweenService:Create(FloatingButton, buttonTweenInfo, {Size = UDim2.fromOffset(60, 60)}):Play()
    end)
    local isDragging = false
    local currentInput, startInputPos, startFramePos
    local dragThresholdExceeded = false
    FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            currentInput = input
            startInputPos = input.Position
            startFramePos = FloatingFrame.Position
            dragThresholdExceeded = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input == currentInput then
            local delta = input.Position - startInputPos
            if delta.Magnitude > 6 then 
                dragThresholdExceeded = true 
            end
            FloatingFrame.Position = UDim2.new(
                startFramePos.X.Scale, 
                startFramePos.X.Offset + delta.X, 
                startFramePos.Y.Scale, 
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == currentInput then 
            isDragging = false 
        end
    end)

    local function ToggleUI()
        local willMinimize = MainFrame.Visible
        MainFrame.Visible = not willMinimize
    end

    FloatingButton.MouseButton1Click:Connect(function()
        if not dragThresholdExceeded then
            ToggleUI()
        end
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        ToggleUI()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == minimizeKey then
            ToggleUI()
        end
    end)

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -sidebarWidth - 20, 1, -76)
    Container.Position = UDim2.new(0, sidebarWidth + 10, 0, 64)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 11
    Container.Parent = MainFrame

    local ColorPickerPopup = Instance.new("Frame")
    ColorPickerPopup.Size = UDim2.new(0, 280, 0, 310)
    ColorPickerPopup.Position = UDim2.new(0.5, -140, 0.5, -155)
    ColorPickerPopup.ZIndex = 1000050
    ColorPickerPopup.Visible = false
    ColorPickerPopup.Parent = GlobalScreenGui
    RegisterElement(ColorPickerPopup, "BackgroundColor3", "ElementBg")
    local CPCorner = Instance.new("UICorner")
    CPCorner.CornerRadius = UDim.new(0, 10)
    CPCorner.Parent = ColorPickerPopup
    local CPStroke = Instance.new("UIStroke")
    CPStroke.Thickness = 1
    CPStroke.Parent = ColorPickerPopup
    RegisterElement(CPStroke, "Color", "Border")
    MakeDraggable(ColorPickerPopup)

    local CPTitle = Instance.new("TextLabel")
    CPTitle.Size = UDim2.new(1, -30, 0, 30)
    CPTitle.Position = UDim2.new(0, 15, 0, 5)
    CPTitle.Text = "Colorpicker 3"
    CPTitle.TextSize = 14
    SetInterFont(CPTitle, "Bold")
    CPTitle.TextXAlignment = Enum.TextXAlignment.Left
    CPTitle.BackgroundTransparency = 1
    CPTitle.ZIndex = 1000051
    CPTitle.Parent = ColorPickerPopup
    RegisterElement(CPTitle, "TextColor3", "Text")

    local ColorMap = Instance.new("ImageLabel")
    ColorMap.Size = UDim2.new(0, 140, 0, 140)
    ColorMap.Position = UDim2.new(0, 15, 0, 40)
    ColorMap.Image = "rbxassetid://4155801252"
    ColorMap.ZIndex = 1000051
    ColorMap.Active = true
    ColorMap.Parent = ColorPickerPopup
    local ColorMapCorner = Instance.new("UICorner")
    ColorMapCorner.CornerRadius = UDim.new(0, 6)
    ColorMapCorner.Parent = ColorMap

    local ColorMapCursor = Instance.new("Frame")
    ColorMapCursor.Size = UDim2.new(0, 10, 0, 10)
    ColorMapCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ColorMapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    ColorMapCursor.ZIndex = 1000052
    ColorMapCursor.Parent = ColorMap
    local ColorMapCursorCorner = Instance.new("UICorner")
    ColorMapCursorCorner.CornerRadius = UDim.new(1, 0)
    ColorMapCursorCorner.Parent = ColorMapCursor
    local ColorMapCursorStroke = Instance.new("UIStroke")
    ColorMapCursorStroke.Thickness = 2
    ColorMapCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    ColorMapCursorStroke.Parent = ColorMapCursor

    local HueSlider = Instance.new("Frame")
    HueSlider.Size = UDim2.new(0, 12, 0, 140)
    HueSlider.Position = UDim2.new(0, 165, 0, 40)
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.ZIndex = 1000051
    HueSlider.Active = true
    HueSlider.Parent = ColorPickerPopup
    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(0, 6)
    HueCorner.Parent = HueSlider
    local HueGradient = Instance.new("UIGradient")
    HueGradient.Rotation = 90
    HueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    HueGradient.Parent = HueSlider

    local HueCursor = Instance.new("Frame")
    HueCursor.Size = UDim2.new(0, 16, 0, 16)
    HueCursor.Position = UDim2.new(0.5, 0, 0, 0)
    HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueCursor.ZIndex = 1000052
    HueCursor.Parent = HueSlider
    local HueCursorCorner = Instance.new("UICorner")
    HueCursorCorner.CornerRadius = UDim.new(1, 0)
    HueCursorCorner.Parent = HueCursor
    local HueCursorStroke = Instance.new("UIStroke")
    HueCursorStroke.Thickness = 2
    HueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    HueCursorStroke.Parent = HueCursor

    local InputsFrame = Instance.new("Frame")
    InputsFrame.Size = UDim2.new(0, 80, 0, 140)
    InputsFrame.Position = UDim2.new(0, 185, 0, 40)
    InputsFrame.BackgroundTransparency = 1
    InputsFrame.ZIndex = 1000051
    InputsFrame.Parent = ColorPickerPopup
    local InputsLayout = Instance.new("UIListLayout")
    InputsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InputsLayout.Padding = UDim.new(0, 8)
    InputsLayout.Parent = InputsFrame

    local CPValHex, CPValR, CPValG, CPValB
    local function makeCPInput(labelTxt, yPos)
        local frm = Instance.new("Frame")
        frm.Size = UDim2.new(1, 0, 0, 26)
        frm.BackgroundTransparency = 1
        frm.Parent = InputsFrame
        frm.ZIndex = 1000051
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.6, 0, 1, 0)
        box.Position = UDim2.new(0, 0, 0, 0)
        box.Text = ""
        box.TextSize = 11
        SetInterFont(box, "Medium")
        box.ClearTextOnFocus = false
        box.ZIndex = 1000052
        box.Parent = frm
        RegisterElement(box, "BackgroundColor3", "Background")
        RegisterElement(box, "TextColor3", "Text")
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = box
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 1
        bStroke.Parent = box
        RegisterElement(bStroke, "Color", "Border")
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.35, 0, 1, 0)
        lbl.Position = UDim2.new(0.65, 0, 0, 0)
        lbl.Text = labelTxt
        lbl.TextSize = 10
        SetInterFont(lbl, "Regular")
        lbl.TextXAlignment = Enum.TextXAlignment.Right
        lbl.BackgroundTransparency = 1
        lbl.ZIndex = 1000052
        lbl.Parent = frm
        RegisterElement(lbl, "TextColor3", "SubText")
        return box
    end
    CPValHex = makeCPInput("Hex", 0)
    CPValR = makeCPInput("Red", 34)
    CPValG = makeCPInput("Green", 68)
    CPValB = makeCPInput("Blue", 102)

    local ColorPresets = Instance.new("ScrollingFrame")
    ColorPresets.Size = UDim2.new(1, -30, 0, 36)
    ColorPresets.Position = UDim2.new(0, 15, 0, 195)
    ColorPresets.BackgroundTransparency = 1
    ColorPresets.ScrollBarThickness = 2
    ColorPresets.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorPresets.ZIndex = 1000051
    ColorPresets.Parent = ColorPickerPopup
    RegisterElement(ColorPresets, "ScrollBarImageColor3", "Border")
    local PresetsLayout = Instance.new("UIListLayout")
    PresetsLayout.FillDirection = Enum.FillDirection.Horizontal
    PresetsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PresetsLayout.Padding = UDim.new(0, 6)
    PresetsLayout.Parent = ColorPresets

    local CPCancelBtn = Instance.new("TextButton")
    CPCancelBtn.Size = UDim2.new(0, 115, 0, 34)
    CPCancelBtn.Position = UDim2.new(0, 15, 0, 250)
    CPCancelBtn.Text = "Cancel"
    CPCancelBtn.TextSize = 12
    SetInterFont(CPCancelBtn, "Bold")
    CPCancelBtn.AutoButtonColor = false
    CPCancelBtn.ZIndex = 1000052
    CPCancelBtn.Parent = ColorPickerPopup
    RegisterElement(CPCancelBtn, "BackgroundColor3", "Background")
    RegisterElement(CPCancelBtn, "TextColor3", "Text")
    local CPCancelCorner = Instance.new("UICorner")
    CPCancelCorner.CornerRadius = UDim.new(0, 6)
    CPCancelCorner.Parent = CPCancelBtn
    local CPCancelStroke = Instance.new("UIStroke")
    CPCancelStroke.Thickness = 1
    CPCancelStroke.Parent = CPCancelBtn
    RegisterElement(CPCancelStroke, "Color", "Border")

    local CPApplyBtn = Instance.new("TextButton")
    CPApplyBtn.Size = UDim2.new(0, 115, 0, 34)
    CPApplyBtn.Position = UDim2.new(0, 150, 0, 250)
    CPApplyBtn.Text = "Apply"
    CPApplyBtn.TextSize = 12
    SetInterFont(CPApplyBtn, "Bold")
    CPApplyBtn.AutoButtonColor = false
    CPApplyBtn.ZIndex = 1000052
    CPApplyBtn.Parent = ColorPickerPopup
    RegisterElement(CPApplyBtn, "BackgroundColor3", "Accent")
    CPApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local CPApplyCorner = Instance.new("UICorner")
    CPApplyCorner.CornerRadius = UDim.new(0, 6)
    CPApplyCorner.Parent = CPApplyBtn

    local cpTargetColor = Color3.new(1,1,1)
    local cpHue, cpSat, cpVal = 0, 0, 1
    local cpCallback = nil

    local function updateCPVisuals(updateInputs)
        cpTargetColor = Color3.fromHSV(cpHue, cpSat, cpVal)
        ColorMap.BackgroundColor3 = Color3.fromHSV(cpHue, 1, 1)
        ColorMapCursor.Position = UDim2.new(cpSat, 0, 1 - cpVal, 0)
        HueCursor.Position = UDim2.new(0.5, 0, cpHue, 0)
        
        if updateInputs then
            local r, g, b = math.floor(cpTargetColor.R*255), math.floor(cpTargetColor.G*255), math.floor(cpTargetColor.B*255)
            CPValHex.Text = string.format("#%02X%02X%02X", r, g, b)
            CPValR.Text = tostring(r)
            CPValG.Text = tostring(g)
            CPValB.Text = tostring(b)
        end
    end

    local function cpSetColor(c)
        cpHue, cpSat, cpVal = c:ToHSV()
        updateCPVisuals(true)
    end

    local PresetColorsList = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 128, 0),
        Color3.fromRGB(128, 0, 255), Color3.fromRGB(128, 255, 0), Color3.fromRGB(255, 0, 128)
    }

    for _, pc in ipairs(PresetColorsList) do
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(0, 26, 0, 26)
        pBtn.BackgroundColor3 = pc
        pBtn.Text = ""
        pBtn.ZIndex = 1000052
        pBtn.Parent = ColorPresets
        local pC = Instance.new("UICorner")
        pC.CornerRadius = UDim.new(0, 4)
        pC.Parent = pBtn
        local pS = Instance.new("UIStroke")
        pS.Thickness = 1
        pS.Parent = pBtn
        RegisterElement(pS, "Color", "Border")
        pBtn.MouseButton1Click:Connect(function()
            cpSetColor(pc)
        end)
    end
    ColorPresets.CanvasSize = UDim2.new(0, #PresetColorsList * 32, 0, 0)

    local mapDragging, hueDragging = false, false
    ColorMap.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            mapDragging = true
            local x = math.clamp((inp.Position.X - ColorMap.AbsolutePosition.X) / ColorMap.AbsoluteSize.X, 0, 1)
            local y = math.clamp((inp.Position.Y - ColorMap.AbsolutePosition.Y) / ColorMap.AbsoluteSize.Y, 0, 1)
            cpSat, cpVal = x, 1 - y
            updateCPVisuals(true)
        end
    end)
    HueSlider.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            local y = math.clamp((inp.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
            cpHue = y
            updateCPVisuals(true)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            if mapDragging then
                local x = math.clamp((inp.Position.X - ColorMap.AbsolutePosition.X) / ColorMap.AbsoluteSize.X, 0, 1)
                local y = math.clamp((inp.Position.Y - ColorMap.AbsolutePosition.Y) / ColorMap.AbsoluteSize.Y, 0, 1)
                cpSat, cpVal = x, 1 - y
                updateCPVisuals(true)
            end
            if hueDragging then
                local y = math.clamp((inp.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                cpHue = y
                updateCPVisuals(true)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            mapDragging, hueDragging = false, false
        end
    end)

    CPCancelBtn.MouseButton1Click:Connect(function() ColorPickerPopup.Visible = false end)
    CPApplyBtn.MouseButton1Click:Connect(function()
        if cpCallback then cpCallback(cpTargetColor) end
        ColorPickerPopup.Visible = false
    end)

    local function OpenColorPicker(startColor, cb)
        cpSetColor(startColor)
        cpCallback = cb
        ColorPickerPopup.Visible = true
    end

    local TabsList = {}
    local CurrentTab = nil

    local function updateTabsVisual()
        for _, btn in ipairs(NavScroll:GetChildren()) do
            if btn:IsA("TextButton") then
                local isSelected = CurrentTab and btn.Name == CurrentTab.Name:gsub("Page", "Tab")
                
                local accentBar = btn:FindFirstChild("AccentBar")
                local content = btn:FindFirstChild("TabContent")
                local lbl = content and content:FindFirstChildOfClass("TextLabel")
                local img = content and content:FindFirstChildOfClass("ImageLabel")
                local emj = content and content:FindFirstChild("EmojiLabel")

                if isSelected then
                    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                    if accentBar then
                        TweenService:Create(accentBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 4, 0.6, 0)}):Play()
                    end
                    if lbl then
                        TweenService:Create(lbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = CurrentTheme.Text}):Play()
                    end
                    if img then
                        TweenService:Create(img, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = CurrentTheme.Text}):Play()
                    end
                    if emj then
                        TweenService:Create(emj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = CurrentTheme.Text}):Play()
                    end
                else
                    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    if accentBar then
                        TweenService:Create(accentBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0.6, 0)}):Play()
                    end
                    if lbl then
                        TweenService:Create(lbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = CurrentTheme.SubText}):Play()
                    end
                    if img then
                        TweenService:Create(img, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = CurrentTheme.SubText}):Play()
                    end
                    if emj then
                        TweenService:Create(emj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = CurrentTheme.SubText}):Play()
                    end
                end
            end
        end
    end

    local function ToggleUI()
        local isVisible = MainFrame.Visible
        local startScale = isVisible and 1 or 0.85
        local endScale = isVisible and 0.85 or 1

        if not isVisible then
            MainFrame.Size = UDim2.fromOffset(size.X.Offset * startScale, size.Y.Offset * startScale)
            MainFrame.Visible = true
        end

        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(size.X.Offset * endScale, size.Y.Offset * endScale)
        })
        tween:Play()

        tween.Completed:Connect(function()
            if isVisible then
                MainFrame.Visible = false
                if ActiveDropdown then
                    ActiveDropdown:Close()
                end
            end
        end)
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == minimizeKey then
            ToggleUI()
        end
    end)

    local WindowObject = {}

    function WindowObject:AddTab(tabConfig)
        local tabName = tabConfig.Title or "Tab"
        local iconEmoji = tabConfig.Icon or "📁"

        local TabButton = Instance.new("TextButton")  
        TabButton.Name = tabName .. "Tab"  
        TabButton.Size = UDim2.new(1, -8, 0, 32)  
        TabButton.BackgroundTransparency = 1  
        TabButton.Text = ""  
        TabButton.AutoButtonColor = false  
        TabButton.ZIndex = 13  
        TabButton.Parent = NavScroll  
        RegisterElement(TabButton, "BackgroundColor3", "ElementBg")  

        local TabCorner = Instance.new("UICorner")  
        TabCorner.CornerRadius = UDim.new(0, 6)  
        TabCorner.Parent = TabButton  

        local AccentBar = Instance.new("Frame")  
        AccentBar.Name = "AccentBar"  
        AccentBar.Size = UDim2.new(0, 0, 0.6, 0)  
        AccentBar.Position = UDim2.new(0, 4, 0.2, 0)  
        AccentBar.BorderSizePixel = 0  
        AccentBar.ZIndex = 14  
        AccentBar.Parent = TabButton  
        RegisterElement(AccentBar, "BackgroundColor3", "Accent")  

        local AccentCorner = Instance.new("UICorner")  
        AccentCorner.CornerRadius = UDim.new(1, 0)  
        AccentCorner.Parent = AccentBar  

        local TabContent = Instance.new("Frame")  
        TabContent.Name = "TabContent"  
        TabContent.Size = UDim2.new(1, -16, 1, 0)  
        TabContent.Position = UDim2.new(0, 12, 0, 0)  
        TabContent.BackgroundTransparency = 1  
        TabContent.ZIndex = 14  
        TabContent.Parent = TabButton  

        local TabContentLayout = Instance.new("UIListLayout")  
        TabContentLayout.FillDirection = Enum.FillDirection.Horizontal  
        TabContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center  
        TabContentLayout.Padding = UDim.new(0, 8)  
        TabContentLayout.Parent = TabContent  

        if iconEmoji:match("^rbxassetid") or iconEmoji:match("^rbxtemp") then  
            local IconImageLabel = Instance.new("ImageLabel")  
            IconImageLabel.Size = UDim2.new(0, 20, 0, 20)  
            IconImageLabel.Image = iconEmoji  
            IconImageLabel.BackgroundTransparency = 1  
            IconImageLabel.ZIndex = 15  
            IconImageLabel.Parent = TabContent  
            RegisterElement(IconImageLabel, "ImageColor3", "SubText")
        else  
            local EmojiLabel = Instance.new("TextLabel")  
            EmojiLabel.Name = "EmojiLabel"
            EmojiLabel.Size = UDim2.new(0, 20, 0, 20)  
            EmojiLabel.Text = iconEmoji  
            EmojiLabel.TextSize = 16  
            SetInterFont(EmojiLabel, "Bold")  
            EmojiLabel.BackgroundTransparency = 1  
            EmojiLabel.ZIndex = 15  
            EmojiLabel.Parent = TabContent  
            RegisterElement(EmojiLabel, "TextColor3", "SubText")
        end  

        local TextLabel = Instance.new("TextLabel")  
        TextLabel.Size = UDim2.new(1, -28, 1, 0)  
        TextLabel.TextSize = 12  
        SetInterFont(TextLabel, "Medium")  
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left  
        TextLabel.BackgroundTransparency = 1  
        TextLabel.ZIndex = 15  
        TextLabel.Parent = TabContent  
        RegisterElement(TextLabel, "TextColor3", "SubText")  
        RegisterLocale(TextLabel, tabName)

        local TabPage = Instance.new("ScrollingFrame")  
        TabPage.Name = tabName .. "Page"  
        TabPage.Size = UDim2.new(1, 0, 1, 0)  
        TabPage.BackgroundTransparency = 1  
        TabPage.BorderSizePixel = 0  
        TabPage.Visible = false  
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)  
        TabPage.ScrollBarThickness = 3  
        TabPage.ZIndex = 12  
        TabPage.Parent = Container  
        RegisterElement(TabPage, "ScrollBarImageColor3", "Border")  

        local PageLayout = Instance.new("UIListLayout")  
        PageLayout.Padding = UDim.new(0, 6)  
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center  
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder  
        PageLayout.Parent = TabPage  

        local PagePadding = Instance.new("UIPadding")  
        PagePadding.PaddingTop = UDim.new(0, 4)  
        PagePadding.PaddingBottom = UDim.new(0, 10)  
        PagePadding.Parent = TabPage  

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()  
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)  
        end)  

        local function selectTab()  
            for _, page in ipairs(Container:GetChildren()) do  
                if page:IsA("ScrollingFrame") then page.Visible = false end  
            end  
            if ActiveDropdown then ActiveDropdown:Close() end
            CurrentTab = TabPage  
            TabPage.Visible = true  
            updateTabsVisual()  
        end  

        TabButton.MouseButton1Click:Connect(selectTab)  
        TabsList[tabName] = selectTab

        if not CurrentTab then selectTab() end

        local Elements = {}

        local function ApplyPremiumLock(parent, isLocked)
            if not isLocked then return end
            local LockOverlay = Instance.new("TextButton")
            LockOverlay.Size = UDim2.new(1, 0, 1, 0)
            LockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            LockOverlay.BackgroundTransparency = 0.5
            LockOverlay.Text = ""
            LockOverlay.AutoButtonColor = false
            LockOverlay.ZIndex = 50
            LockOverlay.Parent = parent
            
            local LockCorner = Instance.new("UICorner")
            LockCorner.CornerRadius = UDim.new(0, 8)
            LockCorner.Parent = LockOverlay
            
            local LockIcon = Instance.new("TextLabel")
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(0.5, -80, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Text = "🔒"
            LockIcon.TextSize = 14
            LockIcon.ZIndex = 51
            LockIcon.Parent = LockOverlay
            
            local LockText = Instance.new("TextLabel")
            LockText.Size = UDim2.new(0, 140, 0, 16)
            LockText.Position = UDim2.new(0.5, -55, 0.5, -8)
            LockText.Text = "This element is locked"
            LockText.TextSize = 12
            SetInterFont(LockText, "Medium")
            LockText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LockText.TextXAlignment = Enum.TextXAlignment.Left
            LockText.BackgroundTransparency = 1
            LockText.ZIndex = 51
            LockText.Parent = LockOverlay
        end

        local function CreateBaseElement(height, hasDesc, descText, titleText, isLocked)
            local finalHeight = height
            if hasDesc and descText and descText ~= "" then
                finalHeight = height + 14
            end

            local Bg = Instance.new("Frame")
            Bg.Size = UDim2.new(1, -20, 0, finalHeight)
            Bg.ZIndex = 13
            Bg.Parent = TabPage
            RegisterElement(Bg, "BackgroundColor3", "ElementBg")

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = Bg

            local Stroke = Instance.new("UIStroke")
            Stroke.Thickness = 1
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Parent = Bg
            RegisterElement(Stroke, "Color", "Border")

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 0, 20)
            Label.Position = UDim2.new(0, 14, 0, 6)
            Label.TextSize = 12
            SetInterFont(Label, "Medium")
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.ZIndex = 14
            Label.RichText = true
            Label.Parent = Bg
            RegisterElement(Label, "TextColor3", "Text")
            RegisterLocale(Label, titleText or "Control")

            local DescLabel
            if hasDesc and descText and descText ~= "" then
                DescLabel = Instance.new("TextLabel")
                DescLabel.Size = UDim2.new(1, -28, 0, 14)
                DescLabel.Position = UDim2.new(0, 14, 0, 24)
                DescLabel.Text = descText
                DescLabel.TextSize = 8
                SetInterFont(DescLabel, "Regular")
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.BackgroundTransparency = 1
                DescLabel.ZIndex = 14
                DescLabel.RichText = true
                DescLabel.Parent = Bg
                RegisterElement(DescLabel, "TextColor3", "SubText")
            end

            ApplyPremiumLock(Bg, isLocked)

            return Bg, Label, DescLabel
        end

        function Elements:Paragraph(options)
            local titleText = options.Title or "Paragraph"
            local descText = options.Content or options.Description or "Information body goes here."
            local isLocked = options.Locked or false

            local ParagraphBg = Instance.new("Frame")
            ParagraphBg.Size = UDim2.new(1, -20, 0, 0)
            ParagraphBg.AutomaticSize = Enum.AutomaticSize.Y
            ParagraphBg.ZIndex = 13
            ParagraphBg.Parent = TabPage
            RegisterElement(ParagraphBg, "BackgroundColor3", "ElementBg")

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = ParagraphBg

            local Stroke = Instance.new("UIStroke")
            Stroke.Thickness = 1
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Parent = ParagraphBg
            RegisterElement(Stroke, "Color", "Border")

            local InnerLayout = Instance.new("UIListLayout")
            InnerLayout.Padding = UDim.new(0, 4)
            InnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            InnerLayout.Parent = ParagraphBg

            local Padding = Instance.new("UIPadding")
            Padding.PaddingTop = UDim.new(0, 10)
            Padding.PaddingBottom = UDim.new(0, 10)
            Padding.PaddingLeft = UDim.new(0, 14)
            Padding.PaddingRight = UDim.new(0, 14)
            Padding.Parent = ParagraphBg

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, 0, 0, 0)
            TitleLabel.AutomaticSize = Enum.AutomaticSize.Y
            TitleLabel.Text = titleText
            TitleLabel.TextSize = 12
            SetInterFont(TitleLabel, "Bold")
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextWrapped = true
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.ZIndex = 14
            TitleLabel.RichText = true
            TitleLabel.LayoutOrder = 1
            TitleLabel.Parent = ParagraphBg
            RegisterElement(TitleLabel, "TextColor3", "Text")

            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Size = UDim2.new(1, 0, 0, 0)
            ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
            ContentLabel.Text = descText
            ContentLabel.TextSize = 10.5
            SetInterFont(ContentLabel, "Regular")
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.TextWrapped = true
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.ZIndex = 14
            ContentLabel.RichText = true
            ContentLabel.LayoutOrder = 2
            ContentLabel.Parent = ParagraphBg
            RegisterElement(ContentLabel, "TextColor3", "SubText")
            
            ApplyPremiumLock(ParagraphBg, isLocked)
            
            local ParagraphMethods = {}
            function ParagraphMethods:SetTitle(newTitle)
                TitleLabel.Text = newTitle
            end
            function ParagraphMethods:SetContent(newContent)
                ContentLabel.Text = newContent
            end
            return ParagraphMethods
        end

        function Elements:Input(options)
            local inputTitle = options.Title or "Input Field"
            local descText = options.Description
            local placeholder = options.Placeholder or "Type here..."
            local default = options.Default or ""
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end

            local hasDesc = descText ~= nil and descText ~= ""
            local InputBg, Label = CreateBaseElement(38, hasDesc, descText, inputTitle, isLocked)

            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)

            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Size = UDim2.new(0, 150, 0, 26)
            TextBoxFrame.Position = UDim2.new(1, -164, 0.5, -13)
            TextBoxFrame.ZIndex = 14
            TextBoxFrame.Parent = InputBg
            RegisterElement(TextBoxFrame, "BackgroundColor3", "Background")

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = TextBoxFrame

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1
            BoxStroke.Parent = TextBoxFrame
            RegisterElement(BoxStroke, "Color", "Border")

            local InputField = Instance.new("TextBox")
            InputField.Size = UDim2.new(1, -16, 1, 0)
            InputField.Position = UDim2.new(0, 8, 0, 0)
            InputField.BackgroundTransparency = 1
            InputField.Text = default
            InputField.PlaceholderText = placeholder
            InputField.TextSize = 11
            InputField.ClipsDescendants = true
            SetInterFont(InputField, "Medium")
            InputField.TextXAlignment = Enum.TextXAlignment.Left
            InputField.ClearTextOnFocus = false
            InputField.ZIndex = 15
            InputField.Parent = TextBoxFrame
            RegisterElement(InputField, "TextColor3", "Text")
            RegisterElement(InputField, "PlaceholderColor3", "SubText")

            InputField.Focused:Connect(function()
                if isLocked then return end
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = CurrentTheme.Accent}):Play()
            end)

            InputField.FocusLost:Connect(function(enterPressed)
                if isLocked then return end
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = CurrentTheme.Border}):Play()
                callback(InputField.Text, enterPressed)
            end)

            local InputMethods = {}
            function InputMethods:SetValue(val)
                InputField.Text = tostring(val)
                callback(tostring(val), false)
            end
            return InputMethods
        end

        function Elements:ColorPicker(options)
            local titleText = options.Title or "Color Picker"
            local descText = options.Description
            local default = options.Default or Color3.fromRGB(255, 255, 255)
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end
            
            local hasDesc = descText ~= nil and descText ~= ""
            local PickerBg, Label = CreateBaseElement(38, hasDesc, descText, titleText, isLocked)
            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)
            
            local ColorBtn = Instance.new("TextButton")
            ColorBtn.Size = UDim2.new(0, 26, 0, 26)
            ColorBtn.Position = UDim2.new(1, -40, 0.5, -13)
            ColorBtn.BackgroundColor3 = default
            ColorBtn.Text = ""
            ColorBtn.ZIndex = 15
            ColorBtn.AutoButtonColor = false
            ColorBtn.Parent = PickerBg
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 6)
            ColorCorner.Parent = ColorBtn
            
            local ColorStroke = Instance.new("UIStroke")
            ColorStroke.Thickness = 1.5
            ColorStroke.Parent = ColorBtn
            RegisterElement(ColorStroke, "Color", "Border")
            
            ColorBtn.MouseButton1Click:Connect(function()
                if isLocked then return end
                OpenColorPicker(ColorBtn.BackgroundColor3, function(newColor)
                    ColorBtn.BackgroundColor3 = newColor
                    callback(newColor)
                end)
            end)
        end
        
        function Elements:Keybind(options)
            local titleText = options.Title or "Keybind"
            local descText = options.Description
            local default = options.Default or Enum.KeyCode.RightShift
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end
            
            local currentKey = default
            local isBinding = false
            
            local hasDesc = descText ~= nil and descText ~= ""
            local KeyBg, Label = CreateBaseElement(38, hasDesc, descText, titleText, isLocked)
            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)
            
            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 90, 0, 26)
            KeyBtn.Position = UDim2.new(1, -104, 0.5, -13)
            KeyBtn.Text = currentKey.Name
            KeyBtn.TextSize = 11
            SetInterFont(KeyBtn, "Medium")
            KeyBtn.ZIndex = 15
            KeyBtn.AutoButtonColor = false
            KeyBtn.Parent = KeyBg
            RegisterElement(KeyBtn, "BackgroundColor3", "Background")
            RegisterElement(KeyBtn, "TextColor3", "Accent")
            
            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 6)
            KeyCorner.Parent = KeyBtn
            
            local KeyStroke = Instance.new("UIStroke")
            KeyStroke.Thickness = 1
            KeyStroke.Parent = KeyBtn
            RegisterElement(KeyStroke, "Color", "Border")
            
            KeyBtn.MouseButton1Click:Connect(function()
                if isLocked or isBinding then return end
                isBinding = true
                KeyBtn.Text = "..."
                
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        conn:Disconnect()
                        currentKey = input.KeyCode
                        KeyBtn.Text = currentKey.Name
                        isBinding = false
                        callback(currentKey)
                    end
                end)
            end)
        end

        function Elements:Button(options)
            local btnText = options.Title or "Button"
            local descText = options.Description
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end

            local hasDesc = descText ~= nil and descText ~= ""
            local ButtonBg, Label = CreateBaseElement(34, hasDesc, descText, btnText, isLocked)
            
            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)

            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Size = UDim2.new(1, 0, 1, 0)
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Text = ""
            ClickBtn.ZIndex = 15
            ClickBtn.AutoButtonColor = false
            ClickBtn.Parent = ButtonBg

            local InteractionBar = Instance.new("Frame")
            InteractionBar.Size = UDim2.new(0, 0, 1, 0)
            InteractionBar.Position = UDim2.new(0, 0, 0, 0)
            InteractionBar.BackgroundTransparency = 0.96
            InteractionBar.ZIndex = 14
            InteractionBar.Parent = ButtonBg
            RegisterElement(InteractionBar, "BackgroundColor3", "Accent")

            local IntCorner = Instance.new("UICorner")
            IntCorner.CornerRadius = UDim.new(0, 8)
            IntCorner.Parent = InteractionBar

            ClickBtn.MouseEnter:Connect(function()
                if isLocked then return end
                TweenService:Create(InteractionBar, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            end)
            ClickBtn.MouseLeave:Connect(function()
                TweenService:Create(InteractionBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 1, 0)}):Play()
            end)

            ClickBtn.MouseButton1Click:Connect(function()
                if isLocked then return end
                local origSize = ButtonBg.Size
                TweenService:Create(ButtonBg, TweenInfo.new(0.08), {Size = UDim2.new(1, -24, 0, origSize.Y.Offset - 2)}):Play()
                task.wait(0.08)
                TweenService:Create(ButtonBg, TweenInfo.new(0.08), {Size = origSize}):Play()
                callback()
            end)
        end

        function Elements:Toggle(toggleText, options)
            local descText = options.Description
            local default = options.Default or false
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end
            local flagName = options.Flag or toggleText

            local savedState = ToggleProfile[flagName]
            local toggled = default
            if savedState ~= nil then
                toggled = savedState
            end

            local hasDesc = descText ~= nil and descText ~= ""
            local ToggleBg, Label = CreateBaseElement(38, hasDesc, descText, toggleText, isLocked)

            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)

            local SwitchFrame = Instance.new("Frame")
            SwitchFrame.Name = "SwitchFrame"
            SwitchFrame.Size = UDim2.new(0, 42, 0, 22)
            SwitchFrame.Position = UDim2.new(1, -56, 0.5, -11)
            SwitchFrame.ZIndex = 15
            SwitchFrame.Parent = ToggleBg
            SwitchFrame.BackgroundColor3 = toggled and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchFrame

            local Circle = Instance.new("Frame")
            Circle.Name = "Thumb"
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Circle.BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or CurrentTheme.SubText
            Circle.ZIndex = 16
            Circle.Parent = SwitchFrame

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Size = UDim2.new(1, 0, 1, 0)
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Text = ""
            ClickBtn.ZIndex = 17
            ClickBtn.Parent = ToggleBg

            TogglesRegistry[SwitchFrame] = {
                GetToggled = function() return toggled end
            }

            local function fireToggle()
                if isLocked then return end
                toggled = not toggled
                local targetPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                local targetColor = toggled and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff
                local thumbColor = toggled and Color3.fromRGB(255, 255, 255) or CurrentTheme.SubText
                
                TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = targetPos, BackgroundColor3 = thumbColor}):Play()
                TweenService:Create(SwitchFrame, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                
                callback(toggled)
                ToggleProfile[flagName] = toggled
                SaveConfig()
            end

            ClickBtn.MouseButton1Click:Connect(fireToggle)

            if savedState ~= nil then
                task.defer(callback, toggled)
            end
        end

        function Elements:Slider(sliderText, options)
            local descText = options.Description
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local rounding = options.Rounding or 1
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end

            local hasDesc = descText ~= nil and descText ~= ""
            local SliderBg, Label = CreateBaseElement(46, hasDesc, descText, sliderText, isLocked)

            local ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(0, 52, 0, 18)
            ValueBox.Position = UDim2.new(1, -66, 0, 6)
            ValueBox.Text = tostring(default)
            ValueBox.TextSize = 11
            SetInterFont(ValueBox, "Bold")
            ValueBox.TextXAlignment = Enum.TextXAlignment.Center
            ValueBox.ClearTextOnFocus = false
            ValueBox.ZIndex = 15
            ValueBox.Parent = SliderBg
            RegisterElement(ValueBox, "BackgroundColor3", "Background")
            RegisterElement(ValueBox, "TextColor3", "Accent")

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = ValueBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1
            BoxStroke.Parent = ValueBox
            RegisterElement(BoxStroke, "Color", "Border")

            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -28, 0, 4)
            SliderTrack.Position = UDim2.new(0, 14, 1, -12)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.ZIndex = 14
            SliderTrack.Parent = SliderBg
            RegisterElement(SliderTrack, "BackgroundColor3", "Background")

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = SliderTrack

            local SliderFill = Instance.new("Frame")
            local initPct = math.clamp((default - min) / (max - min), 0, 1)
            SliderFill.Size = UDim2.new(initPct, 0, 1, 0)
            SliderFill.BorderSizePixel = 0
            SliderFill.ZIndex = 15
            SliderFill.Parent = SliderTrack
            RegisterElement(SliderFill, "BackgroundColor3", "Accent")

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill

            local SliderKnob = Instance.new("TextButton")
            SliderKnob.Size = UDim2.new(0, 14, 0, 14)
            SliderKnob.Position = UDim2.new(initPct, -7, 0.5, -7)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.Text = ""
            SliderKnob.AutoButtonColor = false
            SliderKnob.ZIndex = 16
            SliderKnob.Parent = SliderTrack

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = SliderKnob

            local KnobStroke = Instance.new("UIStroke")
            KnobStroke.Thickness = 1
            KnobStroke.Color = Color3.fromRGB(180, 180, 180)
            KnobStroke.Parent = SliderKnob

            local dragging = false

            local function updateSliderVisual(val)
                local percentage = math.clamp((val - min) / (max - min), 0, 1)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percentage, -7, 0.5, -7)
                ValueBox.Text = tostring(val)
            end

            local function snapToMouse(input)
                local mouseX = input.Position.X
                local trackX = SliderTrack.AbsolutePosition.X
                local trackWidth = SliderTrack.AbsoluteSize.X
                local percentage = math.clamp((mouseX - trackX) / trackWidth, 0, 1)
                
                local calculatedValue = min + ((max - min) * percentage)
                calculatedValue = math.round(calculatedValue / rounding) * rounding
                calculatedValue = math.clamp(calculatedValue, min, max)
                
                updateSliderVisual(calculatedValue)
                callback(calculatedValue)
            end

            SliderKnob.InputBegan:Connect(function(input)
                if isLocked then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    TabPage.ScrollingEnabled = false
                    snapToMouse(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isLocked then return end
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    snapToMouse(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if isLocked then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    TabPage.ScrollingEnabled = true
                end
            end)
        end

        function Elements:Dropdown(dropdownText, options)
            local list = options.Values or {}
            local descText = options.Description
            local defaultIndex = options.Default or 1
            local isLocked = options.Locked or false
            local callback = options.Callback or function() end
            local isMulti = options.Multi or false

            local active = false
            local isAnimating = false
            local selectedValue = ""
            if not isMulti then
                selectedValue = list[defaultIndex] or ""
            end
            
            local multiSelected = {}
            if isMulti then
                if type(options.Default) == "table" then
                    for _, v in ipairs(options.Default) do
                        if list[v] then multiSelected[list[v]] = true end
                    end
                elseif type(options.Default) == "number" then
                    if list[options.Default] then
                        multiSelected[list[options.Default]] = true
                    end
                end
            end

            local hasDesc = descText ~= nil and descText ~= ""
            local DropdownBg, Label = CreateBaseElement(42, hasDesc, descText, dropdownText, isLocked)

            Label.Position = UDim2.new(0, 14, 0.5, hasDesc and -18 or -10)

            local function getDropdownDisplay()
                if isMulti then
                    local count = 0
                    local first = nil
                    for k, v in pairs(multiSelected) do
                        if v then
                            count = count + 1
                            if not first then first = k end
                        end
                    end
                    if count == 0 then return "Select Options" end
                    if count == 1 then return first end
                    return first .. " (+" .. tostring(count - 1) .. ")"
                else
                    return selectedValue ~= "" and selectedValue or "Select Option"
                end
            end

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(0, 180, 1, 0)
            DropBtn.Position = UDim2.new(1, -194, 0, 0)
            DropBtn.Text = getDropdownDisplay() .. "  ▼"
            DropBtn.TextSize = 12
            SetInterFont(DropBtn, "Medium")
            DropBtn.AutoButtonColor = false
            DropBtn.BackgroundTransparency = 1
            DropBtn.TextXAlignment = Enum.TextXAlignment.Right
            DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            DropBtn.ZIndex = 15
            DropBtn.Parent = DropdownBg
            RegisterElement(DropBtn, "TextColor3", "Text")

            local DropMenu = Instance.new("Frame")
            DropMenu.Name = "DropMenu"
            DropMenu.Size = UDim2.new(0, 180, 0, 0)
            DropMenu.ClipsDescendants = true
            DropMenu.Visible = false
            DropMenu.ZIndex = 1000000
            DropMenu.BackgroundColor3 = CurrentTheme.ElementBg
            DropMenu.Parent = GlobalScreenGui

            DropdownsRegistry[DropMenu] = true

            local DropMenuCorner = Instance.new("UICorner")
            DropMenuCorner.CornerRadius = UDim.new(0, 8)
            DropMenuCorner.Parent = DropMenu

            local DropMenuStroke = Instance.new("UIStroke")
            DropMenuStroke.Thickness = 1
            DropMenuStroke.Parent = DropMenu
            RegisterElement(DropMenuStroke, "Color", "Border")

            local SearchBox = Instance.new("TextBox")
            SearchBox.Size = UDim2.new(1, -16, 0, 26)
            SearchBox.Position = UDim2.new(0, 8, 0, 8)
            SearchBox.PlaceholderText = "Search... 🔍"
            SearchBox.Text = ""
            SearchBox.TextSize = 11
            SetInterFont(SearchBox, "Regular")
            SearchBox.ZIndex = 1000001
            SearchBox.Parent = DropMenu
            RegisterElement(SearchBox, "BackgroundColor3", "Background")
            RegisterElement(SearchBox, "TextColor3", "Text")
            RegisterElement(SearchBox, "PlaceholderColor3", "SubText")

            local SearchCorner = Instance.new("UICorner")
            SearchCorner.CornerRadius = UDim.new(0, 6)
            SearchCorner.Parent = SearchBox

            local ListHolder = Instance.new("ScrollingFrame")
            ListHolder.Size = UDim2.new(1, 0, 1, -42)
            ListHolder.Position = UDim2.new(0, 0, 0, 38)
            ListHolder.BackgroundTransparency = 1
            ListHolder.BorderSizePixel = 0
            ListHolder.ZIndex = 1000001
            ListHolder.Parent = DropMenu
            ListHolder.ScrollBarThickness = 3
            RegisterElement(ListHolder, "ScrollBarImageColor3", "Accent")

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = ListHolder

            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ListHolder.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
            end)

            local ListPadding = Instance.new("UIPadding")
            ListPadding.PaddingLeft = UDim.new(0, 8)
            ListPadding.PaddingRight = UDim.new(0, 8)
            ListPadding.PaddingBottom = UDim.new(0, 6)
            ListPadding.Parent = ListHolder

            local DropdownHandler = {}
            local savedCanvasPosition = Vector2.new(0, 0)

            local function updateMenuPosition()
                local absPos = DropBtn.AbsolutePosition
                local absSize = DropBtn.AbsoluteSize
                local currentViewport = CurrentCamera.ViewportSize
                
                local matchCount = 0
                local filter = string.lower(SearchBox.Text)
                for _, item in ipairs(list) do
                    if filter == "" or string.find(string.lower(item), filter) then
                        matchCount = matchCount + 1
                    end
                end
                
                local spaceBelow = currentViewport.Y - (absPos.Y + absSize.Y + 10)
                local spaceAbove = absPos.Y - 10
                local isAbove = spaceBelow < 150 and spaceAbove > spaceBelow
                
                local maxHeight = isAbove and (spaceAbove - 20) or (spaceBelow - 20)
                local targetHeight = (matchCount * 28) + 46
                
                local calculatedHeight = math.clamp(targetHeight, 46 + 28, math.min(250, maxHeight))
                
                local margin = 10
                local posX = absPos.X + absSize.X - 180
                if posX + 180 > currentViewport.X - margin then
                    posX = currentViewport.X - 180 - margin
                end
                if posX < margin then posX = margin end

                local posY = isAbove and (absPos.Y - calculatedHeight - 4) or (absPos.Y + absSize.Y + 4)
                if posY < margin then posY = margin end
                
                DropMenu.Position = UDim2.fromOffset(posX, posY)
                return calculatedHeight
            end

            local function populateList(filter)
                for _, child in ipairs(ListHolder:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for _, item in ipairs(list) do
                    if filter == "" or string.find(string.lower(item), string.lower(filter)) then
                        local isSelected = false
                        if isMulti then
                            isSelected = multiSelected[item] == true
                        else
                            isSelected = (selectedValue == item)
                        end
                        
                        local ItemBtn = Instance.new("TextButton")
                        ItemBtn.Size = UDim2.new(1, 0, 0, 26)
                        
                        if isMulti then
                            ItemBtn.Text = isSelected and "•  " .. item or "   " .. item
                        else
                            ItemBtn.Text = isSelected and "•  " .. item or "   " .. item
                        end
                        
                        ItemBtn.TextSize = 11.5
                        
                        if isSelected then
                            SetInterFont(ItemBtn, "Bold")
                        else
                            SetInterFont(ItemBtn, "Medium")
                        end
                        
                        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        ItemBtn.AutoButtonColor = false
                        ItemBtn.ZIndex = 1000020
                        ItemBtn.Parent = ListHolder
                        ItemBtn.BackgroundTransparency = 1
                        ItemBtn.TextTruncate = Enum.TextTruncate.AtEnd
                        ItemBtn.RichText = true

                        RegisterElement(ItemBtn, "TextColor3", function()
                            local currentActive = isMulti and multiSelected[item] or (selectedValue == item)
                            return currentActive and CurrentTheme.Accent or CurrentTheme.Text
                        end)

                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 6)
                        ItemCorner.Parent = ItemBtn

                        ItemBtn.MouseEnter:Connect(function()
                            TweenService:Create(ItemBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.92, BackgroundColor3 = CurrentTheme.Background}):Play()
                        end)
                        ItemBtn.MouseLeave:Connect(function()
                            TweenService:Create(ItemBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                        end)

                        ItemBtn.MouseButton1Click:Connect(function()
                            if isAnimating then return end
                            
                            if isMulti then
                                multiSelected[item] = not multiSelected[item]
                                ItemBtn.Text = multiSelected[item] and "•  " .. item or "   " .. item
                                
                                if multiSelected[item] then
                                    SetInterFont(ItemBtn, "Bold")
                                else
                                    SetInterFont(ItemBtn, "Medium")
                                end
                                
                                DropBtn.Text = getDropdownDisplay() .. "  ▼"
                                
                                ApplyTheme(CurrentThemeName)
                                callback(multiSelected)
                            else
                                selectedValue = item
                                DropBtn.Text = item .. "  ▼"
                                
                                populateList(filter)
                                ApplyTheme(CurrentThemeName)
                                
                                callback(item)
                            end
                        end)
                    end
                end

                
                local totalItems = 0
                for _, child in ipairs(ListHolder:GetChildren()) do
                    if child:IsA("TextButton") then totalItems = totalItems + 1 end
                end
                ListHolder.ScrollBarThickness = (totalItems <= 5) and 0 or 3
                
                local maxPossibleScrollY = math.max(0, ListHolder.AbsoluteCanvasSize.Y - ListHolder.AbsoluteSize.Y)
                if savedCanvasPosition.Y > maxPossibleScrollY then
                    ListHolder.CanvasPosition = Vector2.new(0, maxPossibleScrollY)
                else
                    ListHolder.CanvasPosition = savedCanvasPosition
                end
            end

            function DropdownHandler:SetValues(newList, newDefault)
                list = newList or {}

                if isMulti then
                    multiSelected = {}
                    if type(newDefault) == "table" then
                        for _, v in ipairs(newDefault) do
                            if list[v] then multiSelected[list[v]] = true end
                        end
                    end
                    DropBtn.Text = getDropdownDisplay() .. "  ▼"
                else
                    if newDefault ~= nil and table.find(list, newDefault) then
                        selectedValue = newDefault
                    elseif not table.find(list, selectedValue) then
                        selectedValue = ""
                    end
                    DropBtn.Text = getDropdownDisplay() .. "  ▼"
                end

                if active then
                    populateList(SearchBox.Text)
                    updateMenuPosition()
                else
                    populateList("")
                end
            end

            populateList("")

            ListHolder:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if active and not isAnimating then
                    savedCanvasPosition = ListHolder.CanvasPosition
                end
            end)

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local previousPos = savedCanvasPosition
                populateList(SearchBox.Text)
                if active then updateMenuPosition() end
                savedCanvasPosition = previousPos
            end)

            function DropdownHandler:Open()
                if isAnimating or isLocked then return end
                
                if ActiveDropdown and ActiveDropdown ~= DropdownHandler then
                    ActiveDropdown:Close()
                end

                active = true
                ActiveDropdown = DropdownHandler
                isAnimating = true
                
                local calculatedHeight = updateMenuPosition()
                DropMenu.Size = UDim2.new(0, 180, 0, 0)
                DropMenu.Visible = true
                
                populateList(SearchBox.Text)
                ListHolder.CanvasPosition = savedCanvasPosition

                local menuTween = TweenService:Create(DropMenu, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 180, 0, calculatedHeight)})
                menuTween:Play()
                menuTween.Completed:Connect(function()
                    isAnimating = false
                    ListHolder.CanvasPosition = savedCanvasPosition
                end)
            end

            function DropdownHandler:Close()
                if not active or isAnimating then return end
                active = false
                isAnimating = true
                
                savedCanvasPosition = ListHolder.CanvasPosition
                
                if ActiveDropdown == DropdownHandler then
                    ActiveDropdown = nil
                end

                local menuTween = TweenService:Create(DropMenu, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 180, 0, 0)})
                menuTween:Play()
                menuTween.Completed:Connect(function()
                    DropMenu.Visible = false
                    isAnimating = false
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                if isLocked then return end
                if active then
                    DropdownHandler:Close()
                else
                    DropdownHandler:Open()
                end
            end)

            DropBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                if active then updateMenuPosition() end
            end)

            DropMenu.Destroying:Connect(function()
                if ActiveDropdown == DropdownHandler then
                    ActiveDropdown = nil
                end
                DropdownsRegistry[DropMenu] = nil
            end)

            return DropdownHandler
        end

        function Elements:CreateSection(sectionText)
            local SectionBg = Instance.new("Frame")
            SectionBg.Size = UDim2.new(1, -20, 0, 28)
            SectionBg.BackgroundTransparency = 1
            SectionBg.ZIndex = 13
            SectionBg.Parent = TabPage

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.TextSize = 10.5
            SetInterFont(Label, "Bold")
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.ZIndex = 14
            Label.RichText = true
            Label.Parent = SectionBg
            RegisterElement(Label, "TextColor3", "Accent")
            RegisterLocale(Label, sectionText, true)

            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BorderSizePixel = 0
            Line.ZIndex = 14
            Line.Parent = SectionBg
            RegisterElement(Line, "BackgroundColor3", "Border")
        end

        function Elements:SettingsUI()
            Elements:CreateSection("Custom Theme Settings")

            local themeNamesList = {}
            for themeName, _ in pairs(Themes) do
                table.insert(themeNamesList, themeName)
            end
            table.sort(themeNamesList)

            Elements:Dropdown("Select Theme", {
                Description = "เลือกธีม UI",
                Values = themeNamesList,
                Default = table.find(themeNamesList, CurrentThemeName) or 1,
                Multi = false,
                Callback = function(themeName)
                    ApplyTheme(themeName)
                    ConfigData.Theme = themeName
                    SaveConfig()
                end
            })

            Elements:Slider("UI Transparency", {
                Description = "ความโปร่งใส UI",
                Min = 0,
                Max = 100,
                Default = math.round(CurrentTransparency * 100),
                Rounding = 1,
                Callback = function(val)
                    local percentageDecimal = val / 100
                    ApplyTransparency(percentageDecimal)
                    ConfigData.Transparency = percentageDecimal
                    SaveConfig()
                end
            })

            Elements:CreateSection("Custom Font Settings")

            local fontNamesList = {}
            for fontName, _ in pairs(Fonts) do
                table.insert(fontNamesList, fontName)
            end
            table.sort(fontNamesList)

            Elements:Dropdown("Select Font", {
                Description = "เลือกฟอนต์ที่ใช้ทั้ง UI",
                Values = fontNamesList,
                Default = table.find(fontNamesList, CurrentFontName) or 1,
                Multi = false,
                Callback = function(fontName)
                    ApplyFont(fontName)
                    ConfigData.Font = fontName
                    SaveConfig()
                end
            })

            Elements:CreateSection("Language Settings")

            Elements:Dropdown("Select Language", {
                Description = "เลือกภาษาที่แสดงผล",
                Values = {"English", "ไทย"},
                Default = CurrentLanguage == "TH" and 2 or 1,
                Multi = false,
                Callback = function(choice)
                    local langCode = choice == "ไทย" and "TH" or "EN"
                    ApplyLanguage(langCode)
                    ConfigData.Language = langCode
                    SaveConfig()
                end
            })
            
            Elements:Keybind({
                Title = "Minimize Keybind",
                Description = "ปุ่มลัดสำหรับย่อหน้าต่าง UI",
                Default = minimizeKey,
                Callback = function(newKey)
                    minimizeKey = newKey
                    ConfigData.MinimizeKey = newKey.Name
                    SaveConfig()
                end
            })
        end

        return Elements
    end

    ApplyTheme(themeDefault)
    ApplyFont(fontDefault)
    ApplyLanguage(languageDefault)
    ApplyTransparency(ConfigData.Transparency or 0)
    updateTabsVisual() 
    return WindowObject
end

return Library
