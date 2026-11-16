local ChatIntervention = script:FindFirstAncestor("ChatIntervention")
local Rodux = require(ChatIntervention.Parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(isShow: boolean)
	return { isShow = isShow }
end)
