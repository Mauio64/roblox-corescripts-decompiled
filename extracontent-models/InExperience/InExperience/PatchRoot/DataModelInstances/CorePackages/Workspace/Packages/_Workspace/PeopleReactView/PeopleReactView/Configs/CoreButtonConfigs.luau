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
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local Constants = require(PeopleReactView.Constants)
local STANDARD_SERVER = CoreScriptsCommon.Constants.STANDARD_SERVER
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local function useCoreButtonConfigs(b1: boolean, t1: {[any]: any}?) -- line: 49
	-- upvalues: FFlagShowSwitchServerButton (copy), React (copy), Signals (copy), RunService (copy), RobloxReplicatedStorage (copy), useSignalState (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), PeopleService (copy), useSignalBinding (copy), FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), GetFFlagNewPeoplePageIcons (copy), Players (copy), STANDARD_SERVER (copy)
	local v27 = if not FFlagShowSwitchServerButton then nil else React.useMemo(function() -- line: 55
		-- upvalues: Signals (copy), RunService (copy), RobloxReplicatedStorage (copy)
		local v41, v42 = Signals.createSignal(nil)

		if not RunService:IsStudio() then
			local GetServerType = RobloxReplicatedStorage:WaitForChild("GetServerType", 2)

			if GetServerType then
				local ok, result = pcall(function() -- line: 61
					-- upvalues: GetServerType (copy)
					return GetServerType:InvokeServer()
				end)

				if ok then
					v42(result)
				end
			end
		end

		return v41
	end, {})
	local v28 = if not FFlagShowSwitchServerButton then nil else useSignalState(v27)
	local v29 = useLocalization({
		inviteFriends = if not FFlagConnectionsToFriendsRename then Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_CONNECTIONS else Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_FRIENDS,
		muteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_ALL,
		unmuteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_ALL,
		switchServer = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.SWITCH_SERVER,
		muteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_SELF,
		unmuteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_SELF
	})
	local v30 = PeopleService.getService("PeopleVoiceChatStore")
	local v31 = PeopleService.getService("PeopleAnalyticsManager")
	local v32 = PeopleService.getService("SettingsHubService")
	local voiceChatServiceConnected = v30.voiceChatServiceConnected
	local v34 = useSignalState(v30.voiceUIVisible)
	local allPlayersMuted = v30.allPlayersMuted
	local v36 = useSignalBinding(allPlayersMuted)
	local localMuted = v30.localMuted
	local v38 = useSignalBinding(localMuted)
	local v39 = v36:map(function(p1) -- line: 99
		-- upvalues: v29 (copy)
		return p1 and v29.unmuteAll or v29.muteAll
	end)
	local v40 = v38:map(function(p2) -- line: 103
		-- upvalues: v29 (copy)
		local unmuteSelf

		if p2 ~= nil then
			if not p2 then
				return v29.muteSelf
			end

			unmuteSelf = v29.unmuteSelf

			if not unmuteSelf then
				return v29.muteSelf
			end
		else
			unmuteSelf = v29.muteSelf
		end

		return unmuteSelf
	end)

	return (React.useMemo(function() -- line: 110
		-- upvalues: FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), v29 (copy), GetFFlagNewPeoplePageIcons (copy), Constants (copy), RunService (copy), Players (copy), v32 (copy), v31 (copy), v39 (copy), allPlayersMuted (copy), v34 (copy), v36 (copy), v30 (copy), FFlagShowSwitchServerButton (copy), v28 (copy), STANDARD_SERVER (copy), t1 (copy), v40 (copy), localMuted (copy), b1 (copy), v38 (copy)
		local t2 = {}

		if not FFlagHidePeoplePageInviteFriends or (not FFlagAddInviteFriendsIntegration or not FFlagEnableSideSheet) then
			table.insert(t2, {
				id = "inviteFriends",
				layoutOrder = 1,
				text = v29.inviteFriends,
				onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_NEW,
				isNewIcon = GetFFlagNewPeoplePageIcons(),
				shouldShow = function() -- line: 122
					-- upvalues: RunService (copy), Players (copy)
					return not RunService:IsStudio() and (Players.LocalPlayer ~= nil and Players.LocalPlayer.UserId > 0)
				end,
				onActivated = function() -- line: 125
					-- upvalues: v32 (copy), v31 (copy)
					local v50 = v32.hubRef()

					if v50 then
						v31:trackGameInviteEntryPoint()
						v50:InviteToGame()
					end
				end
			})
		end

		table.insert(t2, {
			id = "muteAll",
			layoutOrder = 2,
			text = v39,
			onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_NEW,
			offIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_LEGACY else Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_NEW,
			buttonState = allPlayersMuted,
			isNewIcon = GetFFlagNewPeoplePageIcons(),
			shouldShow = function() -- line: 150
				-- upvalues: v34 (copy)
				return v34
			end,
			onActivated = function() -- line: 153
				-- upvalues: v36 (copy), v31 (copy), v30 (copy)
				local v51 = v36:getValue()

				v31:trackToggleMuteAll(v51)
				v30.toggleMuteAll()
			end
		})

		if FFlagShowSwitchServerButton then
			table.insert(t2, {
				id = "switchServer",
				isNewIcon = true,
				layoutOrder = 3,
				text = v29.switchServer,
				onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.SWITCH_SERVER,
				shouldShow = function() -- line: 170
					-- upvalues: v28 (copy), STANDARD_SERVER (copy), Players (copy)
					return game:GetEngineFeature("GameIdToExcludeAvailable") and (v28 == STANDARD_SERVER and Players.MaxPlayers > 1)
				end,
				onActivated = t1[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER]
			})
		end

		table.insert(t2, {
			id = "muteSelf",
			isNewIcon = false,
			text = v40,
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE,
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE_MUTED,
			animatedIcon = v30.getMuteSelfIcon(),
			buttonState = localMuted,
			shouldShow = function() -- line: 189
				-- upvalues: v34 (copy), b1 (copy)
				return v34 and not b1
			end,
			onActivated = function() -- line: 192
				-- upvalues: v38 (copy), v31 (copy), v30 (copy)
				local v52 = v38:getValue() or false

				v31:trackToggleMuteSelf(v52)
				v30.toggleMuteSelf()
			end,
			layoutOrder = not FFlagShowSwitchServerButton and 3 or 4
		})

		return t2
	end, {
		v34,
		voiceChatServiceConnected,
		v27
	}))
end

return useCoreButtonConfigs
