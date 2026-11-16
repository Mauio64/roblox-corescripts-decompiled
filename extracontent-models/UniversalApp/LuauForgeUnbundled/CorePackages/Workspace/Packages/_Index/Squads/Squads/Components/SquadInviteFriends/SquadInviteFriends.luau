local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsMenu")
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/NotificationModalsManager")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Promise")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ReactFocusNavigation")
local coreGui = ReactFocusNavigation.EngineInterface.CoreGui
local focusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local focusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FocusBehaviors")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/Constants")
local InviteToParentChannel = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/InviteToParentChannel")
local SquadInviteSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadInviteSourceEnum")

local cryo = dependencies.Cryo
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local useDispatch = dependencies.Hooks.useDispatch
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useNavigation = dependencies.useNavigation
local useIsInviteButtonDisabled = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useIsInviteButtonDisabled")

local friendsMenuFriendsList = FriendsMenu.FriendsMenuFriendsList
local friendsMenuContextWrapper = FriendsMenu.FriendsMenuContextWrapper
local friendsMenuSearch = FriendsMenu.FriendsMenuSearch
local friendMenuType = FriendsMenu.FriendMenuType
local selectedUsersScroller = FriendsMenu.SelectedUsersScroller
local selectedUsersContext = FriendsMenu.SelectedUsersContext
local fFlagEnablePartyQuickStartButton = sharedFlags.FFlagEnablePartyQuickStartButton

local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local SquadInviteFriendsButton = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadInviteFriends/SquadInviteFriendsButton")

local inviteToSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/inviteToSquad")

local function fn() end

local v5 = {
	buttonText = "Add",
	onMultiInvite = function(p2) end,
	participants = {},
	analyticsInfo = {},
	onRemoveCallback = function() end,
	preselectedUsers = nil,
	preselectedUsersUnremovable = false,
	onSelectedFriendsChanged = function() end,
	shouldHideFooterButton = nil
}

local function SelectedFriendsListener(data): nil
	local v6 = react.useContext(selectedUsersContext)
	local selectedFriendsSize = v6.selectedFriendsSize
	local selectedFriends = v6.selectedFriends

	local v7 = react.useCallback(function()
		if fFlagEnablePartyQuickStartButton and data.onMultiInvite then
			data.onMultiInvite(selectedFriends)
		else
			data.fallbackOnMultiInvite(selectedFriends)
		end
	end, { data.onMultiInvite, data.fallbackOnMultiInvite, selectedFriends })

	local v8 = useIsInviteButtonDisabled(selectedFriendsSize, v6.selectedFriends or {}, v6.preselectedUsers or {})

	react.useEffect(function()
		data.onSelectedFriendsChanged(not v8, v7)
	end, { v8, v7, data.onSelectedFriendsChanged })

	return nil
end

local function SquadInviteFriends(p2)
	local joined = cryo.Dictionary.join(v5, p2)

	local v6 = react.useContext(focusNavigationContext)
	local v7 = react.useContext(squadExternalContractContext)

	local v8 = useDispatch()
	local v9 = useNavigation()
	local v10 = useStore()

	local theme = useStyle().Theme
	local state, setState = react.useState(0)
	local v12 = useAppPolicy((react.useCallback(function(p3)
		return p3.getCanUsePlatformChat()
	end, {})))

	local ref = react.useRef(nil)
	local ref2 = react.useRef(nil)

	local v13 = useLocalUserId()

	local v14 = react.useCallback(function(p3)
		setState(p3.AbsoluteSize.Y)
	end, { setState })

	local v15 = useCurrentSquadSelector()
	local v16 = not (v15 and v15.parentChannelId) and "" or v15.parentChannelId

	local v17 = v7.useGetConversationFromId(v16)

	local v18 = useLocalization({
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})

	local v19 = react.useCallback(function(p3)
		local union = cryo.Dictionary.union(
			{ parentChannelId = v16, source = SquadInviteSourceEnum.SourceSquadInvitePage },
			p3
		)

		v7.fireSquadAnalytics(EventNames.SquadInvite, union)
	end, { v16, v7.fireSquadAnalytics })

	local v20 = react.useCallback(function(p3)
		local keys = cryo.Dictionary.keys(p3)

		local displayName = p3[keys[1]].displayName
		local v21

		if #keys > 2 then
			v21 = v18.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#keys - 1)
			})
		elseif #keys == 2 then
			local displayName2 = p3[keys[2]].displayName
			v21 = v18.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			v21 = v18.youAddedToChat:gsub("{(.-)}", { username = displayName })
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = images["icons/actions/friends/friendAdd"],
			toastTitle = v21
		})
	end, { v18.youAddedMoreThanTwoToChat, v18.youAddedToChat, v18.youAddedTwoToChat })

	local v21 = react.useCallback(function(p3)
		if not (v15 and v17) then
			return
		end

		local keys = cryo.Dictionary.keys(p3)

		local set = cryo.List.toSet(v17.participants)

		local filtered = cryo.List.filter(keys, function(p4): boolean
			return set[p4] == nil
		end)

		local function fn2()
			local filtered2 = cryo.List.filter(v17.participants, function(p4): boolean
				return cryo.List.find(keys, (tostring(p4))) == nil and p4 ~= v13
			end)

			local v22 = {}

			for i, v23 in ipairs(filtered2) do
				table.insert(v22, v7.removeUserFromParentChannel(v8, v17.id, v23))
			end

			Promise.all(v22):andThen(function()
				if #filtered > 0 then
					v8(InviteToParentChannel({
						dispatch = v8,
						onErrorCallback = function()
							if #filtered2 > 0 then
								v9.pop()
							end
						end,
						onSuccessCallback = function(p4)
							local v23 = p4 ~= v17.id
							v8(inviteToSquad(v15.squadId, p4, v13, filtered, v19, v23))

							v20(p3)
							v9.pop()
						end,
						parentChannel = v17,
						squadExternalContext = v7,
						userIds = filtered
					}))
				else
					v9.pop()
				end
			end)
		end

		if v17.type == module11.CONVERSATION_CHANNEL_GROUP_TYPE and v12 and #filtered > 0 then
			v7.setSquadPrompt(v10, {
				hideCancelButton = false,
				promptType = squadPromptType.ConfirmInviteToSquad,
				onConfirm = function()
					fn2()
				end
			})
		else
			fn2()
		end
	end, {
		v15,
		v8,
		v9,
		v17,
		v19,
		v20,
		v7.setSquadPrompt,
		v7.inviteToParentChannel,
		v7.removeUserFromParentChannel,
		v10,
		v13
	})

	react.useEffect(function()
		if v6 and ref.current ~= nil and ref2.current ~= nil then
			if v6 then
				local default = FocusBehaviors.default(ref2.current)
				local current = ref.current
				v6:registerFocusBehavior(current, default)
				return function()
					v6:deregisterFocusBehavior(current, default)
				end
			end
		elseif ref.current ~= nil and ref2.current ~= nil then
			focusNavigationService.new(coreGui):registerFocusBehavior(
				ref.current,
				FocusBehaviors.default(ref2.current)
			)
		end

		return function() end
	end, { v6 })

	local createElement = react.createElement
	local v23 = {
		inviteSingleFriend = fn,
		inviteMultiFriends = 0,
		isLoadingCustomParams = false,
		selectionLimit = 0,
		preselectedUsers = 0,
		preselectedUsersUnremovable = 0,
		onRemoveCallback = 0
	}

	local v24 = if fFlagEnablePartyQuickStartButton then joined.onMultiInvite else v21
	v23.inviteMultiFriends = v24

	v23.selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1
	local v25

	if fFlagEnablePartyQuickStartButton then
		v25 = joined.preselectedUsers
	else
		v25 = v17 and v17.participants and cryo.List.filter(v17.participants, function(p3): boolean
			return p3 ~= v13
		end)
	end

	v23.preselectedUsers = v25
	local v26

	if fFlagEnablePartyQuickStartButton then
		v26 = joined.preselectedUsersUnremovable
	elseif v17 then
		v26 = v17.type == module11.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE or v17.initiator ~= tostring(v13)
	end

	v23.preselectedUsersUnremovable = v26
	local v27

	if fFlagEnablePartyQuickStartButton then
		v27 = joined.onRemoveCallback
	else
		v27 = v17 and function(p3, p4)
			if cryo.List.find(v17.participants, p3) then
				v7.setSquadPrompt(v10, {
					bodyTextLocalizationProps = {
						displayName = p4 or v18.user
					},
					hideCancelButton = true,
					promptType = squadPromptType.RemoveFromParty
				})
			end
		end or nil
	end

	v23.onRemoveCallback = v27

	local v28 = {
		SelectedFriendsListener = react.createElement(SelectedFriendsListener, {
			onMultiInvite = joined.onMultiInvite,
			fallbackOnMultiInvite = v21,
			onSelectedFriendsChanged = joined.onSelectedFriendsChanged
		}),
		ContainerFrame = 0,
		FriendsListButtonFrame = 0
	}

	local createElement2 = react.createElement
	local v31 = if joined.shouldHideFooterButton then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 1, -52)
	v28.ContainerFrame = createElement2("Frame", {
		Size = v31,
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
			[react.Change.AbsoluteSize] = v14
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
			FriendsMenuSearch = react.createElement(friendsMenuSearch, {
				layoutOrder = 0,
				size = UDim2.new(1, 0, 0, 36),
				focusElement = false,
				ref = ref2
			}),
			SelectedUsersScroller = react.createElement(selectedUsersScroller, {
				layoutOrder = 1,
				selectionLimit = Constants.SQUAD_PARTICIPANT_LIMIT - 1
			})
		}),
		FriendsList = react.createElement(friendsMenuFriendsList, {
			size = UDim2.new(1, 0, 1, -state - 16),
			layoutOrder = 1,
			parentComponentName = Constants.SQUAD_INVITE_PARENT_COMPONENT,
			menuType = friendMenuType.MultiSelect,
			isFullRowActivatable = true,
			backgroundTransparency = 1,
			disableSelectionParentManagement = true,
			disableListFocus = true
		})
	})

	local v33 = if not joined.shouldHideFooterButton then react.createElement("Frame", {
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
	}) else nil
	v28.FriendsListButtonFrame = v33
	return createElement(friendsMenuContextWrapper, v23, v28)
end

return SquadInviteFriends
