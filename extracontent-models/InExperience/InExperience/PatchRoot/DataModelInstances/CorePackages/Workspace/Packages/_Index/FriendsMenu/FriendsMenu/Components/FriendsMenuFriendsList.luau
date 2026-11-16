local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Components = FriendsMenu.Components
local Context = FriendsMenu.Context
local Enums = FriendsMenu.Enums
local parent = FriendsMenu.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local FriendRow = require(Components.FriendRow)
local EmptyFriendsList = require(Components.EmptyFriendsList)
local FriendsListMsg = require(Components.FriendsListMsg)
local FriendsListContext = require(Context.FriendsListContext)
require(Enums.FriendMenuType)
require(FriendsMenu.friendsMenuModalType)
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local FFlagUpdateInvitesToUsePaginatedFriends = require(FriendsMenu.Flags.FFlagUpdateInvitesToUsePaginatedFriends)
local FriendsMenuShareGameInviteLink = require(Components.FriendsMenuShareGameInviteLink)
local defineFastFlag = game:DefineFastFlag("EnableFriendsMenuShareGameInviteLink3", false)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function(props)
	local v = React.useContext(FriendsListContext)
	local friends = v.friends
	local isFetchingFriends = v.isFetchingFriends

	local isFetchingFriendsNames = isFetchingFriends or v.friendsNames and v.friendsNames.loading
	local isFriendsListFetchFailed = v.isFriendsListFetchFailed
	local hasFriends = v.hasFriends
	local ref = React.useRef(nil)
	local state, setState = React.useState(0)

	React.useEffect(function()
		if not UserInputService.GamepadEnabled or props.disableListFocus then
			return
		end

		local current = ref.current
		local screenGui

		if current then
			screenGui = current:FindFirstAncestorOfClass("ScreenGui")

			if screenGui and screenGui.Enabled and GuiService.SelectedCoreObject == nil then
				if not props.disableSelectionParentManagement then
					GuiService:AddSelectionParent(props.parentComponentName, current)
				end

				for _, button in ipairs(current:GetChildren()) do
					if button:IsA("ImageButton") and button.LayoutOrder == 1 then
						GuiService.SelectedCoreObject = button
					end
				end
			end
		else
			screenGui = nil
		end

		return function()
			if
				GuiService.SelectedCoreObject
				and screenGui
				and (GuiService.SelectedCoreObject.Parent == nil or screenGui:IsAncestorOf(GuiService.SelectedCoreObject))
			then
				GuiService.SelectedCoreObject = nil
			end

			if not props.disableSelectionParentManagement then
				GuiService:RemoveSelectionGroup(props.parentComponentName)
			end
		end
	end, { friends, props.disableListFocus, props.disableSelectionParentManagement })

	local v2 = useAppPolicy(function(p)
		return p.getExperienceInviteShareLinkEnabled()
	end)

	local v3 = defineFastFlag

	if v3 then
		if props.parentComponentName == "GameInviteModal" and game.GameId > 0 then
			v3 = props.gameDetailsData and props.gameDetailsData.isCoreScript

			if v3 then
				if props.gameDetailsData.serverType == "StandardServer" then
					v3 = v2
				else
					v3 = false
				end
			end
		else
			v3 = false
		end
	end

	local children = React.useMemo(function()
		local children = {}
		children.RowListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		for i, friend in ipairs(friends) do
			children["User-" .. tostring(friend.id)] = React.createElement(FriendRow, {
				friend = friend,
				layoutOrder = i,
				isFullRowActivatable = (UserInputService.GamepadEnabled or props.isFullRowActivatable) == true,
				menuType = props.menuType,
				sidePadding = props.sidePadding,
				backgroundTransparency = props.backgroundTransparency,
				isFetchingFriends = isFetchingFriends,
				isFetchingFriendsNames = isFetchingFriendsNames
			})
		end

		return children
	end, { friends })

	if isFriendsListFetchFailed then
		if v3 then
			children = {
				InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
				FriendsListMsg = React.createElement(FriendsListMsg, {
					msgType = "errorFriendsList"
				})
			}
		else
			children = React.createElement(FriendsListMsg, { msgType = "errorFriendsList" })
		end
	elseif isFetchingFriends then
		if v3 then
			children.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
				layoutOrder = 0
			})
		end
	elseif hasFriends then
		if #friends > 0 then
			if v3 then
				children.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
					layoutOrder = 0
				})
			end
		elseif v3 then
			children = {
				InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
				FriendsListMsg = React.createElement(FriendsListMsg, {
					msgType = "noResultFriendsList"
				})
			}
		else
			children = React.createElement(FriendsListMsg, { msgType = "noResultFriendsList" })
		end
	elseif v3 then
		children = {
			InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
			EmptyFriendsList = React.createElement(EmptyFriendsList)
		}
	else
		children = React.createElement(EmptyFriendsList)
	end

	return React.createElement(VerticalScrollView, {
		layoutOrder = props.layoutOrder,
		size = props.size,
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(1, 0),
		selectable = false,
		scrollingFrameRef = ref,
		[React.Change.CanvasPosition] = FFlagUpdateInvitesToUsePaginatedFriends and function(data)
			if
				data.CanvasPosition.Y / (data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y) >= 0.8
				and state < data.AbsoluteCanvasSize.Y
			then
				setState(data.AbsoluteCanvasSize.Y)
				v.fetchMoreFriends()
			end
		end or nil
	}, children)
end
