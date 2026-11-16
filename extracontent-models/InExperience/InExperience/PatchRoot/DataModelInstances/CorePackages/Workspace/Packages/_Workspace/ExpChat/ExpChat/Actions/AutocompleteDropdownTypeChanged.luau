local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(autocompleteType: string)
	return { autocompleteType = autocompleteType }
end)
