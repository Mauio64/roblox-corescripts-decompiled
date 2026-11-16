local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(feedStoreKey: string)
	return { feedStoreKey = feedStoreKey }
end)
