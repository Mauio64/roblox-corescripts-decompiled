local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
CoreGui:WaitForChild("RobloxGui")

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.UIBlox)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useEventConnection = ReactUtils.useEventConnection
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local Style2 = require(CorePackages.Workspace.Packages.Style)
local useDesignTokens = Style2.useDesignTokens
local parent = script.Parent.Parent.Parent.Parent
local chrome = parent.Parent.Chrome
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local GamepadConnector

if FFlagEnableConsoleExpControls and not enabled then
	GamepadConnector = nil
else
	GamepadConnector = require(parent.Components.GamepadConnector)
end

local useObservableValue = require(chrome.ChromeShared.Hooks.useObservableValue)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local FFlagLocalizeMenuNavigationToggleDialog = require(CoreGui.RobloxGui.Modules.TopBar.Flags.FFlagLocalizeMenuNavigationToggleDialog)

local function MenuNavigationToggleDialog(p)
	local v = useDesignTokens()
	local captionMedium = v.Typography.CaptionMedium
	local size_400 = v.Size.Size_400
	local size_150 = v.Size.Size_150
	local medium = v.Radius.Medium
	local size_600 = v.Size.Size_600
	local overMedia_0 = v.Color.OverMedia.OverMedia_0
	local color3 = v.Color.Content.Emphasis.Color3
	local size_100 = v.Size.Size_100

	local image = not (FFlagLocalizeMenuNavigationToggleDialog and game:GetEngineFeature("GetImageForKeyCode"))
		and "rbxasset://textures/ui/Controls/DesignSystem/ButtonSelect@2x.png"
		or UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)
	local text, text2

	if FFlagLocalizeMenuNavigationToggleDialog then
		local state, setState = React.useState(LocalizationService.RobloxLocaleId)
		useEventConnection(LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"), function()
			setState(LocalizationService.RobloxLocaleId)
		end)

		text, text2 = React.useMemo(function()
			local v2 = Localization.new(state)

			local success, result = pcall(v2.Format, v2, "CoreScripts.InGameMenu.VirtualCursorHintPreIcon")

			local success2, result2 = pcall(v2.Format, v2, "CoreScripts.InGameMenu.VirtualCursorHintPostIcon")
			local selected = not success and "Some experiences require pressing" or result

			if success2 then
				return selected, result2
			end

			return selected, "to toggle menu navigation"
		end, { state })
	else
		local _ = {
			VirtualCursorHintPreIcon = "Some experiences require pressing ",
			VirtualCursorHintPostIcon = " to toggle menu navigation"
		}
		text = "Some experiences require pressing "
		text2 = " to toggle menu navigation"
	end

	local v2, v3 = React.useMemo(function()
		return
			GetTextSize(text, captionMedium.FontSize, captionMedium.Font, Vector2.new(1e999, 1e999)),
			(GetTextSize(text2, captionMedium.FontSize, captionMedium.Font, Vector2.new(1e999, 1e999)))
	end, { captionMedium.FontSize, captionMedium.Font, text, text2 })

	local v4 = nil

	if enabled and FFlagEnableConsoleExpControls then
		v4 = useObservableValue(GamepadConnector:getSelectedCoreObject())
	end

	local createElement = React.createElement
	local v5 = {
		BackgroundColor3 = overMedia_0.Color3,
		BackgroundTransparency = overMedia_0.Transparency,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = p.Position,
		Visible = not (enabled and FFlagEnableConsoleExpControls) or v4 ~= nil
	}

	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, medium) }),
		Layout = 0,
		LeftText = 0,
		Icon = 0,
		RightText = 0,
		Padding = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0
	}
	local padding

	if FFlagLocalizeMenuNavigationToggleDialog then
		padding = UDim.new(0, size_100)
	end

	v6.Padding = padding
	children.Layout = createElement2("UIListLayout", v6)

	local createElement3 = React.createElement
	local v7 = {
		Size = UDim2.fromOffset(v2.X, v2.Y),
		Text = text,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = color3,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextWrapped = false,
		BackgroundTransparency = 1,
		LayoutOrder = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = captionMedium.Font
	end

	v7.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(captionMedium.Font)
	end

	v7.FontFace = fontFace
	v7.TextSize = captionMedium.FontSize
	children.LeftText = createElement3("TextLabel", v7)

	children.Icon = React.createElement("ImageLabel", {
		Size = UDim2.fromOffset(size_600, size_600),
		BackgroundTransparency = 1,
		LayoutOrder = 100,
		Image = image
	})

	local createElement4 = React.createElement
	local v8 = {
		Size = UDim2.fromOffset(v3.X, v3.Y),
		Text = text2,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = color3,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextWrapped = false,
		BackgroundTransparency = 1,
		LayoutOrder = 200
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = captionMedium.Font
	end

	v8.Font = font2
	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(captionMedium.Font)
	end

	v8.FontFace = fontFace2
	v8.TextSize = captionMedium.FontSize
	children.RightText = createElement4("TextLabel", v8)

	children.Padding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, size_150),
		PaddingBottom = UDim.new(0, size_150),
		PaddingLeft = UDim.new(0, size_400),
		PaddingRight = UDim.new(0, size_400)
	})
	return createElement("Frame", v5, children)
end

return MenuNavigationToggleDialog
