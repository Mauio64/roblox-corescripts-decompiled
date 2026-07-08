local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createFriendsStore = require(script.Parent.createFriendsStore)
local v4 = Signals.createComputed(createFriendsStore)

return {
	get = function() -- line: 11
		-- upvalues: v4 (copy)
		return v4(false)
	end
}
