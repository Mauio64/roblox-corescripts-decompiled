local module = require("@luauforge/bundled/dGK")
local communityListRouting = require("@luauforge/bundled/dGP").CommunityListRouting

return function(p2)
	if communityListRouting.getIsCompactTouch(false) then
		return module.PolicyDependent
	end

	return module.Visible
end
