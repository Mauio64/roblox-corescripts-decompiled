local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local useTokens = Foundation.Hooks.useTokens
local useSlotItemCardBreakpoints = require("@luauforge/bundled/fuM").Hooks.useSlotItemCardBreakpoints

local module = require("@luauforge/bundled/gSi")

local module2 = require("@luauforge/deferred/gSj")
local module3 = require("@luauforge/deferred/gSn")

local v5 = if module then require("@luauforge/deferred/gSq") else require("@luauforge/deferred/gSr")
local module4 = require("@luauforge/deferred/gSs")
require("@luauforge/bundled/dHK")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module6 = require("@luauforge/bundled/dNQ")
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function ScalesPage(props, ref)
	local v6 = useTokens()
	local v7 = useAdaptiveScrolling()

	local v8 = useIsSpatial()
	local v9 = useSlotItemCardBreakpoints()

	local v10, v11 = React.useBinding(UDim2.new(0, 0, 1, 0))

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local v12 = useLocalization({
		headSize = "Feature.Avatar.Label.HeadSize",
		r6R15 = "Feature.Avatar.Label.R6R15"
	})

	local v13 = useSelector(selectAvatarType) == module6.AvatarType.R6

	local size_250 = v6.Size.Size_250
	local titleLarge = v6.Typography.TitleLarge

	local v14 = not (v7 and v7.scrollingEnabledBinding) or v7.scrollingEnabledBinding

	local v15 = React.useCallback(function(p2)
		local v16 = not v8 and 0 or v9.slotCardTotalHeight

		local v17 = size_250 * 2
		local v18 = p2.AbsoluteContentSize.Y + v17 + v16
		v11(UDim2.new(0, 0, 0, v18))
	end, { v11, size_250, v8, v9 })

	local function onScrollingFrameCanvasPositionChanged(p2)
		if props.onCanvasPositionChanged then
			props.onCanvasPositionChanged(p2)
		end

		if v7 and v7.onCanvasPositionChanged then
			v7.onCanvasPositionChanged(p2)
		end
	end

	local createElement = React.createElement
	local onScrollingFrameCanvasPositionChangedsByCanvasPosition = {
		["CanvasSize"] = nil,
		["CanvasSize"] = nil,
		["CanvasSize"] = nil,
		CanvasSize = v10,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y
	}

	if not props.enableNavigation then
		v14 = false
	end

	onScrollingFrameCanvasPositionChangedsByCanvasPosition.ScrollingEnabled = v14

	onScrollingFrameCanvasPositionChangedsByCanvasPosition.ref = ref
	onScrollingFrameCanvasPositionChangedsByCanvasPosition[React.Change.CanvasPosition] = onScrollingFrameCanvasPositionChanged
	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_250 * 2),
			PaddingLeft = UDim.new(0, v6.Size.Size_600),
			PaddingRight = UDim.new(0, v6.Size.Size_600)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, size_250),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			[React.Change.AbsoluteContentSize] = v15
		}),
		BodyWrappers = React.createElement(fitFrameVertical, {
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SelectionGroup = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			BodyTypeWrapper = React.createElement(module2, {
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				enableNavigation = props.enableNavigation,
				layoutOrder = 1,
				isDisabled = v13,
				ref = ref2
			}),
			BodySizeWrapper = React.createElement(module3, {
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				enableNavigation = props.enableNavigation,
				layoutOrder = 2,
				isDisabled = v13,
				ref = ref3
			})
		}),
		HeadSizeWrapper = 0,
		R6R15Wrapper = 0
	}

	local createElement3 = React.createElement
	local v19 = {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, v6.Size.Size_300),
		margin = roactFitComponents.Rect.quad(0, 0, v6.Size.Size_600, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local createElement4 = React.createElement
	local v21 = {
		Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
		BackgroundTransparency = 1,
		Text = v12.headSize,
		TextSize = titleLarge.FontSize,
		TextColor3 = v6.Color.Content.Default.Color3,
		TextTransparency = v6.Color.Content.Default.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		Font = 0,
		FontFace = 0
	}

	local v22 = if not foundationFontFaceMigration then titleLarge.Font else nil
	v21.Font = v22
	local v23 = if foundationFontFaceMigration then normalizeFontFace(titleLarge.Font) else nil
	v21.FontFace = v23
	children.HeadSizeWrapper = createElement3(fitFrameVertical, v19, {
		HeadSizeLabel = createElement4("TextLabel", v21),
		HeadSize = React.createElement(v5, {
			LayoutOrder = 2,
			lockNavigationCallback = props.lockNavigationCallback,
			unlockNavigationCallback = props.unlockNavigationCallback,
			isDisabled = v13,
			ref = ref4
		})
	})

	local createElement5 = React.createElement
	local v25 = {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, v6.Size.Size_300),
		margin = roactFitComponents.Rect.quad(0, 0, v6.Size.Size_600, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		BackgroundTransparency = 1,
		LayoutOrder = 4
	}

	local createElement6 = React.createElement
	local v27 = {
		Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
		BackgroundTransparency = 1,
		Text = v12.r6R15,
		TextSize = titleLarge.FontSize,
		TextColor3 = v6.Color.Content.Default.Color3,
		TextTransparency = v6.Color.Content.Default.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		Font = 0,
		FontFace = 0
	}

	local v28 = if not foundationFontFaceMigration then titleLarge.Font else nil
	v27.Font = v28
	local v29 = if foundationFontFaceMigration then normalizeFontFace(titleLarge.Font) else nil
	v27.FontFace = v29
	children.R6R15Wrapper = createElement5(fitFrameVertical, v25, {
		R6R15Label = createElement6("TextLabel", v27),
		AvatarTypeSwitch = React.createElement(module4, { LayoutOrder = 2, ref = ref5 })
	})
	return createElement("ScrollingFrame", onScrollingFrameCanvasPositionChangedsByCanvasPosition, children)
end

return React.memo(React.forwardRef(ScalesPage))
