local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2, p3, p4, p5) -- line: 8
	-- upvalues: ArgCheck (copy), LocalizationService (copy), Cryo (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "name")

	if p4 ~= nil then
		if type(p4) == "number" then
			p4 = tostring(p4)
		end

		if type(p4) ~= "string" then
			p4 = nil
		end
	end

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local t1 = {
		page = p3,
		detail = p4,
		locale = RobloxLocaleId
	}

	if p5 ~= nil then
		t1 = Cryo.Dictionary.join(t1, p5)
	end

	p1:setRBXEventStream(p2, "luaPageLoad", t1)
end
