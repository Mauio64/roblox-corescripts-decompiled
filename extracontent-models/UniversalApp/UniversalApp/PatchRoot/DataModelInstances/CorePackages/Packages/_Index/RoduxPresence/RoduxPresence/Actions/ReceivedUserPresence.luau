local ParentParent = script.Parent.Parent.Parent
local Rodux = require(ParentParent.Rodux)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(p1) -- line: 6
	return {
		payload = p1
	}
end)
