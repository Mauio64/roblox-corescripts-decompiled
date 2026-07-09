local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local DualLayoutBackButton = require(Modules.LuaApp.Components.Authentication.DualLayoutBackButton)
local FitChildren = require(Modules.LuaApp.FitChildren)
local Alignment = require(Modules.LuaApp.Enum.Alignment)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function v19(p1) -- line: 27
	-- upvalues: useStyle (copy), useDesignTokens (copy), Alignment (copy), useUiModeInfo (copy), React (copy), UiMode (copy), DualLayoutBackButton (copy), FitChildren (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v21 = useStyle()
	local v22 = useDesignTokens()
	local Font = v21.Font
	local Theme = v21.Theme
	local children = p1.children
	local v26 = p1.ContentAlign or Alignment.Top
	local Size_1600 = v22.Size.Size_1600
	local Size_2000 = v22.Size.Size_2000
	local Size_800 = v22.Size.Size_800
	local v30 = v22.FontSize.FontSize_900 + Size_800
	local v31 = useUiModeInfo()
	local buttonRef = p1.buttonRef
	local t1 = {
		[Alignment.Top] = {
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		},
		[Alignment.Bottom] = {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1)
		}
	}
	local t2 = {
		Title = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			BackButton = if v31.uiMode ~= UiMode.VR then nil else React.createElement(DualLayoutBackButton, {
				navigateBack = p1.navigateBack
			}),
			TitleLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = p1.localized.title,
				TextSize = v22.FontSize.FontSize_900,
				Font = Font.Title.Font,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextColor3 = Theme.TextEmphasis.Color,
				Size = UDim2.new(1, 0, 1, 0)
			})
		}),
		AlignmentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.new(0.5, 0, 0, v30),
			Size = UDim2.new(1, 0, 1, -v30),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			Content = React.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				Position = t1[v26].Position,
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = FitChildren.FitAxis.Height,
				AnchorPoint = t1[v26].AnchorPoint
			}, { children })
		})
	}
	local v35 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(ScrollView, {
		BorderSizePixel = 0,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.None
		},
		Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.new(0, -v35.left, 0, -v35.top),
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.new(1, 0, 1, 0) else UDim2.new(1, v35.left + v35.right, 1, v35.top + v35.bottom),
		tag = (not FFlagEnableLeftNavOnConsole or v31.uiMode ~= UiMode.TenFoot) and "bg-action-subtle" or "bg-surface-0"
	}, {
		ContentFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, Size_1600, 0, Size_2000),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -(2 * Size_1600), 1, -(2 * Size_2000)),
			AnchorPoint = Vector2.new(0, 0),
			ref = buttonRef
		}, { t2 })
	})
end

return function(p2) -- line: 135
	-- upvalues: useLocalization (copy), React (copy), v19 (copy), Cryo (copy)
	local v37 = useLocalization({
		title = "Authentication.Login.Heading.LoginRoblox"
	})

	return React.createElement(v19, Cryo.Dictionary.join({
		localized = v37
	}, p2))
end
