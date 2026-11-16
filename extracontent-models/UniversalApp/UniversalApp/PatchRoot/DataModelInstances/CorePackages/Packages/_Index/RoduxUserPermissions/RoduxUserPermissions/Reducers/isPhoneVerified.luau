local parent = script.Parent.Parent.Parent
local Rodux = require(parent.Rodux)

return function(p)
	local networkingAccountInformation = p.networkingAccountInformation

	return Rodux.createReducer(false, {
		[networkingAccountInformation.GetPhoneInformation.Succeeded.name] = function(_, p2)
			return p2.responseBody and p2.responseBody.isVerified
		end
	})
end
