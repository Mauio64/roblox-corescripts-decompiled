require("@luauforge/bundled/gnE")
local module = require("@luauforge/bundled/gnG")
local module2 = require("@luauforge/bundled/gnH")

local module3 = require("@luauforge/bundled/gnT")
local isStringEmail = module3.Utils.isStringEmail
local isStringPhone = module3.Utils.isStringPhone

function LUAUFORGE_MODULE_GLOBALS_goI_getIdentifierType(p2, p3)
	if p3 or isStringPhone(p2) then
		return module2.Phone
	end

	if isStringEmail(p2) then
		return module2.Email
	end

	return module2.Username
end

function LUAUFORGE_MODULE_GLOBALS_goI_identifierTypeToContactMethodType(p2)
	if p2 == module2.Phone then
		return module.Phone
	end

	return module.Email
end

return {
	getIdentifierType = LUAUFORGE_MODULE_GLOBALS_goI_getIdentifierType,
	identifierTypeToContactMethodType = LUAUFORGE_MODULE_GLOBALS_goI_identifierTypeToContactMethodType,
	formatIdentifier = function(p2, p3, p4)
		if p3 ~= module2.Phone then
			return p2
		end

		if p4 and p4.prefix and p4.prefix ~= "" then
			return "+" .. p4.prefix .. p2
		end

		return p2
	end
}
