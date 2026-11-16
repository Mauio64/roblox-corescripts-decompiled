local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return {
		value = {
			preferredTransparency = p.preferredTransparency or 1
		}
	}
end)
