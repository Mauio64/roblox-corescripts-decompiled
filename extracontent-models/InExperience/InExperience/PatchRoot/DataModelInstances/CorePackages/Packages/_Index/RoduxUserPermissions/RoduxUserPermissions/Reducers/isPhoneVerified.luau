local ParentParent = script.Parent.Parent.Parent
local Rodux = require(ParentParent.Rodux)

return function(p1) -- line: 7
	-- upvalues: Rodux (copy)
	local networkingAccountInformation = p1.networkingAccountInformation

	return Rodux.createReducer(false, {
		[networkingAccountInformation.GetPhoneInformation.Succeeded.name] = function(_, p3) -- line: 11
			return p3.responseBody and p3.responseBody.isVerified
		end
	})
end
