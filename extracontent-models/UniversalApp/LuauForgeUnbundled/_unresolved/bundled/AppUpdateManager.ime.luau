local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/eie")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appUpdateService = RoactServiceTags.AppUpdateService
local roactAnalytics = RoactServiceTags.RoactAnalytics

local handleUpdate = require("@luauforge/bundled/hWQ").HandleUpdate

local module4 = require("@luauforge/bundled/ggj")

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function AppUpdateManager(p2): nil
	local v5 = module2(roactAnalytics)
	local v6 = module2(appUpdateService)

	local v7 = useDispatch()
	local v8

	if fFlagUseSignalsForAuthenticationStatus then
		v8 = useSignalState(getAuthenticationStatusStore(false).getStatus)
	else
		v8 = useSelector(function(p3)
			return p3.AuthenticationStatus.status
		end)
	end

	React.useEffect(function()
		if v8 == module4.LOGGED_IN then
			handleUpdate(v7, v6, false, v5, "AppUpdateManager", function() end)
		end
	end, { v8, v6, v5 })

	return nil
end

return AppUpdateManager
