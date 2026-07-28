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
local FFlagDebugEnablePioneerUX = SharedFlags.FFlagDebugEnablePioneerUX
local v22 = FFlagEnableSideSheet and FFlagDebugEnablePioneerUX
local Constants = require(PeopleReactView.Constants)
local STANDARD_SERVER = CoreScriptsCommon.Constants.STANDARD_SERVER
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local SwitchServerTelemetry = require(PeopleReactView.Telemetry.SwitchServerTelemetry)
local u28 = false

local function sendSwitchServerButtonImpressionOnce() -- line: 57
	-- upvalues: u28 (ref), SwitchServerTelemetry (copy)
	if not u28 then
		u28 = true
		SwitchServerTelemetry.sendSwitchServerButtonActions({
			event_type = "impression"
		})
	end
end
local function useCoreButtonConfigs(b1: boolean, t1: {[any]: any}?) -- line: 66
	-- upvalues: FFlagShowSwitchServerButton (copy), React (copy), Signals (copy), RunService (copy), RobloxReplicatedStorage (copy), useSignalState (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), PeopleService (copy), useSignalBinding (copy), FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), GetFFlagNewPeoplePageIcons (copy), v22 (copy), Players (copy), STANDARD_SERVER (copy), FFlagEnablePeoplePageButtonOnMount (copy), u28 (ref), SwitchServerTelemetry (copy)
	local v33 = if not FFlagShowSwitchServerButton then nil else React.useMemo(function() -- line: 72
		-- upvalues: Signals (copy), RunService (copy), RobloxReplicatedStorage (copy)
		local v47, v48 = Signals.createSignal(nil)

		if not RunService:IsStudio() then
			local GetServerType = RobloxReplicatedStorage:WaitForChild("GetServerType", 2)

			if GetServerType then
				local ok, result = pcall(function() -- line: 78
					-- upvalues: GetServerType (copy)
					return GetServerType:InvokeServer()
				end)

				if ok then
					v48(result)
				end
			end
		end

		return v47
	end, {})
	local v34 = if not FFlagShowSwitchServerButton then nil else useSignalState(v33)
	local v35 = useLocalization({
		inviteFriends = if not FFlagConnectionsToFriendsRename then Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_CONNECTIONS else Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_FRIENDS,
		muteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_ALL,
		unmuteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_ALL,
		switchServer = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.SWITCH_SERVER,
		muteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_SELF,
		unmuteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_SELF
	})
	local v36 = PeopleService.getService("PeopleVoiceChatStore")
	local v37 = PeopleService.getService("PeopleAnalyticsManager")
	local v38 = PeopleService.getService("SettingsHubService")
	local voiceChatServiceConnected = v36.voiceChatServiceConnected
	local v40 = useSignalState(v36.voiceUIVisible)
	local allPlayersMuted = v36.allPlayersMuted
	local v42 = useSignalBinding(allPlayersMuted)
	local localMuted = v36.localMuted
	local v44 = useSignalBinding(localMuted)
	local v45 = v42:map(function(p1) -- line: 116
		-- upvalues: v35 (copy)
		return p1 and v35.unmuteAll or v35.muteAll
	end)
	local v46 = v44:map(function(p2) -- line: 120
		-- upvalues: v35 (copy)
		local unmuteSelf

		if p2 ~= nil then
			if not p2 then
				return v35.muteSelf
			end

			unmuteSelf = v35.unmuteSelf

			if not unmuteSelf then
				return v35.muteSelf
			end
		else
			unmuteSelf = v35.muteSelf
		end

		return unmuteSelf
	end)

	return (React.useMemo(function() -- line: 127
		-- upvalues: FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), v35 (copy), GetFFlagNewPeoplePageIcons (copy), Constants (copy), v22 (copy), RunService (copy), Players (copy), v38 (copy), v37 (copy), v45 (copy), allPlayersMuted (copy), v40 (copy), v42 (copy), v36 (copy), FFlagShowSwitchServerButton (copy), v34 (copy), STANDARD_SERVER (copy), t1 (copy), FFlagEnablePeoplePageButtonOnMount (copy), u28 (ref), SwitchServerTelemetry (copy), v46 (copy), localMuted (copy), b1 (copy), v44 (copy)
		local t2 = {}

		if not FFlagHidePeoplePageInviteFriends or (not FFlagAddInviteFriendsIntegration or not FFlagEnableSideSheet) then
			table.insert(t2, {
				id = "inviteFriends",
				layoutOrder = 1,
				text = v35.inviteFriends,
				onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_NEW,
				isNewIcon = GetFFlagNewPeoplePageIcons(),
				shouldShow = function() -- line: 139
					-- upvalues: v22 (copy), RunService (copy), Players (copy)
					return not v22 and (not RunService:IsStudio() and (Players.LocalPlayer ~= nil and Players.LocalPlayer.UserId > 0))
				end,
				onActivated = function() -- line: 145
					-- upvalues: v38 (copy), v37 (copy)
					local v56 = v38.hubRef()

					if v56 then
						v37:trackGameInviteEntryPoint()
						v56:InviteToGame()
					end
				end
			})
		end

		table.insert(t2, {
			id = "muteAll",
			layoutOrder = 2,
			text = v45,
			onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_NEW,
			offIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_NEW,
			buttonState = allPlayersMuted,
			isNewIcon = GetFFlagNewPeoplePageIcons(),
			shouldShow = function() -- line: 170
				-- upvalues: v40 (copy)
				return v40
			end,
			onActivated = function() -- line: 173
				-- upvalues: v42 (copy), v37 (copy), v36 (copy)
				local v57 = v42:getValue()

				v37:trackToggleMuteAll(v57)
				v36.toggleMuteAll()
			end
		})

		if FFlagShowSwitchServerButton then
			table.insert(t2, {
				id = "switchServer",
				isNewIcon = true,
				layoutOrder = 3,
				text = v35.switchServer,
				onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.SWITCH_SERVER,
				shouldShow = function() -- line: 190
					-- upvalues: v22 (copy), v34 (copy), STANDARD_SERVER (copy), Players (copy)
					return not v22 and (game:GetEngineFeature("GameIdToExcludeAvailable") and (v34 == STANDARD_SERVER and Players.MaxPlayers > 1))
				end,
				onActivated = t1[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER],
				onMount = if not FFlagEnablePeoplePageButtonOnMount then nil else function() -- line: 199
					-- upvalues: u28 (ref), SwitchServerTelemetry (copy)
					if not u28 then
						u28 = true
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
			text = v46,
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE,
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE_MUTED,
			animatedIcon = v36.getMuteSelfIcon(),
			buttonState = localMuted,
			shouldShow = function() -- line: 215
				-- upvalues: v40 (copy), b1 (copy)
				return v40 and not b1
			end,
			onActivated = function() -- line: 218
				-- upvalues: v44 (copy), v37 (copy), v36 (copy)
				local v58 = v44:getValue() or false

				v37:trackToggleMuteSelf(v58)
				v36.toggleMuteSelf()
			end,
			layoutOrder = not FFlagShowSwitchServerButton and 3 or 4
		})

		return t2
	end, {
		v40,
		voiceChatServiceConnected,
		v33
	}))
end

return useCoreButtonConfigs
