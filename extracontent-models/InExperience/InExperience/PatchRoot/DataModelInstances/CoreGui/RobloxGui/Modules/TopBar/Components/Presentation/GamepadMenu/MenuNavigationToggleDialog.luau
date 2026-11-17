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

	local image = not game:GetEngineFeature("GetImageForKeyCode")
		and "rbxasset://textures/ui/Controls/DesignSystem/ButtonSelect@2x.png"
		or UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)
	useEventConnection(LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"), function()
		setState(LocalizationService.RobloxLocaleId)
	end)

	local text, text2 = React.useMemo(function()
		local v2 = Localization.new(state)

		local success, result = pcall(v2.Format, v2, "CoreScripts.InGameMenu.VirtualCursorHintPreIcon")
		local success2, result2 = pcall(v2.Format, v2, "CoreScripts.InGameMenu.VirtualCursorHintPostIcon")
		local selected = not success and "Some experiences require pressing" or result

		if success2 then
			return selected, result2
		end

		return selected, "to toggle menu navigation"
	end, { state })

	local v2, v3 = React.useMemo(function()
		return
			GetTextSize(text, captionMedium.FontSize, captionMedium.Font, Vector2.new(1e999, 1e999)),
			(GetTextSize(text2, captionMedium.FontSize, captionMedium.Font, Vector2.new(1e999, 1e999)))
	end, { captionMedium.FontSize, captionMedium.Font, text, text2 })

	local v4 = nil

	if enabled and FFlagEnableConsoleExpControls then
		v4 = useObservableValue(GamepadConnector:getSelectedCoreObject())
	end

	return React.createElement("Frame", {
		BackgroundColor3 = overMedia_0.Color3,
		BackgroundTransparency = overMedia_0.Transparency,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = p.Position,
		Visible = not (enabled and FFlagEnableConsoleExpControls) or v4 ~= nil
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, medium) }),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_100)
		}),
		LeftText = React.createElement("TextLabel", {
			Size = UDim2.fromOffset(v2.X, v2.Y),
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = color3,
			FontFace = normalizeFontFace(captionMedium.Font),
			TextSize = captionMedium.FontSize,
			TextWrapped = false,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}),
		Icon = React.createElement("ImageLabel", {
			Size = UDim2.fromOffset(size_600, size_600),
			BackgroundTransparency = 1,
			LayoutOrder = 100,
			Image = image
		}),
		RightText = React.createElement("TextLabel", {
			Size = UDim2.fromOffset(v3.X, v3.Y),
			Text = text2,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = color3,
			FontFace = normalizeFontFace(captionMedium.Font),
			TextSize = captionMedium.FontSize,
			TextWrapped = false,
			BackgroundTransparency = 1,
			LayoutOrder = 200
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_150),
			PaddingBottom = UDim.new(0, size_150),
			PaddingLeft = UDim.new(0, size_400),
			PaddingRight = UDim.new(0, size_400)
		})
	})
end

return MenuNavigationToggleDialog
