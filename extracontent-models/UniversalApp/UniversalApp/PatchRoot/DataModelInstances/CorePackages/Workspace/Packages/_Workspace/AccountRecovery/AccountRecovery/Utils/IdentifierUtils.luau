local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local ContactMethodType = require(AccountRecovery.Enums.ContactMethodType)
local IdentifierType = require(AccountRecovery.Enums.IdentifierType)
local AuthCommon = require(AccountRecoveryParent.AuthCommon)
local isStringEmail = AuthCommon.Utils.isStringEmail
local isStringPhone = AuthCommon.Utils.isStringPhone

function getIdentifierType(s1: string, b1: boolean) -- line: 12
	-- upvalues: isStringPhone (copy), IdentifierType (copy), isStringEmail (copy)
	if b1 or isStringPhone(s1) then
		return IdentifierType.Phone
	end

	if isStringEmail(s1) then
		return IdentifierType.Email
	end

	return IdentifierType.Username
end
function identifierTypeToContactMethodType(p1) -- line: 23
	-- upvalues: IdentifierType (copy), ContactMethodType (copy)
	if p1 == IdentifierType.Phone then
		return ContactMethodType.Phone
	end

	return ContactMethodType.Email
end

return {
	getIdentifierType = getIdentifierType,
	identifierTypeToContactMethodType = identifierTypeToContactMethodType,
	formatIdentifier = function(s2: string, p2, p3) -- line: 33
		-- upvalues: IdentifierType (copy)
		if p2 ~= IdentifierType.Phone then
			return s2
		end

		if not p3 or not p3.prefix or p3.prefix == "" then
			return s2
		end

		return "+" .. p3.prefix .. s2
	end
}
