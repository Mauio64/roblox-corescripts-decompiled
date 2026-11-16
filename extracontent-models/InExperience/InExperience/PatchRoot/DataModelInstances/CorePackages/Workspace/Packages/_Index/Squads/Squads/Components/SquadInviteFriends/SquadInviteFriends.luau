local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FriendsMenu = require(parent.FriendsMenu)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local Promise = require(parent.Promise)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require(parent.FocusBehaviors)

local dependencies = require(Squads.dependencies)
local Constants = require(Squads.Common.Constants)
local InviteToParentChannel = require(Squads.Thunks.InviteToParentChannel)
local SquadInviteSourceEnum = require(Squads.Enums.SquadInviteSourceEnum)

local cryo = dependencies.Cryo
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local Constants2 = require(parent.SquadsCore.Constants)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
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
local fFlagEnablePartyQuickStartButton = sharedFlags.FFlagEnablePartyQuickStartButton

local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local SquadInviteFriendsButton = require(script.Parent.SquadInviteFriendsButton)

local inviteToSquad = require(Squads.Thunks.inviteToSquad)

local function fn() end

local v = {
	buttonText = "Add",
	onMultiInvite = function(_) end,
	participants = {},
	analyticsInfo = {},
	onRemoveCallback = function() end,
	preselectedUsers = nil,
	preselectedUsersUnremovable = false,
	onSelectedFriendsChanged = function() end,
	shouldHideFooterButton = nil
}

local function SelectedFriendsListener(data): nil
	local v2 = react.useContext(SelectedUsersContext)
	local selectedFriendsSize = v2.selectedFriendsSize
	local selectedFriends = v2.selectedFriends

	local v3 = react.useCallback(function()
		if fFlagEnablePartyQuickStartButton and data.onMultiInvite then
			data.onMultiInvite(selectedFriends)
		else
			data.fallbackOnMultiInvite(selectedFriends)
		end
	end, { data.onMultiInvite, data.fallbackOnMultiInvite, selectedFriends })

	local v4 = useIsInviteButtonDisabled(selectedFriendsSize, v2.selectedFriends or {}, v2.preselectedUsers or {})

	react.useEffect(function()
		data.onSelectedFriendsChanged(not v4, v3)
	end, { v4, v3, data.onSelectedFriendsChanged })

	return nil
end

local function SquadInviteFriends(p)
	local joined = cryo.Dictionary.join(v, p)

	local v2 = react.useContext(FocusNavigationContext)
	local squadExternalContext = react.useContext(SquadExternalContractContext)

	local dispatch = useDispatch()
	local v3 = useNavigation()
	local v4 = useStore()

	local theme = useStyle().Theme
	local state, setState = react.useState(0)
	local v5 = useAppPolicy((react.useCallback(function(p2)
		return p2.getCanUsePlatformChat()
	end, {})))

	local ref = react.useRef(nil)
	local ref2 = react.useRef(nil)

	local v6 = useLocalUserId()

	local v7 = react.useCallback(function(p2)
		setState(p2.AbsoluteSize.Y)
	end, { setState })

	local v8 = useCurrentSquadSelector()
	local parentChannelId = not (v8 and v8.parentChannelId) and "" or v8.parentChannelId

	local parentChannel = squadExternalContext.useGetConversationFromId(parentChannelId)

	local v9 = useLocalization({
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})

	local v10 = react.useCallback(function(p2)
		local union = cryo.Dictionary.union(
			{
				parentChannelId = parentChannelId,
				source = SquadInviteSourceEnum.SourceSquadInvitePage
			},
			p2
		)

		squadExternalContext.fireSquadAnalytics(EventNames.SquadInvite, union)
	end, { parentChannelId, squadExternalContext.fireSquadAnalytics })

	local v11 = react.useCallback(function(p2)
		local keys = cryo.Dictionary.keys(p2)

		local displayName = p2[keys[1]].displayName
		local toastTitle

		if #keys > 2 then
			toastTitle = v9.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#keys - 1)
			})
		elseif #keys == 2 then
			local displayName2 = p2[keys[2]].displayName
			toastTitle = v9.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			toastTitle = v9.youAddedToChat:gsub("{(.-)}", { username = displayName })
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = Images["icons/actions/friends/friendAdd"],
			toastTitle = toastTitle
		})
	end, { v9.youAddedMoreThanTwoToChat, v9.youAddedToChat, v9.youAddedTwoToChat })

	local fallbackOnMultiInvite = react.useCallback(function(p2)
		if not (v8 and parentChannel) then
			return
		end

		local keys = cryo.Dictionary.keys(p2)

		local set = cryo.List.toSet(parentChannel.participants)

		local filtered = cryo.List.filter(keys, function(p3): boolean
			return set[p3] == nil
		end)

		local function fn2()
			local filtered2 = cryo.List.filter(parentChannel.participants, function(p3): boolean
				return cryo.List.find(keys, (tostring(p3))) == nil and p3 ~= v6
			end)

			local v12 = {}

			for _, v13 in ipairs(filtered2) do
				table.insert(v12, squadExternalContext.removeUserFromParentChannel(dispatch, parentChannel.id, v13))
			end

			Promise.all(v12):andThen(function()
				if #filtered > 0 then
					dispatch(InviteToParentChannel({
						dispatch = dispatch,
						onErrorCallback = function()
							if #filtered2 > 0 then
								v3.pop()
							end
						end,
						onSuccessCallback = function(p3: string)
							local v13 = p3 ~= parentChannel.id
							dispatch(inviteToSquad(v8.squadId, p3, v6, filtered, v10, v13))

							v11(p2)
							v3.pop()
						end,
						parentChannel = parentChannel,
						squadExternalContext = squadExternalContext,
						userIds = filtered
					}))
				else
					v3.pop()
				end
			end)
		end

		if parentChannel.type == Constants2.CONVERSATION_CHANNEL_GROUP_TYPE and v5 and #filtered > 0 then
			squadExternalContext.setSquadPrompt(v4, {
				hideCancelButton = false,
				promptType = SquadPromptType.ConfirmInviteToSquad,
				onConfirm = function()
					fn2()
				end
			})
		else
			fn2()
		end
	end, {
		v8,
		dispatch,
		v3,
		parentChannel,
		v10,
		v11,
		squadExternalContext.setSquadPrompt,
		squadExternalContext.inviteToParentChannel,
		squadExternalContext.removeUserFromParentChannel,
		v4,
		v6
	})

	react.useEffect(function()
		if v2 and ref.current ~= nil and ref2.current ~= nil then
			if v2 then
				local default = FocusBehaviors.default(ref2.current)
				local current = ref.current
				v2:registerFocusBehavior(current, default)
				return function()
					v2:deregisterFocusBehavior(current, default)
				end
			end
		elseif ref.current ~= nil and ref2.current ~= nil then
			FocusNavigationService.new(CoreGui):registerFocusBehavior(ref.current, FocusBehaviors.default(ref2.current))
		end

		return function() end
	end, { v2 })

	local createElement = react.createElement
	local v12 = {
		inviteSingleFriend = fn,
		inviteMultiFriends = 0,
		isLoadingCustomParams = false,
		selectionLimit = 0,
		preselectedUsers = 0,
		preselectedUsersUnremovable = 0,
		onRemoveCallback = 0
	}
	local inviteMultiFriends

	if fFlagEnablePartyQuickStartButton then
		inviteMultiFriends = joined.onMultiInvite
	else
		inviteMultiFriends = fallbackOnMultiInvite
	end

	v12.inviteMultiFriends = inviteMultiFriends

	v12.selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1
	local preselectedUsers

	if fFlagEnablePartyQuickStartButton then
		preselectedUsers = joined.preselectedUsers
	else
		preselectedUsers = parentChannel
			and parentChannel.participants
			and cryo.List.filter(parentChannel.participants, function(p2): boolean
				return p2 ~= v6
			end)
	end

	v12.preselectedUsers = preselectedUsers
	local preselectedUsersUnremovable

	if fFlagEnablePartyQuickStartButton then
		preselectedUsersUnremovable = joined.preselectedUsersUnremovable
	elseif parentChannel then
		preselectedUsersUnremovable = parentChannel.type == Constants2.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			or parentChannel.initiator ~= tostring(v6)
	end

	v12.preselectedUsersUnremovable = preselectedUsersUnremovable
	local onRemoveCallback

	if fFlagEnablePartyQuickStartButton then
		onRemoveCallback = joined.onRemoveCallback
	else
		onRemoveCallback = parentChannel and function(p2, p3)
			if cryo.List.find(parentChannel.participants, p2) then
				squadExternalContext.setSquadPrompt(v4, {
					bodyTextLocalizationProps = {
						displayName = p3 or v9.user
					},
					hideCancelButton = true,
					promptType = SquadPromptType.RemoveFromParty
				})
			end
		end or nil
	end

	v12.onRemoveCallback = onRemoveCallback

	local v13 = {
		SelectedFriendsListener = react.createElement(SelectedFriendsListener, {
			onMultiInvite = joined.onMultiInvite,
			fallbackOnMultiInvite = fallbackOnMultiInvite,
			onSelectedFriendsChanged = joined.onSelectedFriendsChanged
		}),
		ContainerFrame = 0,
		FriendsListButtonFrame = 0
	}

	local createElement2 = react.createElement
	local size

	if joined.shouldHideFooterButton then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, 0, 1, -52)
	end

	v13.ContainerFrame = createElement2("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		ref = ref
	}, {
		VerticalLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 16),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchSelectFrame = react.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			[react.Change.AbsoluteSize] = v7
		}, {
			Padding = react.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24),
				PaddingTop = UDim.new(0, 12)
			}),
			VerticalLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 16),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			FriendsMenuSearch = react.createElement(FriendsMenuSearch, {
				layoutOrder = 0,
				size = UDim2.new(1, 0, 0, 36),
				focusElement = false,
				ref = ref2
			}),
			SelectedUsersScroller = react.createElement(SelectedUsersScroller, {
				layoutOrder = 1,
				selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1
			})
		}),
		FriendsList = react.createElement(FriendsMenuFriendsList, {
			size = UDim2.new(1, 0, 1, -state - 16),
			layoutOrder = 1,
			parentComponentName = Constants.SQUAD_INVITE_PARENT_COMPONENT,
			menuType = FriendMenuType.MultiSelect,
			isFullRowActivatable = true,
			backgroundTransparency = 1,
			disableSelectionParentManagement = true,
			disableListFocus = true
		})
	})
	local friendsListButtonFrame

	if not joined.shouldHideFooterButton then
		friendsListButtonFrame = react.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 52),
			BackgroundTransparency = 1,
			BackgroundColor3 = theme.BackgroundContrast.Color,
			BorderSizePixel = 0
		}, {
			Padding = react.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8)
			}),
			Button = react.createElement(SquadInviteFriendsButton, {
				buttonText = joined.buttonText,
				analyticsInfo = joined.analyticsInfo,
				partyStartedRef = joined.partyStartedRef
			})
		})
	end

	v13.FriendsListButtonFrame = friendsListButtonFrame
	return createElement(FriendsMenuContextWrapper, v12, v13)
end

return SquadInviteFriends
