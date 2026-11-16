local parent = script.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.Types.ContactTypes)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(payload)
	return { payload = payload }
end)
