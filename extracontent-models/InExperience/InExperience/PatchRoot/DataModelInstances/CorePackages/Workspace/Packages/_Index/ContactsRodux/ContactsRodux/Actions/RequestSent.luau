local ParentParent = script.Parent.Parent.Parent
local Rodux = require(ParentParent.Rodux)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(t1: {[any]: any}) -- line: 6
	return {
		payload = t1
	}
end)
