local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p, reverseNudgeType: string)
	return { toxicUserId = tostring(p), reverseNudgeType = reverseNudgeType }
end)
