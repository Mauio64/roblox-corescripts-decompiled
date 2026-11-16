local parent = script:FindFirstAncestor("AppChat").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama

return function(p)
	if #p.existing ~= #p.new then
		return false
	end

	local sorted = llama.List.sort(p.existing)
	local sorted2 = llama.List.sort(p.new)

	return llama.List.equals(sorted, sorted2)
end
