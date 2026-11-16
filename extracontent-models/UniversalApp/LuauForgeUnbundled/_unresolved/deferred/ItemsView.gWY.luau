local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local module2 = require("@luauforge/deferred/ggH")
local module3 = require("@luauforge/deferred/ggG")
local module4 = require("@luauforge/bundled/dMx")

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module5 = require("@luauforge/deferred/gTD")

local set = {
	[avatarScreen.ProfilePictureEditorEmotes] = true,
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.Catalog] = true
}

local function ItemsView(props)
	local v5 = React.useContext(module3)
	local v6 = useNavigation()
	local v7 = useStyle()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v8 = React.useMemo(function()
		return signal.new()
	end, {})
	local v9 = useAvatarRoute()
	local v10 = usePrevious(v9)

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not (v10 and v9) then
			return
		end

		local name = if v9 and v9.opaque then v9.opaque.name else nil
		local name2 = if v10 and v10.opaque then v10.opaque.name else nil

		if name == avatarScreen.SearchLandingFocusedWidgetPage and not state then
			setState(true)
		elseif name2 == avatarScreen.SearchLandingFocusedWidgetPage and name and set[name] and state then
			setState(false)
		end
	end, { v10, v9, v6, state })

	local theme = v7.Theme
	local defaultChildRef = props.defaultChildRef
	local nextSelectionUp = props.NextSelectionUp
	local v11 = v5[avatarScreen.SearchLandingFocusedWidgetPage .. module2.ItemsList]

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
		ResultsList = React.createElement(module5, {
			frameRef = v11,
			navBarRef = ref,
			analyticsContext = module4.AnalyticsContext[avatarScreen.SearchLandingFocusedWidgetPage],
			fromSearch = false,
			searchUuid = props.searchUuid,
			widgetRequestId = props.searchUuid,
			scrollingFrameRef = ref2,
			showCloseIcon = false,
			onCloseFocusedWidget = props.onCloseFocusedWidget,
			onRetry = function() end,
			NextSelectionUp = nextSelectionUp,
			backToTopSignal = v8,
			multiTryOnBottomBarRef = props.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs
		})
	})
end

return ItemsView
