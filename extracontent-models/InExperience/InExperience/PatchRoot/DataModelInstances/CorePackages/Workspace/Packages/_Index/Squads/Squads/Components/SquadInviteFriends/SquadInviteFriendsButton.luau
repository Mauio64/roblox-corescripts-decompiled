local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local Cryo = require(parent.Cryo)
local FriendsMenu = require(parent.FriendsMenu)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local UIBlox = require(parent.UIBlox)
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local dependencies = require(Squads.dependencies)
local useIsInviteButtonDisabled = require(Squads.Hooks.useIsInviteButtonDisabled)

local react = dependencies.React
local useLocalization = dependencies.Hooks.useLocalization

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FriendsListContext = FriendsMenu.FriendsListContext
local InviteCallbackContext = FriendsMenu.InviteCallbackContext
local SelectedUsersContext = FriendsMenu.SelectedUsersContext

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton

local encodeUserIds = require(parent.SquadsCore.encodeUserIds)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)

local Enums = require(parent.SquadsCore.Enums)
local SquadRootViewType = Enums.SquadRootViewType

local v = {
	[UserModel.PresenceType.OFFLINE] = 0,
	[UserModel.PresenceType.ONLINE] = 1,
	[UserModel.PresenceType.IN_GAME] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 3
}

local function getFFlagRenameFriendsToConnectionsPartyLobby() -- 1 equivalent call inferred from this helper
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

local function SquadInviteFriendsButton(props)
	local v2 = react.useContext(SelectedUsersContext)
	local v3 = react.useContext(InviteCallbackContext)
	local v4 = react.useContext(FriendsListContext)
	local v5 = react.useContext(SquadExternalContractContext)

	local isDisabled = useIsInviteButtonDisabled(
		v2.selectedFriendsSize,
		v2.selectedFriends or {},
		v2.preselectedUsers or {}
	)

	local v6 = useLocalization({
		addFriendsText = "Feature.Chat.Label.AddFriends",
		addConnectionsText = "CommonUI.Features.Label.AddConnections"
	})
	local onActivated

	if FFlagEnablePartyQuickStartButton then
		local v7 = v5.useSquadRootView()

		local ref = react.useRef({})

		local v8 = react.useCallback(function()
			if v4.isFetchingFriends then
				return {}, {}
			end

			local ids = {}
			local result = {}

			for _, friend in pairs(v4.friends) do
				if friend.presence == UserModel.PresenceType.OFFLINE then
					continue
				end

				table.insert(ids, (tonumber(friend.id)))
				table.insert(result, v[friend.presence])
			end

			return ids, result
		end, { v4.isFetchingFriends, v4.friends })

		local v9 = react.useCallback(function()
			local set = {}
			local ids = {}
			local result = {}

			for k, _ in pairs(v2.selectedFriends) do
				set[k] = true
			end

			for _, friend in ipairs(v4.friends) do
				if not set[friend.id] then
					continue
				end

				table.insert(ids, (tonumber(friend.id)))
				table.insert(result, v[friend.presence])
			end

			return ids, result
		end, { v2.selectedFriends, v4.friends })

		react.useEffect(function()
			local onlineFriendsIds, onlineFriendsPresence = v8()
			local selectedFriendsIds, selectedFriendsPresence = v9()
			ref.current = {
				onlineFriendsIds = onlineFriendsIds,
				onlineFriendsPresence = onlineFriendsPresence,
				selectedFriendsIds = selectedFriendsIds,
				selectedFriendsPresence = selectedFriendsPresence,
				numActiveFriends = #onlineFriendsIds,
				numSelectedFriends = #selectedFriendsIds
			}
		end, { v8, v9 })

		local v10 = react.useCallback(function(actionType)
			local current = ref.current

			local joined = Cryo.Dictionary.join(props.analyticsInfo, {
				actionLocation = v5.squadLocation,
				actionType = actionType,
				activeFriendsUserIds = encodeUserIds(current.onlineFriendsIds),
				activeFriendsPresences = encodeUserIds(current.onlineFriendsPresence),
				selectedFriendsUserIds = encodeUserIds(current.selectedFriendsIds),
				selectedFriendsPresences = encodeUserIds(current.selectedFriendsPresence),
				numActiveFriends = current.numActiveFriends,
				numSelectedFriends = current.numSelectedFriends,
				clientTimeStamp = os.time()
			})

			v5.fireSquadAnalytics(EventNames.MultiInviteMenuActionStatus, joined)
		end, { v5.squadLocation, v5.fireSquadAnalytics, props.analyticsInfo })

		react.useEffect(function()
			return function()
				if props.partyStartedRef.current then
					v10("multi_invite_attempted")
				else
					v10("leave_page")
				end
			end
		end, {})

		react.useEffect(function()
			if v7 == SquadRootViewType.None then
				v10("leave_page")
			end
		end, { v7, v10 })

		onActivated = react.useCallback(function()
			v10("multi_invite_button_clicked")
			v3.inviteMultiFriends(v2.selectedFriends)
		end, { v10, v3.inviteMultiFriends, v2.selectedFriends })
	else
		onActivated = react.useCallback(function()
			v3.inviteMultiFriends(v2.selectedFriends)
		end, { v3.inviteMultiFriends, v2.selectedFriends })
	end

	local createElement = react.createElement
	local v7 = {
		onActivated = onActivated,
		buttonTextOverride = { TextWrapped = false },
		buttonType = ButtonType.PrimarySystem,
		size = UDim2.new(1, 0, 0, 36),
		text = 0,
		isDisabled = 0
	}
	local text

	if FFlagEnablePartyQuickStartButton then
		text = props.buttonText
	elseif getFFlagRenameFriendsToConnectionsPartyLobby() then -- inferred equivalent call
		text = v6.addConnectionsText
	else
		text = v6.addFriendsText
	end

	v7.text = text

	v7.isDisabled = isDisabled
	return createElement(Button, v7)
end

return SquadInviteFriendsButton
