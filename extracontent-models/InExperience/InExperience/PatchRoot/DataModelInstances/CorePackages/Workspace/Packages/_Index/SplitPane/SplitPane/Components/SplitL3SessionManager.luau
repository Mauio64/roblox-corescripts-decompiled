local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local SignalsReact = require(parent.SignalsReact)
local SplitL3SessionHelper = require(script.Parent.Parent.Utils.SplitL3SessionHelper)
local SplitL3Store = require(script.Parent.Parent.Stores.SplitL3Store)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)

local function SplitL3SessionManagerActive(p): nil
	local store = SplitL3Store.getStore()
	local v = SignalsReact.useSignalState(store.getSplitL2SessionVersion)
	local v2 = SignalsReact.useSignalState(store.getPendingSplitSubPaneTag)
	local v3 = SignalsReact.useSignalState(store.getPendingSplitSubPaneDetail)
	local sessionService = p.sessionService

	React.useLayoutEffect(function()
		if sessionService == nil then
			return
		end

		SplitL3SessionHelper.applySplitSubPaneSession(sessionService, v2, v3)
	end, { v, v2, v3, sessionService })

	React.useEffect(function()
		if sessionService == nil or sessionService.SessionChangedSignal == nil then
			return
		end

		local sessionChangedSignalConnection = sessionService.SessionChangedSignal:connect(function()
			local store2 = SplitL3Store.getStore()
			SplitL3SessionHelper.applySplitSubPaneSession(
				sessionService,
				store2.getPendingSplitSubPaneTag(false),
				store2.getPendingSplitSubPaneDetail(false)
			)
		end)
		return function()
			sessionChangedSignalConnection:disconnect()
			SplitL3SessionHelper.applySplitSubPaneSession(sessionService, nil)
		end
	end, { sessionService })

	return nil
end

local function SplitL3SessionManager(p)
	local sessionService = p.sessionService
	local v = SignalsReact.useSignalState(SplitPaneStore.getStore().getIsBreakpointEnabled)
	local resolveEligibility = React.useContext(SplitPaneContext).resolveEligibility

	React.useLayoutEffect(function()
		if v or sessionService == nil then
			return
		end

		SplitL3SessionHelper.applySplitSubPaneSession(sessionService, nil)
	end, { v, sessionService })

	React.useLayoutEffect(function()
		if p.connectRouteSignal == nil then
			return
		end

		return SplitL3SessionHelper.subscribeToRouteSignal(p.connectRouteSignal, resolveEligibility)
	end, { p.connectRouteSignal, resolveEligibility })

	if v then
		return React.createElement(SplitL3SessionManagerActive, { sessionService = sessionService })
	end

	return nil
end

return roactServices.connect({ sessionService = AppSessionService })(SplitL3SessionManager)
