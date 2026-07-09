local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local GamePlayButton = require(CorePackages.Workspace.Packages.GamePlayButton)
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local useOnPlaySquadButtonCallback = GamePlayButton.useOnPlaySquadButtonCallback
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local MenuDirection = require(CorePackages.Packages.UIBlox).App.Menu.MenuDirection
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local wrapComponent = require(Modules.LuaApp.Common.wrapComponent)
local GetFFlagLuaAppEnableVirtualEventPlaceId = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableVirtualEventPlaceId
local FFlagLuaAppEnablePlaySquadButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry

return {
	connect = function(p1, p2) -- line: 30
		-- upvalues: Roact (copy), t (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), FFlagLuaAppEnablePlaySquadButton (copy), Dash (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonContextualMessage (copy), useOnPlaySquadButtonCallback (copy), MenuDirection (copy), Cryo (copy), RoactRodux (copy), GameInfosReducer (copy), wrapComponent (copy)
		return function(p3) -- line: 31
			-- upvalues: Roact (copy), t (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), FFlagLuaAppEnablePlaySquadButton (copy), Dash (copy), p2 (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonContextualMessage (copy), useOnPlaySquadButtonCallback (copy), MenuDirection (copy), Cryo (copy), RoactRodux (copy), GameInfosReducer (copy), wrapComponent (copy), p1 (copy)
			local v24 = Roact.PureComponent:extend("LaunchExperienceConnector(" .. tostring(p3) .. ")")

			v24.validateProps = t.interface({
				componentProps = t.table,
				universeId = t.string,
				extraParams = t.optional(t.table),
				launchSource = t.optional(t.string),
				eventContext = t.optional(t.string),
				referralSource = t.optional(t.string),
				fetchDelayInSeconds = t.optional(t.number),
				placeId = t.optional(t.string),
				shouldReportLoadingDurationTelemetry = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else t.optional(t.boolean)
			})

			function v24.init(p4) -- line: 52
				-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy)
				function p4.onPlayButtonActivated(p5, p6) -- line: 53
					-- upvalues: p4 (copy)
					local v49 = p5 or p4.props.playButtonState

					p4.props.onPlayButtonCallback(v49, p6)
				end

				if FFlagLuaAppEnablePlaySquadButton then
					function p4.onPlaySquadButtonActivated(p7) -- line: 59
						-- upvalues: p4 (copy)
						p4.props.onPlaySquadButtonCallback(p7)
					end
				end
			end
			function v24.render(p8) -- line: 65
				-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy), Roact (copy), p3 (copy), Dash (copy), p2 (copy)
				local componentProps = p8.props.componentProps
				local t1 = {
					playabilityStatus = p8.props.playabilityStatus,
					playButtonState = p8.props.playButtonState,
					onPlayButtonActivated = p8.onPlayButtonActivated,
					onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else p8.onPlaySquadButtonActivated,
					playButtonContextualMessage = p8.props.playButtonContextualMessage,
					gameName = p8.props.gameName,
					fetchDelayInSeconds = p8.props.fetchDelayInSeconds
				}

				return Roact.createElement(p3, Dash.assign({}, p8.props.componentProps, p2(t1, componentProps)))
			end

			local v25 = v24
			local v26 = RoactRodux.connect(function(p9, p10) -- line: 143
				-- upvalues: GameInfosReducer (copy)
				local universeId = p10.universeId
				local v42 = p9.GameDetails[universeId]
				local v43 = p9.Personalization[GameInfosReducer.key][p10.universeId]

				return {
					gameName = v42 and v42.name or (v43 and v43.name or nil)
				}
			end)(function(p11) -- line: 85
				-- upvalues: useRoactService (copy), RoactNetworking (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), usePlayButtonContextualMessage (copy), FFlagLuaAppEnablePlaySquadButton (copy), useOnPlaySquadButtonCallback (copy), MenuDirection (copy), Cryo (copy), Roact (copy), v25 (copy)
				local v32 = useRoactService(RoactNetworking)
				local v33 = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else p11.eventContext or "PlayButton"
				local v34 = usePlayButtonState(v32, p11.universeId, p11.fetchDelayInSeconds, nil, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else p11.shouldReportLoadingDurationTelemetry, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v33)
				local v35 = useOnPlayButtonCallback(p11.universeId, p11.referralSource, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then p11.eventContext or "PlayButton" else v33, nil, p11.launchSource or "UnknownLaunchSource", p11.extraParams, if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else p11.placeId)
				local v36 = usePlayButtonContextualMessage(p11.universeId, v34.playButtonState, v34.playabilityStatus)
				local v37 = if not FFlagLuaAppEnablePlaySquadButton then nil else useOnPlaySquadButtonCallback(MenuDirection.Down, v34.playButtonState, p11.referralSource, p11.universeId)
				local v38 = Cryo.Dictionary.join(p11, {
					onPlayButtonCallback = v35,
					onPlaySquadButtonCallback = if not FFlagLuaAppEnablePlaySquadButton then nil else v37,
					playButtonState = v34.playButtonState,
					playabilityStatus = v34.playabilityStatus,
					playButtonContextualMessage = v36
				})

				return Roact.createElement(v25, v38)
			end)

			return wrapComponent(function(p12, p13) -- line: 155
				-- upvalues: p1 (copy), Roact (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy)
				local v46 = p1(p13)

				return Roact.createElement(p12, {
					componentProps = p13,
					universeId = v46.universeId,
					extraParams = v46.extraParams,
					launchSource = v46.launchSource,
					eventContext = v46.eventContext,
					referralSource = v46.referralSource,
					fetchDelayInSeconds = v46.fetchDelayInSeconds,
					placeId = v46.placeId,
					shouldReportLoadingDurationTelemetry = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v46.shouldReportLoadingDurationTelemetry
				})
			end)(v26)
		end
	end
}
