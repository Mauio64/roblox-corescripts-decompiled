local AppChat = script:FindFirstAncestor("AppChat")

local Enums = require(AppChat.MessageData.Enums)
require(AppChat.AppChatData.Types)

local MessageStatus = Enums.MessageStatus
local MessageVisibility = Enums.MessageVisibility

local function getMessageState(p)
	if p.status == MessageStatus.Pending then
		return { deliveryState = "Pending", visibility = "Visible" }
	end

	if p.status == MessageStatus.Failed then
		return { deliveryState = "Failed", visibility = "Visible" }
	end

	if p.status == MessageStatus.Moderated then
		return { deliveryState = "Rejected", visibility = "Moderated" }
	end

	if p.status == MessageStatus.Hidden or p.visibility == MessageVisibility.Hidden then
		return { deliveryState = "Sent", visibility = "Hidden" }
	end

	return { deliveryState = "Sent", visibility = "Visible" }
end

return getMessageState
