local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local parent = script.Parent.Parent.Parent

local PlayerLabelV2 = require(parent.Components.PlayerLabelV2)
local GetFFlagIGMGamepadSelectionHistory = require(parent.Flags.GetFFlagIGMGamepadSelectionHistory)

local Divider = require(parent.Components.Divider)
local SendInviteButton = require(script.Parent.SendInviteButton)
local SearchBox = require(script.Parent.SearchBox)
local BarOnTopScrollingFrame = require(parent.Components.BarOnTopScrollingFrame)
local PlayerSearchPredicate = require(parent.Utility.PlayerSearchPredicate)
local FocusHandler = require(parent.Components.Connection.FocusHandler)
local RootedConnection = require(parent.Components.Connection.RootedConnection)

local Constants = require(parent.Resources.Constants)
local InviteStatus = Constants.InviteStatus

local InviteUserToPlaceId = require(parent.Thunks.InviteUserToPlaceId)

local placeId = tostring(game.PlaceId)

local extended = Roact.PureComponent:extend("InviteFriendsList")

local strictInterface = t.strictInterface
local v = {
	friends = t.array(t.strictInterface({
		IsOnline = t.boolean,
		Id = t.integer,
		Username = t.string,
		DisplayName = t.string
	})),
	invitesState = t.table,
	shouldForgetPreviousSelection = 0,
	dispatchInviteUserToPlaceId = 0,
	canCaptureFocus = 0,
	searchBoxRef = 0
}
local shouldForgetPreviousSelection2

if GetFFlagIGMGamepadSelectionHistory() then
	shouldForgetPreviousSelection2 = t.optional(t.boolean) or nil
end

v.shouldForgetPreviousSelection = shouldForgetPreviousSelection2
v.dispatchInviteUserToPlaceId = t.callback
v.canCaptureFocus = t.boolean
v.searchBoxRef = t.table
extended.validateProps = strictInterface(v)

function extended:init()
	self.playerRefs = RoactGamepad.createRefCache()

	self.state = { searchText = "" }

	self.inviteAnimationInProgress = {}
end

function extended:renderListEntries()
	local friends = self.props.friends

	local v2 = #friends

	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}
	local count = 0
	local layoutOrder = 1

	for k, friend in pairs(friends) do
		local id = tostring(friend.Id)
		local userInviteStatus = self.props.invitesState[id]
		local visible = PlayerSearchPredicate(self.state.searchText, friend.Username, friend.DisplayName)

		if visible then
			count += 1
		end

		local v3 = "friend_" .. k
		children[v3] = Roact.createElement(PlayerLabelV2, {
			username = friend.Username,
			displayName = friend.DisplayName,
			userId = friend.Id,
			isOnline = friend.IsOnline,
			isSelected = false,
			LayoutOrder = layoutOrder,
			Visible = visible,
			[Roact.Ref] = self.playerRefs[k],
			onActivated = function()
				local v4 = userInviteStatus == InviteStatus.Pending
				local v5 = userInviteStatus == InviteStatus.Success
				local v6 = self.inviteAnimationInProgress[friend.Id]

				if not (v4 or v5 or v6) then
					self.props.dispatchInviteUserToPlaceId(id, placeId)
				end
			end
		}, {
			InviteButton = Roact.createElement(SendInviteButton, {
				userInviteStatus = userInviteStatus,
				onActivated = function()
					self.props.dispatchInviteUserToPlaceId(id, placeId)
				end,
				animationBegun = function()
					self.inviteAnimationInProgress[friend.Id] = true
				end,
				animationEnded = function()
					self.inviteAnimationInProgress[friend.Id] = nil
				end
			})
		})

		layoutOrder += 1

		if not (k < v2) then
			continue
		end

		children["divider_" .. layoutOrder] = Roact.createElement(Divider, {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, -104, 0, 1),
			Visible = visible
		})

		layoutOrder += 1
	end

	return children, count
end

function extended:render()
	local listEntries, v2 = self:renderListEntries()

	local element = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		SearchBox = Roact.createElement(SearchBox, {
			Size = UDim2.new(1, -48, 0, 36),
			Position = UDim2.new(0.5, 0, 0, 8),
			AnchorPoint = Vector2.new(0.5, 0),
			searchUpdated = function(searchText)
				self:setState({ searchText = searchText })
			end,
			searchCleared = function()
				self:setState({ searchText = "" })

				if self.props.canCaptureFocus then
					GuiService.SelectedCoreObject = self.props.searchBoxRef:getValue()
				end
			end,
			itemRef = self.props.searchBoxRef
		}),
		List = Roact.createElement(BarOnTopScrollingFrame, {
			Position = UDim2.new(0, 0, 0, 64),
			Size = UDim2.new(1, 0, 1, -64),
			CanvasSize = UDim2.new(1, 0, 0, v2 * 72)
		}, listEntries)
	})
	local shouldForgetPreviousSelection

	if GetFFlagIGMGamepadSelectionHistory() then
		shouldForgetPreviousSelection = self.props.shouldForgetPreviousSelection
	else
		shouldForgetPreviousSelection = nil
	end

	return Roact.createElement(RootedConnection, {
		render = function(p)
			return Roact.createElement(FocusHandler, {
				isFocused = self.props.canCaptureFocus and p,
				shouldForgetPreviousSelection = shouldForgetPreviousSelection,
				didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p2)
					GuiService.SelectedCoreObject = p2
						or self:getFirstVisiblePlayerRef()
						or self.props.searchBoxRef:getValue()
				end or function()
					GuiService.SelectedCoreObject = self:getFirstVisiblePlayerRef()
						or self.props.searchBoxRef:getValue()
				end
			}, { FriendsList = element })
		end
	})
end

function extended:getFirstVisiblePlayerRef()
	local friends = self.props.friends

	for k, friend in pairs(friends) do
		if PlayerSearchPredicate(self.state.searchText, friend.Username, friend.DisplayName) then
			return self.playerRefs[k]:getValue()
		end
	end

	return nil
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local shouldForgetPreviousSelection

	if GetFFlagIGMGamepadSelectionHistory() then
		shouldForgetPreviousSelection = data.menuPage == Constants.MainPagePageKey or data.currentZone == 0
	end

	return {
		invitesState = data.invites,
		shouldForgetPreviousSelection = shouldForgetPreviousSelection
	}
end, function(callback)
	return {
		dispatchInviteUserToPlaceId = function(p, p2)
			callback(InviteUserToPlaceId(p, p2))
		end
	}
end)(extended)
