local module = require("@luauforge/deferred/eil")

local images = require("@luauforge/deferred/eiT").App.ImageSet.Images

local module2 = require("@luauforge/deferred/eiU")
local iconName = module2.Enums.IconName
local buttonVariant = module2.Enums.ButtonVariant

local module3 = require("@luauforge/deferred/elT")

local focusNavigationEventNameEnum = require("@luauforge/deferred/eiR").FocusNavigationEventNameEnum

local buttonTypes = require("@luauforge/deferred/eka").Enums.ButtonTypes

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/eiz").FFlagAddFriendsUserListEnabled

local ctaAction = require("@luauforge/deferred/elR").CtaAction

local function useAddFriendsTileButtons(data)
	return module.useMemo(function()
		local result = {}

		for i, v5 in ipairs(data.ctaActions or {}) do
			if v5.actionEnum == ctaAction.IgnoreTrustedFriendRequest then
				local v6 = {
					icon = iconName.X,
					onActivated = function()
						if data.handleIgnoreTrustedFriendRequest then
							data.handleIgnoreTrustedFriendRequest()
						end
					end,
					focusEventName = 0,
					type = 0
				}
				local v7 = if data.shouldAddFocusEventName then focusNavigationEventNameEnum.IgnoreTrustedFriendRequest else nil
				v6.focusEventName = v7

				local v8 = if fFlagAddFriendsUserListEnabled then buttonTypes.Dismiss else nil
				v6.type = v8
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.AcceptTrustedFriendRequest then
				local v6 = {
					icon = images["icons/actions/friends/friendAdd"],
					onActivated = function()
						if data.handleAcceptTrustedFriendRequest then
							data.handleAcceptTrustedFriendRequest()
						end
					end,
					focusEventName = 0,
					type = 0
				}
				local v7 = if data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest else nil
				v6.focusEventName = v7

				local v8 = if fFlagAddFriendsUserListEnabled then buttonTypes.Accept else nil
				v6.type = v8
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.DeclineFriendRequest then
				local v7 = if fFlagAddFriendsUserListEnabled then iconName.X else images["icons/actions/reject"]
				local v6 = {
					icon = v7,
					isSecondary = not fFlagAddFriendsUserListEnabled or nil,
					onActivated = function()
						data.handleDeclineFriendRequest(v5.onSuccessCallback)
					end,
					focusEventName = 0,
					type = 0
				}
				local v8 = if data.shouldAddFocusEventName then focusNavigationEventNameEnum.IgnoreFriendRequest else nil
				v6.focusEventName = v8

				local v9 = if fFlagAddFriendsUserListEnabled then buttonTypes.Dismiss else nil
				v6.type = v9
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.AcceptFriendRequest then
				local v6 = {
					icon = images["icons/actions/friends/friendAdd"],
					isSecondary = if not fFlagAddFriendsUserListEnabled then false else nil,
					onActivated = function()
						data.handleAcceptFriendRequest(v5.onSuccessCallback)
					end,
					focusEventName = 0,
					type = 0
				}
				local v8 = if data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToAcceptFriendRequest else nil
				v6.focusEventName = v8

				local v9 = if fFlagAddFriendsUserListEnabled then buttonTypes.Accept else nil
				v6.type = v9
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.RequestFriendship then
				local v6 = {
					icon = images["icons/actions/friends/friendAdd"],
					isSecondary = if not fFlagAddFriendsUserListEnabled then false else nil,
					onActivated = function()
						data.handleRequestFriendship(v5.onSuccessCallback)
					end,
					focusEventName = 0,
					type = 0
				}
				local v8 = if data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToAddFriend else nil
				v6.focusEventName = v8

				local v9 = if fFlagAddFriendsUserListEnabled then buttonTypes.Add else nil
				v6.type = v9
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.PendingFriendRequest then
				local v6 = {
					icon = images["icons/actions/friends/friendpending"],
					isSecondary = if not fFlagAddFriendsUserListEnabled then false else nil,
					isDisabled = true,
					onActivated = function() end,
					type = 0
				}
				local v8 = if fFlagAddFriendsUserListEnabled then buttonTypes.Pending else nil
				v6.type = v8
				table.insert(result, v6)
			elseif v5.actionEnum == ctaAction.ViewProfile and fFlagAddFriendsUserListEnabled then
				local v6 = {
					onActivated = function()
						if data.handleViewProfile then
							data.handleViewProfile()
						end
					end,
					type = buttonTypes.View,
					variant = 0
				}
				local v7 = if module3 then buttonVariant.Standard else nil
				v6.variant = v7
				table.insert(result, v6)
			end
		end

		return result
	end, {
		data.ctaActions,
		data.handleRequestFriendship,
		data.handleAcceptFriendRequest,
		data.handleDeclineFriendRequest,
		data.handleAcceptTrustedFriendRequest,
		data.handleIgnoreTrustedFriendRequest,
		data.handleViewProfile,
		data.shouldAddFocusEventName
	})
end

return useAddFriendsTileButtons
