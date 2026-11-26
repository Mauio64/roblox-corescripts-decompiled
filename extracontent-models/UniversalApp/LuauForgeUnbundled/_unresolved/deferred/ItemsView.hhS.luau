local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module3 = require("@luauforge/bundled/eie")
local module4 = require("@luauforge/bundled/egx")

local module5 = require("@luauforge/deferred/gLn")
local module6 = require("@luauforge/deferred/gLm")
local module7 = require("@luauforge/bundled/dPN")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module8 = require("@luauforge/deferred/gJW")

local module9 = require("@luauforge/bundled/dXh")

local module10 = require("@luauforge/deferred/hfL")

local set = {
	[avatarScreen.ProfilePictureEditorEmotes] = true,
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.Catalog] = true
}

local function ItemsView(props)
	local v5 = React.useContext(module6)
	local v6 = useNavigation()
	local v7 = useStyle()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v8 = React.useMemo(function()
		return signal.new()
	end, {})
	local v9 = useDispatch()
	local v10 = module3(module4)
	local v11 = useAvatarRoute()
	local v12 = usePrevious(v11)

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not (v12 and v11) then
			return
		end

		local name = v11.opaque and v11.opaque.name
		local name2 = v12.opaque and v12.opaque.name

		if name == avatarScreen.MySharedAvatars and not state then
			setState(true)
		elseif name2 == avatarScreen.MySharedAvatars and set[name] and state then
			setState(false)
		end
	end, { v12, v11, v6, state })

	local theme = v7.Theme
	local defaultChildRef = props.defaultChildRef
	local nextSelectionUp = props.NextSelectionUp
	local v13 = v5[avatarScreen.MySharedAvatars .. module5.ItemsList]

	local v14 = React.useCallback(function()
		v9(module8(v10))
	end, { v9, v10 })

	local v15 = React.useCallback(function()
		module9.closeMySharedAvatars(v6)
		v6.navigate(avatarScreen.AvatarEditor)
	end, { v6 })

	return React.createElement(focusable.Frame, {
		BackgroundTransparency = theme.BackgroundDefault.Transparency or 1,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ref = defaultChildRef,
		restorePreviousChildFocus = state,
		defaultChild = ref,
		NextSelectionRight = props.NextSelectionRight
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		ResultsList = React.createElement(module10, {
			frameRef = v13,
			navBarRef = ref,
			analyticsContext = module7.AnalyticsContext[avatarScreen.MySharedAvatars],
			fromSearch = false,
			searchUuid = widgetConstants.ContextWidgets.MySharedAvatars.RequestId,
			layoutOrder = 2,
			scrollingFrameRef = ref2,
			showCloseIcon = true,
			onCloseFocusedWidget = v15,
			onRetry = v14,
			NextSelectionUp = nextSelectionUp,
			backToTopSignal = v8,
			multiTryOnBottomBarRef = props.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs
		})
	})
end

return ItemsView
