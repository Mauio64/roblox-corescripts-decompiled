local CoreGui = game:GetService("CoreGui")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local ReactRoblox = require(SduiSharedUtilitiesParent.ReactRoblox)
local React = require(SduiSharedUtilitiesParent.React)
local Foundation = require(SduiSharedUtilitiesParent.Foundation)
local Loading = Foundation.Loading
local useTokens = Foundation.Hooks.useTokens
local DataHydration = require(SduiSharedUtilitiesParent.DataHydration)
local ReactFocusNavigation = require(SduiSharedUtilitiesParent.ReactFocusNavigation)
local useDispatch = require(SduiSharedUtilitiesParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateBack = require(SduiSharedUtilitiesParent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(SduiSharedUtilitiesParent.RobloxAppNavigation).NavigationCommands
local useCloseWithBackButton = require(SduiSharedUtilitiesParent.AppBlox).useCloseWithBackButton
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiComponentWrapper = require(SduiSharedUtilitiesParent.SduiCoreSystem).getSduiComponentWrapper
local CompositionTags = require(SduiSharedUtilitiesParent.AppComposition).CompositionTags
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

require(SduiSharedUtilities.SduiLoadTimer)

local SduiPageNavigationHeader = require(SduiSharedUtilities.SduiPageNavigationHeader)
local useCreateClientBindingSduiContext = require(SduiSharedUtilities.useCreateClientBindingSduiContext)
local NavButtonType = require(SduiSharedUtilities.SduiIntegrationTypes).NavButtonType
local SduiPageErrorState = require(SduiSharedUtilities.SduiPageErrorState)
local DataHydrationTypes = DataHydration.DataHydrationTypes
local usePageEntrySnackbar = require(SduiSharedUtilities.usePageEntrySnackbar)
local useComponentLifecycleTiming = require(SduiSharedUtilities.hooks.useComponentLifecycleTiming)
local useLocalAnalyticsData = require(SduiSharedUtilities.hooks.useLocalAnalyticsData)
local useStatefulRef = require(SduiSharedUtilities.hooks.useStatefulRef)
local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useUiStatus = require(SduiSharedUtilities.hooks.useUiStatus)
local useDataUpdatedTimestamp = require(SduiSharedUtilities.hooks.useDataUpdatedTimestamp)
local UiStatus = require(SduiSharedUtilities.SduiIntegrationTypes).UiStatus
local Snackbar = Foundation.Snackbar
local FFlagLuaAppSduiPageEntryPointSnackbar = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiPageEntryPointSnackbar
local FFlagSduiExperienceDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiPageEntryUseSharedHooks = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntryUseSharedHooks
local FFlagSduiUseSharedUiStatusHook = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUseSharedUiStatusHook
local FFlagSduiChartsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiChartsSupport
local FFlagLuaAppSduiPageEntryScrollAway = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiPageEntryScrollAway

local function SduiPageEntryPoint(t1: {[any]: any}, p1) -- line: 135
	-- upvalues: useTokens (copy), useDispatch (copy), FFlagSduiPageEntryUseSharedHooks (copy), useComponentConfig (copy), React (copy), getSduiApiStore (copy), SignalsReact (copy), FFlagSduiUseSharedUiStatusHook (copy), useUiStatus (copy), UiStatus (copy), DataHydrationTypes (copy), useComponentLifecycleTiming (copy), useLocalAnalyticsData (copy), useStatefulRef (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateBack (copy), ReactFocusNavigation (copy), useCloseWithBackButton (copy), FFlagLuaAppSduiPageEntryPointSnackbar (copy), usePageEntrySnackbar (copy), FFlagSduiChartsSupport (copy), useDataUpdatedTimestamp (copy), useCreateClientBindingSduiContext (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiComponentWrapper (copy), SduiPageNavigationHeader (copy), CompositionTags (copy), NavButtonType (copy), FFlagLuaAppSduiPageEntryScrollAway (copy), Foundation (copy), Loading (copy), SduiPageErrorState (copy), ReactRoblox (copy), Snackbar (copy), CoreGui (copy)
	local appPage = t1.appPage
	local v45 = t1.configKey or appPage
	local v46 = `SduiPageEntryPoint-{ v45 }`
	local pageTimer = t1.pageTimer
	local v48 = useTokens()
	local v49 = useDispatch()
	local u50

	if FFlagSduiPageEntryUseSharedHooks then
		u50 = useComponentConfig(v45, t1.identifier)
	else
		local v51 = React.useCallback(function(p2) -- line: 149
			-- upvalues: getSduiApiStore (copy), v45 (copy), t1 (copy)
			return getSduiApiStore().getRootConfig(v45, p2, t1.identifier)
		end, {
			v45,
			t1.identifier
		})

		u50 = SignalsReact.useSignalState(v51)
	end

	local v52 = React.useCallback(function(p3) -- line: 156
		-- upvalues: getSduiApiStore (copy), v45 (copy)
		return getSduiApiStore().getTitle(v45, p3)
	end, { v45 })
	local v53 = SignalsReact.useSignalState(v52) or t1.pageTitle
	local v55, v56

	if FFlagSduiUseSharedUiStatusHook then
		local v54 = useUiStatus(v45)

		v55 = v54 == UiStatus.Loading
		v56 = v54 == UiStatus.Error
	else
		local v57 = SignalsReact.useSignalState(getSduiApiStore().getData(v45).status)

		v55 = v57 == DataHydrationTypes.DataStatus.NotReady
		v56 = v57 == DataHydrationTypes.DataStatus.Failed
	end

	if FFlagSduiPageEntryUseSharedHooks then
		useComponentLifecycleTiming(pageTimer, typeof(u50) == "table")
	else
		React.useEffect(function() -- line: 176
			-- upvalues: pageTimer (copy)
			if pageTimer then
				pageTimer.logComponentMounted()
			end
		end, { pageTimer })
		React.useEffect(function() -- line: 182
			-- upvalues: pageTimer (copy), u50 (ref)
			if pageTimer and u50 then
				pageTimer.logComponentReady()
			end
		end, {
			pageTimer,
			u50
		})
	end

	local v58 = if not FFlagSduiPageEntryUseSharedHooks then React.useMemo(function() -- line: 191
		-- upvalues: v45 (copy), appPage (copy)
		return {
			configKey = v45,
			appPage = appPage
		}
	end, {
		v45,
		appPage
	}) else useLocalAnalyticsData(v45, appPage, t1.additionalAnalyticsData)
	local v59, v60

	if FFlagSduiPageEntryUseSharedHooks then
		v59, v60 = useStatefulRef(p1)
	else
		v59, v60 = React.useState(nil)
		React.useRef(v59).current = v59
	end

	local v61 = React.useCallback(function() -- line: 208
		-- upvalues: t1 (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v49 (copy), NavigateBack (copy)
		if t1.onCloseActivated then
			t1.onCloseActivated()

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v14.back()

			return
		end

		v49(NavigateBack())
	end, {
		v49,
		t1.onCloseActivated
	})
	local _, v63 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v60)
	local v64 = useCloseWithBackButton(v63, v61)
	local v65 = if not FFlagLuaAppSduiPageEntryPointSnackbar then nil else usePageEntrySnackbar(v45)
	local v66 = nil

	if FFlagSduiChartsSupport then
		v66 = useDataUpdatedTimestamp(v45, t1.identifier)
	end

	local v67, v68 = React.useState(nil)
	local v69 = useCreateClientBindingSduiContext(appPage, v67, nil, if not FFlagSduiChartsSupport then nil else v66, if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v45, nil, t1.routeName)
	local v70 = v59 == nil
	local v71 = React.useMemo(function() -- line: 245
		-- upvalues: u50 (ref), getSduiComponentWrapper (copy), React (copy), v46 (copy), v69 (copy), v58 (copy), t1 (copy), FFlagSduiChartsSupport (copy)
		if u50 == nil then
			return nil
		end

		local v75 = getSduiComponentWrapper(u50)

		return React.createElement(v75, {
			debugName = v46,
			componentConfig = u50,
			sduiContext = v69,
			localAnalyticsData = v58,
			extraLocalProps = {
				pageBottomPadding = t1.pageBottomPadding,
				scrollingFrameRef = t1.scrollingFrameRef,
				defaultContentTag = t1.contentTag,
				defaultStickyContentTag = if not FFlagSduiChartsSupport then nil else t1.stickyContentTag
			}
		})
	end, {
		u50,
		v46,
		v69,
		v58,
		t1.contentTag,
		if not FFlagSduiChartsSupport then nil else t1.stickyContentTag,
		t1.pageBottomPadding,
		t1.scrollingFrameRef
	})
	local v72 = t1.scrollingFrameRef ~= nil

	return React.createElement("Frame", {
		[React.Tag] = t1.layoutTag,
		Size = UDim2.new(1, 0, not v72 and 1 or 0, 0),
		AutomaticSize = if not v72 then nil else Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = not t1.backgroundStyle and 0 or t1.backgroundStyle.Transparency,
		BackgroundColor3 = if not t1.backgroundStyle then v48.Color.Surface.Surface_0.Color3 else t1.backgroundStyle.Color3,
		ref = v64,
		ClipsDescendants = not FFlagSduiExperienceDetailsSupport or (t1.clipsDescendantsOverride == nil or t1.clipsDescendantsOverride)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		PageTopPadding = if not FFlagSduiChartsSupport or (not t1.pageTopPadding or not (t1.pageTopPadding > 0)) then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, t1.pageTopPadding)
		}),
		PageHeader = if not v70 then if not t1.includeNavigationHeaderBar then nil else React.createElement(SduiPageNavigationHeader, {
			layoutOrder = 1,
			title = v53,
			contentTag = t1.headerContentTag or CompositionTags.ContentRegion.Header,
			renderUtilities = t1.renderUtilities,
			navButtonType = t1.navButtonType or NavButtonType.back,
			closeCallback = v61,
			scrollAwayHeader = if not FFlagLuaAppSduiPageEntryScrollAway then nil else t1.scrollAwayHeader
		}) else nil,
		PageBody = if not v55 then if not v56 then React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, not v72 and 1 or 0, 0),
			AutomaticSize = if not v72 then nil else Enum.AutomaticSize.Y,
			ref = v68
		}, {
			UIFlexItem = if not v72 then React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}) else nil,
			Content = if not v70 then v71 else nil
		}) else if not t1.errorSlot then React.createElement(SduiPageErrorState, {
			refresh = t1.refresh
		}) else t1.errorSlot else if not t1.loadingSlot then React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, 0)
		}, React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})) else t1.loadingSlot,
		SnackbarPortal = if not v65 or not v65.snackbarConfig then nil else ReactRoblox.createPortal({
			SduiSnackbarScreenGui = React.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				DisplayOrder = t1.snackbarPortalLayoutOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Snackbar = React.createElement(Snackbar, {
					title = v65.snackbarConfig.title,
					icon = v65.snackbarConfig.icon,
					Position = UDim2.new(0.5, 0, 1, -v48.Padding.XLarge),
					AnchorPoint = Vector2.new(0.5, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					onClose = v65.onDismiss
				})
			})
		}, CoreGui)
	})
end

if FFlagSduiPageEntryUseSharedHooks then
	return React.memo(React.forwardRef(SduiPageEntryPoint))
end

return React.memo(SduiPageEntryPoint)
