local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local deviceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").DeviceInfo
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactUtils")

local friendsMenuFriendsList = FriendsMenu.FriendsMenuFriendsList
local inviteFriendContext = FriendsMenu.InviteFriendContext
local friendsMenuContextWrapper = FriendsMenu.FriendsMenuContextWrapper
local friendsMenuSearch = FriendsMenu.FriendsMenuSearch
local friendMenuType = FriendsMenu.FriendMenuType

local GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteTitle")
local GameInviteRewardsBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteRewardsBanner")
local GameInviteCustomText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteCustomText")

local GameInviteFriendsListContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteFriendsListContainer")
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")

local GameInviteModalLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteModalLayoutContext")
local GameDetailsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameDetailsContext")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getFFlagEnableCommonFriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").GetFFlagEnableCommonFriendsMenu
local getFFlagEnableGameInviteRewardsBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").GetFFlagEnableGameInviteRewardsBanner
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Loggers").Logger:new("GameInviteContent")
local GetRewardMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Requests/GetRewardMetadata")
local FFlagGameInviteInExpUserListRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpUserListRenderer")

local sidePadding = GameInviteConstants.Layout.SidePadding
local titleHeight = GameInviteConstants.Layout.TitleHeight

local function fn(p2)
	local v6 = React.useContext(GameInviteModalLayoutContext)
	local v7 = React.useContext(GameDetailsContext)
	local state, setState = React.useState(nil)

	if getFFlagEnableGameInviteRewardsBanner() then
		React.useEffect(function()
			if game.GameId > 0 then
				GetRewardMetadata():andThen(function(p3)
					if p3.responseBody and p3.responseBody.name and p3.responseBody.description then
						setState(p3.responseBody)
					end
				end):catch(function(p3)
					v5:error(`Error fetching reward metadata: {p3}`)
				end)
			end
		end, {})
	end

	local v8 = useSelector(function(p3)
		return p3.TopBar
	end)

	local console = deviceInfo.isConsole()
	local v9 = v6.modalMode == "compact"
	local promptMessage = v7.promptMessage
	local v10 = promptMessage and #promptMessage > 0

	local v11 = titleHeight + 12
	local v12 = not (v9 or console)

	if v12 then
		v11 += 48
	end

	if v10 then
		v11 += 48
	end

	local v13 = titleHeight

	if not v7.isCoreScript and v8 and v8.statusBarHeight and v8 then
		v11 += v8.statusBarHeight
		v13 += v8.statusBarHeight
	end

	local createElement = React.createElement
	local v15 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}
	local v16 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		TitleContainer = React.createElement(
			"Frame",
			{
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, v13)
			},
			{
				GameInviteTitle = React.createElement(module5, {
					layoutOrder = 0,
					size = UDim2.new(1, 0, 0, titleHeight),
					hideCloseButton = p2.hideCloseButton
				})
			}
		),
		SearchBox = v12 and React.createElement(
			"Frame",
			{
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 36)
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, sidePadding),
					PaddingRight = UDim.new(0, sidePadding)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				FriendsMenuSearch = React.createElement(friendsMenuSearch, {
					layoutOrder = 1,
					size = UDim2.new(1, 0, 0, 36),
					focusElement = false,
					onFocus = function()
						GameInviteAnalyticsManager:onSearchFocused()
					end
				})
			}
		) or nil,
		CustomTextContainer = v10 and React.createElement(GameInviteCustomText, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 0, 36),
			promptMessage = promptMessage
		}) or nil,
		RewardsBanner = 0,
		FriendsList = 0
	}

	local v17 = if getFFlagEnableGameInviteRewardsBanner() and state ~= nil then React.createElement(GameInviteRewardsBanner, {
		layoutOrder = 2,
		rewardMetadata = state
	}) or nil else nil
	v16.RewardsBanner = v17

	local v18 = if FFlagGameInviteInExpUserListRenderer and v7.trigger == GameInviteConstants.Triggers.GameMenu then React.createElement(GameInviteFriendsListContainer, {
		layoutOrder = 3,
		size = UDim2.new(1, 0, 1, -v11)
	}) else React.createElement(friendsMenuFriendsList, {
		layoutOrder = 3,
		size = UDim2.new(1, 0, 1, -v11),
		parentComponentName = GameInviteConstants.ParentComponentName,
		menuType = friendMenuType.SingleSelect,
		gameDetailsData = v7,
		disableSelectionParentManagement = p2.disableSelectionParentManagement
	})
	v16.FriendsList = v18
	return createElement("Frame", v15, v16)
end

return function(p2)
	local v6 = not getFFlagEnableCommonFriendsMenu() and {
		inviteSingleFriend = function() end,
		getMaxRecipientRowNum = function() end
	} or React.useContext(inviteFriendContext)

	if getFFlagEnableCommonFriendsMenu() then
		return (React.createElement(friendsMenuContextWrapper, {
			inviteSingleFriend = v6.inviteSingleFriend,
			inviteMultiFriends = function() end,
			isLoadingCustomParams = p2.isLoadingCustomParams
		}, { GameInviteContent = React.createElement(fn, p2) }))
	end

	return (React.createElement(fn, p2))
end
