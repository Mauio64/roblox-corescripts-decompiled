require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags")
local roactAnalytics = RoactServiceTags.RoactAnalytics
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appGame = RoactServiceTags.AppGame
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics")
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local joinGamePlayButton = DiscoveryAnalytics.Points.joinGamePlayButton
local GameVotesRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameVotesRodux")
local reasonForNotVoteable = GameVotesRodux.Enums.ReasonForNotVoteable
local clearUserGameVotes = GameVotesRodux.UserGameVotes.ClearUserGameVotes
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AppCommonLib").IsVRAppBuild
local splashScreenManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SplashScreenManager").SplashScreenManager
local launchGame = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameLaunch").LaunchGame
local fFlagDeferInExperienceRbxmDownload = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagDeferInExperienceRbxmDownload
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Dash")

local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId

local fFlagLuaAppEnableStratusStreamingTestOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppEnableStratusStreamingTestOnly
local fFlagLuaAppStratusPassUniverseId = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppStratusPassUniverseId

local navigateToRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Thunks.NavigateToRoute
local appPage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").AppPage
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppNavigation").NavigationCommands else nil

local fFlagLuaAppEnablePlayButtonThrottle = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppEnablePlayButtonThrottle
local fIntLuaAppPlayButtonThrottleTimeSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FIntLuaAppPlayButtonThrottleTimeSeconds
local fFlagLuaAppFixLaunchGameSourceParam = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppFixLaunchGameSourceParam
local fFlagLuaAppEnableStratusStreamingCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppEnableStratusStreamingCheck
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer

local VideoService = game:GetService("VideoService")

return function(universeId, p2, p3, referralSource, ctx, launchSource, extraParams)
	local v5 = useRoactService(roactAnalytics)
	local v6 = useRoactService(appEventIngestService)
	local v7 = useRoactService(appGame)

	local v8 = useSelector(function(p4)
		return p4.UserGameVotes[universeId]
	end)

	local v9 = useDispatch()

	local ref = if fFlagLuaAppEnablePlayButtonThrottle then React.useRef(0) else nil

	local useCallback = React.useCallback
	local function fn(callback, actionType, p4)
		if fFlagLuaAppEnablePlayButtonThrottle then
			local now = tick()

			if now - ref.current < fIntLuaAppPlayButtonThrottleTimeSeconds then
				return
			end

			ref.current = now
		end

		if
			getFFlagLuaAppEnableVirtualEventPlaceId() and not (p2 and p3)
			or not (getFFlagLuaAppEnableVirtualEventPlaceId() or p3)
		then
			return
		end

		if callback == nil then
			local v14 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
			local v13 = {
				placeId = v14,
				rootPlaceId = tonumber(p3),
				referralSource = referralSource,
				universeId = universeId,
				launchData = 0,
				tileType = 0,
				nativeAdData = 0,
				actionType = 0
			}

			local v15 = if extraParams and extraParams.launchData then extraParams.launchData else nil
			v13.launchData = v15
			local v16 = if extraParams then extraParams.tileType else nil
			v13.tileType = v16
			local v17 = if extraParams then extraParams.nativeAdData else nil
			v13.nativeAdData = v17
			v13.actionType = if fFlagLuaAppDemoModePlayButtonTelemetry then actionType else nil
			gamePlayIntent(v6, "PlayButton", v13)
		elseif fFlagLuaAppDemoModePlayButtonTelemetry then
			callback(actionType)
		else
			callback()
		end

		local influxDb = v5.InfluxDb
		local v12 = {
			isUniversalApp = true,
			referralSource = referralSource,
			placeId = 0,
			ctx = 0,
			actionType = 0
		}

		local v13 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
		v12.placeId = v13
		v12.ctx = ctx

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v12.actionType = actionType
		joinGamePlayButton(influxDb, "gamePlayIntent", v12)

		local cloudClientReservation = if fFlagLuaAppCloudClientPlayButtonOffer and p4 then p4.cloudClientReservation else nil

		if cloudClientReservation == nil then
			if fFlagLuaAppEnableStratusStreamingTestOnly then
				if fFlagLuaAppEnableStratusStreamingCheck then
					if VideoService:GameStreamingEnabled() then
						local v15 = {
							name = appPage.VideoServer,
							placeId = 0,
							universeId = 0,
							launchSource = 0,
							extraParams = 0
						}
						local v16 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
						v15.placeId = v16
						v15.universeId = if fFlagLuaAppStratusPassUniverseId then universeId else nil
						v15.launchSource = launchSource
						v15.extraParams = extraParams
						local v14 = { v15 }

						if fFlagSignalsNavP3Dispatch then
							navigationCommands.to(navigationCommands.fromLegacyPage(v14[#v14]))
						else
							v9(navigateToRoute(v14))
						end

						return
					end
				else
					local v15 = {
						name = appPage.VideoServer,
						placeId = 0,
						universeId = 0,
						launchSource = 0,
						extraParams = 0
					}
					local v16 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
					v15.placeId = v16
					v15.universeId = if fFlagLuaAppStratusPassUniverseId then universeId else nil
					v15.launchSource = launchSource
					v15.extraParams = extraParams
					local v14 = { v15 }

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage(v14[#v14]))
					else
						v9(navigateToRoute(v14))
					end

					return
				end
			end

			if isVRAppBuild() then
				splashScreenManager.initialize(36)
				wait(0.3)
			end

			if fFlagDeferInExperienceRbxmDownload then
				extraParams = Dash.join(extraParams or {}, {
					universeId = universeId
				})
			end

			if fFlagLuaAppFixLaunchGameSourceParam then
				local v15 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
				launchGame(v15, referralSource, extraParams, v7, launchSource)
			else
				local v15 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
				launchGame(v15, launchSource, extraParams, v7)
			end

			if v8 and v8.reasonForNotVoteable == reasonForNotVoteable.PlayGame then
				v9(clearUserGameVotes(universeId))
			end
		else
			local v15 = {
				name = appPage.VideoServer,
				placeId = 0,
				universeId = 0,
				launchSource = 0,
				extraParams = 0,
				reservationToken = 0,
				offerKind = 0
			}
			local v16 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else p3
			v15.placeId = v16
			v15.universeId = if fFlagLuaAppStratusPassUniverseId then universeId else nil
			v15.launchSource = launchSource
			v15.extraParams = extraParams
			v15.reservationToken = cloudClientReservation.reservationToken
			v15.offerKind = cloudClientReservation.offerKind
			local v14 = { v15 }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage(v14[#v14]))
			else
				v9(navigateToRoute(v14))
			end
		end
	end

	local v11 = if getFFlagLuaAppEnableVirtualEventPlaceId() then p2 else nil

	local v12 = extraParams
	local v13 = if fFlagLuaAppDemoModePlayButtonTelemetry then v9 else nil
	return (useCallback(fn, {
		v6,
		v5,
		v7,
		v8,
		universeId,
		v11,
		p3,
		referralSource,
		ctx,
		v12,
		v13,
		if fFlagLuaAppDemoModePlayButtonTelemetry then launchSource else nil
	}))
end
