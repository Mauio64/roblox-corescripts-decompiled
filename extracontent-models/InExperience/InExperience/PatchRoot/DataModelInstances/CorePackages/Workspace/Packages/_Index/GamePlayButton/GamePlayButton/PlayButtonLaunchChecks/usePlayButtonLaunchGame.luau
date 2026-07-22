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
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry
local VideoService = game:GetService("VideoService")

return function(p1, p2, p3, p4, p5, p6, t1: {[any]: any}?) -- line: 43
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppEventIngestService (copy), AppGame (copy), useSelector (copy), useDispatch (copy), FFlagLuaAppEnablePlayButtonThrottle (copy), React (copy), FIntLuaAppPlayButtonThrottleTimeSeconds (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), gamePlayIntent (copy), joinGamePlayButton (copy), FFlagLuaAppEnableStratusStreamingTestOnly (copy), FFlagLuaAppEnableStratusStreamingCheck (copy), VideoService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateToRoute (copy), IsVRAppBuild (copy), SplashScreenManager (copy), FFlagLuaAppFixLaunchGameSourceParam (copy), LaunchGame (copy), ReasonForNotVoteable (copy), ClearUserGameVotes (copy)
	local v40 = useRoactService(RoactAnalytics)
	local v41 = useRoactService(AppEventIngestService)
	local v42 = useRoactService(AppGame)
	local v43 = useSelector(function(p7) -- line: 56
		-- upvalues: p1 (copy)
		return p7.UserGameVotes[p1]
	end)
	local v44 = useDispatch()
	local v45 = if not FFlagLuaAppEnablePlayButtonThrottle then nil else React.useRef(0)

	return (React.useCallback(function(p8: ((...any) -> ...any)?, s1: string?) -- line: 64
		-- upvalues: FFlagLuaAppEnablePlayButtonThrottle (copy), v45 (copy), FIntLuaAppPlayButtonThrottleTimeSeconds (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), p2 (copy), p3 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), gamePlayIntent (copy), v41 (copy), p4 (copy), p1 (copy), t1 (copy), joinGamePlayButton (copy), v40 (copy), p5 (copy), FFlagLuaAppEnableStratusStreamingTestOnly (copy), FFlagLuaAppEnableStratusStreamingCheck (copy), VideoService (copy), AppPage (copy), p6 (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v44 (copy), NavigateToRoute (copy), IsVRAppBuild (copy), SplashScreenManager (copy), FFlagLuaAppFixLaunchGameSourceParam (copy), LaunchGame (copy), v42 (copy), v43 (copy), ReasonForNotVoteable (copy), ClearUserGameVotes (copy)
		if FFlagLuaAppEnablePlayButtonThrottle then
			local timestamp = tick()

			if timestamp - v45.current < FIntLuaAppPlayButtonThrottleTimeSeconds then
				return
			end

			v45.current = timestamp
		end

		if GetFFlagLuaAppEnableVirtualEventPlaceId() and (not p2 or not p3) or not GetFFlagLuaAppEnableVirtualEventPlaceId() and not p3 then
			return
		end

		if p8 ~= nil then
			if FFlagLuaAppDemoModePlayButtonTelemetry then
				p8(s1)
			else
				p8()
			end
		else
			gamePlayIntent(v41, "PlayButton", {
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
				rootPlaceId = tonumber(p3),
				referralSource = p4,
				universeId = p1,
				launchData = if not t1 or not t1.launchData then nil else t1.launchData,
				tileType = if not t1 then nil else t1.tileType,
				nativeAdData = if not t1 then nil else t1.nativeAdData,
				actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1
			})
		end

		joinGamePlayButton(v40.InfluxDb, "gamePlayIntent", {
			isUniversalApp = true,
			referralSource = p4,
			placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2,
			ctx = p5,
			actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1
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

				v44(NavigateToRoute(t2))

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

				v44(NavigateToRoute(t3))

				return
			end
		end

		if IsVRAppBuild() then
			SplashScreenManager.initialize(36)
			wait(0.3)
		end

		if FFlagLuaAppFixLaunchGameSourceParam then
			LaunchGame(if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2, p4, t1, v42, p6)
		else
			LaunchGame(if not GetFFlagLuaAppEnableVirtualEventPlaceId() then p3 else p2, p6, t1, v42)
		end

		if v43 and v43.reasonForNotVoteable == ReasonForNotVoteable.PlayGame then
			v44(ClearUserGameVotes(p1))
		end
	end, {
		v41,
		v40,
		v42,
		v43,
		p1,
		if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else p2,
		p3,
		p4,
		p5,
		t1,
		if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else v44,
		if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else p6
	}))
end
