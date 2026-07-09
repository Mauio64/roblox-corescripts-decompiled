local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Common = Modules.AvatarExperience.Common
local NamedRefConstants = require(Common.NamedRefConstants)
local NamedRefsContext = require(Common.Context.NamedRefsContext)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local FetchMySharedAvatars = require(Modules.AvatarExperience.AvatarEditor.Thunks.FetchMySharedAvatars)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ResultsList = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsList)
local t1 = {
	[AvatarScreen.ProfilePictureEditorEmotes] = true,
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.Catalog] = true
}

local function ItemsView(t2: {[any]: any}) -- line: 51
	-- upvalues: React (copy), NamedRefsContext (copy), useNavigation (copy), useStyle (copy), Signal (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useAvatarRoute (copy), usePrevious (copy), AvatarScreen (copy), t1 (copy), NamedRefConstants (copy), FetchMySharedAvatars (copy), NavigationUtils (copy), Focusable (copy), ResultsList (copy), Constants (copy), WidgetConstants (copy)
	local v28 = React.useContext(NamedRefsContext)
	local v29 = useNavigation()
	local v30 = useStyle()
	local v31 = React.useRef(nil)
	local v32 = React.useRef(nil)
	local v33 = React.useMemo(function() -- line: 58
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v34 = useDispatch()
	local v35 = useRoactService(RoactNetworking)
	local v36 = useAvatarRoute()
	local v37 = usePrevious(v36)
	local v38, v39 = React.useState(false)

	React.useEffect(function() -- line: 68
		-- upvalues: v37 (copy), v36 (copy), AvatarScreen (copy), v38 (copy), v39 (copy), t1 (copy)
		if not v37 or not v36 then
			return
		end

		local v46 = v36.opaque and v36.opaque.name
		local v47 = v37.opaque and v37.opaque.name

		if v46 == AvatarScreen.MySharedAvatars and not v38 then
			v39(true)

			return
		end

		if v47 == AvatarScreen.MySharedAvatars and t1[v46] and v38 then
			v39(false)
		end
	end, {
		v37,
		v36,
		v29,
		v38
	})

	local Theme = v30.Theme
	local defaultChildRef = t2.defaultChildRef
	local NextSelectionUp = t2.NextSelectionUp
	local v43 = v28[AvatarScreen.MySharedAvatars .. NamedRefConstants.ItemsList]
	local v44 = React.useCallback(function() -- line: 92
		-- upvalues: v34 (copy), FetchMySharedAvatars (copy), v35 (copy)
		v34(FetchMySharedAvatars(v35))
	end, {
		v34,
		v35
	})
	local v45 = React.useCallback(function() -- line: 96
		-- upvalues: NavigationUtils (copy), v29 (copy), AvatarScreen (copy)
		NavigationUtils.closeMySharedAvatars(v29)
		v29.navigate(AvatarScreen.AvatarEditor)
	end, { v29 })

	return React.createElement(Focusable.Frame, {
		BorderSizePixel = 0,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		Size = UDim2.new(1, 0, 1, 0),
		ref = defaultChildRef,
		restorePreviousChildFocus = v38,
		defaultChild = v31,
		NextSelectionRight = t2.NextSelectionRight
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		ResultsList = React.createElement(ResultsList, {
			fromSearch = false,
			layoutOrder = 2,
			showCloseIcon = true,
			frameRef = v43,
			navBarRef = v31,
			analyticsContext = Constants.AnalyticsContext[AvatarScreen.MySharedAvatars],
			searchUuid = WidgetConstants.ContextWidgets.MySharedAvatars.RequestId,
			scrollingFrameRef = v32,
			onCloseFocusedWidget = v45,
			onRetry = v44,
			NextSelectionUp = NextSelectionUp,
			backToTopSignal = v33,
			multiTryOnBottomBarRef = t2.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs
		})
	})
end

return ItemsView
