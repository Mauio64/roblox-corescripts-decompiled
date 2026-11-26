local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactServices").RoactServices
local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactServiceTags").AppSessionService
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact")
local SplitL3SessionHelper = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitL3SessionHelper")
local SplitL3Store = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitL3Store")
local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local SplitPaneContext = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Context/SplitPaneContext")

local function SplitL3SessionManagerActive(p2): nil
	local store = SplitL3Store.getStore()
	local v5 = SignalsReact.useSignalState(store.getSplitL2SessionVersion)
	local v6 = SignalsReact.useSignalState(store.getPendingSplitSubPaneTag)
	local v7 = SignalsReact.useSignalState(store.getPendingSplitSubPaneDetail)
	local sessionService = p2.sessionService

	React.useLayoutEffect(function()
		if sessionService == nil then
			return
		end

		SplitL3SessionHelper.applySplitSubPaneSession(sessionService, v6, v7)
	end, { v5, v6, v7, sessionService })

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

local function SplitL3SessionManager(p2)
	local sessionService = p2.sessionService
	local v5 = SignalsReact.useSignalState(SplitPaneStore.getStore().getIsBreakpointEnabled)
	local resolveEligibility = React.useContext(SplitPaneContext).resolveEligibility

	React.useLayoutEffect(function()
		if v5 or sessionService == nil then
			return
		end

		SplitL3SessionHelper.applySplitSubPaneSession(sessionService, nil)
	end, { v5, sessionService })

	React.useLayoutEffect(function()
		if p2.connectRouteSignal == nil then
			return
		end

		return SplitL3SessionHelper.subscribeToRouteSignal(p2.connectRouteSignal, resolveEligibility)
	end, { p2.connectRouteSignal, resolveEligibility })

	if v5 then
		return React.createElement(SplitL3SessionManagerActive, {
			sessionService = sessionService
		})
	end

	return nil
end

return roactServices.connect({ sessionService = appSessionService })(SplitL3SessionManager)
