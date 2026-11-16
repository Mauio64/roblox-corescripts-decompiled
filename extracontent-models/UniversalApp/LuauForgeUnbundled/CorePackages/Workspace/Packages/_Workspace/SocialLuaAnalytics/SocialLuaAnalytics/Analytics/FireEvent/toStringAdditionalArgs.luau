local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies")
local tutils = dependencies.tutils
local llama = dependencies.llama

return function(p2)
	if llama.isEmpty(p2) then
		return "{}"
	end

	local v5, v6 = string.gsub(" args: " .. tutils.toString(p2), "%s+", " ")
	return v5
end
