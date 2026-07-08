local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local tutils = dependencies.tutils
local llama = dependencies.llama

return function(p1) -- line: 7
	-- upvalues: llama (copy), tutils (copy)
	if llama.isEmpty(p1) then
		return "{}"
	end

	local result, _ = string.gsub(" args: " .. tutils.toString(p1), "%s+", " ")

	return result
end
