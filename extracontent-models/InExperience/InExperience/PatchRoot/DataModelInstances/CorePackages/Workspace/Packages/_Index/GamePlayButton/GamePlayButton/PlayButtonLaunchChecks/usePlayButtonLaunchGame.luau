local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
require(GamePlayButton.PlayButtonTypes)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppGame = RoactServiceTags.AppGame
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local joinGamePlayButton = DiscoveryAnalytics.Points.joinGamePlayButton
local GameVotesRodux = require(parent.GameVotesRodux)
local ReasonForNotVoteable = GameVotesRodux.Enums.ReasonForNotVoteable
local ClearUserGameVotes = GameVotesRodux.UserGameVotes.ClearUserGameVotes
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local SplashScreenManager = require(parent.SplashScreenManager)
local splashScreenManager = SplashScreenManager.SplashScreenManager
local GameLaunch = require(parent.GameLaunch)
local LaunchGame = GameLaunch.LaunchGame
local SharedFlags = require(parent.SharedFlags)
local FFlagDeferInExperienceRbxmDownload = SharedFlags.FFlagDeferInExperienceRbxmDownload
local Dash = require(parent.Dash)

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppEnableVirtualEventPlaceId = SharedFlags2.GetFFlagLuaAppEnableVirtualEventPlaceId

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEnableStratusStreamingTestOnly = SharedFlags3.FFlagLuaAppEnableStratusStreamingTestOnly
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppStratusPassUniverseId = SharedFlags4.FFlagLuaAppStratusPassUniverseId

local NavigationRodux = require(parent.NavigationRodux)
local NavigateToRoute = NavigationRodux.Thunks.NavigateToRoute
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags5.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppEnablePlayButtonThrottle = SharedFlags6.FFlagLuaAppEnablePlayButtonThrottle
local SharedFlags7 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonThrottleTimeSeconds = SharedFlags7.FIntLuaAppPlayButtonThrottleTimeSeconds
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppFixLaunchGameSourceParam = SharedFlags8.FFlagLuaAppFixLaunchGameSourceParam
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppEnableStratusStreamingCheck = SharedFlags9.FFlagLuaAppEnableStratusStreamingCheck
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags10.FFlagLuaAppDemoModePlayButtonTelemetry
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppCloudClientPlayButtonOffer = SharedFlags11.FFlagLuaAppCloudClientPlayButtonOffer

local VideoService = game:GetService("VideoService")

return function(universeId, p, p2, referralSource, ctx, launchSource, extraParams)
	local v = useRoactService(RoactAnalytics)
	local v2 = useRoactService(AppEventIngestService)
	local v3 = useRoactService(AppGame)

	local v4 = useSelector(function(p3)
		return p3.UserGameVotes[universeId]
	end)

	local v5 = useDispatch()
	local ref

	if FFlagLuaAppEnablePlayButtonThrottle then
		ref = React.useRef(0)
	else
		ref = nil
	end

	local useCallback = React.useCallback
	local function fn(callback, actionType: string?, p3)
		if FFlagLuaAppEnablePlayButtonThrottle then
			local now = tick()

			if now - ref.current < FIntLuaAppPlayButtonThrottleTimeSeconds then
				return
			end

			ref.current = now
		end

		if
			GetFFlagLuaAppEnableVirtualEventPlaceId() and not (p and p2)
			or not (GetFFlagLuaAppEnableVirtualEventPlaceId() or p2)
		then
			return
		end

		if callback == nil then
			local placeId

			if GetFFlagLuaAppEnableVirtualEventPlaceId() then
				placeId = p
			else
				placeId = p2
			end

			local v6 = {
				placeId = placeId,
				rootPlaceId = tonumber(p2),
				referralSource = referralSource,
				universeId = universeId,
				launchData = 0,
				tileType = 0,
				nativeAdData = 0,
				actionType = 0
			}
			local launchData

			if extraParams and extraParams.launchData then
				launchData = extraParams.launchData
			end

			v6.launchData = launchData
			local tileType

			if extraParams then
				tileType = extraParams.tileType
			end

			v6.tileType = tileType
			local nativeAdData

			if extraParams then
				nativeAdData = extraParams.nativeAdData
			end

			v6.nativeAdData = nativeAdData
			local actionType2

			if FFlagLuaAppDemoModePlayButtonTelemetry then
				actionType2 = actionType
			end

			v6.actionType = actionType2
			gamePlayIntent(v2, "PlayButton", v6)
		elseif FFlagLuaAppDemoModePlayButtonTelemetry then
			callback(actionType)
		else
			callback()
		end

		local influxDb = v.InfluxDb
		local v6 = {
			isUniversalApp = true,
			referralSource = referralSource,
			placeId = 0,
			ctx = 0,
			actionType = 0
		}
		local placeId

		if GetFFlagLuaAppEnableVirtualEventPlaceId() then
			placeId = p
		else
			placeId = p2
		end

		v6.placeId = placeId
		v6.ctx = ctx

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v6.actionType = actionType
		joinGamePlayButton(influxDb, "gamePlayIntent", v6)
		local cloudClientReservation

		if FFlagLuaAppCloudClientPlayButtonOffer and p3 then
			cloudClientReservation = p3.cloudClientReservation
		end

		if cloudClientReservation == nil then
			if FFlagLuaAppEnableStratusStreamingTestOnly then
				if FFlagLuaAppEnableStratusStreamingCheck then
					if VideoService:GameStreamingEnabled() then
						local v7 = {
							name = AppPage.VideoServer,
							placeId = 0,
							universeId = 0,
							launchSource = 0,
							extraParams = 0
						}
						local placeId2

						if GetFFlagLuaAppEnableVirtualEventPlaceId() then
							placeId2 = p
						else
							placeId2 = p2
						end

						v7.placeId = placeId2
						local universeId2

						if FFlagLuaAppStratusPassUniverseId then
							universeId2 = universeId
						end

						v7.universeId = universeId2
						v7.launchSource = launchSource
						v7.extraParams = extraParams
						local v8 = { v7 }

						if FFlagSignalsNavP3Dispatch then
							navigationCommands.to(navigationCommands.fromLegacyPage(v8[#v8]))
						else
							v5(NavigateToRoute(v8))
						end

						return
					end
				else
					local v7 = {
						name = AppPage.VideoServer,
						placeId = 0,
						universeId = 0,
						launchSource = 0,
						extraParams = 0
					}
					local placeId2

					if GetFFlagLuaAppEnableVirtualEventPlaceId() then
						placeId2 = p
					else
						placeId2 = p2
					end

					v7.placeId = placeId2
					local universeId2

					if FFlagLuaAppStratusPassUniverseId then
						universeId2 = universeId
					end

					v7.universeId = universeId2
					v7.launchSource = launchSource
					v7.extraParams = extraParams
					local v8 = { v7 }

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage(v8[#v8]))
					else
						v5(NavigateToRoute(v8))
					end

					return
				end
			end

			if IsVRAppBuild() then
				splashScreenManager.initialize(36)
				wait(0.3)
			end

			if FFlagDeferInExperienceRbxmDownload then
				extraParams = Dash.join(extraParams or {}, { universeId = universeId })
			end

			if FFlagLuaAppFixLaunchGameSourceParam then
				local v7

				if GetFFlagLuaAppEnableVirtualEventPlaceId() then
					v7 = p
				else
					v7 = p2
				end

				LaunchGame(v7, referralSource, extraParams, v3, launchSource)
			else
				local v7

				if GetFFlagLuaAppEnableVirtualEventPlaceId() then
					v7 = p
				else
					v7 = p2
				end

				LaunchGame(v7, launchSource, extraParams, v3)
			end

			if v4 and v4.reasonForNotVoteable == ReasonForNotVoteable.PlayGame then
				v5(ClearUserGameVotes(universeId))
			end
		else
			local v7 = {
				name = AppPage.VideoServer,
				placeId = 0,
				universeId = 0,
				launchSource = 0,
				extraParams = 0,
				reservationToken = 0,
				offerKind = 0
			}
			local placeId2

			if GetFFlagLuaAppEnableVirtualEventPlaceId() then
				placeId2 = p
			else
				placeId2 = p2
			end

			v7.placeId = placeId2
			local universeId2

			if FFlagLuaAppStratusPassUniverseId then
				universeId2 = universeId
			end

			v7.universeId = universeId2
			v7.launchSource = launchSource
			v7.extraParams = extraParams
			v7.reservationToken = cloudClientReservation.reservationToken
			v7.offerKind = cloudClientReservation.offerKind
			local v8 = { v7 }

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage(v8[#v8]))
			else
				v5(NavigateToRoute(v8))
			end
		end
	end

	local v6

	if GetFFlagLuaAppEnableVirtualEventPlaceId() then
		v6 = p
	end

	local v7 = extraParams
	local v8

	if FFlagLuaAppDemoModePlayButtonTelemetry then
		v8 = v5
	end

	local v9

	if FFlagLuaAppDemoModePlayButtonTelemetry then
		v9 = launchSource
	end

	return (useCallback(fn, {
		v2,
		v,
		v3,
		v4,
		universeId,
		v6,
		p2,
		referralSource,
		ctx,
		v7,
		v8,
		v9
	}))
end
