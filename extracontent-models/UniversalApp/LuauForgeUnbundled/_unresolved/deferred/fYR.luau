local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local module = require("@luauforge/bundled/fWH")
local usePlayButtonState = module.usePlayButtonState
local useOnPlayButtonCallback = module.useOnPlayButtonCallback
local useOnPlaySquadButtonCallback = module.useOnPlaySquadButtonCallback
local usePlayButtonContextualMessage = module.usePlayButtonContextualMessage
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UIBlox = require(CorePackages.Packages.UIBlox)
local menuDirection = UIBlox.App.Menu.MenuDirection

local module3 = require("@luauforge/bundled/frt")

local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

return {
	connect = function(callback, callback2)
		return function(p2)
			local extended = Roact.PureComponent:extend("LaunchExperienceConnector(" .. tostring(p2) .. ")")

			local interface = t.interface
			local v5 = {
				componentProps = t.table,
				universeId = t.string,
				extraParams = t.optional(t.table),
				launchSource = t.optional(t.string),
				eventContext = t.optional(t.string),
				referralSource = t.optional(t.string),
				fetchDelayInSeconds = t.optional(t.number),
				placeId = t.optional(t.string),
				shouldReportLoadingDurationTelemetry = 0
			}

			local v6 = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then t.optional(t.boolean) else nil
			v5.shouldReportLoadingDurationTelemetry = v6
			extended.validateProps = interface(v5)

			function extended:init()
				function self.onPlayButtonActivated(p4, p5)
					local v7 = p4 or self.props.playButtonState
					self.props.onPlayButtonCallback(v7, p5)
				end

				if getFFlagIsSquadEnabled() then
					function self.onPlaySquadButtonActivated(p4)
						self.props.onPlaySquadButtonCallback(p4)
					end
				end
			end

			function extended.render(props)
				local componentProps = props.props.componentProps
				local v7 = {
					playabilityStatus = props.props.playabilityStatus,
					playButtonState = props.props.playButtonState,
					secondaryPlayButtonState = props.props.secondaryPlayButtonState,
					onPlayButtonActivated = props.onPlayButtonActivated,
					onPlaySquadButtonActivated = 0,
					playButtonContextualMessage = 0,
					gameName = 0,
					fetchDelayInSeconds = 0
				}
				local v8 = if getFFlagIsSquadEnabled() then props.onPlaySquadButtonActivated else nil
				v7.onPlaySquadButtonActivated = v8
				v7.playButtonContextualMessage = props.props.playButtonContextualMessage
				v7.gameName = props.props.gameName
				v7.fetchDelayInSeconds = props.props.fetchDelayInSeconds

				return Roact.createElement(
					p2,
					Dash.assign({}, props.props.componentProps, callback2(v7, componentProps))
				)
			end

			local function fn(props)
				local v7 = useRoactService(roactNetworking)

				local eventContext = fFlagLuaAppPlayButtonLoadingDurationTelemetry
					and (props.eventContext or "PlayButton")
					or nil

				local universeId = props.universeId
				local fetchDelayInSeconds = props.fetchDelayInSeconds
				local shouldReportLoadingDurationTelemetry

				if fFlagLuaAppPlayButtonLoadingDurationTelemetry then
					shouldReportLoadingDurationTelemetry = props.shouldReportLoadingDurationTelemetry
				end

				local v10 = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then eventContext else nil
				local v11 = usePlayButtonState(
					v7,
					universeId,
					fetchDelayInSeconds,
					nil,
					shouldReportLoadingDurationTelemetry,
					v10
				)

				local universeId2 = props.universeId
				local referralSource = props.referralSource

				local eventContext2 = not fFlagLuaAppPlayButtonLoadingDurationTelemetry
					and (props.eventContext or "PlayButton")
					or eventContext

				local launchSource = props.launchSource or "UnknownLaunchSource"
				local extraParams = props.extraParams
				local v14 = if getFFlagLuaAppEnableVirtualEventPlaceId() then props.placeId else nil
				local v15 = useOnPlayButtonCallback(
					universeId2,
					referralSource,
					eventContext2,
					nil,
					launchSource,
					extraParams,
					v14
				)

				local v16 = usePlayButtonContextualMessage(
					props.universeId,
					v11.playButtonState,
					v11.playabilityStatus
				)
				local v17

				if getFFlagIsSquadEnabled() then
					v17 = useOnPlaySquadButtonCallback(
						menuDirection.Down,
						v11.playButtonState,
						props.referralSource,
						props.universeId
					)
				end

				local gameName

				if fFlagMigrateGameInfoToStore then
					local v18 = GameHydrationReact.useGameInfo(props.universeId)
					gameName = props.gameName or v18 and v18.name or nil
				end

				local join = Cryo.Dictionary.join

				if not getFFlagIsSquadEnabled() then
					v17 = nil
				end

				local v18 = {
					onPlayButtonCallback = v15,
					onPlaySquadButtonCallback = v17,
					playButtonState = v11.playButtonState,
					secondaryPlayButtonState = v11.secondaryPlayButtonState,
					playabilityStatus = v11.playabilityStatus,
					playButtonContextualMessage = v16,
					gameName = 0
				}

				if not fFlagMigrateGameInfoToStore then
					gameName = nil
				end

				v18.gameName = gameName
				local v19 = join(props, v18)

				return Roact.createElement(extended, v19)
			end

			local v7 = RoactRodux.connect(function(p3, p4)
				local universeId = p4.universeId
				local gameDetail = p3.GameDetails[universeId]
				local name

				if fFlagMigrateGameInfoToStore then
					name = gameDetail and gameDetail.name or nil
				else
					local v8 = p3.Personalization[gameInfosReducer.key][p4.universeId]
					name = gameDetail and gameDetail.name or v8 and v8.name or nil
				end

				return { gameName = name }
			end)(fn)

			return module3(function(p3, p4)
				local v8 = callback(p4)
				local createElement = Roact.createElement
				local v9 = {
					componentProps = p4,
					universeId = v8.universeId,
					extraParams = v8.extraParams,
					launchSource = v8.launchSource,
					eventContext = v8.eventContext,
					referralSource = v8.referralSource,
					fetchDelayInSeconds = v8.fetchDelayInSeconds,
					placeId = v8.placeId,
					shouldReportLoadingDurationTelemetry = 0
				}

				local v10 = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then v8.shouldReportLoadingDurationTelemetry else nil
				v9.shouldReportLoadingDurationTelemetry = v10
				return createElement(p3, v9)
			end)(v7)
		end
	end
}
