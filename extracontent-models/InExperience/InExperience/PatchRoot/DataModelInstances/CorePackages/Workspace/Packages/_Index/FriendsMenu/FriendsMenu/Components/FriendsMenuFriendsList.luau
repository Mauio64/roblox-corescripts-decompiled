local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Components = FriendsMenu.Components
local Context = FriendsMenu.Context
local Enums = FriendsMenu.Enums
local FriendsMenuParent = FriendsMenu.Parent
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local FriendRow = require(Components.FriendRow)
local EmptyFriendsList = require(Components.EmptyFriendsList)
local FriendsListMsg = require(Components.FriendsListMsg)
local FriendsListContext = require(Context.FriendsListContext)

require(Enums.FriendMenuType)
require(FriendsMenu.friendsMenuModalType)

local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local FFlagUpdateInvitesToUsePaginatedFriends = require(FriendsMenu.Flags.FFlagUpdateInvitesToUsePaginatedFriends)
local FriendsMenuShareGameInviteLink = require(Components.FriendsMenuShareGameInviteLink)
local v17 = game:DefineFastFlag("EnableFriendsMenuShareGameInviteLink3", false)
local useAppPolicy = require(FriendsMenuParent.UniversalAppPolicy).useAppPolicy

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), FriendsListContext (copy), UserInputService (copy), GuiService (copy), useAppPolicy (copy), v17 (copy), FriendRow (copy), FriendsMenuShareGameInviteLink (copy), FriendsListMsg (copy), EmptyFriendsList (copy), VerticalScrollView (copy), FFlagUpdateInvitesToUsePaginatedFriends (copy)
	local v20 = React.useContext(FriendsListContext)
	local friends = v20.friends
	local isFetchingFriends = v20.isFetchingFriends
	local v23 = isFetchingFriends or v20.friendsNames and v20.friendsNames.loading
	local isFriendsListFetchFailed = v20.isFriendsListFetchFailed
	local hasFriends = v20.hasFriends
	local v26 = React.useRef(nil)
	local v27, v28 = React.useState(0)

	React.useEffect(function() -- line: 54
		-- upvalues: UserInputService (copy), t1 (copy), v26 (copy), GuiService (copy)
		if not UserInputService.GamepadEnabled or t1.disableListFocus then
			return
		end

		local current = v26.current
		local ScreenGui = nil

		if current then
			ScreenGui = current:FindFirstAncestorOfClass("ScreenGui")

			if ScreenGui and ScreenGui.Enabled and GuiService.SelectedCoreObject == nil then
				if not t1.disableSelectionParentManagement then
					GuiService:AddSelectionParent(t1.parentComponentName, current)
				end

				for _, child in ipairs(current:GetChildren()) do
					if child:IsA("ImageButton") and child.LayoutOrder == 1 then
						GuiService.SelectedCoreObject = child
					end
				end
			end
		end

		return function() -- line: 76
			-- upvalues: GuiService (copy), ScreenGui (ref), t1 (copy)
			if GuiService.SelectedCoreObject and ScreenGui and (GuiService.SelectedCoreObject.Parent == nil or ScreenGui:IsAncestorOf(GuiService.SelectedCoreObject)) then
				GuiService.SelectedCoreObject = nil
			end

			if not t1.disableSelectionParentManagement then
				GuiService:RemoveSelectionGroup(t1.parentComponentName)
			end
		end
	end, {
		friends,
		t1.disableListFocus,
		t1.disableSelectionParentManagement
	})

	local v29 = useAppPolicy(function(p1) -- line: 102
		return p1.getExperienceInviteShareLinkEnabled()
	end)
	local v30 = v17 and (t1.parentComponentName == "GameInviteModal" and (game.GameId > 0 and (t1.gameDetailsData and (t1.gameDetailsData.isCoreScript and (t1.gameDetailsData.serverType == "StandardServer" and v29)))))
	local v31 = React.useMemo(function() -- line: 115
		-- upvalues: React (copy), friends (copy), FriendRow (copy), UserInputService (copy), t1 (copy), isFetchingFriends (copy), v23 (copy)
		local t2 = {
			RowListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		}

		for i, v in ipairs(friends) do
			t2["User-" .. tostring(v.id)] = React.createElement(FriendRow, {
				friend = v,
				layoutOrder = i,
				isFullRowActivatable = (UserInputService.GamepadEnabled or t1.isFullRowActivatable) == true,
				menuType = t1.menuType,
				sidePadding = t1.sidePadding,
				backgroundTransparency = t1.backgroundTransparency,
				isFetchingFriends = isFetchingFriends,
				isFetchingFriendsNames = v23
			})
		end

		return t2
	end, { friends })

	if isFriendsListFetchFailed then
		v31 = if not v30 then React.createElement(FriendsListMsg, {
			msgType = "errorFriendsList"
		}) else {
			InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
				layoutOrder = 0
			}),
			FriendsListMsg = React.createElement(FriendsListMsg, {
				msgType = "errorFriendsList"
			})
		}
	elseif isFetchingFriends then
		if v30 then
			v31.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
				layoutOrder = 0
			})
		end
	elseif hasFriends then
		if #friends > 0 then
			if v30 then
				v31.InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
					layoutOrder = 0
				})
			end
		else
			v31 = if not v30 then React.createElement(FriendsListMsg, {
				msgType = "noResultFriendsList"
			}) else {
				InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
					layoutOrder = 0
				}),
				FriendsListMsg = React.createElement(FriendsListMsg, {
					msgType = "noResultFriendsList"
				})
			}
		end
	else
		v31 = if not v30 then React.createElement(EmptyFriendsList) else {
			InviteLink = React.createElement(FriendsMenuShareGameInviteLink, {
				layoutOrder = 0
			}),
			EmptyFriendsList = React.createElement(EmptyFriendsList)
		}
	end

	return React.createElement(VerticalScrollView, {
		layoutOrder = t1.layoutOrder,
		size = t1.size,
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(1, 0),
		selectable = false,
		scrollingFrameRef = v26,
		[React.Change.CanvasPosition] = if not FFlagUpdateInvitesToUsePaginatedFriends then nil else function(p2) -- line: 202
			-- upvalues: v27 (copy), v28 (copy), v20 (copy)
			if p2.CanvasPosition.Y / (p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y) >= 0.8 and v27 < p2.AbsoluteCanvasSize.Y then
				v28(p2.AbsoluteCanvasSize.Y)
				v20.fetchMoreFriends()
			end
		end
	}, v31)
end
