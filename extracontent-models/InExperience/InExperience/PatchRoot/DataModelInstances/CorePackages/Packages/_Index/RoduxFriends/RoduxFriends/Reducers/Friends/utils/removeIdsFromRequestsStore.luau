local parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(parent.llama)

return function(p, items)
	local nones = {}

	for _, item in pairs(items) do
		nones[item] = llama.None
	end

	return llama.Dictionary.join(p, nones)
end
