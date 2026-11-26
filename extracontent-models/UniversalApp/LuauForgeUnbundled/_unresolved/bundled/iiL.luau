local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzO")
local Cryo = require(CorePackages.Packages.Cryo)

local module2 = require("@luauforge/bundled/iiM")

return function(object, p2, p3, value, p4)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "name")
	local v5 = module2()
	local flag

	if v5 and #v5 > 0 then
		local flag2 = true

		for k, v6 in string.split(v5, ",") do
			if v6 == p3 then
				flag = true
				flag2 = false
				break
			end
		end

		if flag2 then
			flag = false
		end
	else
		flag = false
	end

	if flag then
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

		if p4 then
			joined = Cryo.Dictionary.join(joined, p4)
		end

		object:setRBXEventStream(p2, "luaPageUnload", joined)
	end
end
