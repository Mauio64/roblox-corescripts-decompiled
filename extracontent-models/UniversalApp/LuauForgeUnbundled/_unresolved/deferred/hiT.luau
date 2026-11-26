local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module = require("@luauforge/bundled/dKX")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module5 = require("@luauforge/deferred/hiU")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local getHeadShapeListHeight = module.Utils.getHeadShapeListHeight
local module6 = require("@luauforge/bundled/gJS")
local getFoundationMappedStyleTokens = module.Utils.getFoundationMappedStyleTokens

local headShapePicker = module.Features.HeadShapePicker
local module7 = require("@luauforge/bundled/gTf")
local module8 = require("@luauforge/bundled/fvR")
local module9 = require("@luauforge/deferred/hhY")
local module10 = require("@luauforge/deferred/hic")

local module11 = require("@luauforge/bundled/gTh")

local module12 = require("@luauforge/deferred/gRz")

local fFlagHeadRefinementFacialAnimationToggle = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagHeadRefinementFacialAnimationToggle
local module13 = require("@luauforge/bundled/dRs")
require("@luauforge/bundled/dKT")

local deviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local function selectGlobalGuiInset(p2)
	return p2.GlobalGuiInset
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function HeadRefinementPage(p2)
	local v5 = useDesignTokens()
	local v6 = useTokens()
	local foundationMappedStyleTokens = getFoundationMappedStyleTokens(v6)
	local v7 = useLocalization({
		topBarTitle = "Feature.Avatar.Label.HeadRefinement.Adjust.Title"
	})

	local v8 = useSelector(module6)
	local v9 = useSelector(selectGlobalGuiInset)

	local v10 = if v8 then deviceOrientationMode.Portrait else deviceOrientationMode.Landscape
	local v11 = useTopBarHeight()
	local v12 = foundationMappedStyleTokens.largeTileContainerSize * 4 + foundationMappedStyleTokens.tileListPaddingBetweenItems * 3 + foundationMappedStyleTokens.tileListPaddingLeft + foundationMappedStyleTokens.tileListPaddingRight

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v13, v14, v15, v16, v17 = module5()

	local v18 = useSelector(selectScreenSize)
	local headShapeListHeight = getHeadShapeListHeight({
		tokens = v6,
		itemCount = v13 and #v13 or 0,
		availableViewportHeight = v18.Y - v11 - v9.bottom
	})

	local function onBackButtonPressed()
		if module13() then
			p2.navigation.pop()
		else
			p2.navigation.navigate(avatarScreen.AvatarRefinement)
		end
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v19 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		defaultChild = ref
	}

	local v20 = {
		HeadRefinementPageTopBar = React.createElement(module8.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v7.topBarTitle,
			transparentBackground = true,
			leftItem = module8.makeBackButton(onBackButtonPressed),
			ref = ref,
			NextSelectionDown = ref2,
			ZIndex = 3
		}),
		RefinementNavBar = 0,
		HeadRefinementPageContainer = 0
	}
	local v21

	if v8 then
		local createElement2 = React.createElement
		local v22 = if module13() then module10 else module9
		v21 = createElement2(v22, {})
	end

	v20.RefinementNavBar = v21

	local createElement2 = React.createElement
	local v23 = {
		Size = UDim2.new(1, 0, 1, -v11 + v9.bottom),
		Position = UDim2.fromOffset(0, v11),
		BackgroundTransparency = 1
	}

	local v24 = {
		HeadRefinementPageSceneInteractionFrame = React.createElement(module7),
		HeadRefinementPageControlPanel = 0
	}
	local createElement3 = React.createElement
	local frame2 = focusable.Frame

	local v26 = if v8 then Vector2.new(0, 1) else Vector2.new(0, 0.5)

	local v27 = if v8 then UDim2.new(0, 0, 1, 0) else UDim2.new(0, v5.Size.Size_900, 0.5, 0)
	local v28 = if v8 then UDim2.new(1, 0, 0, 0) else UDim2.new(0, v12, 0, 0)
	local v25 = {
		BackgroundTransparency = 1,
		AnchorPoint = v26,
		Position = v27,
		Size = v28,
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 3
	}

	local createElement4 = React.createElement
	local v30 = focusable[headShapePicker]
	local v31 = {
		isUnsupported = v14,
		items = v13,
		orientation = v10,
		tileSize = v10 == deviceOrientationMode.Portrait and "small" or "large",
		isLoading = v15,
		containerRef = ref2,
		NextSelectionUp = ref,
		isFacialAnimationEnabled = 0,
		onFacialAnimationToggle = 0,
		headShapeListMaxHeight = 0
	}

	if not fFlagHeadRefinementFacialAnimationToggle then
		v16 = nil
	end

	v31.isFacialAnimationEnabled = v16

	if not fFlagHeadRefinementFacialAnimationToggle then
		v17 = nil
	end

	v31.onFacialAnimationToggle = v17

	if v10 ~= deviceOrientationMode.Landscape then
		headShapeListHeight = nil
	end

	v31.headShapeListMaxHeight = headShapeListHeight
	local v29 = {
		HeadShapePicker = createElement4(v30, v31),
		HeadRefinementPageBottomFiller = 0
	}

	local v32 = if v8 then React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v9.bottom),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency,
		ZIndex = 0
	}) else nil
	v29.HeadRefinementPageBottomFiller = v32
	v24.HeadRefinementPageControlPanel = createElement3(frame2, v25, v29)
	v20.HeadRefinementPageContainer = createElement2("Frame", v23, v24)
	return createElement(frame, v19, v20)
end

return (module12((module11(HeadRefinementPage))))
