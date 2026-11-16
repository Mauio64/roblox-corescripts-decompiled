local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local DropDownButtonAnimator = require(script.Parent.DropDownButtonAnimator)

local Images = UIBlox.App.ImageSet.Images

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local LocalPlayer = Players.LocalPlayer

local _ = {
	unfriend = "Feature.Friends.Action.Unfriend",
	friendRequest = "Feature.Friends.Label.FriendRequest"
}

local extended = Roact.PureComponent:extend("FriendDropDownButton")

extended.validateProps = t.strictInterface({
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
	contentVisible = t.optional(t.boolean)
})

local function getFriendTextAndIcon(friendStatus)
	local iconsactionsfriendsfriendAdd = Images["icons/actions/friends/friendAdd"]
	local iconsactionsfriendsfriendRemove = Images["icons/actions/friends/friendRemove"]

	local v = Localization.new(LocalizationService.RobloxLocaleId)

	if friendStatus == Enum.FriendStatus.Friend then
		return v:Format("Feature.Friends.Action.Unfriend"), iconsactionsfriendsfriendRemove
	end

	if friendStatus == Enum.FriendStatus.Unknown or friendStatus == Enum.FriendStatus.NotFriend then
		return v:Format("Feature.Friends.Label.FriendRequest"), iconsactionsfriendsfriendAdd
	end

	if friendStatus == Enum.FriendStatus.FriendRequestSent then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.CancelRequest"), iconsactionsfriendsfriendAdd
	end

	if friendStatus == Enum.FriendStatus.FriendRequestReceived then
		return RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Accept"), iconsactionsfriendsfriendAdd
	end

	return v:Format("Feature.Friends.Label.FriendRequest"), iconsactionsfriendsfriendAdd
end

function extended:init()
	self.state = { unfriendConfirm = false }
end

function extended.render(object)
	local playerRelationship = object.props.playerRelationship
	local selectedPlayer = object.props.selectedPlayer

	local fn = playerRelationship.friendStatus == Enum.FriendStatus.Friend
		and not object.state.unfriendConfirm
		and function()
			object:setState({ unfriendConfirm = true })
		end
		or function()
			if playerRelationship.friendStatus == Enum.FriendStatus.Friend then
				LocalPlayer:RevokeFriendship(selectedPlayer)
			elseif
				playerRelationship.friendStatus == Enum.FriendStatus.Unknown
				or playerRelationship.friendStatus == Enum.FriendStatus.NotFriend
			then
				object.props.requestFriendship(selectedPlayer, false)
			elseif playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestSent then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RevokeFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "PlayerDropDown")
				LocalPlayer:RevokeFriendship(selectedPlayer)
			elseif playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")
				object.props.requestFriendship(selectedPlayer, true)
			end
		end

	local fn2 = playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived and function()
		LocalPlayer:RevokeFriendship(selectedPlayer)
	end or nil

	local fn3 = object.state.unfriendConfirm and function()
		object:setState({ unfriendConfirm = false })
	end or nil

	local friendTextAndIcon, icon = getFriendTextAndIcon(playerRelationship.friendStatus)
	return Roact.createElement(DropDownButtonAnimator, {
		layoutOrder = object.props.layoutOrder,
		text = friendTextAndIcon,
		icon = icon,
		lastButton = false,
		onActivated = fn,
		forceShowOptions = object.state.unfriendConfirm,
		selectedPlayer = selectedPlayer,
		onDecline = fn2,
		onDismiss = fn3
	})
end

function extended.didUpdate(object, data, _)
	if data.playerRelationship.friendStatus ~= object.props.playerRelationship.friendStatus then
		object:setState({ unfriendConfirm = false })
	end

	if data.selectedPlayer ~= object.props.selectedPlayer or data.dropDownOpen ~= object.props.dropDownOpen then
		object:setState({ unfriendConfirm = false })
	end
end

return extended
