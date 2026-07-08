local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")

CoreGui:WaitForChild("RobloxGui")

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.UIBlox)

local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local useEventConnection = ReactUtils.useEventConnection
local GetTextSize = require(CorePackages.Workspace.Packages.Style).GetTextSize
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local ParentParent = script.Parent.Parent.Parent.Parent
local Chrome = ParentParent.Parent.Chrome
local v13 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v14 = if not not FFlagEnableConsoleExpControls and not v13 then nil else require(ParentParent.Components.GamepadConnector)
local useObservableValue = require(Chrome.ChromeShared.Hooks.useObservableValue)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local FFlagLocalizeMenuNavigationToggleDialog = require(CoreGui.RobloxGui.Modules.TopBar.Flags.FFlagLocalizeMenuNavigationToggleDialog)

local function MenuNavigationToggleDialog(t1: {[any]: any}) -- line: 41
	-- upvalues: useDesignTokens (copy), FFlagLocalizeMenuNavigationToggleDialog (copy), UserInputService (copy), React (copy), LocalizationService (copy), useEventConnection (copy), Localization (copy), GetTextSize (copy), v13 (copy), FFlagEnableConsoleExpControls (copy), useObservableValue (copy), v14 (copy)
	local v20 = useDesignTokens()
	local CaptionMedium = v20.Typography.CaptionMedium
	local Size_400 = v20.Size.Size_400
	local Size_150 = v20.Size.Size_150
	local Medium = v20.Radius.Medium
	local Size_600 = v20.Size.Size_600
	local OverMedia_0 = v20.Color.OverMedia.OverMedia_0
	local EmphasisColor3 = v20.Color.Content.Emphasis.Color3
	local Size_100 = v20.Size.Size_100
	local v29 = (not FFlagLocalizeMenuNavigationToggleDialog or not game:GetEngineFeature("GetImageForKeyCode")) and "rbxasset://textures/ui/Controls/DesignSystem/ButtonSelect@2x.png" or UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)
	local u34, u35

	if FFlagLocalizeMenuNavigationToggleDialog then
		local v30, v31 = React.useState(LocalizationService.RobloxLocaleId)

		useEventConnection(LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"), function() -- line: 60
			-- upvalues: v31 (copy), LocalizationService (copy)
			v31(LocalizationService.RobloxLocaleId)
		end)

		local v32, v33 = React.useMemo(function() -- line: 70
			-- upvalues: Localization (copy), v30 (copy)
			local v40 = Localization.new(v30)
			local ok, result = pcall(v40.Format, v40, "CoreScripts.InGameMenu.VirtualCursorHintPreIcon")
			local ok2, result2 = pcall(v40.Format, v40, "CoreScripts.InGameMenu.VirtualCursorHintPostIcon")
			local v45 = not ok and "Some experiences require pressing" or result

			if ok2 then
				return v45, result2
			end

			return v45, "to toggle menu navigation"
		end, { v30 })

		u34 = v32
		u35 = v33
	else
		local _ = {
			VirtualCursorHintPreIcon = "Some experiences require pressing ",
			VirtualCursorHintPostIcon = " to toggle menu navigation"
		}

		u34 = "Some experiences require pressing "
		u35 = " to toggle menu navigation"
	end

	local v37, v38 = React.useMemo(function() -- line: 94
		-- upvalues: GetTextSize (copy), u34 (ref), CaptionMedium (copy), u35 (ref)
		return GetTextSize(u34, CaptionMedium.FontSize, CaptionMedium.Font, Vector2.new(1e999, 1e999)), (GetTextSize(u35, CaptionMedium.FontSize, CaptionMedium.Font, Vector2.new(1e999, 1e999)))
	end, {
		CaptionMedium.FontSize,
		CaptionMedium.Font,
		u34,
		u35
	})
	local v39 = nil

	if v13 then
		if FFlagEnableConsoleExpControls then
			v39 = useObservableValue(v14:getSelectedCoreObject())
		end
	else
		v39 = nil
	end

	return React.createElement("Frame", {
		BackgroundColor3 = OverMedia_0.Color3,
		BackgroundTransparency = OverMedia_0.Transparency,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = t1.Position,
		Visible = not v13 or (not FFlagEnableConsoleExpControls or v39 ~= nil)
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, Medium)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = if not FFlagLocalizeMenuNavigationToggleDialog then nil else UDim.new(0, Size_100)
		}),
		LeftText = React.createElement("TextLabel", {
			TextWrapped = false,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.fromOffset(v37.X, v37.Y),
			Text = u34,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = EmphasisColor3,
			Font = CaptionMedium.Font,
			TextSize = CaptionMedium.FontSize
		}),
		Icon = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 100,
			Size = UDim2.fromOffset(Size_600, Size_600),
			Image = v29
		}),
		RightText = React.createElement("TextLabel", {
			TextWrapped = false,
			BackgroundTransparency = 1,
			LayoutOrder = 200,
			Size = UDim2.fromOffset(v38.X, v38.Y),
			Text = u35,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = EmphasisColor3,
			Font = CaptionMedium.Font,
			TextSize = CaptionMedium.FontSize
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Size_150),
			PaddingBottom = UDim.new(0, Size_150),
			PaddingLeft = UDim.new(0, Size_400),
			PaddingRight = UDim.new(0, Size_400)
		})
	})
end

return MenuNavigationToggleDialog
