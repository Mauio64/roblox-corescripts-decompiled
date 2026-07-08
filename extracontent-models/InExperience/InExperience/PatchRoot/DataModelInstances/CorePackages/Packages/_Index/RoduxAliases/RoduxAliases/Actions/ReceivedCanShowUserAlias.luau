local Parent = script:FindFirstAncestor("RoduxAliases").Parent
local Rodux = require(Parent.Rodux)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(p1) -- line: 6
	return {
		payload = {
			showUserAlias = p1
		}
	}
end)
