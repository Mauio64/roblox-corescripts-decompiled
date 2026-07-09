local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local SquadInviteSourceEnum = require(Squads.Enums.SquadInviteSourceEnum)
local inviteToSquad = require(Squads.Thunks.inviteToSquad)
local InviteToParentChannel = require(Squads.Thunks.InviteToParentChannel)
local NotificationModalsManager = require(SquadsParent.NotificationModalsManager)
local Promise = require(SquadsParent.Promise)
local UIBlox = require(SquadsParent.UIBlox)
local useAppPolicy = require(SquadsParent.UniversalAppPolicy).useAppPolicy
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local Cryo = dependencies.Cryo
local React = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local Constants = require(SquadsParent.SquadsCore.Constants)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local useNavigation = dependencies.useNavigation
local useStore = dependencies.Hooks.useStore
local Images = UIBlox.App.ImageSet.Images
local SquadInviteFriends = require(script.Parent.SquadInviteFriends)

local function SquadInviteFriendsContainer(p1) -- line: 33
	-- upvalues: React (copy), SquadExternalContractContext (copy), useNavigation (copy), useDispatch (copy), useStore (copy), useLocalization (copy), useCurrentSquadSelector (copy), useLocalUserId (copy), useAppPolicy (copy), Cryo (copy), NotificationModalsManager (copy), Images (copy), SquadInviteSourceEnum (copy), EventNames (copy), Promise (copy), InviteToParentChannel (copy), inviteToSquad (copy), Constants (copy), SquadPromptType (copy), SquadInviteFriends (copy)
	local v27 = React.useContext(SquadExternalContractContext)
	local v28 = useNavigation()
	local v29 = useDispatch()
	local v30 = useStore()
	local v31 = useLocalization({
		addText = "Feature.Squads.Action.Add",
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})
	local v32 = React.useRef(false)
	local v33 = useCurrentSquadSelector()
	local v34 = (not v33 or not v33.parentChannelId) and "" or v33.parentChannelId
	local v35 = v27.useGetConversationFromId(v34)
	local v36 = useLocalUserId()
	local v37 = React.useCallback(function(p2) -- line: 57
		return p2.getCanUsePlatformChat()
	end, {})
	local v38 = useAppPolicy(v37)
	local v39 = React.useCallback(function(p3) -- line: 65
		-- upvalues: Cryo (copy), v31 (copy), NotificationModalsManager (copy), Images (copy)
		local v44 = Cryo.Dictionary.keys(p3)
		local displayName = p3[v44[1]].displayName
		local v46

		if #v44 > 2 then
			v46 = v31.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#v44 - 1)
			})
		elseif #v44 == 2 then
			local displayName2 = p3[v44[2]].displayName

			v46 = v31.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			v46 = v31.youAddedToChat:gsub("{(.-)}", {
				username = displayName
			})
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = Images["icons/actions/friends/friendAdd"],
			toastTitle = v46
		})
	end, {
		v31.youAddedMoreThanTwoToChat,
		v31.youAddedToChat,
		v31.youAddedTwoToChat
	})
	local v40 = React.useCallback(function(p4) -- line: 92
		-- upvalues: Cryo (copy), v34 (copy), SquadInviteSourceEnum (copy), v27 (copy), EventNames (copy)
		local v49 = Cryo.Dictionary.union({
			parentChannelId = v34,
			source = SquadInviteSourceEnum.SourceSquadInvitePage
		}, p4)

		v27.fireSquadAnalytics(EventNames.SquadInvite, v49)
	end, {
		v34,
		v27.fireSquadAnalytics
	})
	local v41 = React.useCallback(function(p5) -- line: 101
		-- upvalues: v33 (copy), v35 (copy), Cryo (copy), v36 (copy), v27 (copy), v29 (copy), Promise (copy), InviteToParentChannel (copy), v28 (copy), inviteToSquad (copy), v40 (copy), v39 (copy), Constants (copy), v30 (copy), SquadPromptType (copy), v38 (copy)
		if not v33 or not v35 then
			return
		end

		local v51 = Cryo.Dictionary.keys(p5)
		local v52 = Cryo.List.toSet(v35.participants)
		local v53 = Cryo.List.filter(v51, function(p6) -- line: 112
			-- upvalues: v52 (copy)
			return v52[p6] == nil
		end)

		local function v54() -- line: 116
			-- upvalues: Cryo (copy), v35 (copy), v51 (copy), v36 (copy), v27 (copy), v29 (copy), Promise (copy), v53 (copy), InviteToParentChannel (copy), v28 (copy), inviteToSquad (copy), v33 (copy), v40 (copy), v39 (copy), p5 (copy)
			local v59 = Cryo.List.filter(v35.participants, function(p7) -- line: 119
				-- upvalues: Cryo (copy), v51 (copy), v36 (copy)
				return Cryo.List.find(v51, (tostring(p7))) == nil and p7 ~= v36
			end)
			local t1 = {}

			if #v59 > 0 then
				for _, v in ipairs(v59) do
					table.insert(t1, v27.removeUserFromParentChannel(v29, v35.id, v))
				end
			end

			Promise.all(t1):andThen(function() -- line: 136
				-- upvalues: v53 (copy), v29 (copy), InviteToParentChannel (copy), v59 (copy), v28 (copy), v35 (copy), inviteToSquad (copy), v33 (copy), v36 (copy), v40 (copy), v39 (copy), p5 (copy), v27 (copy)
				if #v53 > 0 then
					v29(InviteToParentChannel({
						dispatch = v29,
						onErrorCallback = function() -- line: 140
							-- upvalues: v59 (copy), v28 (copy)
							if #v59 > 0 then
								v28.pop()
							end
						end,
						onSuccessCallback = function(s1: string) -- line: 145
							-- upvalues: v35 (copy), v29 (copy), inviteToSquad (copy), v33 (copy), v36 (copy), v53 (copy), v40 (copy), v39 (copy), p5 (copy), v28 (copy)
							local v65 = s1 ~= v35.id

							v29(inviteToSquad(v33.squadId, s1, v36, v53, v40, v65))
							v39(p5)
							v28.pop()
						end,
						parentChannel = v35,
						userIds = v53,
						squadExternalContext = v27
					}))

					return
				end

				v28.pop()
			end)
		end

		if v35.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and v35.moderationType == Constants.TRUSTED_COMM_MODERATION_TYPE then
			v27.setSquadPrompt(v30, {
				hideCancelButton = true,
				promptType = SquadPromptType.CannotExpandToGroupChatActiveParty,
				onConfirm = function() -- line: 177
					-- upvalues: v28 (copy)
					v28.pop()
				end
			})

			return
		end

		if v35.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v38 and #v53 > 0 then
			v27.setSquadPrompt(v30, {
				hideCancelButton = false,
				promptType = SquadPromptType.ConfirmInviteToSquad,
				onConfirm = function() -- line: 189
					-- upvalues: v54 (copy)
					v54()
				end
			})

			return
		end

		v54()
	end, {
		v33,
		v29,
		v28,
		v35,
		v40,
		v39,
		v27.setSquadPrompt,
		v27.inviteToParentChannel,
		v30,
		v38,
		v36,
		v27
	})

	return React.createElement(SquadInviteFriends, {
		participants = p1.participants,
		onMultiInvite = v41,
		buttonText = v31.addText,
		analyticsInfo = {
			selectionPageType = "SquadInvite"
		},
		partyStartedRef = v32,
		onRemoveCallback = if not v35 then nil else function(p8, p9) -- line: 220
			-- upvalues: Cryo (copy), v35 (copy), v27 (copy), v30 (copy), v31 (copy), SquadPromptType (copy)
			if Cryo.List.find(v35.participants, p8) then
				v27.setSquadPrompt(v30, {
					hideCancelButton = true,
					bodyTextLocalizationProps = {
						displayName = p9 or v31.user
					},
					promptType = SquadPromptType.RemoveFromParty
				})
			end
		end,
		preselectedUsers = v35 and (v35.participants and Cryo.List.filter(v35.participants, function(p10) -- line: 235
			-- upvalues: v36 (copy)
			return p10 ~= v36
		end)),
		preselectedUsersUnremovable = if not v35 then nil else v35.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE or v35.initiator ~= tostring(v36),
		onSelectedFriendsChanged = p1.onSelectedFriendsChanged,
		shouldHideFooterButton = p1.shouldHideFooterButton
	})
end

return SquadInviteFriendsContainer
