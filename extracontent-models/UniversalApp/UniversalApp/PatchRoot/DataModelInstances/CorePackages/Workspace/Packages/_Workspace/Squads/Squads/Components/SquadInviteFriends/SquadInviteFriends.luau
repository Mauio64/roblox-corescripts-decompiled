local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local FriendsMenu = require(SquadsParent.FriendsMenu)
local NotificationModalsManager = require(SquadsParent.NotificationModalsManager)
local Promise = require(SquadsParent.Promise)
local UIBlox = require(SquadsParent.UIBlox)
local useAppPolicy = require(SquadsParent.UniversalAppPolicy).useAppPolicy
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local ReactFocusNavigation = require(SquadsParent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require(SquadsParent.FocusBehaviors)
local dependencies = require(Squads.dependencies)
local Constants = require(Squads.Common.Constants)
local InviteToParentChannel = require(Squads.Thunks.InviteToParentChannel)
local SquadInviteSourceEnum = require(Squads.Enums.SquadInviteSourceEnum)
local Cryo = dependencies.Cryo
local React = dependencies.React
local SharedFlags = dependencies.SharedFlags
local Constants2 = require(SquadsParent.SquadsCore.Constants)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local useDispatch = dependencies.Hooks.useDispatch
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useNavigation = dependencies.useNavigation
local useIsInviteButtonDisabled = require(Squads.Hooks.useIsInviteButtonDisabled)
local FriendsMenuFriendsList = FriendsMenu.FriendsMenuFriendsList
local FriendsMenuContextWrapper = FriendsMenu.FriendsMenuContextWrapper
local FriendsMenuSearch = FriendsMenu.FriendsMenuSearch
local FriendMenuType = FriendsMenu.FriendMenuType
local SelectedUsersScroller = FriendsMenu.SelectedUsersScroller
local SelectedUsersContext = FriendsMenu.SelectedUsersContext
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local SquadInviteFriendsButton = require(script.Parent.SquadInviteFriendsButton)
local inviteToSquad = require(Squads.Thunks.inviteToSquad)

local function v42() -- line: 59
end

local t1 = {
	buttonText = "Add",
	preselectedUsers = nil,
	preselectedUsersUnremovable = false,
	shouldHideFooterButton = nil,
	onMultiInvite = function(_) -- line: 63
	end,
	participants = {},
	analyticsInfo = {},
	onRemoveCallback = function() -- line: 66
	end,
	onSelectedFriendsChanged = function() -- line: 69
	end
}

local function SelectedFriendsListener(t2: {[any]: any}) -- line: 73
	-- upvalues: React (copy), SelectedUsersContext (copy), FFlagEnablePartyQuickStartButton (copy), useIsInviteButtonDisabled (copy)
	local v48 = React.useContext(SelectedUsersContext)
	local selectedFriendsSize = v48.selectedFriendsSize
	local selectedFriends = v48.selectedFriends
	local v51 = React.useCallback(function() -- line: 82
		-- upvalues: FFlagEnablePartyQuickStartButton (copy), t2 (copy), selectedFriends (copy)
		if FFlagEnablePartyQuickStartButton and t2.onMultiInvite then
			t2.onMultiInvite(selectedFriends)

			return
		end

		t2.fallbackOnMultiInvite(selectedFriends)
	end, {
		t2.onMultiInvite,
		t2.fallbackOnMultiInvite,
		selectedFriends
	})
	local v52 = useIsInviteButtonDisabled(selectedFriendsSize, v48.selectedFriends or {}, v48.preselectedUsers or {})

	React.useEffect(function() -- line: 96
		-- upvalues: t2 (copy), v52 (copy), v51 (copy)
		t2.onSelectedFriendsChanged(not v52, v51)
	end, {
		v52,
		v51,
		t2.onSelectedFriendsChanged
	})

	return nil
end
local function SquadInviteFriends(p2) -- line: 103
	-- upvalues: Cryo (copy), t1 (copy), React (copy), FocusNavigationContext (copy), SquadExternalContractContext (copy), useDispatch (copy), useNavigation (copy), useStore (copy), useStyle (copy), useAppPolicy (copy), useLocalUserId (copy), useCurrentSquadSelector (copy), useLocalization (copy), SquadInviteSourceEnum (copy), EventNames (copy), NotificationModalsManager (copy), Images (copy), Promise (copy), InviteToParentChannel (copy), inviteToSquad (copy), Constants2 (copy), SquadPromptType (copy), FocusBehaviors (copy), FocusNavigationService (copy), CoreGui (copy), FriendsMenuContextWrapper (copy), v42 (copy), FFlagEnablePartyQuickStartButton (copy), Constants (copy), SelectedFriendsListener (copy), FriendsMenuSearch (copy), SelectedUsersScroller (copy), FriendsMenuFriendsList (copy), FriendMenuType (copy), SquadInviteFriendsButton (copy)
	local v54 = Cryo.Dictionary.join(t1, p2)
	local v55 = React.useContext(FocusNavigationContext)
	local v56 = React.useContext(SquadExternalContractContext)
	local v57 = useDispatch()
	local v58 = useNavigation()
	local v59 = useStore()
	local Theme = useStyle().Theme
	local v61, v62 = React.useState(0)
	local v63 = React.useCallback(function(p3) -- line: 116
		return p3.getCanUsePlatformChat()
	end, {})
	local v64 = useAppPolicy(v63)
	local v65 = React.useRef(nil)
	local v66 = React.useRef(nil)
	local v67 = useLocalUserId()
	local v68 = React.useCallback(function(p4) -- line: 126
		-- upvalues: v62 (copy)
		v62(p4.AbsoluteSize.Y)
	end, { v62 })
	local v69 = useCurrentSquadSelector()
	local v70 = (not v69 or not v69.parentChannelId) and "" or v69.parentChannelId
	local v71 = v56.useGetConversationFromId(v70)
	local v72 = useLocalization({
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})
	local v73 = React.useCallback(function(p5) -- line: 143
		-- upvalues: Cryo (copy), v70 (copy), SquadInviteSourceEnum (copy), v56 (copy), EventNames (copy)
		local v79 = Cryo.Dictionary.union({
			parentChannelId = v70,
			source = SquadInviteSourceEnum.SourceSquadInvitePage
		}, p5)

		v56.fireSquadAnalytics(EventNames.SquadInvite, v79)
	end, {
		v70,
		v56.fireSquadAnalytics
	})
	local v74 = React.useCallback(function(p6) -- line: 155
		-- upvalues: Cryo (copy), v72 (copy), NotificationModalsManager (copy), Images (copy)
		local v81 = Cryo.Dictionary.keys(p6)
		local displayName = p6[v81[1]].displayName
		local v83

		if #v81 > 2 then
			v83 = v72.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#v81 - 1)
			})
		elseif #v81 == 2 then
			local displayName2 = p6[v81[2]].displayName

			v83 = v72.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			v83 = v72.youAddedToChat:gsub("{(.-)}", {
				username = displayName
			})
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = Images["icons/actions/friends/friendAdd"],
			toastTitle = v83
		})
	end, {
		v72.youAddedMoreThanTwoToChat,
		v72.youAddedToChat,
		v72.youAddedTwoToChat
	})
	local v75 = React.useCallback(function(p7) -- line: 182
		-- upvalues: v69 (copy), v71 (copy), Cryo (copy), v67 (copy), v56 (copy), v57 (copy), Promise (copy), InviteToParentChannel (copy), v58 (copy), inviteToSquad (copy), v73 (copy), v74 (copy), Constants2 (copy), v64 (copy), v59 (copy), SquadPromptType (copy)
		if not v69 or not v71 then
			return
		end

		local v86 = Cryo.Dictionary.keys(p7)
		local v87 = Cryo.List.toSet(v71.participants)
		local v88 = Cryo.List.filter(v86, function(p8) -- line: 193
			-- upvalues: v87 (copy)
			return v87[p8] == nil
		end)

		local function v89() -- line: 197
			-- upvalues: Cryo (copy), v71 (copy), v86 (copy), v67 (copy), v56 (copy), v57 (copy), Promise (copy), v88 (copy), InviteToParentChannel (copy), v58 (copy), inviteToSquad (copy), v69 (copy), v73 (copy), v74 (copy), p7 (copy)
			local v96 = Cryo.List.filter(v71.participants, function(p9) -- line: 200
				-- upvalues: Cryo (copy), v86 (copy), v67 (copy)
				return Cryo.List.find(v86, (tostring(p9))) == nil and p9 ~= v67
			end)
			local t3 = {}

			for _, v in ipairs(v96) do
				table.insert(t3, v56.removeUserFromParentChannel(v57, v71.id, v))
			end

			Promise.all(t3):andThen(function() -- line: 215
				-- upvalues: v88 (copy), v57 (copy), InviteToParentChannel (copy), v96 (copy), v58 (copy), v71 (copy), inviteToSquad (copy), v69 (copy), v67 (copy), v73 (copy), v74 (copy), p7 (copy), v56 (copy)
				if #v88 > 0 then
					v57(InviteToParentChannel({
						dispatch = v57,
						onErrorCallback = function() -- line: 219
							-- upvalues: v96 (copy), v58 (copy)
							if #v96 > 0 then
								v58.pop()
							end
						end,
						onSuccessCallback = function(s1: string) -- line: 224
							-- upvalues: v71 (copy), v57 (copy), inviteToSquad (copy), v69 (copy), v67 (copy), v88 (copy), v73 (copy), v74 (copy), p7 (copy), v58 (copy)
							local v102 = s1 ~= v71.id

							v57(inviteToSquad(v69.squadId, s1, v67, v88, v73, v102))
							v74(p7)
							v58.pop()
						end,
						parentChannel = v71,
						squadExternalContext = v56,
						userIds = v88
					}))

					return
				end

				v58.pop()
			end)
		end

		if v71.type == Constants2.CONVERSATION_CHANNEL_GROUP_TYPE and v64 and #v88 > 0 then
			v56.setSquadPrompt(v59, {
				hideCancelButton = false,
				promptType = SquadPromptType.ConfirmInviteToSquad,
				onConfirm = function() -- line: 257
					-- upvalues: v89 (copy)
					v89()
				end
			})

			return
		end

		v89()
	end, {
		v69,
		v57,
		v58,
		v71,
		v73,
		v74,
		v56.setSquadPrompt,
		v56.inviteToParentChannel,
		v56.removeUserFromParentChannel,
		v59,
		v67
	})

	React.useEffect(function() -- line: 278
		-- upvalues: v55 (copy), v65 (copy), v66 (copy), FocusBehaviors (copy), FocusNavigationService (copy), CoreGui (copy)
		if v55 and (v65.current ~= nil and v66.current ~= nil) then
			if v55 then
				local v90 = FocusBehaviors.default(v66.current)
				local current = v65.current

				v55:registerFocusBehavior(current, v90)

				return function() -- line: 284
					-- upvalues: v55 (copy), current (copy), v90 (copy)
					v55:deregisterFocusBehavior(current, v90)
				end
			end
		elseif v65.current ~= nil and v66.current ~= nil then
			FocusNavigationService.new(CoreGui):registerFocusBehavior(v65.current, FocusBehaviors.default(v66.current))
		end

		return function() -- line: 296
		end
	end, { v55 })

	return React.createElement(FriendsMenuContextWrapper, {
		isLoadingCustomParams = false,
		inviteSingleFriend = v42,
		inviteMultiFriends = if not FFlagEnablePartyQuickStartButton then v75 else v54.onMultiInvite,
		selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1,
		preselectedUsers = if not FFlagEnablePartyQuickStartButton then v71 and (v71.participants and Cryo.List.filter(v71.participants, function(p10) -- line: 308
			-- upvalues: v67 (copy)
			return p10 ~= v67
		end)) else v54.preselectedUsers,
		preselectedUsersUnremovable = if not FFlagEnablePartyQuickStartButton then if not v71 then nil else v71.type == Constants2.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE or v71.initiator ~= tostring(v67) else v54.preselectedUsersUnremovable,
		onRemoveCallback = if not FFlagEnablePartyQuickStartButton then if not v71 then nil else function(p11, p12) -- line: 321
			-- upvalues: Cryo (copy), v71 (copy), v56 (copy), v59 (copy), v72 (copy), SquadPromptType (copy)
			if Cryo.List.find(v71.participants, p11) then
				v56.setSquadPrompt(v59, {
					hideCancelButton = true,
					bodyTextLocalizationProps = {
						displayName = p12 or v72.user
					},
					promptType = SquadPromptType.RemoveFromParty
				})
			end
		end else v54.onRemoveCallback
	}, {
		SelectedFriendsListener = React.createElement(SelectedFriendsListener, {
			onMultiInvite = v54.onMultiInvite,
			fallbackOnMultiInvite = v75,
			onSelectedFriendsChanged = v54.onSelectedFriendsChanged
		}),
		ContainerFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if not v54.shouldHideFooterButton then UDim2.new(1, 0, 1, -52) else UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			ref = v65
		}, {
			VerticalLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 16),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SearchSelectFrame = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				[React.Change.AbsoluteSize] = v68
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingTop = UDim.new(0, 12)
				}),
				VerticalLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 16),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				FriendsMenuSearch = React.createElement(FriendsMenuSearch, {
					layoutOrder = 0,
					focusElement = false,
					size = UDim2.new(1, 0, 0, 36),
					ref = v66
				}),
				SelectedUsersScroller = React.createElement(SelectedUsersScroller, {
					layoutOrder = 1,
					selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1
				})
			}),
			FriendsList = React.createElement(FriendsMenuFriendsList, {
				layoutOrder = 1,
				isFullRowActivatable = true,
				backgroundTransparency = 1,
				disableSelectionParentManagement = true,
				disableListFocus = true,
				size = UDim2.new(1, 0, 1, -v61 - 16),
				parentComponentName = Constants.SQUAD_INVITE_PARENT_COMPONENT,
				menuType = FriendMenuType.MultiSelect
			})
		}),
		FriendsListButtonFrame = if not v54.shouldHideFooterButton then React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 52),
			BackgroundColor3 = Theme.BackgroundContrast.Color
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8)
			}),
			Button = React.createElement(SquadInviteFriendsButton, {
				buttonText = v54.buttonText,
				analyticsInfo = v54.analyticsInfo,
				partyStartedRef = v54.partyStartedRef
			})
		}) else nil
	})
end

return SquadInviteFriends
