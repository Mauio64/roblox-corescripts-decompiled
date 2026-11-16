local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local tutils = dependencies.tutils
local llama = dependencies.llama

return function(p)
	if llama.isEmpty(p) then
		return "{}"
	end

	local v, _ = string.gsub(" args: " .. tutils.toString(p), "%s+", " ")
	return v
end
