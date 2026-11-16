local parent = script.Parent.Parent.Parent
local Rodux = require(parent.Rodux)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(payload)
	return { payload = payload }
end)
