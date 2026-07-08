local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local PeopleService = require(PeopleReactViewParent.PeopleService)
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)

require(PeopleReactViewParent.Signals)

local RobloxAppHooks = require(PeopleReactViewParent.RobloxAppHooks)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local ButtonVariant = require(PeopleReactViewParent.Foundation).Enums.ButtonVariant
local useSignalState = SignalsReact.useSignalState
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local Constants = require(PeopleReactView.Constants)
local v16 = PeopleService.getService("Constants")
local v17 = PeopleService.getService("Flags")
local GetFFlagNewPeopleButtonOrder = v17.GetFFlagNewPeopleButtonOrder
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagNewPeoplePageIcons = v17.GetFFlagNewPeoplePageIcons
local GetFFlagAddPeoplePageCardLayout = v17.GetFFlagAddPeoplePageCardLayout
local FFlagConnectionsToFriendsRename = require(PeopleReactViewParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagStandardizeSafetyIcon = require(PeopleReactViewParent.SharedFlags).FFlagStandardizeSafetyIcon

local function getPlaySessionId() -- line: 42
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	if EngineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return ""
end
local function usePersonButtonConfigs(n1: number?) -- line: 67
	-- upvalues: PeopleService (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), useLocalization (copy), Constants (copy), FFlagConnectionsToFriendsRename (copy), React (copy), Players (copy), getPlaySessionId (copy), useSignalState (copy), GetFFlagAddPeoplePageCardLayout (copy), v16 (copy), GetFFlagNewPeopleButtonOrder (copy), GetFFlagNewPeoplePageIcons (copy), ButtonVariant (copy), FFlagStandardizeSafetyIcon (copy), GuiService (copy)
	local v27 = PeopleService.getService("PeopleVoiceChatStore")
	local v28 = PeopleService.getService("PeopleReportAbuseMenu")
	local v29 = PeopleService.getService("PeopleAnalyticsManager")
	local v30 = PeopleService.getService("SettingsHubService")
	local v31 = PeopleService.getService("FriendStatusStore")
	local v32 = PeopleService.getService("PeopleBlockStatusStore")
	local v33 = PeopleService.getService("PeopleUtility")
	local v34 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v35 = useLocalization({
		requestSent = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.REQUEST_SENT,
		friend = if not FFlagConnectionsToFriendsRename then nil else Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.FRIEND,
		addFriend = if not FFlagConnectionsToFriendsRename then nil else Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.ADD_FRIEND,
		connection = if not FFlagConnectionsToFriendsRename then Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.CONNECTION else nil,
		addConnection = if not FFlagConnectionsToFriendsRename then Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.ADD_CONNECTION else nil,
		unblock = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNBLOCK
	})
	local v36 = React.useMemo(function() -- line: 101
		-- upvalues: FFlagConnectionsToFriendsRename (copy), v35 (copy)
		return {
			isFriend = if not FFlagConnectionsToFriendsRename then v35.connection else v35.friend,
			addPerson = if not FFlagConnectionsToFriendsRename then v35.addConnection else v35.addFriend,
			requestSent = v35.requestSent
		}
	end, { v35 })
	local v37 = React.useMemo(function() -- line: 111
		-- upvalues: n1 (copy), Players (copy)
		if n1 then
			return (Players:GetPlayerByUserId(n1))
		end

		return nil
	end, { n1 })
	local v38 = React.useMemo(getPlaySessionId, {})
	local v39 = v27.getPlayerMuteState(n1)
	local v40 = v27.getPlayerAnimatedIcon(n1)
	local v41 = v27.getPlayerIsLocalMuted(n1)
	local v42 = useSignalState(v27.getPlayerShouldShowMuteButton(n1))
	local v43 = useSignalState(v31.getShouldShowFriendButton(n1, v37))
	local v44 = if not GetFFlagAddPeoplePageCardLayout() then v31.getFriendStatus(n1) else React.useMemo(function() -- line: 125
		-- upvalues: v31 (copy), n1 (copy)
		return v31.getFriendStatus(n1)
	end, { n1 })
	local v45 = if not GetFFlagAddPeoplePageCardLayout() then v31.getFriendButtonText(n1, v36) else React.useMemo(function() -- line: 132
		-- upvalues: v31 (copy), n1 (copy), v36 (copy)
		return v31.getFriendButtonText(n1, v36)
	end, {
		n1,
		v36
	})
	local v46 = if not GetFFlagAddPeoplePageCardLayout() then v31.getFriendButtonVariant(n1) else React.useMemo(function() -- line: 139
		-- upvalues: v31 (copy), n1 (copy)
		return v31.getFriendButtonVariant(n1)
	end, { n1 })
	local v47 = React.useMemo(function() -- line: 145
		-- upvalues: n1 (copy), v32 (copy)
		if n1 then
			return (v32.getPlayerBlockStatus(n1))
		end

		return nil
	end, { n1 })
	local v48 = useSignalState(v47)
	local v49 = React.useMemo(function() -- line: 150
		-- upvalues: v33 (copy), v37 (copy), n1 (copy)
		return v33.showPersonButtons(v37, n1)
	end, { n1 })

	return (React.useMemo(function() -- line: 155
		-- upvalues: v16 (copy), v40 (copy), v39 (copy), v42 (copy), v29 (copy), n1 (copy), v41 (copy), GetFFlagAddPeoplePageCardLayout (copy), v27 (copy), GetFFlagNewPeopleButtonOrder (copy), v48 (copy), v35 (copy), GetFFlagNewPeoplePageIcons (copy), Constants (copy), v49 (copy), v37 (copy), v32 (copy), ButtonVariant (copy), v34 (copy), v45 (copy), v44 (copy), v46 (copy), v43 (copy), v31 (copy), FFlagStandardizeSafetyIcon (copy), v28 (copy), GuiService (copy), v38 (copy), v30 (copy)
		local t1 = {}
		local t2 = {
			isBuilderIcon = false,
			id = v16.PERSON_BUTTONS.MUTE_PLAYER,
			animatedIcon = v40,
			buttonState = v39,
			shouldShow = function() -- line: 163
				-- upvalues: v42 (copy)
				return v42
			end,
			onActivated = function(s1: string?) -- line: 166
				-- upvalues: v29 (copy), n1 (copy), v41 (copy), GetFFlagAddPeoplePageCardLayout (copy), v27 (copy)
				v29:trackToggleMutePlayer(n1, v41(false), if not GetFFlagAddPeoplePageCardLayout() then nil else s1)
				v27.togglePlayerMute(n1)
			end,
			layoutOrder = not GetFFlagNewPeopleButtonOrder() and 10 or 30,
			isGrayedOut = v41
		}

		if GetFFlagAddPeoplePageCardLayout() then
			t1[v16.PERSON_BUTTONS.MUTE_PLAYER] = t2
		else
			table.insert(t1, t2)
		end

		local t3 = {
			id = v16.PERSON_BUTTONS.BLOCK_PLAYER,
			text = if not v48 then nil else v35.unblock,
			onIcon = if not v48 then if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.BLOCK_LEGACY else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.BLOCK_NEW else nil,
			shouldShow = function() -- line: 196
				-- upvalues: v49 (copy)
				return v49
			end,
			onActivated = function(s2: string?) -- line: 199
				-- upvalues: v37 (copy), v48 (copy), v32 (copy), GetFFlagAddPeoplePageCardLayout (copy)
				if v37 then
					if v48 then
						v32.unblockPlayer(v37, if not GetFFlagAddPeoplePageCardLayout() then nil else s2)

						return
					end

					v32.blockPlayer(v37, if not GetFFlagAddPeoplePageCardLayout() then nil else s2)
				end
			end,
			buttonVariant = if not v48 then nil else ButtonVariant.Subtle,
			layoutOrder = not GetFFlagNewPeopleButtonOrder() and 40 or 10,
			isBuilderIcon = GetFFlagNewPeoplePageIcons()
		}

		if GetFFlagAddPeoplePageCardLayout() then
			t1[v16.PERSON_BUTTONS.BLOCK_PLAYER] = t3
		else
			table.insert(t1, t3)
		end

		local t4 = {
			layoutOrder = 60,
			id = v16.PERSON_BUTTONS.ADD_FRIEND,
			text = if not v34 then v45 else nil,
			onIcon = if v34 then if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.ADD_FRIEND_LEGACY else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.ADD_FRIEND_NEW else nil,
			offIcon = if v34 then if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.FRIEND_LEGACY else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.FRIEND_NEW else nil,
			buttonState = v44,
			buttonVariant = if not v34 then v46 else nil,
			shouldShow = function() -- line: 239
				-- upvalues: v43 (copy)
				return v43
			end,
			onActivated = function(s3: string?) -- line: 242
				-- upvalues: v29 (copy), GetFFlagAddPeoplePageCardLayout (copy), v31 (copy), v37 (copy)
				v29:trackRequestFriendship(if not GetFFlagAddPeoplePageCardLayout() then nil else s3)
				v31.sendFriendRequest(v37)
			end,
			isDisabled = v31.getIsFriendButtonDisabled(n1),
			isGrayedOut = v31.getIsFriendButtonGrayedOut(n1),
			isBuilderIcon = GetFFlagNewPeoplePageIcons()
		}

		if GetFFlagAddPeoplePageCardLayout() then
			t1[v16.PERSON_BUTTONS.ADD_FRIEND] = t4
		else
			table.insert(t1, t4)
		end

		local t5 = {
			id = v16.PERSON_BUTTONS.REPORT_PLAYER,
			onIcon = if not FFlagStandardizeSafetyIcon then if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_LEGACY else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_NEW else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.REPORT_PLAYER_FLAG,
			shouldShow = function() -- line: 270
				-- upvalues: v49 (copy)
				return v49
			end,
			onActivated = function(s4: string?) -- line: 273
				-- upvalues: v37 (copy), v28 (copy), GetFFlagAddPeoplePageCardLayout (copy)
				if v37 then
					v28:ReportPlayer(v37, not GetFFlagAddPeoplePageCardLayout() and "MenuPlayerList" or s4)
				end
			end,
			layoutOrder = not GetFFlagNewPeopleButtonOrder() and 30 or 40,
			isBuilderIcon = GetFFlagNewPeoplePageIcons()
		}

		if GetFFlagAddPeoplePageCardLayout() then
			t1[v16.PERSON_BUTTONS.REPORT_PLAYER] = t5
		else
			table.insert(t1, t5)
		end

		local t6 = {
			layoutOrder = 20,
			id = v16.PERSON_BUTTONS.INSPECT,
			onIcon = if not GetFFlagNewPeoplePageIcons() then Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.INSPECT_LEGACY else Constants.PEOPLEPAGE.PERSON_BUTTONS.ICON.INSPECT_NEW,
			shouldShow = function() -- line: 297
				-- upvalues: GuiService (copy)
				return GuiService:GetInspectMenuEnabled()
			end,
			onActivated = function(s5: string?) -- line: 300
				-- upvalues: v37 (copy), GetFFlagAddPeoplePageCardLayout (copy), v29 (copy), v38 (copy), GuiService (copy), v30 (copy)
				if v37 then
					if GetFFlagAddPeoplePageCardLayout() then
						v29:trackInspectButton(game.GameId, v38, s5)
					else
						v29:trackInspectButton(game.GameId, v38)
					end

					GuiService:InspectPlayerFromUserIdWithCtx(v37.UserId, "escapeMenu")

					local v61 = v30.hubRef()

					if v61 then
						v61:SetVisibility(false)
					end
				end
			end,
			isBuilderIcon = GetFFlagNewPeoplePageIcons()
		}

		if GetFFlagAddPeoplePageCardLayout() then
			t1[v16.PERSON_BUTTONS.INSPECT] = t6

			return t1
		end

		table.insert(t1, t6)

		return t1
	end, {
		v42,
		v43,
		v49,
		v48,
		v34,
		v45,
		v46,
		v44
	}))
end

return usePersonButtonConfigs
