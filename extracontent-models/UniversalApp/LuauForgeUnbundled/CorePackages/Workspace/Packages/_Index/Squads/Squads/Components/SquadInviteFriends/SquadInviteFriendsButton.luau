local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")
local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsMenu")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Models.UserModel
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local useIsInviteButtonDisabled = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useIsInviteButtonDisabled")

local react = dependencies.React
local useLocalization = dependencies.Hooks.useLocalization

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local friendsListContext = FriendsMenu.FriendsListContext
local inviteCallbackContext = FriendsMenu.InviteCallbackContext
local selectedUsersContext = FriendsMenu.SelectedUsersContext

local fFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags").FFlagEnablePartyQuickStartButton

local encodeUserIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/encodeUserIds")
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadRootViewType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadRootViewType

local v5 = {
	[userModel.PresenceType.OFFLINE] = 0,
	[userModel.PresenceType.ONLINE] = 1,
	[userModel.PresenceType.IN_GAME] = 2,
	[userModel.PresenceType.IN_STUDIO] = 3
}

local function getFFlagRenameFriendsToConnectionsPartyLobby()
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

local function SquadInviteFriendsButton(props)
	local v6 = react.useContext(selectedUsersContext)
	local v7 = react.useContext(inviteCallbackContext)
	local v8 = react.useContext(friendsListContext)
	local v9 = react.useContext(squadExternalContractContext)

	local v10 = useIsInviteButtonDisabled(v6.selectedFriendsSize, v6.selectedFriends or {}, v6.preselectedUsers or {})

	local v11 = useLocalization({
		addFriendsText = "Feature.Chat.Label.AddFriends",
		addConnectionsText = "CommonUI.Features.Label.AddConnections"
	})
	local v12

	if fFlagEnablePartyQuickStartButton then
		local v13 = v9.useSquadRootView()

		local ref = react.useRef({})

		local v14 = react.useCallback(function()
			if v8.isFetchingFriends then
				return {}, {}
			end

			local ids = {}
			local result = {}

			for k, friend in pairs(v8.friends) do
				if friend.presence == userModel.PresenceType.OFFLINE then
					continue
				end

				table.insert(ids, (tonumber(friend.id)))
				table.insert(result, v5[friend.presence])
			end

			return ids, result
		end, { v8.isFetchingFriends, v8.friends })

		local v15 = react.useCallback(function()
			local set = {}
			local ids = {}
			local result = {}

			for k, selectedFriend in pairs(v6.selectedFriends) do
				set[k] = true
			end

			for i, friend in ipairs(v8.friends) do
				if not set[friend.id] then
					continue
				end

				table.insert(ids, (tonumber(friend.id)))
				table.insert(result, v5[friend.presence])
			end

			return ids, result
		end, { v6.selectedFriends, v8.friends })

		react.useEffect(function()
			local v16, v17 = v14()
			local v18, v19 = v15()
			ref.current = {
				onlineFriendsIds = v16,
				onlineFriendsPresence = v17,
				selectedFriendsIds = v18,
				selectedFriendsPresence = v19,
				numActiveFriends = #v16,
				numSelectedFriends = #v18
			}
		end, { v14, v15 })

		local v16 = react.useCallback(function(p2)
			local current = ref.current

			local joined = Cryo.Dictionary.join(props.analyticsInfo, {
				actionLocation = v9.squadLocation,
				actionType = p2,
				activeFriendsUserIds = encodeUserIds(current.onlineFriendsIds),
				activeFriendsPresences = encodeUserIds(current.onlineFriendsPresence),
				selectedFriendsUserIds = encodeUserIds(current.selectedFriendsIds),
				selectedFriendsPresences = encodeUserIds(current.selectedFriendsPresence),
				numActiveFriends = current.numActiveFriends,
				numSelectedFriends = current.numSelectedFriends,
				clientTimeStamp = os.time()
			})

			v9.fireSquadAnalytics(EventNames.MultiInviteMenuActionStatus, joined)
		end, { v9.squadLocation, v9.fireSquadAnalytics, props.analyticsInfo })

		react.useEffect(function()
			return function()
				if props.partyStartedRef.current then
					v16("multi_invite_attempted")
				else
					v16("leave_page")
				end
			end
		end, {})

		react.useEffect(function()
			if v13 == squadRootViewType.None then
				v16("leave_page")
			end
		end, { v13, v16 })

		v12 = react.useCallback(function()
			v16("multi_invite_button_clicked")
			v7.inviteMultiFriends(v6.selectedFriends)
		end, { v16, v7.inviteMultiFriends, v6.selectedFriends })
	else
		v12 = react.useCallback(function()
			v7.inviteMultiFriends(v6.selectedFriends)
		end, { v7.inviteMultiFriends, v6.selectedFriends })
	end

	local createElement = react.createElement
	local v14 = {
		onActivated = v12,
		buttonTextOverride = { TextWrapped = false },
		buttonType = buttonType.PrimarySystem,
		size = UDim2.new(1, 0, 0, 36),
		text = 0,
		isDisabled = 0
	}
	local v15

	if fFlagEnablePartyQuickStartButton then
		v15 = props.buttonText
	elseif UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() then
		v15 = v11.addConnectionsText
	else
		v15 = v11.addFriendsText
	end

	v14.text = v15

	v14.isDisabled = v10
	return createElement(button, v14)
end

return SquadInviteFriendsButton
