local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local SwitchServer = require(parent.SwitchServer)

local service = PeopleService.getService("Flags")
local getFFlagNewPeoplePageIcons = service.GetFFlagNewPeoplePageIcons
local fFlagEnablePeoplePageButtonOnMount = service.FFlagEnablePeoplePageButtonOnMount
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagPeopleTabUseSwitchServerModule = require(PeopleReactView.Flags.FFlagPeopleTabUseSwitchServerModule)
local FFlagGameInviteInExpJoinOrInviteLabel = require(parent.GameInvite.FFlagGameInviteInExpJoinOrInviteLabel)
local isSideSheetEnabled = require(parent.InExperienceSideSheetUtils.isSideSheetEnabled)
local isPlatformInviteUIEnabled = require(parent.GameInvite.isPlatformInviteUIEnabled)

local Constants = require(PeopleReactView.Constants)
local STANDARD_SERVER = CoreScriptsCommon.Constants.STANDARD_SERVER
local constants = SwitchServer.Constants

local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local GetSwitchServerStore = SwitchServer.GetSwitchServerStore
local SwitchServerTelemetry = SwitchServer.SwitchServerTelemetry

local v = false
local function sendSwitchServerButtonImpressionOnce()
	if not v then
		v = true
		SwitchServerTelemetry.sendSwitchServerButtonActions({ event_type = "impression" })
	end
end

local function useCoreButtonConfigs(flag: boolean, p)
	local v2

	if FFlagShowSwitchServerButton and not FFlagPeopleTabUseSwitchServerModule then
		v2 = React.useMemo(function()
			local signal, v3 = Signals.createSignal(nil)

			local getServerType = not RunService:IsStudio() and RobloxReplicatedStorage:WaitForChild("GetServerType", 2)

			if getServerType then
				local success, result = pcall(function()
					return getServerType:InvokeServer()
				end)

				if success then
					v3(result)
				end
			end

			return signal
		end, {})
	end

	local v3

	if FFlagShowSwitchServerButton and not FFlagPeopleTabUseSwitchServerModule then
		v3 = useSignalState(v2)
	else
		v3 = nil
	end

	local v4

	if FFlagShowSwitchServerButton and FFlagPeopleTabUseSwitchServerModule then
		v4 = useSignalState(GetSwitchServerStore(false).shouldEnableSwitchServer)
	else
		v4 = false
	end

	local v5 = {
		inviteFriends = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.INVITE_FRIENDS,
		joinOrInvite = 0,
		muteAll = 0,
		unmuteAll = 0,
		switchServer = 0,
		muteSelf = 0,
		unmuteSelf = 0
	}
	local joinOrInvite

	if FFlagGameInviteInExpJoinOrInviteLabel then
		joinOrInvite = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.JOIN_OR_INVITE
	end

	v5.joinOrInvite = joinOrInvite

	v5.muteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_ALL
	v5.unmuteAll = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_ALL
	v5.switchServer = constants.BUTTON.LABEL
	v5.muteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.MUTE_SELF
	v5.unmuteSelf = Constants.PEOPLEPAGE.CORE_BUTTONS.LOCALIZED_STRINGS.UNMUTE_SELF
	local v6 = useLocalization(v5)

	local service2 = PeopleService.getService("PeopleVoiceChatStore")
	local service3 = PeopleService.getService("PeopleAnalyticsManager")
	local service4 = PeopleService.getService("SettingsHubService")

	local voiceChatServiceConnected = service2.voiceChatServiceConnected
	local v7 = useSignalState(service2.voiceUIVisible)
	local allPlayersMuted = service2.allPlayersMuted
	local v8 = useSignalBinding(allPlayersMuted)
	local localMuted = service2.localMuted
	local v9 = useSignalBinding(localMuted)

	local mapped = v8:map(function(p2)
		return p2 and v6.unmuteAll or v6.muteAll
	end)

	local mapped2 = v9:map(function(p2)
		local v10

		if p2 == nil then
			return v6.muteSelf
		end

		v10 = p2 and v6.unmuteSelf
		return v10 or v6.muteSelf
	end)

	return (React.useMemo(function()
		local v10 = {}

		if not (FFlagHidePeoplePageInviteFriends and FFlagAddInviteFriendsIntegration and isSideSheetEnabled) then
			local text

			if FFlagGameInviteInExpJoinOrInviteLabel and not isPlatformInviteUIEnabled() then
				text = v6.joinOrInvite
			else
				text = v6.inviteFriends
			end

			local onIcon

			if getFFlagNewPeoplePageIcons() then
				onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_NEW
			else
				onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.INVITE_FRIENDS_LEGACY
			end

			local v11 = {
				id = "inviteFriends",
				text = text,
				onIcon = onIcon,
				isNewIcon = getFFlagNewPeoplePageIcons(),
				shouldShow = function()
					local v11 = not RunService:IsStudio()

					if v11 then
						if Players.LocalPlayer == nil then
							return false
						end

						return Players.LocalPlayer.UserId > 0
					end

					return v11
				end,
				onActivated = function()
					local hubRef = service4.hubRef()

					if hubRef then
						service3:trackGameInviteEntryPoint()

						hubRef:InviteToGame()
					end
				end,
				layoutOrder = 1
			}
			table.insert(v10, v11)
		end

		local v11 = {
			id = "muteAll",
			text = mapped,
			onIcon = 0,
			offIcon = 0,
			buttonState = 0,
			isNewIcon = 0,
			shouldShow = 0,
			onActivated = 0,
			layoutOrder = 2
		}
		local onIcon

		if getFFlagNewPeoplePageIcons() then
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_NEW
		else
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_LEGACY
		end

		v11.onIcon = onIcon
		local offIcon

		if getFFlagNewPeoplePageIcons() then
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_NEW
		else
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.HEADPHONE_MUTED_LEGACY
		end

		v11.offIcon = offIcon

		v11.buttonState = allPlayersMuted
		v11.isNewIcon = getFFlagNewPeoplePageIcons()
		function v11.shouldShow()
			return v7
		end

		function v11.onActivated()
			service3:trackToggleMuteAll((v8:getValue()))

			service2.toggleMuteAll()
		end

		table.insert(v10, v11)

		if FFlagShowSwitchServerButton and not isSideSheetEnabled then
			table.insert(v10, {
				id = "switchServer",
				text = v6.switchServer,
				onIcon = constants.BUTTON.ICON,
				isNewIcon = true,
				shouldShow = function()
					if FFlagPeopleTabUseSwitchServerModule then
						return v4
					end

					local v12 = game:GetEngineFeature("GameIdToExcludeAvailable")

					if v12 then
						if v3 == STANDARD_SERVER then
							return Players.MaxPlayers > 1
						end

						return false
					end

					return v12
				end,
				onActivated = p[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER],
				layoutOrder = 3,
				onMount = fFlagEnablePeoplePageButtonOnMount and function()
					if not v then
						v = true
						SwitchServerTelemetry.sendSwitchServerButtonActions({
							event_type = "impression"
						})
					end
				end or nil
			})
		end

		table.insert(v10, {
			id = "muteSelf",
			text = mapped2,
			onIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE,
			offIcon = Constants.PEOPLEPAGE.CORE_BUTTONS.ICON.MICROPHONE_MUTED,
			animatedIcon = service2.getMuteSelfIcon(),
			buttonState = localMuted,
			isNewIcon = false,
			shouldShow = function()
				return v7 and not flag
			end,
			onActivated = function()
				service3:trackToggleMuteSelf(v9:getValue() or false)

				service2.toggleMuteSelf()
			end,
			layoutOrder = FFlagShowSwitchServerButton and 4 or 3
		})

		return v10
	end, { v7, voiceChatServiceConnected, v2 }))
end

return useCoreButtonConfigs
