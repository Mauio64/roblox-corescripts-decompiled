local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Cryo = require(SquadsParent.Cryo)
local FriendsMenu = require(SquadsParent.FriendsMenu)
local SquadExternalContractProvider = require(SquadsParent.SquadsCore.SquadExternalContractProvider)
local UIBlox = require(SquadsParent.UIBlox)
local UserModel = require(SquadsParent.UserLib).Models.UserModel
local UniversalAppPolicy = require(SquadsParent.UniversalAppPolicy)
local dependencies = require(Squads.dependencies)
local useIsInviteButtonDisabled = require(Squads.Hooks.useIsInviteButtonDisabled)
local React = dependencies.React
local useLocalization = dependencies.Hooks.useLocalization
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FriendsListContext = FriendsMenu.FriendsListContext
local InviteCallbackContext = FriendsMenu.InviteCallbackContext
local SelectedUsersContext = FriendsMenu.SelectedUsersContext
local FFlagEnablePartyQuickStartButton = require(SquadsParent.SharedFlags).FFlagEnablePartyQuickStartButton
local encodeUserIds = require(SquadsParent.SquadsCore.encodeUserIds)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadRootViewType = require(SquadsParent.SquadsCore.Enums).SquadRootViewType
local t1 = {
	[UserModel.PresenceType.OFFLINE] = 0,
	[UserModel.PresenceType.ONLINE] = 1,
	[UserModel.PresenceType.IN_GAME] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 3
}

local function getFFlagRenameFriendsToConnectionsPartyLobby() -- line: 46
	-- upvalues: UniversalAppPolicy (copy)
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end
local function SquadInviteFriendsButton(t2: {[any]: any}) -- line: 50
	-- upvalues: React (copy), SelectedUsersContext (copy), InviteCallbackContext (copy), FriendsListContext (copy), SquadExternalContractContext (copy), useIsInviteButtonDisabled (copy), useLocalization (copy), FFlagEnablePartyQuickStartButton (copy), UserModel (copy), t1 (copy), Cryo (copy), encodeUserIds (copy), EventNames (copy), SquadRootViewType (copy), Button (copy), ButtonType (copy), UniversalAppPolicy (copy)
	local v27 = React.useContext(SelectedUsersContext)
	local v28 = React.useContext(InviteCallbackContext)
	local v29 = React.useContext(FriendsListContext)
	local v30 = React.useContext(SquadExternalContractContext)
	local selectedFriendsSize = v27.selectedFriendsSize
	local v32 = useIsInviteButtonDisabled(selectedFriendsSize, v27.selectedFriends or {}, v27.preselectedUsers or {})
	local v33 = useLocalization({
		addFriendsText = "Feature.Chat.Label.AddFriends",
		addConnectionsText = "CommonUI.Features.Label.AddConnections"
	})
	local v39

	if FFlagEnablePartyQuickStartButton then
		local v34 = v30.useSquadRootView()
		local v35 = React.useRef({})
		local v36 = React.useCallback(function() -- line: 77
			-- upvalues: v29 (copy), UserModel (copy), t1 (copy)
			if v29.isFetchingFriends then
				return {}, {}
			end

			local t3 = {}
			local t4 = {}

			for _, v in pairs(v29.friends) do
				if v.presence ~= UserModel.PresenceType.OFFLINE then
					table.insert(t3, (tonumber(v.id)))
					table.insert(t4, t1[v.presence])
				end
			end

			return t3, t4
		end, {
			v29.isFetchingFriends,
			v29.friends
		})
		local v37 = React.useCallback(function() -- line: 94
			-- upvalues: v27 (copy), v29 (copy), t1 (copy)
			local t5 = {}
			local t6 = {}
			local t7 = {}

			for k, _ in pairs(v27.selectedFriends) do
				t7[k] = true
			end

			for _, v in ipairs(v29.friends) do
				if t7[v.id] then
					table.insert(t5, (tonumber(v.id)))
					table.insert(t6, t1[v.presence])
				end
			end

			return t5, t6
		end, {
			v27.selectedFriends,
			v29.friends
		})

		React.useEffect(function() -- line: 113
			-- upvalues: v36 (copy), v37 (copy), v35 (copy)
			local v51, v52 = v36()
			local v53, v54 = v37()

			v35.current = {
				onlineFriendsIds = v51,
				onlineFriendsPresence = v52,
				selectedFriendsIds = v53,
				selectedFriendsPresence = v54,
				numActiveFriends = #v51,
				numSelectedFriends = #v53
			}
		end, {
			v36,
			v37
		})

		local v38 = React.useCallback(function(p1) -- line: 127
			-- upvalues: v35 (copy), Cryo (copy), t2 (copy), v30 (copy), encodeUserIds (copy), EventNames (copy)
			local current = v35.current
			local v57 = Cryo.Dictionary.join(t2.analyticsInfo, {
				actionLocation = v30.squadLocation,
				actionType = p1,
				activeFriendsUserIds = encodeUserIds(current.onlineFriendsIds),
				activeFriendsPresences = encodeUserIds(current.onlineFriendsPresence),
				selectedFriendsUserIds = encodeUserIds(current.selectedFriendsIds),
				selectedFriendsPresences = encodeUserIds(current.selectedFriendsPresence),
				numActiveFriends = current.numActiveFriends,
				numSelectedFriends = current.numSelectedFriends,
				clientTimeStamp = os.time()
			})

			v30.fireSquadAnalytics(EventNames.MultiInviteMenuActionStatus, v57)
		end, {
			v30.squadLocation,
			v30.fireSquadAnalytics,
			t2.analyticsInfo
		})

		React.useEffect(function() -- line: 146
			-- upvalues: t2 (copy), v38 (copy)
			return function() -- line: 147
				-- upvalues: t2 (copy), v38 (copy)
				if not t2.partyStartedRef.current then
					v38("leave_page")

					return
				end

				v38("multi_invite_attempted")
			end
		end, {})
		React.useEffect(function() -- line: 158
			-- upvalues: v34 (copy), SquadRootViewType (copy), v38 (copy)
			if v34 == SquadRootViewType.None then
				v38("leave_page")
			end
		end, {
			v34,
			v38
		})
		v39 = React.useCallback(function() -- line: 165
			-- upvalues: v38 (copy), v28 (copy), v27 (copy)
			v38("multi_invite_button_clicked")
			v28.inviteMultiFriends(v27.selectedFriends)
		end, {
			v38,
			v28.inviteMultiFriends,
			v27.selectedFriends
		})
	else
		v39 = React.useCallback(function() -- line: 174
			-- upvalues: v28 (copy), v27 (copy)
			v28.inviteMultiFriends(v27.selectedFriends)
		end, {
			v28.inviteMultiFriends,
			v27.selectedFriends
		})
	end

	return React.createElement(Button, {
		onActivated = v39,
		buttonTextOverride = {
			TextWrapped = false
		},
		buttonType = ButtonType.PrimarySystem,
		size = UDim2.new(1, 0, 0, 36),
		text = if not FFlagEnablePartyQuickStartButton then if not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() then v33.addFriendsText else v33.addConnectionsText else t2.buttonText,
		isDisabled = v32
	})
end

return SquadInviteFriendsButton
