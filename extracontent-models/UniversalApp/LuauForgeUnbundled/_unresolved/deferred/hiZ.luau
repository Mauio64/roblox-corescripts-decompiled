local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")

local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useTopBarHeight
local useTokens = Foundation.Hooks.useTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module2 = require("@luauforge/bundled/egB")
local module3 = require("@luauforge/bundled/gJS")
local module4 = require("@luauforge/bundled/dPN")

local module5 = require("@luauforge/bundled/gTf")
local module6 = require("@luauforge/bundled/fvR")
local module7 = require("@luauforge/deferred/hic")
local module8 = require("@luauforge/deferred/het")

local module9 = require("@luauforge/deferred/gRz")

local fFlagAXFixBodyShapePortraitSliderFreeze = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixBodyShapePortraitSliderFreeze

local v5 = module4.PeekHeaderHeight + module4.MainNavHeight + module4.SubNavHeight

local function BodyShapePortraitPanel(props)
	return React.createElement(Foundation.View, { tag = "size-full-full", ZIndex = 2 }, {
		ScalesPageContainer = React.createElement(Foundation.ScrollView, {
			tag = "bg-surface-0 anchor-bottom-left position-bottom-left auto-xy",
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingEnabled = props.isSceneInteractionEnabled
			},
			Size = UDim2.new(1, 0, 0.4, 0)
		}, {
			ScalesPage = React.createElement(module8, {
				lockNavigationCallback = props.lockNavigationCallback,
				unlockNavigationCallback = props.unlockNavigationCallback,
				enableNavigation = props.isSceneInteractionEnabled
			})
		}),
		BodyShapePageBottomFiller = React.createElement(Foundation.View, {
			tag = "bg-surface-0 position-bottom-left",
			Size = UDim2.new(1, 0, 0, v5)
		})
	})
end

local function BodyShapePage()
	local v6 = useTokens()
	local state, setState = React.useState(true)

	local v7 = useSelector(module3)
	local v8 = useTopBarHeight()
	local v9 = useNavigation()
	local v10 = useLocalization({ title = "Feature.Avatar.Label.Title.BodyShape" })

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v11 = React.useCallback(function()
		setState(true)
	end, {})

	local v12 = React.useCallback(function()
		setState(false)
	end, {})

	local v13 = React.useCallback(module2(function()
		setState(true)
	end, 1), {})

	local v14 = React.useCallback(function()
		setState(false)

		v13()
	end, { v13 })

	local function onBackButtonPressed()
		v9.pop()
	end

	local function renderLandscapeBodyShapePanel()
		return React.createElement(focusable.Frame, {
			BackgroundColor3 = v6.Color.Surface.Surface_0.Color3,
			Position = UDim2.fromOffset(v6.Size.Size_2400, v8 + v6.Size.Size_500),
			Size = UDim2.new(0.5, -v6.Size.Size_2400, 0.8, 0),
			ZIndex = 2
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v6.Size.Size_200)
			}),
			ScalesPage = React.createElement(module8, {
				lockNavigationCallback = v12,
				unlockNavigationCallback = v11,
				enableNavigation = true,
				onCanvasPositionChanged = v14,
				NextSelectionUp = ref
			})
		})
	end

	local function renderPortraitBodyShapePanel()
		return React.createElement(Foundation.View, {
			tag = "size-full-full",
			ZIndex = 2
		}, {
			ScalesPageContainer = React.createElement(Foundation.ScrollView, {
				tag = "bg-surface-0 anchor-bottom-left position-bottom-left auto-xy",
				scroll = {
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y
				},
				Size = UDim2.new(1, 0, 0.4, 0),
				isDisabled = not state
			}, {
				ScalesPage = React.createElement(module8, {
					lockNavigationCallback = v12,
					unlockNavigationCallback = v11,
					enableNavigation = state
				})
			}),
			BodyShapePageBottomFiller = React.createElement(Foundation.View, {
				tag = "bg-surface-0 position-bottom-left",
				Size = UDim2.new(1, 0, 0, v5)
			})
		})
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v15 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		defaultChild = ref
	}

	local v16 = {
		BodyShapePageTopBar = React.createElement(module6.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v10.title,
			transparentBackground = true,
			leftItem = module6.makeBackButton(onBackButtonPressed),
			ref = ref,
			NextSelectionDown = ref2,
			ZIndex = 3
		}),
		RefinementControlBar = React.createElement(module7),
		BodyShapePageSceneInteractionFrame = 0,
		BodyShapePageControlPanel = 0
	}

	local v17 = if state then React.createElement(module5) else nil
	v16.BodyShapePageSceneInteractionFrame = v17
	local v18

	if v7 then
		if fFlagAXFixBodyShapePortraitSliderFreeze then
			v18 = React.createElement(BodyShapePortraitPanel, {
				isSceneInteractionEnabled = state,
				lockNavigationCallback = v12,
				unlockNavigationCallback = v11
			})
		else
			v18 = renderPortraitBodyShapePanel()
		end
	else
		v18 = renderLandscapeBodyShapePanel()
	end

	v16.BodyShapePageControlPanel = v18
	return createElement(frame, v15, v16)
end

return (module9(BodyShapePage))
