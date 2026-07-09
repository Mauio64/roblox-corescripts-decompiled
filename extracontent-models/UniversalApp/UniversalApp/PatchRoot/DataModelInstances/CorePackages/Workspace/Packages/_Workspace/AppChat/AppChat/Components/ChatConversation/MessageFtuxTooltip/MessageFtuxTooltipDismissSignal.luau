local Parent = script:FindFirstAncestor("AppChat").Parent
local Signal = require(Parent.AppCommonLib).Signal

require(script.Parent.MessageFtuxTooltipVariant)

local t1 = {
	dismissed = Signal.new()
}

function t1.dismiss(p1) -- line: 17
	-- upvalues: t1 (copy)
	t1.dismissed:fire(p1)
end

return t1
