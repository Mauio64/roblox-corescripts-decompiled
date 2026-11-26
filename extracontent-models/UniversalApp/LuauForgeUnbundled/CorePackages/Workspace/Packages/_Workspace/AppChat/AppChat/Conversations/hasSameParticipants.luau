local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").llama

return function(p2)
	if #p2.existing ~= #p2.new then
		return false
	end

	local sorted = llama.List.sort(p2.existing)
	local sorted2 = llama.List.sort(p2.new)

	return llama.List.equals(sorted, sorted2)
end
