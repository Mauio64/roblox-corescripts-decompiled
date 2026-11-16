local parent = script:FindFirstAncestor("RoduxAliases").Parent
local Rodux = require(parent.Rodux)
local ActionDomain = require(script.Parent.ActionDomain)

return Rodux.makeActionCreator(ActionDomain .. script.Name, function(showUserAlias)
	return {
		payload = { showUserAlias = showUserAlias }
	}
end)
