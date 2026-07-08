local GamePlayButton = script:FindFirstAncestor("GamePlayButton")

require(GamePlayButton.PlayButtonTypes)

local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(GamePlayButtonParent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppGame = RoactServiceTags.AppGame
local RoactUtils = require(GamePlayButtonParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local DiscoveryAnalytics = require(GamePlayButtonParent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local joinGamePlayButton = DiscoveryAnalytics.Points.joinGamePlayButton
local GameVotesRodux = require(GamePlayButtonParent.GameVotesRodux)
local ReasonForNotVoteable = GameVotesRodux.Enums.ReasonForNotVoteable
local ClearUserGameVotes = GameVotesRodux.UserGameVotes.ClearUserGameVotes
local IsVRAppBuild = require(GamePlayButtonParent.AppCommonLib).IsVRAppBuild
local SplashScreenManager = require(GamePlayButtonParent.SplashScreenManager).SplashScreenManager
local LaunchGame = require(GamePlayButtonParent.GameLaunch).LaunchGame
local GetFFlagLuaAppEnableVirtualEventPlaceId = require(GamePlayButtonParent.SharedFlags).GetFFlagLuaAppEnableVirtualEventPlaceId
local FFlagLuaAppEnableStratusStreamingTestOnly = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppEnableStratusStreamingTestOnly
local NavigateToRoute = require(GamePlayButtonParent.NavigationRodux).Thunks.NavigateToRoute
local AppPage = require(GamePlayButtonParent.RobloxAppEnums).AppPage
local FFlagSignalsNavP3Dispatch = require(GamePlayButtonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(GamePlayButtonParent.RobloxAppNavigation).NavigationCommands
local FFlagLuaAppEnablePlayButtonThrottle = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppEnablePlayButtonThrottle
local FIntLuaAppPlayButtonThrottleTimeSeconds = require(GamePlayButtonParent.SharedFlags).FIntLuaAppPlayButtonThrottleTimeSeconds
local FFlagLuaAppFixLaunchGameSourceParam = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppFixLaunchGameSourceParam
local FFlagLuaAppEnableStratusStreamingCheck = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppEnableStratusStreamingCheck
local VideoService = game:GetService("VideoService")

return function(p1, p2, p3, p4, p5, p6, t1: {[any]: any}?) -- line: 42
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppEventIngestService (copy), AppGame (copy), useSelector (copy), useDispatch (copy), FFlagLuaAppEnablePlayButtonThrottle (copy), React (copy), FIntLuaAppPlayButtonThrottleTimeSeconds (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), gamePlayIntent (copy), joinGamePlayButton (copy), FFlagLuaAppEnableStratusStreamingTestOnly (copy), FFlagLuaAppEnableStratusStreamingCheck (copy), VideoService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateToRoute (copy), IsVRAppBuild (copy), SplashScreenManager (copy), FFlagLuaAppFixLaunchGameSourceParam (copy), LaunchGame (copy), ReasonForNotVoteable (copy), ClearUserGameVotes (copy)
	local v39 = useRoactService(RoactAnalytics)
	local v40 = useRoactService(AppEventIngestService)
	local v41 = useRoactService(AppGame)
	local v42 = useSelector(function(p7) -- line: 55
		-- upvalues: p1 (copy)
		return p7.UserGameVotes[p1]
	end)
	local v43 = useDispatch()
	local v44 = if not FFlagLuaAppEnablePlayButtonThrottle then nil else React.useRef(0)

	return (React.useCallback(function(p8: ((...any) -> ...any)?) -- line: 62
		-- upvalues: FFlagLuaAppEnablePlayButtonThrottle (copy), v44 (copy), FIntLuaAppPlayButtonThrottleTimeSeconds (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), p2 (copy), p3 (copy), gamePlayIntent (copy), v40 (copy), p4 (copy), p1 (copy), t1 (copy), joinGamePlayButton (copy), v39 (copy), p5 (copy), FFlagLuaAppEnableStratusStreamingTestOnly (copy), FFlagLuaAppEnableStratusStreamingCheck (copy), VideoService (copy), AppPage (copy), p6 (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v43 (copy), NavigateToRoute (copy), IsVRAppBuild (copy), SplashScreenManager (copy), FFlagLuaAppFixLaunchGameSourceParam (copy), LaunchGame (copy), v41 (copy), v42 (copy), ReasonForNotVoteable (copy), ClearUserGameVotes (copy)
		if FFlagLuaAppEnablePlayButtonThrottle then
			local timestamp = tick()

			if timestamp - v44.current < FIntLuaAppPlayButtonThrottleTimeSeconds then
				return
			end

			v44.current = timestamp
		end

		if GetFFlagLuaAppEnableVirtualEventPlaceId() and (not p2 or not p3) or not GetFFlagLuaAppEnableVirtualEventPlaceId() and not p3 then
			return
		end

		if p8 ~= nil then
			p8()
		else
			gamePlayIntent(v40, "PlayButton", {
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
				rootPlaceId = tonumber(p3),
				referralSource = p4,
				universeId = p1,
				launchData = if not t1 or not t1.launchData then nil else t1.launchData,
				tileType = if not t1 then nil else t1.tileType,
				nativeAdData = if not t1 then nil else t1.nativeAdData
			})
		end

		joinGamePlayButton(v39.InfluxDb, "gamePlayIntent", {
			isUniversalApp = true,
			referralSource = p4,
			placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
			ctx = p5
		})

		if FFlagLuaAppEnableStratusStreamingTestOnly then
			if not FFlagLuaAppEnableStratusStreamingCheck then
				local t2 = {{
					name = AppPage.VideoServer,
					placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
					launchSource = p6,
					extraParams = t1
				}}

				if FFlagSignalsNavP3Dispatch then
					v26.to(v26.fromLegacyPage(t2[#t2]))

					return
				end

				v43(NavigateToRoute(t2))

				return
			end

			if VideoService:GameStreamingEnabled() then
				local t3 = {{
					name = AppPage.VideoServer,
					placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
					launchSource = p6,
					extraParams = t1
				}}

				if FFlagSignalsNavP3Dispatch then
					v26.to(v26.fromLegacyPage(t3[#t3]))

					return
				end

				v43(NavigateToRoute(t3))

				return
			end
		end

		if IsVRAppBuild() then
			SplashScreenManager.initialize(36)
			wait(0.3)
		end

		if FFlagLuaAppFixLaunchGameSourceParam then
			LaunchGame(if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2, p4, t1, v41, p6)
		else
			LaunchGame(if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2, p6, t1, v41)
		end

		if v42 and v42.reasonForNotVoteable == ReasonForNotVoteable.PlayGame then
			v43(ClearUserGameVotes(p1))
		end
	end, {
		v40,
		v39,
		v41,
		v42,
		p1,
		if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else p2,
		p3,
		p4,
		p5,
		t1
	}))
end
