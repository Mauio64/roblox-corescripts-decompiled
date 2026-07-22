local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local CoreScriptsCommon = require(PeopleReactViewParent.CoreScriptsCommon)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Signals = require(PeopleReactViewParent.Signals)
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local SharedFlags = require(PeopleReactViewParent.SharedFlags)
local v13 = PeopleService.getService("Flags")
local GetFFlagNewPeoplePageIcons = v13.GetFFlagNewPeoplePageIcons
local FFlagShowSwitchServerButton = v13.FFlagShowSwitchServerButton
local FFlagEnablePeoplePageButtonOnMount = v13.FFlagEnablePeoplePageButtonOnMount
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local Constants = require(PeopleReactView.Constants)
local STANDARD_SERVER = CoreScriptsCommon.Constants.STANDARD_SERVER
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local SwitchServerTelemetry = require(PeopleReactView.Telemetry.SwitchServerTelemetry)
local u26 = false

local function sendSwitchServerButtonImpressionOnce() -- line: 55
	-- upvalues: u26 (ref), SwitchServerTelemetry (copy)
	if not u26 then
		u26 = true
		SwitchServerTelemetry.sendSwitchServerButtonActions({
			event_type = "impression"
		})
	end
end
local function useCoreButtonConfigs(b1: boolean, t1: {[any]: any}?) -- line: 64
	-- upvalues: FFlagShowSwitchServerButton (copy), React (copy), Signals (copy), RunService (copy), RobloxReplicatedStorage (copy), useSignalState (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), PeopleService (copy), useSignalBinding (copy), FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), GetFFlagNewPeoplePageIcons (copy), Players (copy), STANDARD_SERVER (copy), FFlagEnablePeoplePageButtonOnMount (copy), u26 (ref), SwitchServerTelemetry (copy)
	local v31 = if not FFlagShowSwitchServerButton then nil else React.useMemo(function() -- line: 70
		-- upvalues: Signals (copy), RunService (copy), RobloxReplicatedStorage (copy)
		local v45, v46 = Signals.createSignal(nil)

		if not RunService:IsStudio() then
			local GetServerType = RobloxReplicatedStorage:WaitForChild("GetServerType", 2)

			if GetServerType then
				local ok, result = pcall(function() -- line: 76
					-- upvalues: GetServerType (copy)
					return GetServerType:InvokeServer()
				end)

				if ok then
					v46(result)
				end
			end
		end

		return v45
	end, {})
	local v32 = if not FFlagShowSwitchServerButton then nil else useSignalState(v31)
	local v33 = useLocalization({
		inviteFriends = if not FFlagConnectionsToFriendsRename then Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_CONNECTIONS else Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_FRIENDS,
		muteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_ALL,
		unmuteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_ALL,
		switchServer = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.SWITCH_SERVER,
		muteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_SELF,
		unmuteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_SELF
	})
	local v34 = PeopleService.getService("PeopleVoiceChatStore")
	local v35 = PeopleService.getService("PeopleAnalyticsManager")
	local v36 = PeopleService.getService("SettingsHubService")
	local voiceChatServiceConnected = v34.voiceChatServiceConnected
	local v38 = useSignalState(v34.voiceUIVisible)
	local allPlayersMuted = v34.allPlayersMuted
	local v40 = useSignalBinding(allPlayersMuted)
	local localMuted = v34.localMuted
	local v42 = useSignalBinding(localMuted)
	local v43 = v40:map(function(p1) -- line: 114
		-- upvalues: v33 (copy)
		return p1 and v33.unmuteAll or v33.muteAll
	end)
	local v44 = v42:map(function(p2) -- line: 118
		-- upvalues: v33 (copy)
		local unmuteSelf

		if p2 ~= nil then
			if not p2 then
				return v33.muteSelf
			end

			unmuteSelf = v33.unmuteSelf

			if not unmuteSelf then
				return v33.muteSelf
			end
		else
			unmuteSelf = v33.muteSelf
		end

		return unmuteSelf
	end)

	return (React.useMemo(function() -- line: 125
		-- upvalues: FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), v33 (copy), GetFFlagNewPeoplePageIcons (copy), Constants (copy), RunService (copy), Players (copy), v36 (copy), v35 (copy), v43 (copy), allPlayersMuted (copy), v38 (copy), v40 (copy), v34 (copy), FFlagShowSwitchServerButton (copy), v32 (copy), STANDARD_SERVER (copy), t1 (copy), FFlagEnablePeoplePageButtonOnMount (copy), u26 (ref), SwitchServerTelemetry (copy), v44 (copy), localMuted (copy), b1 (copy), v42 (copy)
		local t2 = {}

		if not FFlagHidePeoplePageInviteFriends or (not FFlagAddInviteFriendsIntegration or not FFlagEnableSideSheet) then
			table.insert(t2, {
				id = "inviteFriends",
				layoutOrder = 1,
				text = v33.inviteFriends,
				onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_NEW,
				isNewIcon = GetFFlagNewPeoplePageIcons(),
				shouldShow = function() -- line: 137
					-- upvalues: RunService (copy), Players (copy)
					return not RunService:IsStudio() and (Players.LocalPlayer ~= nil and Players.LocalPlayer.UserId > 0)
				end,
				onActivated = function() -- line: 140
					-- upvalues: v36 (copy), v35 (copy)
					local v54 = v36.hubRef()

					if v54 then
						v35:trackGameInviteEntryPoint()
						v54:InviteToGame()
					end
				end
			})
		end

		table.insert(t2, {
			id = "muteAll",
			layoutOrder = 2,
			text = v43,
			onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_NEW,
			offIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_NEW,
			buttonState = allPlayersMuted,
			isNewIcon = GetFFlagNewPeoplePageIcons(),
			shouldShow = function() -- line: 165
				-- upvalues: v38 (copy)
				return v38
			end,
			onActivated = function() -- line: 168
				-- upvalues: v40 (copy), v35 (copy), v34 (copy)
				local v55 = v40:getValue()

				v35:trackToggleMuteAll(v55)
				v34.toggleMuteAll()
			end
		})

		if FFlagShowSwitchServerButton then
			table.insert(t2, {
				id = "switchServer",
				isNewIcon = true,
				layoutOrder = 3,
				text = v33.switchServer,
				onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.SWITCH_SERVER,
				shouldShow = function() -- line: 185
					-- upvalues: v32 (copy), STANDARD_SERVER (copy), Players (copy)
					return game:GetEngineFeature("GameIdToExcludeAvailable") and (v32 == STANDARD_SERVER and Players.MaxPlayers > 1)
				end,
				onActivated = t1[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER],
				onMount = if not FFlagEnablePeoplePageButtonOnMount then nil else function() -- line: 193
					-- upvalues: u26 (ref), SwitchServerTelemetry (copy)
					if not u26 then
						u26 = true
						SwitchServerTelemetry.sendSwitchServerButtonActions({
							event_type = "impression"
						})
					end
				end
			})
		end

		table.insert(t2, {
			id = "muteSelf",
			isNewIcon = false,
			text = v44,
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE,
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE_MUTED,
			animatedIcon = v34.getMuteSelfIcon(),
			buttonState = localMuted,
			shouldShow = function() -- line: 209
				-- upvalues: v38 (copy), b1 (copy)
				return v38 and not b1
			end,
			onActivated = function() -- line: 212
				-- upvalues: v42 (copy), v35 (copy), v34 (copy)
				local v56 = v42:getValue() or false

				v35:trackToggleMuteSelf(v56)
				v34.toggleMuteSelf()
			end,
			layoutOrder = not FFlagShowSwitchServerButton and 3 or 4
		})

		return t2
	end, {
		v38,
		voiceChatServiceConnected,
		v31
	}))
end

return useCoreButtonConfigs
