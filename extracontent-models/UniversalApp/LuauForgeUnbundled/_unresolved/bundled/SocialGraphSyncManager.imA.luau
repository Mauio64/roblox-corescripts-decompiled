local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local module = require("@luauforge/bundled/imB")

local module2 = require("@luauforge/bundled/imH")
local useSelector = require("@luauforge/bundled/imI").Hooks.RoactRodux.useSelector
local useSignalState = require("@luauforge/bundled/imJ").useSignalState
local loginStatus = require("@luauforge/bundled/imK").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@luauforge/bundled/imF").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/imL").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

require("@luauforge/bundled/imM")
local useDispatch = require("@luauforge/bundled/imI").Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@luauforge/bundled/imN").useAppPolicy
local useRoactService = require("@luauforge/bundled/imO").useRoactService
local module3 = require("@luauforge/bundled/imP")
local roactNetworking = module3.RoactNetworking
local roactAnalytics = module3.RoactAnalytics

local fFlagChangeSocialGraphLifecycleEvent = require("@luauforge/bundled/imF").FFlagChangeSocialGraphLifecycleEvent

local function registerPlatformSocialGraphSync(p2, p3, p4)
	local function fn()
		module(p2, p3, p4)
	end

	if not v5 then
		return nil
	end

	module(p2, p3, p4)

	if fFlagChangeSocialGraphLifecycleEvent then
		return v5.OnUnhide:Connect(fn)
	end

	return v5.OnBecomeActive:Connect(fn)
end

local function useRegisterPlatformSocialGraphSync()
	local v6 = useRoactService(roactAnalytics)
	local v7 = useRoactService(roactNetworking)
	local v8 = useDispatch()

	local v9 = useSelector(function(p2)
		return { authenticationStatus = p2.AuthenticationStatus.status }
	end)

	local v11 = (if fFlagUseSignalsForAuthenticationStatus then useSignalState(getAuthenticationStatusStore(false).getStatus) else v9.authenticationStatus) == loginStatus.LOGGED_IN

	module2.useEffect(function()
		local v12 = if v11 then registerPlatformSocialGraphSync(v8, v7, v6) else nil

		return function()
			if v12 then
				v12:disconnect()
				v12 = nil
			end
		end
	end, { v11, v7, v6 })
end

local function SocialGraphSynchronizer(): nil
	useRegisterPlatformSocialGraphSync()
	return nil
end

local function SocialGraphSyncManager()
	if useAppPolicy(function(p2)
		return p2.getSocialGraphSyncEnabled()
	end) then
		return (module2.createElement(SocialGraphSynchronizer))
	end

	return nil
end

return SocialGraphSyncManager
