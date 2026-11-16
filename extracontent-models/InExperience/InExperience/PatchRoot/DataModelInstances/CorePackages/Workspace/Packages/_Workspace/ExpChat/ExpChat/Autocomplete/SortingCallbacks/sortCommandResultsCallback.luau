local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List

return function(p)
	return list.sort(p)
end
