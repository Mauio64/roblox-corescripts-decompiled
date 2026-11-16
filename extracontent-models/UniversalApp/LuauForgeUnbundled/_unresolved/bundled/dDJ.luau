local module = require("@luauforge/bundled/dDF")
local communityListRouting = require("@luauforge/bundled/dDK").CommunityListRouting

return function(p2)
	if communityListRouting.getIsCompactTouch(false) then
		return module.PolicyDependent
	end

	return module.Visible
end
