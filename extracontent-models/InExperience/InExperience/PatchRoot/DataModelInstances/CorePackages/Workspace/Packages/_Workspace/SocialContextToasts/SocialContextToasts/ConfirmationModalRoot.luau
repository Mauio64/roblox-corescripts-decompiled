local parent = script:FindFirstAncestor("SocialContextToasts").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local React = require(parent.React)

local NotificationsCommon = require(parent.NotificationsCommon)
local DeeplinkConfirmationModal = NotificationsCommon.DeeplinkConfirmationModal

local function ConfirmationModalRoot()
	local v = useSelector(function(p)
		return p.ConfirmationModal
	end)

	return {
		DeeplinkConfirmationModal = v and v.isOpen and React.createElement(DeeplinkConfirmationModal, {
			closeCallback = v.closeCallback
		})
	}
end

return ConfirmationModalRoot
