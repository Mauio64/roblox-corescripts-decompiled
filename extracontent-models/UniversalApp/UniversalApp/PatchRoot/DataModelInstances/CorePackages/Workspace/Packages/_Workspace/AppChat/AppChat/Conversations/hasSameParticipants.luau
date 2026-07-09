local Parent = script:FindFirstAncestor("AppChat").Parent
local llama = require(Parent.LuaSocialLibrariesDeps).llama

return function(p1) -- line: 6
	-- upvalues: llama (copy)
	if #p1.existing ~= #p1.new then
		return false
	end

	local v4 = llama.List.sort(p1.existing)
	local v5 = llama.List.sort(p1.new)

	return llama.List.equals(v4, v5)
end
