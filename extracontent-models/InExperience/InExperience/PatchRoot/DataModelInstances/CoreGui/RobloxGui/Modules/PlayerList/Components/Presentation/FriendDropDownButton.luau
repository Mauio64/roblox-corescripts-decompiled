local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local DropDownButtonAnimator = require(script.Parent.DropDownButtonAnimator)
local Images = UIBlox.App.ImageSet.Images
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local FFlagConnectionsToFriendsRename = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionsToFriendsRename
local LocalPlayer = Players.LocalPlayer
local t1 = {
	unfriend = if not FFlagConnectionsToFriendsRename then nil else "Feature.Friends.Action.Unfriend",
	friendRequest = if not FFlagConnectionsToFriendsRename then nil else "Feature.Friends.Label.FriendRequest",
	removeConnection = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.RemoveConnection" or nil,
	connectionRequest = not FFlagConnectionsToFriendsRename and "InGame.PlayerDropDown.Action.ConnectionRequest" or nil
}
local v15 = Roact.PureComponent:extend("FriendDropDownButton")

v15.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	playerRelationship = t.strictInterface({
		isBlocked = t.boolean,
		friendStatus = t.enum(Enum.FriendStatus),
		isFollowing = t.boolean,
		isFollower = t.boolean
	}),
	selectedPlayer = t.optional(t.instanceIsA("Player")),
	dropDownOpen = t.boolean,
	requestFriendship = t.callback
})

local function getFriendTextAndIcon(p1) -- line: 49
	-- upvalues: Images (copy), Localization (copy), LocalizationService (copy), FFlagConnectionsToFriendsRename (copy), t1 (copy), RobloxTranslator (copy)
	local v18 = Images["icons/actions/friends/friendAdd"]
	local v19 = Images["icons/actions/friends/friendRemove"]
	local v20 = Localization.new(LocalizationService.RobloxLocaleId)

	if p1 == Enum.FriendStatus.Friend then
		return v20:Format(if not FFlagConnectionsToFriendsRename then t1.removeConnection else t1.unfriend), v19
	end

	if p1 == Enum.FriendStatus.Unknown or p1 == Enum.FriendStatus.NotFriend then
		return v20:Format(if not FFlagConnectionsToFriendsRename then t1.connectionRequest else t1.friendRequest), v18
	end

	if p1 == Enum.FriendStatus.FriendRequestSent then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.CancelRequest"), v18
	end

	if p1 == Enum.FriendStatus.FriendRequestReceived then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Accept"), v18
	end

	return v20:Format(t1.connectionRequest), v18
end

function v15.init(p2) -- line: 75
	p2.state = {
		unfriendConfirm = false
	}
end
function v15.render(p3) -- line: 81
	-- upvalues: LocalPlayer (copy), RbxAnalyticsService (copy), getFriendTextAndIcon (copy), Roact (copy), DropDownButtonAnimator (copy)
	local playerRelationship = p3.props.playerRelationship
	local selectedPlayer = p3.props.selectedPlayer
	local v25 = (playerRelationship.friendStatus ~= Enum.FriendStatus.Friend or p3.state.unfriendConfirm) and function() -- line: 92
		-- upvalues: playerRelationship (copy), LocalPlayer (copy), selectedPlayer (copy), p3 (copy), RbxAnalyticsService (copy)
		if playerRelationship.friendStatus == Enum.FriendStatus.Friend then
			LocalPlayer:RevokeFriendship(selectedPlayer)

			return
		end

		if playerRelationship.friendStatus == Enum.FriendStatus.Unknown or playerRelationship.friendStatus == Enum.FriendStatus.NotFriend then
			p3.props.requestFriendship(selectedPlayer, false)

			return
		end

		if playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestSent then
			RbxAnalyticsService:ReportCounter("PlayerDropDown-RevokeFriendship")
			RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "PlayerDropDown")
			LocalPlayer:RevokeFriendship(selectedPlayer)

			return
		end

		if playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived then
			RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
			RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")
			p3.props.requestFriendship(selectedPlayer, true)
		end
	end or function() -- line: 86
		-- upvalues: p3 (copy)
		p3:setState({
			unfriendConfirm = true
		})
	end
	local v26 = nil

	if playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived then
		function v26() -- line: 114
			-- upvalues: LocalPlayer (copy), selectedPlayer (copy)
			LocalPlayer:RevokeFriendship(selectedPlayer)
		end
	end

	local v27 = nil

	if p3.state.unfriendConfirm then
		function v27() -- line: 120
			-- upvalues: p3 (copy)
			p3:setState({
				unfriendConfirm = false
			})
		end
	end

	local v28, v29 = getFriendTextAndIcon(playerRelationship.friendStatus)

	return Roact.createElement(DropDownButtonAnimator, {
		lastButton = false,
		layoutOrder = p3.props.layoutOrder,
		text = v28,
		icon = v29,
		onActivated = v25,
		forceShowOptions = p3.state.unfriendConfirm,
		selectedPlayer = selectedPlayer,
		onDecline = v26,
		onDismiss = v27
	})
end
function v15.didUpdate(p4, p5, _) -- line: 141
	if p5.playerRelationship.friendStatus ~= p4.props.playerRelationship.friendStatus then
		p4:setState({
			unfriendConfirm = false
		})
	end

	if p5.selectedPlayer ~= p4.props.selectedPlayer or p5.dropDownOpen ~= p4.props.dropDownOpen then
		p4:setState({
			unfriendConfirm = false
		})
	end
end

return v15
