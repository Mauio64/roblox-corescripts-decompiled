local Parent = script:FindFirstAncestor("SocialContextToasts").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(Parent.React)
local DeeplinkConfirmationModal = require(Parent.NotificationsCommon).DeeplinkConfirmationModal

local function ConfirmationModalRoot() -- line: 10
	-- upvalues: useSelector (copy), React (copy), DeeplinkConfirmationModal (copy)
	local v6 = useSelector(function(p1) -- line: 11
		return p1.ConfirmationModal
	end)

	return {
		DeeplinkConfirmationModal = v6 and v6.isOpen and React.createElement(DeeplinkConfirmationModal, {
			closeCallback = v6.closeCallback
		})
	}
end

return ConfirmationModalRoot
