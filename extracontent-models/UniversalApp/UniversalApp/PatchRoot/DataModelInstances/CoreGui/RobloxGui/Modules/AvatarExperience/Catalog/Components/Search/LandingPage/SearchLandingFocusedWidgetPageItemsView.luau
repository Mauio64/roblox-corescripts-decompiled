local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Common = Modules.AvatarExperience.Common
local NamedRefConstants = require(Common.NamedRefConstants)
local NamedRefsContext = require(Common.Context.NamedRefsContext)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local ResultsList = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsList)
local t1 = {
	[AvatarScreen.ProfilePictureEditorEmotes] = true,
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.Catalog] = true
}

local function ItemsView(t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy), NamedRefsContext (copy), useNavigation (copy), useStyle (copy), Signal (copy), useAvatarRoute (copy), usePrevious (copy), AvatarScreen (copy), t1 (copy), NamedRefConstants (copy), Focusable (copy), ResultsList (copy), Constants (copy)
	local v21 = React.useContext(NamedRefsContext)
	local v22 = useNavigation()
	local v23 = useStyle()
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = React.useMemo(function() -- line: 53
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v27 = useAvatarRoute()
	local v28 = usePrevious(v27)
	local v29, v30 = React.useState(false)

	React.useEffect(function() -- line: 61
		-- upvalues: v28 (copy), v27 (copy), AvatarScreen (copy), v29 (copy), v30 (copy), t1 (copy)
		if not v28 or not v27 then
			return
		end

		local v35 = if not v27 or not v27.opaque then nil else v27.opaque.name
		local v36 = if not v28 or not v28.opaque then nil else v28.opaque.name

		if v35 == AvatarScreen.SearchLandingFocusedWidgetPage and not v29 then
			v30(true)

			return
		end

		if v36 == AvatarScreen.SearchLandingFocusedWidgetPage and v35 and t1[v35] and v29 then
			v30(false)
		end
	end, {
		v28,
		v27,
		v22,
		v29
	})

	local Theme = v23.Theme
	local defaultChildRef = t2.defaultChildRef
	local NextSelectionUp = t2.NextSelectionUp
	local v34 = v21[AvatarScreen.SearchLandingFocusedWidgetPage .. NamedRefConstants.ItemsList]

	return React.createElement(Focusable.Frame, {
		BorderSizePixel = 0,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		Size = UDim2.new(1, 0, 1, 0),
		ref = defaultChildRef,
		restorePreviousChildFocus = v29,
		defaultChild = v24,
		NextSelectionRight = t2.NextSelectionRight
	}, {
		ResultsList = React.createElement(ResultsList, {
			fromSearch = false,
			showCloseIcon = false,
			frameRef = v34,
			navBarRef = v24,
			analyticsContext = Constants.AnalyticsContext[AvatarScreen.SearchLandingFocusedWidgetPage],
			searchUuid = t2.searchUuid,
			widgetRequestId = t2.searchUuid,
			scrollingFrameRef = v25,
			onCloseFocusedWidget = t2.onCloseFocusedWidget,
			onRetry = function() -- line: 107
			end,
			NextSelectionUp = NextSelectionUp,
			backToTopSignal = v26,
			multiTryOnBottomBarRef = t2.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs
		})
	})
end

return ItemsView
