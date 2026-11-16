local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local parent = GameInvite.Parent

local FriendsMenu = require(parent.FriendsMenu)
local React = require(parent.React)
local NotificationsCommon = require(parent.NotificationsCommon)
local DeviceInfo = NotificationsCommon.DeviceInfo
local RoactUtils = require(parent.RoactUtils)

local FriendsMenuFriendsList = FriendsMenu.FriendsMenuFriendsList
local InviteFriendContext = FriendsMenu.InviteFriendContext
local FriendsMenuContextWrapper = FriendsMenu.FriendsMenuContextWrapper
local FriendsMenuSearch = FriendsMenu.FriendsMenuSearch
local FriendMenuType = FriendsMenu.FriendMenuType

local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local GameInviteTitle = require(Components.GameInviteTitle)
local GameInviteRewardsBanner = require(Components.GameInviteRewardsBanner)
local GameInviteCustomText = require(Components.GameInviteCustomText)

local GameInviteFriendsListContainer = require(Components.GameInviteFriendsList.GameInviteFriendsListContainer)
local GameInviteConstants = require(GameInvite.GameInviteConstants)

local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameDetailsContext = require(Context.GameDetailsContext)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableCommonFriendsMenu = SharedFlags.GetFFlagEnableCommonFriendsMenu
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableGameInviteRewardsBanner = SharedFlags2.GetFFlagEnableGameInviteRewardsBanner
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)
local GetRewardMetadata = require(GameInvite.Requests.GetRewardMetadata)
local FFlagGameInviteInExpUserListRenderer = require(GameInvite.Flags.FFlagGameInviteInExpUserListRenderer)

local SidePadding = GameInviteConstants.Layout.SidePadding
local TitleHeight = GameInviteConstants.Layout.TitleHeight

local function fn(p)
	local v2 = React.useContext(GameInviteModalLayoutContext)
	local gameDetailsData = React.useContext(GameDetailsContext)
	local state, setState = React.useState(nil)

	if GetFFlagEnableGameInviteRewardsBanner() then
		React.useEffect(function()
			if game.GameId > 0 then
				GetRewardMetadata():andThen(function(p2)
					if p2.responseBody and p2.responseBody.name and p2.responseBody.description then
						setState(p2.responseBody)
					end
				end):catch(function(p2)
					v:error(`Error fetching reward metadata: {p2}`)
				end)
			end
		end, {})
	end

	local v3 = useSelector(function(p2)
		return p2.TopBar
	end)

	local console = DeviceInfo.isConsole()
	local v4 = v2.modalMode == "compact"
	local promptMessage = gameDetailsData.promptMessage
	local v5 = promptMessage and #promptMessage > 0

	local v6 = TitleHeight + 12
	local v7 = not (v4 or console)

	if v7 then
		v6 += 48
	end

	if v5 then
		v6 += 48
	end

	local v8 = TitleHeight

	if not gameDetailsData.isCoreScript and v3 and v3.statusBarHeight and v3 then
		v6 += v3.statusBarHeight
		v8 += v3.statusBarHeight
	end

	local createElement = React.createElement
	local v9 = { BorderSizePixel = 0, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
	local v10 = {
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
				Size = UDim2.new(1, 0, 0, v8)
			},
			{
				GameInviteTitle = React.createElement(GameInviteTitle, {
					layoutOrder = 0,
					size = UDim2.new(1, 0, 0, TitleHeight),
					hideCloseButton = p.hideCloseButton
				})
			}
		),
		SearchBox = v7 and React.createElement(
			"Frame",
			{
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 36)
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, SidePadding),
					PaddingRight = UDim.new(0, SidePadding)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				FriendsMenuSearch = React.createElement(FriendsMenuSearch, {
					layoutOrder = 1,
					size = UDim2.new(1, 0, 0, 36),
					focusElement = false,
					onFocus = function()
						GameInviteAnalyticsManager:onSearchFocused()
					end
				})
			}
		) or nil,
		CustomTextContainer = v5 and React.createElement(GameInviteCustomText, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 0, 36),
			promptMessage = promptMessage
		}) or nil,
		RewardsBanner = 0,
		FriendsList = 0
	}
	local rewardsBanner

	if GetFFlagEnableGameInviteRewardsBanner() and state ~= nil then
		rewardsBanner = React.createElement(GameInviteRewardsBanner, {
			layoutOrder = 2,
			rewardMetadata = state
		}) or nil
	end

	v10.RewardsBanner = rewardsBanner
	local friendsList

	if FFlagGameInviteInExpUserListRenderer and gameDetailsData.trigger == GameInviteConstants.Triggers.GameMenu then
		friendsList = React.createElement(GameInviteFriendsListContainer, {
			layoutOrder = 3,
			size = UDim2.new(1, 0, 1, -v6)
		})
	else
		friendsList = React.createElement(FriendsMenuFriendsList, {
			layoutOrder = 3,
			size = UDim2.new(1, 0, 1, -v6),
			parentComponentName = GameInviteConstants.ParentComponentName,
			menuType = FriendMenuType.SingleSelect,
			gameDetailsData = gameDetailsData,
			disableSelectionParentManagement = p.disableSelectionParentManagement
		})
	end

	v10.FriendsList = friendsList
	return createElement("Frame", v9, v10)
end

return function(p)
	local v2 = not GetFFlagEnableCommonFriendsMenu() and {
		inviteSingleFriend = function() end,
		getMaxRecipientRowNum = function() end
	} or React.useContext(InviteFriendContext)

	if GetFFlagEnableCommonFriendsMenu() then
		return (React.createElement(FriendsMenuContextWrapper, {
			inviteSingleFriend = v2.inviteSingleFriend,
			inviteMultiFriends = function() end,
			isLoadingCustomParams = p.isLoadingCustomParams
		}, { GameInviteContent = React.createElement(fn, p) }))
	end

	return (React.createElement(fn, p))
end
