local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local PeopleService = require(parent.PeopleService)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.Signals)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant

local useSignalState = SignalsReact.useSignalState
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local Constants = require(PeopleReactView.Constants)
local service = PeopleService.getService("Constants")

local service2 = PeopleService.getService("Flags")
local getFFlagNewPeopleButtonOrder = service2.GetFFlagNewPeopleButtonOrder

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local getFFlagNewPeoplePageIcons = service2.GetFFlagNewPeoplePageIcons
local getFFlagAddPeoplePageCardLayout = service2.GetFFlagAddPeoplePageCardLayout
local SharedFlags = require(parent.SharedFlags)
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local FFlagPeopleListButtonOverflow = require(PeopleReactView.Flags.FFlagPeopleListButtonOverflow)

local function getPlaySessionId()
	if engineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return ""
end

local function usePersonButtonConfigs(p: number?, flag: boolean?)
	local service3 = PeopleService.getService("PeopleVoiceChatStore")
	local service4 = PeopleService.getService("PeopleReportAbuseMenu")
	local service5 = PeopleService.getService("PeopleAnalyticsManager")
	local service6 = PeopleService.getService("SettingsHubService")
	local service7 = PeopleService.getService("FriendStatusStore")
	local service8 = PeopleService.getService("PeopleBlockStatusStore")
	local service9 = PeopleService.getService("PeopleUtility")

	local v = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
		or FFlagPeopleListButtonOverflow and flag == true

	local v2 = useLocalization({
		requestSent = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.REQUEST_SENT,
		friend = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.FRIEND,
		addFriend = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.ADD_FRIEND,
		unblock = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNBLOCK
	})

	local v3 = React.useMemo(function()
		return { isFriend = v2.friend, addPerson = v2.addFriend, requestSent = v2.requestSent }
	end, { v2 })

	local v4 = React.useMemo(function()
		if p then
			return (Players:GetPlayerByUserId(p))
		end

		return nil
	end, { p })

	local v5 = React.useMemo(getPlaySessionId, {})

	local playerMuteState = service3.getPlayerMuteState(p)
	local playerAnimatedIcon = service3.getPlayerAnimatedIcon(p)
	local playerIsLocalMuted = service3.getPlayerIsLocalMuted(p)
	local v6 = useSignalState(service3.getPlayerShouldShowMuteButton(p))
	local v7 = useSignalState(service7.getShouldShowFriendButton(p, v4))
	local buttonState

	if getFFlagAddPeoplePageCardLayout() then
		buttonState = React.useMemo(function()
			return service7.getFriendStatus(p)
		end, { p })
	else
		buttonState = service7.getFriendStatus(p)
	end

	local v8

	if getFFlagAddPeoplePageCardLayout() then
		v8 = React.useMemo(function()
			return service7.getFriendButtonText(p, v3)
		end, { p, v3 })
	else
		v8 = service7.getFriendButtonText(p, v3)
	end

	local v9

	if getFFlagAddPeoplePageCardLayout() then
		v9 = React.useMemo(function()
			return service7.getFriendButtonVariant(p)
		end, { p })
	else
		v9 = service7.getFriendButtonVariant(p)
	end

	local v10 = useSignalState((React.useMemo(function()
		if p then
			return (service8.getPlayerBlockStatus(p))
		end

		return nil
	end, { p })))

	local v11 = React.useMemo(function()
		return service9.showPersonButtons(v4, p)
	end, { p })

	return (React.useMemo(function()
		local v12 = {}

		local v13 = {
			id = service.PERSON_BUTTONS.MUTE_PLAYER,
			animatedIcon = playerAnimatedIcon,
			buttonState = playerMuteState,
			shouldShow = function()
				return v6
			end,
			onActivated = function(p2: string?)
				local v13 = playerIsLocalMuted(false)

				if not getFFlagAddPeoplePageCardLayout() then
					p2 = nil
				end

				service5:trackToggleMutePlayer(p, v13, p2)

				service3.togglePlayerMute(p)
			end,
			layoutOrder = getFFlagNewPeopleButtonOrder() and 30 or 10,
			isGrayedOut = playerIsLocalMuted,
			isBuilderIcon = false
		}

		if getFFlagAddPeoplePageCardLayout() then
			v12[service.PERSON_BUTTONS.MUTE_PLAYER] = v13
		else
			table.insert(v12, v13)
		end

		local v14 = {
			id = service.PERSON_BUTTONS.BLOCK_PLAYER,
			text = 0,
			onIcon = 0,
			shouldShow = 0,
			onActivated = 0,
			buttonVariant = 0,
			layoutOrder = 0,
			isBuilderIcon = 0
		}
		local text

		if v10 then
			text = v2.unblock
		end

		v14.text = text
		local onIcon

		if not v10 then
			if getFFlagNewPeoplePageIcons() then
				onIcon = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.BLOCK_NEW
			else
				onIcon = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.BLOCK_LEGACY
			end
		end

		v14.onIcon = onIcon

		function v14.shouldShow()
			return v11
		end

		function v14.onActivated(p2: string?)
			if v4 then
				if v10 then
					local unblockPlayer = service8.unblockPlayer

					if not getFFlagAddPeoplePageCardLayout() then
						p2 = nil
					end

					unblockPlayer(v4, p2)
				else
					local blockPlayer = service8.blockPlayer

					if not getFFlagAddPeoplePageCardLayout() then
						p2 = nil
					end

					blockPlayer(v4, p2)
				end
			end
		end

		local buttonVariant

		if v10 then
			buttonVariant = ButtonVariant.Subtle
		end

		v14.buttonVariant = buttonVariant
		v14.layoutOrder = getFFlagNewPeopleButtonOrder() and 10 or 40
		v14.isBuilderIcon = getFFlagNewPeoplePageIcons()

		if getFFlagAddPeoplePageCardLayout() then
			v12[service.PERSON_BUTTONS.BLOCK_PLAYER] = v14
		else
			table.insert(v12, v14)
		end

		local v15 = {
			id = service.PERSON_BUTTONS.ADD_FRIEND,
			text = 0,
			onIcon = 0,
			offIcon = 0,
			buttonState = 0,
			buttonVariant = 0,
			shouldShow = 0,
			onActivated = 0,
			layoutOrder = 60,
			isDisabled = 0,
			isGrayedOut = 0,
			isBuilderIcon = 0
		}
		local text2

		if not v then
			text2 = v8
		end

		v15.text = text2
		local onIcon2

		if v then
			if getFFlagNewPeoplePageIcons() then
				onIcon2 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.ADD_FRIEND_NEW
			else
				onIcon2 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.ADD_FRIEND_LEGACY
			end
		end

		v15.onIcon = onIcon2
		local offIcon

		if v then
			if getFFlagNewPeoplePageIcons() then
				offIcon = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.FRIEND_NEW
			else
				offIcon = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.FRIEND_LEGACY
			end
		end

		v15.offIcon = offIcon

		v15.buttonState = buttonState
		local buttonVariant2

		if not v then
			buttonVariant2 = v9
		end

		v15.buttonVariant = buttonVariant2
		function v15.shouldShow()
			return v7
		end

		function v15.onActivated(p2: string?)
			if not getFFlagAddPeoplePageCardLayout() then
				p2 = nil
			end

			service5:trackRequestFriendship(p2)

			service7.sendFriendRequest(v4)
		end

		v15.isDisabled = service7.getIsFriendButtonDisabled(p)
		v15.isGrayedOut = service7.getIsFriendButtonGrayedOut(p)
		v15.isBuilderIcon = getFFlagNewPeoplePageIcons()

		if getFFlagAddPeoplePageCardLayout() then
			v12[service.PERSON_BUTTONS.ADD_FRIEND] = v15
		else
			table.insert(v12, v15)
		end

		local v16 = {
			id = service.PERSON_BUTTONS.REPORT_PLAYER,
			onIcon = 0,
			shouldShow = 0,
			onActivated = 0,
			layoutOrder = 0,
			isBuilderIcon = 0
		}
		local onIcon3

		if FFlagStandardizeSafetyIcon then
			onIcon3 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_FLAG
		elseif getFFlagNewPeoplePageIcons() then
			onIcon3 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_NEW
		else
			onIcon3 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_LEGACY
		end

		v16.onIcon = onIcon3

		function v16.shouldShow()
			return v11
		end

		function v16.onActivated(p2: string?)
			if v4 then
				service4:ReportPlayer(v4, not getFFlagAddPeoplePageCardLayout() and "MenuPlayerList" or p2)
			end
		end
		v16.layoutOrder = getFFlagNewPeopleButtonOrder() and 40 or 30
		v16.isBuilderIcon = getFFlagNewPeoplePageIcons()

		if getFFlagAddPeoplePageCardLayout() then
			v12[service.PERSON_BUTTONS.REPORT_PLAYER] = v16
		else
			table.insert(v12, v16)
		end

		local v17 = {
			id = service.PERSON_BUTTONS.INSPECT,
			onIcon = 0,
			shouldShow = 0,
			onActivated = 0,
			layoutOrder = 20,
			isBuilderIcon = 0
		}
		local onIcon4

		if getFFlagNewPeoplePageIcons() then
			onIcon4 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.INSPECT_NEW
		else
			onIcon4 = Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.INSPECT_LEGACY
		end

		v17.onIcon = onIcon4

		function v17.shouldShow()
			return GuiService:GetInspectMenuEnabled()
		end

		function v17.onActivated(p2: string?)
			if v4 then
				if getFFlagAddPeoplePageCardLayout() then
					service5:trackInspectButton(game.GameId, v5, p2)
				else
					service5:trackInspectButton(game.GameId, v5)
				end

				GuiService:InspectPlayerFromUserIdWithCtx(v4.UserId, "escapeMenu")
				local hubRef = service6.hubRef()

				if hubRef then
					hubRef:SetVisibility(false)
				end
			end
		end

		v17.isBuilderIcon = getFFlagNewPeoplePageIcons()

		if getFFlagAddPeoplePageCardLayout() then
			v12[service.PERSON_BUTTONS.INSPECT] = v17
			return v12
		end

		table.insert(v12, v17)

		return v12
	end, { v6, v7, v11, v10, v, v8, v9, buttonState }))
end

return usePersonButtonConfigs
