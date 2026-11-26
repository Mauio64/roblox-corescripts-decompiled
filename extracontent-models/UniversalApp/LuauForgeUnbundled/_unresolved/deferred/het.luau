local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local useTokens = Foundation.Hooks.useTokens
local useSlotItemCardBreakpoints = require("@luauforge/bundled/fCn").Hooks.useSlotItemCardBreakpoints

local module = require("@luauforge/deferred/heu")
local module2 = require("@luauforge/deferred/hex")
local module3 = require("@luauforge/deferred/hez")
local module4 = require("@luauforge/deferred/heA")
require("@luauforge/bundled/dKT")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module6 = require("@luauforge/bundled/dRg")
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function ScalesPage(props, ref)
	local v5 = useTokens()
	local v6 = useAdaptiveScrolling()

	local v7 = useIsSpatial()
	local v8 = useSlotItemCardBreakpoints()

	local v9, v10 = React.useBinding(UDim2.new(0, 0, 1, 0))

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local v11 = useLocalization({
		headSize = "Feature.Avatar.Label.HeadSize",
		r6R15 = "Feature.Avatar.Label.R6R15"
	})

	local v12 = useSelector(selectAvatarType) == module6.AvatarType.R6

	local size_250 = v5.Size.Size_250
	local titleLarge = v5.Typography.TitleLarge

	local v13 = not (v6 and v6.scrollingEnabledBinding) or v6.scrollingEnabledBinding

	local v14 = React.useCallback(function(p2)
		local v15 = not v7 and 0 or v8.slotCardTotalHeight

		local v16 = size_250 * 2
		local v17 = p2.AbsoluteContentSize.Y + v16 + v15
		v10(UDim2.new(0, 0, 0, v17))
	end, { v10, size_250, v7, v8 })

	local function onScrollingFrameCanvasPositionChanged(p2)
		if props.onCanvasPositionChanged then
			props.onCanvasPositionChanged(p2)
		end

		if v6 and v6.onCanvasPositionChanged then
			v6.onCanvasPositionChanged(p2)
		end
	end

	local createElement = React.createElement
	local onScrollingFrameCanvasPositionChangedsByCanvasPosition = {
		["CanvasSize"] = nil,
		["CanvasSize"] = nil,
		["CanvasSize"] = nil,
		CanvasSize = v9,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y
	}

	if not props.enableNavigation then
		v13 = false
	end

	onScrollingFrameCanvasPositionChangedsByCanvasPosition.ScrollingEnabled = v13

	onScrollingFrameCanvasPositionChangedsByCanvasPosition.ref = ref
	onScrollingFrameCanvasPositionChangedsByCanvasPosition[React.Change.CanvasPosition] = onScrollingFrameCanvasPositionChanged
	return createElement("ScrollingFrame", onScrollingFrameCanvasPositionChangedsByCanvasPosition, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_250 * 2),
			PaddingLeft = UDim.new(0, v5.Size.Size_600),
			PaddingRight = UDim.new(0, v5.Size.Size_600)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, size_250),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			[React.Change.AbsoluteContentSize] = v14
		}),
		BodyWrappers = React.createElement(fitFrameVertical, {
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SelectionGroup = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			BodyTypeWrapper = React.createElement(module, {
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				enableNavigation = props.enableNavigation,
				layoutOrder = 1,
				isDisabled = v12,
				ref = ref2
			}),
			BodySizeWrapper = React.createElement(module2, {
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				enableNavigation = props.enableNavigation,
				layoutOrder = 2,
				isDisabled = v12,
				ref = ref3
			})
		}),
		HeadSizeWrapper = React.createElement(fitFrameVertical, {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, v5.Size.Size_300),
			margin = roactFitComponents.Rect.quad(0, 0, v5.Size.Size_600, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}, {
			HeadSizeLabel = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
				BackgroundTransparency = 1,
				Text = v11.headSize,
				TextSize = titleLarge.FontSize,
				TextColor3 = v5.Color.Content.Default.Color3,
				TextTransparency = v5.Color.Content.Default.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				FontFace = normalizeFontFace(titleLarge.Font)
			}),
			HeadSize = React.createElement(module3, {
				LayoutOrder = 2,
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				isDisabled = v12,
				ref = ref4
			})
		}),
		R6R15Wrapper = React.createElement(fitFrameVertical, {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, v5.Size.Size_300),
			margin = roactFitComponents.Rect.quad(0, 0, v5.Size.Size_600, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			BackgroundTransparency = 1,
			LayoutOrder = 4
		}, {
			R6R15Label = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
				BackgroundTransparency = 1,
				Text = v11.r6R15,
				TextSize = titleLarge.FontSize,
				TextColor3 = v5.Color.Content.Default.Color3,
				TextTransparency = v5.Color.Content.Default.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				FontFace = normalizeFontFace(titleLarge.Font)
			}),
			AvatarTypeSwitch = React.createElement(module4, {
				LayoutOrder = 2,
				ref = ref5
			})
		})
	})
end

return React.memo(React.forwardRef(ScalesPage))
