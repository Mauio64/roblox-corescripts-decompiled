local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dwM")

return function(object, p2, p3, value, p4)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "name")

	if value ~= nil then
		if type(value) == "number" then
			value = tostring(value)
		end

		if type(value) ~= "string" then
			value = nil
		end
	end

	local joined = {
		page = p3,
		detail = value,
		locale = LocalizationService.RobloxLocaleId
	}

	if p4 ~= nil then
		joined = Cryo.Dictionary.join(joined, p4)
	end

	object:setRBXEventStream(p2, "luaPageLoad", joined)
end
