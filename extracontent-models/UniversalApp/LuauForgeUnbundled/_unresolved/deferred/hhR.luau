local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local focusable = RoactGamepad.Focusable
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local module4 = require("@luauforge/bundled/dAB")
local module5 = require("@luauforge/bundled/egx")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module6 = require("@luauforge/bundled/eie")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module7 = require("@luauforge/bundled/fCe")
local module8 = require("@luauforge/deferred/gLm")
local module9 = require("@luauforge/bundled/dPN")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local module10 = require("@luauforge/deferred/gQQ")
local module11 = require("@luauforge/deferred/gQN")
local module12 = require("@luauforge/deferred/gTM")

local module13 = require("@luauforge/deferred/hhS")
local module14 = require("@luauforge/deferred/hfo")
local module15 = require("@luauforge/deferred/gJK")
local module16 = require("@luauforge/deferred/gTt")
local module17 = require("@luauforge/deferred/gRz")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module18 = require("@luauforge/bundled/dRg")

local fullView = AvatarExperienceCommon.Enums.FullView

local module19 = require("@luauforge/bundled/dWo")
local module20 = require("@luauforge/bundled/dWn")
local module21 = require("@luauforge/deferred/gJW")

local mySharedAvatars = widgetConstants.ContextWidgets.MySharedAvatars

local function selectMySharedAvatarsApiFetchStatus(p2)
	return performFetch.GetStatus(p2, module18.GetMySharedAvatarsKey)
end

local function MySharedAvatarsPage(p2)
	local v5 = useNavigation()
	local ref = React.useRef(nil)
	local v6 = module10()

	local v7 = useAvatarRoute()
	local v8 = useDispatch()
	local v9 = module6(module5)
	local v10 = useSelector(selectMySharedAvatarsApiFetchStatus)
	local v11, v12 = module12()
	local v13 = v11 == fullView.SceneFullView
	local v14 = v11 == fullView.UIFullView

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local v15 = module11({ overlayClosedCallback = v6 })

	local v16 = React.useContext(module8)
	local v17 = RoactGamepad.useRefCache()

	local v18 = React.useCallback(function()
		v12((module7.getNewFullViewEnum(v11)))
	end, { v11, v12 })

	React.useEffect(function()
		if v10 == module4.NotStarted then
			sendAXCounterV2(module9.Counter.MySharedAvatars.ReloadTriggedInPage)
			v8(module21(v9))
		end
	end, { v10, v8, v9 })

	local v19 = useLocalization({
		mySharedAvatarsTooltip = "Feature.Avatar.Label.MyPostedAvatars.Tooltip"
	})

	React.useEffect(function()
		local v20 = {
			title = mySharedAvatars.Title,
			localizedTooltip = v19.mySharedAvatarsTooltip
		}

		v8(module20(mySharedAvatars.RequestId, mySharedAvatars.WidgetId, v20))

		return function()
			v8(module19(mySharedAvatars.RequestId))
		end
	end, { v8 })

	return React.createElement(
		"Frame",
		{ ref = v15, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		React.createElement(focusable.Frame, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ref = v16[avatarScreen.MySharedAvatars],
			defaultChild = ref6,
			restorePreviousChildFocus = false
		}, {
			NavigationEventsLogger = React.createElement(module15, {
				pageName = avatarScreen.MySharedAvatars
			}),
			AvatarExperienceView = React.createElement(module16, {
				allowAdaptiveScrolling = true,
				bottomBarEnabled = false,
				changeViewFunction = v18,
				isSceneFullView = v13,
				isUIFullView = v14,
				topBar = React.createElement(module14, {
					navigation = v5,
					avatarRoute = v7,
					showManageOutfitButton = true,
					overlayClosedCallback = v6,
					topBarRef = ref2,
					defaultChildRef = ref6,
					sceneUIContainerRef = ref3
				}),
				refinementButtonsRef = ref4,
				quickButtonsRef = ref5,
				ref = ref3,
				NextSelectionDown = ref6,
				NextSelectionLeft = ref2,
				defaultChildRef = ref6,
				multiTryOnBottomBarRef = ref,
				itemDetailsPeekViewRefs = v17
			}, {
				MySharedAvatarsItemsView = React.createElement(module13, {
					defaultChildRef = ref6,
					NextSelectionUp = ref2,
					NextSelectionRight = ref5,
					multiTryOnBottomBarRef = ref,
					itemDetailsPeekViewRefs = v17
				})
			})
		})
	)
end

return (module17(MySharedAvatarsPage))
