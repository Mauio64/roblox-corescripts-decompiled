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
local FFlagSduiPageEntryCustomSlots = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntryCustomSlots
local FFlagLuaAppSduiPageEntryScrollAway = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiPageEntryScrollAway

local function SduiPageEntryPoint(t1: {[any]: any}, p1) -- line: 136
	-- upvalues: useTokens (copy), useDispatch (copy), FFlagSduiPageEntryUseSharedHooks (copy), useComponentConfig (copy), React (copy), getSduiApiStore (copy), SignalsReact (copy), FFlagSduiUseSharedUiStatusHook (copy), useUiStatus (copy), UiStatus (copy), DataHydrationTypes (copy), useComponentLifecycleTiming (copy), useLocalAnalyticsData (copy), useStatefulRef (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateBack (copy), ReactFocusNavigation (copy), useCloseWithBackButton (copy), FFlagLuaAppSduiPageEntryPointSnackbar (copy), usePageEntrySnackbar (copy), FFlagSduiChartsSupport (copy), useDataUpdatedTimestamp (copy), useCreateClientBindingSduiContext (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiComponentWrapper (copy), SduiPageNavigationHeader (copy), CompositionTags (copy), NavButtonType (copy), FFlagLuaAppSduiPageEntryScrollAway (copy), FFlagSduiPageEntryCustomSlots (copy), Foundation (copy), Loading (copy), SduiPageErrorState (copy), ReactRoblox (copy), Snackbar (copy), CoreGui (copy)
	local appPage = t1.appPage
	local v46 = t1.configKey or appPage
	local v47 = `SduiPageEntryPoint-{ v46 }`
	local pageTimer = t1.pageTimer
	local v49 = useTokens()
	local v50 = useDispatch()
	local u51

	if FFlagSduiPageEntryUseSharedHooks then
		u51 = useComponentConfig(v46, t1.identifier)
	else
		local v52 = React.useCallback(function(p2) -- line: 150
			-- upvalues: getSduiApiStore (copy), v46 (copy), t1 (copy)
			return getSduiApiStore().getRootConfig(v46, p2, t1.identifier)
		end, {
			v46,
			t1.identifier
		})

		u51 = SignalsReact.useSignalState(v52)
	end

	local v53 = React.useCallback(function(p3) -- line: 157
		-- upvalues: getSduiApiStore (copy), v46 (copy)
		return getSduiApiStore().getTitle(v46, p3)
	end, { v46 })
	local v54 = SignalsReact.useSignalState(v53) or t1.pageTitle
	local v56, v57

	if FFlagSduiUseSharedUiStatusHook then
		local v55 = useUiStatus(v46)

		v56 = v55 == UiStatus.Loading
		v57 = v55 == UiStatus.Error
	else
		local v58 = SignalsReact.useSignalState(getSduiApiStore().getData(v46).status)

		v56 = v58 == DataHydrationTypes.DataStatus.NotReady
		v57 = v58 == DataHydrationTypes.DataStatus.Failed
	end

	if FFlagSduiPageEntryUseSharedHooks then
		useComponentLifecycleTiming(pageTimer, typeof(u51) == "table")
	else
		React.useEffect(function() -- line: 177
			-- upvalues: pageTimer (copy)
			if pageTimer then
				pageTimer.logComponentMounted()
			end
		end, { pageTimer })
		React.useEffect(function() -- line: 183
			-- upvalues: pageTimer (copy), u51 (ref)
			if pageTimer and u51 then
				pageTimer.logComponentReady()
			end
		end, {
			pageTimer,
			u51
		})
	end

	local v59 = if not FFlagSduiPageEntryUseSharedHooks then React.useMemo(function() -- line: 192
		-- upvalues: v46 (copy), appPage (copy)
		return {
			configKey = v46,
			appPage = appPage
		}
	end, {
		v46,
		appPage
	}) else useLocalAnalyticsData(v46, appPage, t1.additionalAnalyticsData)
	local v60, v61

	if FFlagSduiPageEntryUseSharedHooks then
		v60, v61 = useStatefulRef(p1)
	else
		v60, v61 = React.useState(nil)
		React.useRef(v60).current = v60
	end

	local v62 = React.useCallback(function() -- line: 209
		-- upvalues: t1 (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v50 (copy), NavigateBack (copy)
		if t1.onCloseActivated then
			t1.onCloseActivated()

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v14.back()

			return
		end

		v50(NavigateBack())
	end, {
		v50,
		t1.onCloseActivated
	})
	local _, v64 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v61)
	local v65 = useCloseWithBackButton(v64, v62)
	local v66 = if not FFlagLuaAppSduiPageEntryPointSnackbar then nil else usePageEntrySnackbar(v46)
	local v67 = nil

	if FFlagSduiChartsSupport then
		v67 = useDataUpdatedTimestamp(v46, t1.identifier)
	end

	local v68, v69 = React.useState(nil)
	local v70 = useCreateClientBindingSduiContext(appPage, v68, nil, if not FFlagSduiChartsSupport then nil else v67, if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v46, nil, t1.routeName)
	local v71 = v60 == nil
	local v72 = React.useMemo(function() -- line: 246
		-- upvalues: u51 (ref), getSduiComponentWrapper (copy), React (copy), v47 (copy), v70 (copy), v59 (copy), t1 (copy), FFlagSduiChartsSupport (copy)
		if u51 == nil then
			return nil
		end

		local v76 = getSduiComponentWrapper(u51)

		return React.createElement(v76, {
			debugName = v47,
			componentConfig = u51,
			sduiContext = v70,
			localAnalyticsData = v59,
			extraLocalProps = {
				pageBottomPadding = t1.pageBottomPadding,
				scrollingFrameRef = t1.scrollingFrameRef,
				defaultContentTag = t1.contentTag,
				defaultStickyContentTag = if not FFlagSduiChartsSupport then nil else t1.stickyContentTag
			}
		})
	end, {
		u51,
		v47,
		v70,
		v59,
		t1.contentTag,
		if not FFlagSduiChartsSupport then nil else t1.stickyContentTag,
		t1.pageBottomPadding,
		t1.scrollingFrameRef
	})
	local v73 = t1.scrollingFrameRef ~= nil

	return React.createElement("Frame", {
		[React.Tag] = t1.layoutTag,
		Size = UDim2.new(1, 0, not v73 and 1 or 0, 0),
		AutomaticSize = if not v73 then nil else Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = not t1.backgroundStyle and 0 or t1.backgroundStyle.Transparency,
		BackgroundColor3 = if not t1.backgroundStyle then v49.Color.Surface.Surface_0.Color3 else t1.backgroundStyle.Color3,
		ref = v65,
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
		PageHeader = if not v71 then if not t1.includeNavigationHeaderBar then nil else React.createElement(SduiPageNavigationHeader, {
			layoutOrder = 1,
			title = v54,
			contentTag = t1.headerContentTag or CompositionTags.ContentRegion.Header,
			renderUtilities = t1.renderUtilities,
			navButtonType = t1.navButtonType or NavButtonType.back,
			closeCallback = v62,
			scrollAwayHeader = if not FFlagLuaAppSduiPageEntryScrollAway then nil else t1.scrollAwayHeader
		}) else nil,
		PageBody = if not v56 then if not v57 then React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, not v73 and 1 or 0, 0),
			AutomaticSize = if not v73 then nil else Enum.AutomaticSize.Y,
			ref = v69
		}, {
			UIFlexItem = if not v73 then React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}) else nil,
			Content = if not v71 then v72 else nil
		}) else if not FFlagSduiPageEntryCustomSlots or not t1.errorSlot then React.createElement(SduiPageErrorState, {
			refresh = t1.refresh
		}) else t1.errorSlot else if not FFlagSduiPageEntryCustomSlots or not t1.loadingSlot then React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, 0)
		}, React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})) else t1.loadingSlot,
		SnackbarPortal = if not v66 or not v66.snackbarConfig then nil else ReactRoblox.createPortal({
			SduiSnackbarScreenGui = React.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				DisplayOrder = t1.snackbarPortalLayoutOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Snackbar = React.createElement(Snackbar, {
					title = v66.snackbarConfig.title,
					icon = v66.snackbarConfig.icon,
					Position = UDim2.new(0.5, 0, 1, -v49.Padding.XLarge),
					AnchorPoint = Vector2.new(0.5, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					onClose = v66.onDismiss
				})
			})
		}, CoreGui)
	})
end

if FFlagSduiPageEntryUseSharedHooks then
	return React.memo(React.forwardRef(SduiPageEntryPoint))
end

return React.memo(SduiPageEntryPoint)
