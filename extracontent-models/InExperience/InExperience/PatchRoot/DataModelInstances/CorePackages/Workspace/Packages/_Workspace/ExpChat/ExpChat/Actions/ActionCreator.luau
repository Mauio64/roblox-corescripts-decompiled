local parent = script:FindFirstAncestor("ExpChat").Parent
local Cryo = require(parent.Cryo)

return function(p: string, callback)
	return function(...)
		local v = callback(...)
		return (Cryo.Dictionary.union(v, { type = p }))
	end
end
