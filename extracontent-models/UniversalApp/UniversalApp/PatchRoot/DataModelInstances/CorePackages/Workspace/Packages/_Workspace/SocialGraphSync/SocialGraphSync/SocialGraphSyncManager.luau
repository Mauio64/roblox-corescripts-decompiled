local AppLifecycleObserverService = nil

pcall(function() -- line: 2
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

local SocialGraphSync = script:FindFirstAncestor("SocialGraphSync")
local SocialGraphSyncParent = SocialGraphSync.Parent
local syncPlatformSocialGraph = require(SocialGraphSync.syncPlatformSocialGraph)
local React = require(SocialGraphSyncParent.React)
local useSelector = require(SocialGraphSyncParent.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(SocialGraphSyncParent.RobloxAppEnums).LoginStatus

require(SocialGraphSyncParent.AppCommonLib)

local useDispatch = require(SocialGraphSyncParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(SocialGraphSyncParent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(SocialGraphSyncParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(SocialGraphSyncParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local FFlagChangeSocialGraphLifecycleEvent = require(SocialGraphSyncParent.SharedFlags).FFlagChangeSocialGraphLifecycleEvent

local function registerPlatformSocialGraphSync(p1, p2, p3) -- line: 31
	-- upvalues: syncPlatformSocialGraph (copy), AppLifecycleObserverService (ref), FFlagChangeSocialGraphLifecycleEvent (copy)
	local function v22() -- line: 33
		-- upvalues: syncPlatformSocialGraph (copy), p1 (copy), p2 (copy), p3 (copy)
		syncPlatformSocialGraph(p1, p2, p3)
	end

	if AppLifecycleObserverService then
		syncPlatformSocialGraph(p1, p2, p3)

		if FFlagChangeSocialGraphLifecycleEvent then
			return AppLifecycleObserverService.OnUnhide:Connect(v22)
		end

		return AppLifecycleObserverService.OnBecomeActive:Connect(v22)
	end

	return nil
end
local function useRegisterPlatformSocialGraphSync() -- line: 54
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), RoactNetworking (copy), useDispatch (copy), useSelector (copy), LoginStatus (copy), React (copy), registerPlatformSocialGraphSync (copy)
	local v23 = useRoactService(RoactAnalytics)
	local v24 = useRoactService(RoactNetworking)
	local v25 = useDispatch()
	local v26 = useSelector(function(p4) -- line: 59
		return {
			authenticationStatus = p4.AuthenticationStatus.status
		}
	end).authenticationStatus == LoginStatus.LOGGED_IN

	React.useEffect(function() -- line: 68
		-- upvalues: v26 (copy), registerPlatformSocialGraphSync (copy), v25 (copy), v24 (copy), v23 (copy)
		local u28 = nil

		if v26 then
			u28 = registerPlatformSocialGraphSync(v25, v24, v23)
		end

		return function() -- line: 75
			-- upvalues: u28 (ref)
			if u28 then
				u28:disconnect()
				u28 = nil
			end
		end
	end, {
		v26,
		v24,
		v23
	})
end
local function SocialGraphSynchronizer() -- line: 84
	-- upvalues: useRegisterPlatformSocialGraphSync (copy)
	useRegisterPlatformSocialGraphSync()

	return nil
end
local function SocialGraphSyncManager() -- line: 89
	-- upvalues: useAppPolicy (copy), React (copy), SocialGraphSynchronizer (copy)
	if useAppPolicy(function(p5) -- line: 90
		return p5.getSocialGraphSyncEnabled()
	end) then
		return (React.createElement(SocialGraphSynchronizer))
	end

	return nil
end

return SocialGraphSyncManager
