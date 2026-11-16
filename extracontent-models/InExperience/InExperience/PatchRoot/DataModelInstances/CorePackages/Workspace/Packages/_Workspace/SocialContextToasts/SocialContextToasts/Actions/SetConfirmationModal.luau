local parent = script:FindFirstAncestor("SocialContextToasts").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(isConfirmationModalOpen, closeCallback)
	return { isConfirmationModalOpen = isConfirmationModalOpen, closeCallback = closeCallback }
end)
