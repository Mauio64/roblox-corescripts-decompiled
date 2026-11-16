local parent = script:FindFirstAncestor("AppChat").Parent
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

require(script.Parent.MessageFtuxTooltipVariant)

local MessageFtuxTooltipDismissSignal = { dismissed = Signal.new() }

function MessageFtuxTooltipDismissSignal.dismiss(p)
	MessageFtuxTooltipDismissSignal.dismissed:fire(p)
end

return MessageFtuxTooltipDismissSignal
