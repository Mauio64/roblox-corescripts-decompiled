local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local ParentParent = script.Parent.Parent.Parent
local PlayerLabelV2 = require(ParentParent.Components.PlayerLabelV2)
local GetFFlagIGMGamepadSelectionHistory = require(ParentParent.Flags.GetFFlagIGMGamepadSelectionHistory)
local Divider = require(ParentParent.Components.Divider)
local SendInviteButton = require(script.Parent.SendInviteButton)
local SearchBox = require(script.Parent.SearchBox)
local BarOnTopScrollingFrame = require(ParentParent.Components.BarOnTopScrollingFrame)
local PlayerSearchPredicate = require(ParentParent.Utility.PlayerSearchPredicate)
local FocusHandler = require(ParentParent.Components.Connection.FocusHandler)
local RootedConnection = require(ParentParent.Components.Connection.RootedConnection)
local Constants = require(ParentParent.Resources.Constants)
local InviteStatus = Constants.InviteStatus
local InviteUserToPlaceId = require(ParentParent.Thunks.InviteUserToPlaceId)
local str = tostring(game.PlaceId)
local v22 = Roact.PureComponent:extend("InviteFriendsList")

v22.validateProps = t.strictInterface({
	friends = t.array(t.strictInterface({
		IsOnline = t.boolean,
		Id = t.integer,
		Username = t.string,
		DisplayName = t.string
	})),
	invitesState = t.table,
	shouldForgetPreviousSelection = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.boolean) or nil,
	dispatchInviteUserToPlaceId = t.callback,
	canCaptureFocus = t.boolean,
	searchBoxRef = t.table
})

function v22.init(p1) -- line: 54
	-- upvalues: RoactGamepad (copy)
	p1.playerRefs = RoactGamepad.createRefCache()
	p1.state = {
		searchText = ""
	}
	p1.inviteAnimationInProgress = {}
end
function v22.renderListEntries(p2) -- line: 63
	-- upvalues: Roact (copy), PlayerSearchPredicate (copy), PlayerLabelV2 (copy), InviteStatus (copy), str (copy), SendInviteButton (copy), Divider (copy)
	local friends = p2.props.friends
	local v26 = #friends
	local n1 = 1
	local t1 = {}
	local n2 = 0

	t1.ListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right
	})

	for k, v in pairs(friends) do
		local str2 = tostring(v.Id)
		local v33 = p2.props.invitesState[str2]
		local v34 = PlayerSearchPredicate(p2.state.searchText, v.Username, v.DisplayName)

		if v34 then
			n2 += 1
		end

		t1["friend_" .. k] = Roact.createElement(PlayerLabelV2, {
			username = v.Username,
			displayName = v.DisplayName,
			userId = v.Id,
			isOnline = v.IsOnline,
			isSelected = false,
			LayoutOrder = n1,
			Visible = v34,
			[Roact.Ref] = p2.playerRefs[k],
			onActivated = function() -- line: 96
				-- upvalues: v33 (copy), InviteStatus (copy), p2 (copy), v (copy), str2 (copy), str (copy)
				local v48 = v33 == InviteStatus.Pending
				local v49 = v33 == InviteStatus.Success
				local v50 = p2.inviteAnimationInProgress[v.Id]

				if not v48 and (not v49 and not v50) then
					p2.props.dispatchInviteUserToPlaceId(str2, str)
				end
			end
		}, {
			InviteButton = Roact.createElement(SendInviteButton, {
				userInviteStatus = v33,
				onActivated = function() -- line: 107
					-- upvalues: p2 (copy), str2 (copy), str (copy)
					p2.props.dispatchInviteUserToPlaceId(str2, str)
				end,
				animationBegun = function() -- line: 110
					-- upvalues: p2 (copy), v (copy)
					p2.inviteAnimationInProgress[v.Id] = true
				end,
				animationEnded = function() -- line: 113
					-- upvalues: p2 (copy), v (copy)
					p2.inviteAnimationInProgress[v.Id] = nil
				end
			})
		})
		n1 += 1

		if k < v26 then
			t1["divider_" .. n1] = Roact.createElement(Divider, {
				LayoutOrder = n1,
				Size = UDim2.new(1, -104, 0, 1),
				Visible = v34
			})
			n1 += 1
		end
	end

	return t1, n2
end
function v22.render(p3) -- line: 135
	-- upvalues: Roact (copy), SearchBox (copy), GuiService (copy), BarOnTopScrollingFrame (copy), GetFFlagIGMGamepadSelectionHistory (copy), RootedConnection (copy), FocusHandler (copy)
	local v36, v37 = p3:renderListEntries()
	local v38 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		SearchBox = Roact.createElement(SearchBox, {
			Size = UDim2.new(1, -48, 0, 36),
			Position = UDim2.new(0.5, 0, 0, 8),
			AnchorPoint = Vector2.new(0.5, 0),
			searchUpdated = function(p4) -- line: 148
				-- upvalues: p3 (copy)
				p3:setState({
					searchText = p4
				})
			end,
			searchCleared = function() -- line: 153
				-- upvalues: p3 (copy), GuiService (copy)
				p3:setState({
					searchText = ""
				})

				if p3.props.canCaptureFocus then
					GuiService.SelectedCoreObject = p3.props.searchBoxRef:getValue()
				end
			end,
			itemRef = p3.props.searchBoxRef
		}),
		List = Roact.createElement(BarOnTopScrollingFrame, {
			Position = UDim2.new(0, 0, 0, 64),
			Size = UDim2.new(1, 0, 1, -64),
			CanvasSize = UDim2.new(1, 0, 0, v37 * 72)
		}, v36)
	})
	local shouldForgetPreviousSelection = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		shouldForgetPreviousSelection = p3.props.shouldForgetPreviousSelection
	end

	return Roact.createElement(RootedConnection, {
		render = function(p5) -- line: 177
			-- upvalues: Roact (copy), FocusHandler (copy), p3 (copy), shouldForgetPreviousSelection (ref), GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy), v38 (copy)
			return Roact.createElement(FocusHandler, {
				isFocused = p3.props.canCaptureFocus and p5,
				shouldForgetPreviousSelection = shouldForgetPreviousSelection,
				didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p6) -- line: 181
					-- upvalues: GuiService (copy), p3 (copy)
					GuiService.SelectedCoreObject = p6 or (p3:getFirstVisiblePlayerRef() or p3.props.searchBoxRef:getValue())
				end or function() -- line: 185
					-- upvalues: GuiService (copy), p3 (copy)
					GuiService.SelectedCoreObject = p3:getFirstVisiblePlayerRef() or p3.props.searchBoxRef:getValue()
				end
			}, {
				FriendsList = v38
			})
		end
	})
end
function v22.getFirstVisiblePlayerRef(p7) -- line: 196
	-- upvalues: PlayerSearchPredicate (copy)
	local friends = p7.props.friends

	for k, v in pairs(friends) do
		if PlayerSearchPredicate(p7.state.searchText, v.Username, v.DisplayName) then
			return p7.playerRefs[k]:getValue()
		end
	end

	return nil
end

return RoactRodux.UNSTABLE_connect2(function(p8, _) -- line: 207
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), Constants (copy)
	local v46 = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		v46 = p8.menuPage == Constants.MainPagePageKey or p8.currentZone == 0
	end

	return {
		invitesState = p8.invites,
		shouldForgetPreviousSelection = v46
	}
end, function(p10) -- line: 217
	-- upvalues: InviteUserToPlaceId (copy)
	return {
		dispatchInviteUserToPlaceId = function(p11, p12) -- line: 219
			-- upvalues: p10 (copy), InviteUserToPlaceId (copy)
			p10(InviteUserToPlaceId(p11, p12))
		end
	}
end)(v22)
