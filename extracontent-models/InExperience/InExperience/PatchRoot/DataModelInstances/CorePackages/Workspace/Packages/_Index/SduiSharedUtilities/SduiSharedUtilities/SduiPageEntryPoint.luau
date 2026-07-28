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
local FFlagSduiPageEntryPointResolvedSlot = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntryPointResolvedSlot
local FFlagSduiUseSharedUiStatusHook = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUseSharedUiStatusHook
local FFlagSduiChartsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiChartsSupport
local FFlagLuaAppSduiPageEntryScrollAway = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiPageEntryScrollAway
local FFlagSduiSrpScrollAway = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiSrpScrollAway

local function SduiPageEntryPoint(t1: {[any]: any}, p1) -- line: 139
	-- upvalues: useTokens (copy), useDispatch (copy), FFlagSduiPageEntryUseSharedHooks (copy), useComponentConfig (copy), React (copy), getSduiApiStore (copy), SignalsReact (copy), FFlagSduiUseSharedUiStatusHook (copy), useUiStatus (copy), UiStatus (copy), DataHydrationTypes (copy), FFlagSduiPageEntryPointResolvedSlot (copy), useComponentLifecycleTiming (copy), useLocalAnalyticsData (copy), useStatefulRef (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateBack (copy), ReactFocusNavigation (copy), useCloseWithBackButton (copy), FFlagLuaAppSduiPageEntryPointSnackbar (copy), usePageEntrySnackbar (copy), FFlagSduiChartsSupport (copy), useDataUpdatedTimestamp (copy), useCreateClientBindingSduiContext (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiComponentWrapper (copy), FFlagSduiSrpScrollAway (copy), SduiPageNavigationHeader (copy), CompositionTags (copy), NavButtonType (copy), FFlagLuaAppSduiPageEntryScrollAway (copy), Foundation (copy), Loading (copy), SduiPageErrorState (copy), ReactRoblox (copy), Snackbar (copy), CoreGui (copy)
	local appPage = t1.appPage
	local v47 = t1.configKey or appPage
	local v48 = `SduiPageEntryPoint-{ v47 }`
	local pageTimer = t1.pageTimer
	local v50 = useTokens()
	local v51 = useDispatch()
	local u52

	if FFlagSduiPageEntryUseSharedHooks then
		u52 = useComponentConfig(v47, t1.identifier)
	else
		local v53 = React.useCallback(function(p2) -- line: 153
			-- upvalues: getSduiApiStore (copy), v47 (copy), t1 (copy)
			return getSduiApiStore().getRootConfig(v47, p2, t1.identifier)
		end, {
			v47,
			t1.identifier
		})

		u52 = SignalsReact.useSignalState(v53)
	end

	local v54 = React.useCallback(function(p3) -- line: 160
		-- upvalues: getSduiApiStore (copy), v47 (copy)
		return getSduiApiStore().getTitle(v47, p3)
	end, { v47 })
	local v55 = SignalsReact.useSignalState(v54) or t1.pageTitle
	local v57, v58

	if FFlagSduiUseSharedUiStatusHook then
		local v56 = useUiStatus(v47)

		v57 = v56 == UiStatus.Loading
		v58 = v56 == UiStatus.Error
	else
		local v59 = SignalsReact.useSignalState(getSduiApiStore().getData(v47).status)

		v57 = v59 == DataHydrationTypes.DataStatus.NotReady
		v58 = v59 == DataHydrationTypes.DataStatus.Failed
	end

	local v60 = FFlagSduiPageEntryPointResolvedSlot and (t1.resolvedSlot ~= nil and (not v57 and not v58))

	if FFlagSduiPageEntryUseSharedHooks then
		useComponentLifecycleTiming(pageTimer, typeof(u52) == "table" or FFlagSduiPageEntryPointResolvedSlot and v60)
	else
		React.useEffect(function() -- line: 187
			-- upvalues: pageTimer (copy)
			if pageTimer then
				pageTimer.logComponentMounted()
			end
		end, { pageTimer })
		React.useEffect(function() -- line: 194
			-- upvalues: pageTimer (copy), u52 (ref), FFlagSduiPageEntryPointResolvedSlot (copy), v60 (copy)
			if pageTimer and (u52 or FFlagSduiPageEntryPointResolvedSlot and v60) then
				pageTimer.logComponentReady()
			end
		end, {
			pageTimer,
			u52,
			if not FFlagSduiPageEntryPointResolvedSlot then nil else v60
		})
	end

	local v61 = if not FFlagSduiPageEntryUseSharedHooks then React.useMemo(function() -- line: 209
		-- upvalues: v47 (copy), appPage (copy)
		return {
			configKey = v47,
			appPage = appPage
		}
	end, {
		v47,
		appPage
	}) else useLocalAnalyticsData(v47, appPage, t1.additionalAnalyticsData)
	local v62, v63

	if FFlagSduiPageEntryUseSharedHooks then
		v62, v63 = useStatefulRef(p1)
	else
		v62, v63 = React.useState(nil)
		React.useRef(v62).current = v62
	end

	local v64 = React.useCallback(function() -- line: 226
		-- upvalues: t1 (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v51 (copy), NavigateBack (copy)
		if t1.onCloseActivated then
			t1.onCloseActivated()

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v14.back()

			return
		end

		v51(NavigateBack())
	end, {
		v51,
		t1.onCloseActivated
	})
	local _, v66 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v63)
	local v67 = useCloseWithBackButton(v66, v64)
	local v68 = if not FFlagLuaAppSduiPageEntryPointSnackbar then nil else usePageEntrySnackbar(v47)
	local v69 = nil

	if FFlagSduiChartsSupport then
		v69 = useDataUpdatedTimestamp(v47, t1.identifier)
	end

	local v70, v71 = React.useState(nil)
	local v72 = useCreateClientBindingSduiContext(appPage, v70, nil, if not FFlagSduiChartsSupport then nil else v69, if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v47, nil, t1.routeName)
	local v73 = v62 == nil
	local v74 = React.useMemo(function() -- line: 263
		-- upvalues: u52 (ref), getSduiComponentWrapper (copy), React (copy), v48 (copy), v72 (copy), v61 (copy), t1 (copy), FFlagSduiSrpScrollAway (copy), FFlagSduiChartsSupport (copy)
		if u52 == nil then
			return nil
		end

		local v78 = getSduiComponentWrapper(u52)

		return React.createElement(v78, {
			debugName = v48,
			componentConfig = u52,
			sduiContext = v72,
			localAnalyticsData = v61,
			extraLocalProps = {
				pageBottomPadding = t1.pageBottomPadding,
				scrollingFrameRef = t1.scrollingFrameRef,
				onScrollDirectionChanged = if not FFlagSduiSrpScrollAway then nil else t1.onScrollDirectionChanged,
				defaultContentTag = t1.contentTag,
				defaultStickyContentTag = if not FFlagSduiChartsSupport then nil else t1.stickyContentTag
			}
		})
	end, {
		u52,
		v48,
		v72,
		v61,
		t1.contentTag,
		if not FFlagSduiChartsSupport then nil else t1.stickyContentTag,
		t1.pageBottomPadding,
		t1.scrollingFrameRef,
		if not FFlagSduiSrpScrollAway then nil else t1.onScrollDirectionChanged
	})
	local v75 = t1.scrollingFrameRef ~= nil

	return React.createElement("Frame", {
		[React.Tag] = t1.layoutTag,
		Size = UDim2.new(1, 0, not v75 and 1 or 0, 0),
		AutomaticSize = if not v75 then nil else Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = not t1.backgroundStyle and 0 or t1.backgroundStyle.Transparency,
		BackgroundColor3 = if not t1.backgroundStyle then v50.Color.Surface.Surface_0.Color3 else t1.backgroundStyle.Color3,
		ref = v67,
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
		PageHeader = if not v73 then if not t1.includeNavigationHeaderBar then nil else React.createElement(SduiPageNavigationHeader, {
			layoutOrder = 1,
			title = v55,
			contentTag = t1.headerContentTag or CompositionTags.ContentRegion.Header,
			renderUtilities = t1.renderUtilities,
			navButtonType = t1.navButtonType or NavButtonType.back,
			closeCallback = v64,
			scrollAwayHeader = if not FFlagLuaAppSduiPageEntryScrollAway then nil else t1.scrollAwayHeader
		}) else nil,
		PageBody = if not v57 then if not v58 then React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, not v75 and 1 or 0, 0),
			AutomaticSize = if not v75 then nil else Enum.AutomaticSize.Y,
			ref = v71
		}, {
			UIFlexItem = if not v75 then React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}) else nil,
			Content = if not v73 then if not FFlagSduiPageEntryPointResolvedSlot or not t1.resolvedSlot then v74 else t1.resolvedSlot else nil
		}) else if not t1.errorSlot then React.createElement(SduiPageErrorState, {
			refresh = t1.refresh
		}) else t1.errorSlot else if not t1.loadingSlot then React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, 0)
		}, React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})) else t1.loadingSlot,
		SnackbarPortal = if not v68 or not v68.snackbarConfig then nil else ReactRoblox.createPortal({
			SduiSnackbarScreenGui = React.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				DisplayOrder = t1.snackbarPortalLayoutOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Snackbar = React.createElement(Snackbar, {
					title = v68.snackbarConfig.title,
					icon = v68.snackbarConfig.icon,
					Position = UDim2.new(0.5, 0, 1, -v50.Padding.XLarge),
					AnchorPoint = Vector2.new(0.5, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					onClose = v68.onDismiss
				})
			})
		}, CoreGui)
	})
end

if FFlagSduiPageEntryUseSharedHooks then
	return React.memo(React.forwardRef(SduiPageEntryPoint))
end

return React.memo(SduiPageEntryPoint)
