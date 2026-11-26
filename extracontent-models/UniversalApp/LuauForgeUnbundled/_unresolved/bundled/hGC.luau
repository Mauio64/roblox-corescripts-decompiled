local module = require("@luauforge/bundled/hGq")
local rodux = module.Rodux
local llama = module.llama

return rodux.createReducer({}, {
	SetUserMembershipType = function(p2, p3)
		return llama.Dictionary.set(p2, p3.userId, p3.membershipType ~= Enum.MembershipType.None)
	end
})
