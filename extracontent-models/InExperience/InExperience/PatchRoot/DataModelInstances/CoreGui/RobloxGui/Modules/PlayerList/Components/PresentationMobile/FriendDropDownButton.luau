local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
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
local v17 = Roact.PureComponent:extend("FriendDropDownButton")

v17.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	playerRelationship = t.strictInterface({
		isBlocked = t.boolean,
		friendStatus = t.enum(Enum.FriendStatus),
		isFollowing = t.boolean,
		isFollower = t.boolean
	}),
	selectedPlayer = t.optional(t.instanceIsA("Player")),
	dropDownOpen = t.boolean,
	requestFriendship = t.callback,
	contentVisible = t.boolean,
	isUsingGamepad = t.optional(t.boolean),
	focusGuiObject = t.callback
})

local function getFriendTextAndIcon(p1) -- line: 55
	-- upvalues: Images (copy), Localization (copy), LocalizationService (copy), FFlagConnectionsToFriendsRename (copy), t1 (copy), RobloxTranslator (copy)
	local v20 = Images["icons/actions/friends/friendAdd"]
	local v21 = Images["icons/actions/friends/friendRemove"]
	local v22 = Localization.new(LocalizationService.RobloxLocaleId)

	if p1 == Enum.FriendStatus.Friend then
		return v22:Format(if not FFlagConnectionsToFriendsRename then t1.removeConnection else t1.unfriend), v21
	end

	if p1 == Enum.FriendStatus.Unknown or p1 == Enum.FriendStatus.NotFriend then
		return v22:Format(if not FFlagConnectionsToFriendsRename then t1.connectionRequest else t1.friendRequest), v20
	end

	if p1 == Enum.FriendStatus.FriendRequestSent then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.CancelRequest"), v20
	end

	if p1 == Enum.FriendStatus.FriendRequestReceived then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Accept"), v20
	end

	return v22:Format(t1.connectionRequest), v20
end

function v17.init(p2) -- line: 81
	-- upvalues: Roact (copy)
	p2.state = {
		unfriendConfirm = false
	}
	p2.dropDownButtonAnimatorRef = Roact.createRef()

	function p2.onAnimationComplete() -- line: 88
		-- upvalues: p2 (copy)
		if p2.props.isUsingGamepad then
			p2.props.focusGuiObject(p2.dropDownButtonAnimatorRef.current)
		end
	end
end
function v17.render(p3) -- line: 95
	-- upvalues: LocalPlayer (copy), RbxAnalyticsService (copy), getFriendTextAndIcon (copy), Roact (copy), DropDownButtonAnimator (copy)
	local playerRelationship = p3.props.playerRelationship
	local selectedPlayer = p3.props.selectedPlayer
	local v27 = (playerRelationship.friendStatus ~= Enum.FriendStatus.Friend or p3.state.unfriendConfirm) and function() -- line: 107
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
	end or function() -- line: 101
		-- upvalues: p3 (copy)
		p3:setState({
			unfriendConfirm = true
		})
	end
	local v28 = nil

	if playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived then
		function v28() -- line: 129
			-- upvalues: LocalPlayer (copy), selectedPlayer (copy)
			LocalPlayer:RevokeFriendship(selectedPlayer)
		end
	end

	local v29 = nil

	if p3.state.unfriendConfirm then
		function v29() -- line: 135
			-- upvalues: p3 (copy)
			p3:setState({
				unfriendConfirm = false
			})
		end
	end

	local v30, v31 = getFriendTextAndIcon(playerRelationship.friendStatus)

	return Roact.createElement(DropDownButtonAnimator, {
		lastButton = false,
		layoutOrder = p3.props.layoutOrder,
		text = v30,
		icon = v31,
		onActivated = v27,
		forceShowOptions = p3.state.unfriendConfirm,
		selectedPlayer = selectedPlayer,
		onDecline = v28,
		onDismiss = v29,
		contentVisible = p3.props.contentVisible,
		forwardRef = p3.dropDownButtonAnimatorRef,
		onAnimationComplete = p3.onAnimationComplete
	})
end
function v17.didUpdate(p4, p5, p6) -- line: 159
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

	if p4.props.isUsingGamepad then
		local v35 = p4.state.unfriendConfirm or p4.props.playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived
		local v36 = p6.unfriendConfirm or p5.playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived

		if v35 and v35 ~= v36 then
			p4.props.focusGuiObject(p4.dropDownButtonAnimatorRef.current)

			return
		end
	elseif p5.isUsingGamepad ~= p4.props.isUsingGamepad then
		p4.props.focusGuiObject(nil)
	end
end
function FriendDropDownButtonWrapper(p7) -- line: 188
	-- upvalues: useFocusGuiObject (copy), Roact (copy), v17 (copy), Cryo (copy)
	local v38 = useFocusGuiObject()

	return Roact.createElement(v17, Cryo.Dictionary.join(p7, {
		focusGuiObject = v38
	}))
end

return FriendDropDownButtonWrapper
