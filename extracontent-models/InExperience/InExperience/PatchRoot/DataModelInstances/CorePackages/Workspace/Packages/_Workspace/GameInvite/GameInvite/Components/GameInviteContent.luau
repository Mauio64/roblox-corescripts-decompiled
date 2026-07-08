local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local GameInviteParent = GameInvite.Parent
local FriendsMenu = require(GameInviteParent.FriendsMenu)
local React = require(GameInviteParent.React)
local DeviceInfo = require(GameInviteParent.NotificationsCommon).DeviceInfo
local RoactUtils = require(GameInviteParent.RoactUtils)
local FriendsMenuFriendsList = FriendsMenu.FriendsMenuFriendsList
local InviteFriendContext = FriendsMenu.InviteFriendContext
local FriendsMenuContextWrapper = FriendsMenu.FriendsMenuContextWrapper
local FriendsMenuSearch = FriendsMenu.FriendsMenuSearch
local FriendMenuType = FriendsMenu.FriendMenuType
local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local GameInviteTitle = require(Components.GameInviteTitle)
local GameInviteRewardsBanner = require(Components.GameInviteRewardsBanner)
local GameInviteCustomText = require(Components.GameInviteCustomText)
local GameInviteConstants = require(GameInvite.GameInviteConstants)
local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameDetailsContext = require(Context.GameDetailsContext)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local GetFFlagEnableCommonFriendsMenu = require(GameInviteParent.SharedFlags).GetFFlagEnableCommonFriendsMenu
local GetFFlagEnableGameInviteRewardsBanner = require(GameInviteParent.SharedFlags).GetFFlagEnableGameInviteRewardsBanner
local v24 = require(GameInviteParent.Loggers).Logger:new(script.Name)
local GetRewardMetadata = require(GameInvite.Requests.GetRewardMetadata)
local SidePadding = GameInviteConstants.Layout.SidePadding
local TitleHeight = GameInviteConstants.Layout.TitleHeight

local function v28(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), GameInviteModalLayoutContext (copy), GameDetailsContext (copy), GetFFlagEnableGameInviteRewardsBanner (copy), GetRewardMetadata (copy), v24 (copy), useSelector (copy), DeviceInfo (copy), TitleHeight (copy), GameInviteTitle (copy), SidePadding (copy), FriendsMenuSearch (copy), GameInviteAnalyticsManager (copy), GameInviteCustomText (copy), GameInviteRewardsBanner (copy), FriendsMenuFriendsList (copy), GameInviteConstants (copy), FriendMenuType (copy)
	local v30 = React.useContext(GameInviteModalLayoutContext)
	local v31 = React.useContext(GameDetailsContext)
	local v32, v33 = React.useState(nil)

	if GetFFlagEnableGameInviteRewardsBanner() then
		React.useEffect(function() -- line: 50
			-- upvalues: GetRewardMetadata (copy), v33 (copy), v24 (copy)
			if game.GameId > 0 then
				GetRewardMetadata():andThen(function(p1) -- line: 52
					-- upvalues: v33 (copy)
					if p1.responseBody and (p1.responseBody.name and p1.responseBody.description) then
						v33(p1.responseBody)
					end
				end):catch(function(p2) -- line: 56
					-- upvalues: v24 (copy)
					v24:error(`Error fetching reward metadata: { p2 }`)
				end)
			end
		end, {})
	end

	local v34 = useSelector(function(p3) -- line: 63
		return p3.TopBar
	end)
	local v35 = DeviceInfo.isConsole()
	local v36 = v30.modalMode == "compact"
	local promptMessage = v31.promptMessage
	local v38 = promptMessage and #promptMessage > 0
	local v39 = TitleHeight + 12
	local v40 = not v36 and not v35

	if v40 then
		v39 += 48
	end

	if v38 then
		v39 += 48
	end

	local v41 = TitleHeight

	if not v31.isCoreScript and (not not v34 and not not v34.statusBarHeight) and v34 then
		v39 += v34.statusBarHeight
		v41 += v34.statusBarHeight
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
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
		TitleContainer = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, v41)
		}, {
			GameInviteTitle = React.createElement(GameInviteTitle, {
				layoutOrder = 0,
				size = UDim2.new(1, 0, 0, TitleHeight),
				hideCloseButton = t1.hideCloseButton
			})
		}),
		SearchBox = v40 and React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 36)
		}, {
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
				focusElement = false,
				size = UDim2.new(1, 0, 0, 36),
				onFocus = function() -- line: 142
					-- upvalues: GameInviteAnalyticsManager (copy)
					GameInviteAnalyticsManager:onSearchFocused()
				end
			})
		}) or nil,
		CustomTextContainer = v38 and React.createElement(GameInviteCustomText, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 0, 36),
			promptMessage = promptMessage
		}) or nil,
		RewardsBanner = GetFFlagEnableGameInviteRewardsBanner() and (v32 ~= nil and React.createElement(GameInviteRewardsBanner, {
			layoutOrder = 2,
			rewardMetadata = v32
		})) or nil,
		FriendsList = React.createElement(FriendsMenuFriendsList, {
			layoutOrder = 3,
			size = UDim2.new(1, 0, 1, -v39),
			parentComponentName = GameInviteConstants.ParentComponentName,
			menuType = FriendMenuType.SingleSelect,
			gameDetailsData = v31,
			disableSelectionParentManagement = t1.disableSelectionParentManagement
		})
	})
end

return function(t2: {[any]: any}) -- line: 170
	-- upvalues: GetFFlagEnableCommonFriendsMenu (copy), React (copy), InviteFriendContext (copy), FriendsMenuContextWrapper (copy), v28 (copy)
	local v43 = if not GetFFlagEnableCommonFriendsMenu() then {
		inviteSingleFriend = function() -- line: 173
		end,
		getMaxRecipientRowNum = function() -- line: 173
		end
	} else React.useContext(InviteFriendContext)

	if GetFFlagEnableCommonFriendsMenu() then
		return (React.createElement(FriendsMenuContextWrapper, {
			inviteSingleFriend = v43.inviteSingleFriend,
			inviteMultiFriends = function() -- line: 177
			end,
			isLoadingCustomParams = t2.isLoadingCustomParams
		}, {
			GameInviteContent = React.createElement(v28, t2)
		}))
	end

	return (React.createElement(v28, t2))
end
