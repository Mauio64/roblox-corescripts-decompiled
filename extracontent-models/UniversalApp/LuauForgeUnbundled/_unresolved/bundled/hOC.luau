local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)

local scrollView = Foundation.ScrollView
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module = require("@luauforge/bundled/hOD")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local alignment = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.Alignment

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local module3 = require("@luauforge/bundled/gxM")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module4 = require("@luauforge/bundled/dXA")

local function fn(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local theme = v5.Theme

	local children = props.children
	local contentAlign = props.ContentAlign or alignment.Top

	local size_1600 = v6.Size.Size_1600
	local size_2000 = v6.Size.Size_2000
	local size_800 = v6.Size.Size_800
	local v7 = v6.FontSize.FontSize_900 + size_800
	local v8 = useUiModeInfo()
	local buttonRef = props.buttonRef

	local v9 = {
		[alignment.Top] = {
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		},
		[alignment.Bottom] = {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1)
		}
	}

	local createElement = React.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1
	}

	local v13 = if v8.uiMode == uiMode.VR then React.createElement(module, {
		navigateBack = props.navigateBack
	}) else nil
	local children2 = {
		Title = createElement("Frame", v11, {
			BackButton = v13,
			TitleLabel = React.createElement("TextLabel", {
				Text = props.localized.title,
				TextSize = v6.FontSize.FontSize_900,
				FontFace = normalizeFontFace(v6.Typography.HeadingLarge.Font),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextColor3 = theme.TextEmphasis.Color,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			})
		}),
		AlignmentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0, v7),
			Size = UDim2.new(1, 0, 1, -v7),
			AnchorPoint = Vector2.new(0.5, 0),
			ZIndex = 2
		}, {
			Content = React.createElement(FitChildren.FitFrame, {
				Position = v9[contentAlign].Position,
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = FitChildren.FitAxis.Height,
				AnchorPoint = v9[contentAlign].AnchorPoint,
				BackgroundTransparency = 1
			}, { children })
		})
	}

	local v14 = useSignalState(module4.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(scrollView, {
		BorderSizePixel = 0,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = scrollBarVisibility.None
		},
		Position = UDim2.new(0, -v14.left, 0, -v14.top),
		Size = UDim2.new(1, v14.left + v14.right, 1, v14.top + v14.bottom),
		tag = v8.uiMode == uiMode.TenFoot and "bg-surface-0" or "bg-action-subtle"
	}, {
		ContentFrame = React.createElement("Frame", {
			Position = UDim2.new(0, size_1600, 0, size_2000),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -(2 * size_1600), 1, -(2 * size_2000)),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			ref = buttonRef
		}, { children2 })
	})
end

return function(p2)
	local v5 = module3({ title = "Authentication.Login.Heading.LoginRoblox" })

	return React.createElement(fn, Cryo.Dictionary.join({ localized = v5 }, p2))
end
