local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

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
	contentVisible = t.boolean,
	isUsingGamepad = t.optional(t.boolean),
	focusGuiObject = t.callback
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

	self.dropDownButtonAnimatorRef = Roact.createRef()

	function self.onAnimationComplete()
		if self.props.isUsingGamepad then
			self.props.focusGuiObject(self.dropDownButtonAnimatorRef.current)
		end
	end
end

function extended.render(props)
	local playerRelationship = props.props.playerRelationship
	local selectedPlayer = props.props.selectedPlayer

	local fn = playerRelationship.friendStatus == Enum.FriendStatus.Friend
		and not props.state.unfriendConfirm
		and function()
			props:setState({ unfriendConfirm = true })
		end
		or function()
			if playerRelationship.friendStatus == Enum.FriendStatus.Friend then
				LocalPlayer:RevokeFriendship(selectedPlayer)
			elseif
				playerRelationship.friendStatus == Enum.FriendStatus.Unknown
				or playerRelationship.friendStatus == Enum.FriendStatus.NotFriend
			then
				props.props.requestFriendship(selectedPlayer, false)
			elseif playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestSent then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RevokeFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "PlayerDropDown")
				LocalPlayer:RevokeFriendship(selectedPlayer)
			elseif playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")
				props.props.requestFriendship(selectedPlayer, true)
			end
		end

	local fn2 = playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived and function()
		LocalPlayer:RevokeFriendship(selectedPlayer)
	end or nil

	local fn3 = props.state.unfriendConfirm and function()
		props:setState({ unfriendConfirm = false })
	end or nil

	local friendTextAndIcon, icon = getFriendTextAndIcon(playerRelationship.friendStatus)
	return Roact.createElement(DropDownButtonAnimator, {
		layoutOrder = props.props.layoutOrder,
		text = friendTextAndIcon,
		icon = icon,
		lastButton = false,
		onActivated = fn,
		forceShowOptions = props.state.unfriendConfirm,
		selectedPlayer = selectedPlayer,
		onDecline = fn2,
		onDismiss = fn3,
		contentVisible = props.props.contentVisible,
		forwardRef = props.dropDownButtonAnimatorRef,
		onAnimationComplete = props.onAnimationComplete
	})
end

function extended.didUpdate(object, data, p)
	if data.playerRelationship.friendStatus ~= object.props.playerRelationship.friendStatus then
		object:setState({ unfriendConfirm = false })
	end

	if data.selectedPlayer ~= object.props.selectedPlayer or data.dropDownOpen ~= object.props.dropDownOpen then
		object:setState({ unfriendConfirm = false })
	end

	if object.props.isUsingGamepad then
		local unfriendConfirm = object.state.unfriendConfirm
			or object.props.playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived
		local unfriendConfirm2 = p.unfriendConfirm
			or data.playerRelationship.friendStatus == Enum.FriendStatus.FriendRequestReceived

		if unfriendConfirm and unfriendConfirm ~= unfriendConfirm2 then
			object.props.focusGuiObject(object.dropDownButtonAnimatorRef.current)
		end
	elseif data.isUsingGamepad ~= object.props.isUsingGamepad then
		object.props.focusGuiObject(nil)
	end
end

function FriendDropDownButtonWrapper(p)
	local focusGuiObject = useFocusGuiObject()

	return Roact.createElement(extended, Cryo.Dictionary.join(p, { focusGuiObject = focusGuiObject }))
end

return FriendDropDownButtonWrapper
