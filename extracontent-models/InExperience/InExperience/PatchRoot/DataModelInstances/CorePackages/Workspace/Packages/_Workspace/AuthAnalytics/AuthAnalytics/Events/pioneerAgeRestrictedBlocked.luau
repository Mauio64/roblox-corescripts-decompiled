local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, source: string)
	checkAndSendEvent(p, "pioneerAgeRestrictedBlocked", { source = source })
end
