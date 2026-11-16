local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local FriendRow = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendRow")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/EmptyFriendsList")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsListMsg")
local FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Enums/FriendMenuType")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")
local verticalScrollView = UIBlox.App.Container.VerticalScrollView
local FFlagUpdateInvitesToUsePaginatedFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagUpdateInvitesToUsePaginatedFriends")
local FriendsMenuShareGameInviteLink = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuShareGameInviteLink")
local defineFastFlag = game:DefineFastFlag("EnableFriendsMenuShareGameInviteLink3", false)
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UniversalAppPolicy").useAppPolicy

return function(props)
	local v5 = React.useContext(FriendsListContext)
	local friends = v5.friends
	local isFetchingFriends = v5.isFetchingFriends

	local v6 = isFetchingFriends or v5.friendsNames and v5.friendsNames.loading
	local isFriendsListFetchFailed = v5.isFriendsListFetchFailed
	local hasFriends = v5.hasFriends
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

				for i, button in ipairs(current:GetChildren()) do
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

	local v7 = useAppPolicy(function(p2)
		return p2.getExperienceInviteShareLinkEnabled()
	end)

	local v8 = defineFastFlag

	if v8 then
		if props.parentComponentName == "GameInviteModal" and game.GameId > 0 then
			v8 = props.gameDetailsData and props.gameDetailsData.isCoreScript

			if v8 then
				v8 = props.gameDetailsData.serverType == "StandardServer" and v7
			end
		else
			v8 = false
		end
	end

	local children = React.useMemo(function()
		local children2 = {}
		children2.RowListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		for i, friend in ipairs(friends) do
			children2["User-" .. tostring(friend.id)] = React.createElement(FriendRow, {
				friend = friend,
				layoutOrder = i,
				isFullRowActivatable = (UserInputService.GamepadEnabled or props.isFullRowActivatable) == true,
				menuType = props.menuType,
				sidePadding = props.sidePadding,
				backgroundTransparency = props.backgroundTransparency,
				isFetchingFriends = isFetchingFriends,
				isFetchingFriendsNames = v6
			})
		end

		return children2
	end, { friends })

	if isFriendsListFetchFailed then
		if v8 then
			children = {
				InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
				FriendsListMsg = React.createElement(module5, {
					msgType = "errorFriendsList"
				})
			}
		else
			children = React.createElement(module5, { msgType = "errorFriendsList" })
		end
	elseif isFetchingFriends then
		if v8 then
			children.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 })
		end
	elseif hasFriends then
		if #friends > 0 then
			if v8 then
				children.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 })
			end
		elseif v8 then
			children = {
				InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
				FriendsListMsg = React.createElement(module5, {
					msgType = "noResultFriendsList"
				})
			}
		else
			children = React.createElement(module5, { msgType = "noResultFriendsList" })
		end
	elseif v8 then
		children = {
			InviteLink = React.createElement(FriendsMenuShareGameInviteLink, { layoutOrder = 0 }),
			EmptyFriendsList = React.createElement(module4)
		}
	else
		children = React.createElement(module4)
	end

	return React.createElement(verticalScrollView, {
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
				v5.fetchMoreFriends()
			end
		end or nil
	}, children)
end
