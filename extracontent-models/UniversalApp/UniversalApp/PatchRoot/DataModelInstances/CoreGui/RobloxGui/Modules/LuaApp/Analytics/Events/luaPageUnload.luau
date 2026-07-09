local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local GetFStringLuaAppUnloadEventEnabledPageNames = require(Modules.LuaApp.Flags.GetFStringLuaAppUnloadEventEnabledPageNames)

return function(p1, p2, p3, p4, p5) -- line: 23
	-- upvalues: ArgCheck (copy), GetFStringLuaAppUnloadEventEnabledPageNames (copy), LocalizationService (copy), Cryo (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "name")

	local v16 = GetFStringLuaAppUnloadEventEnabledPageNames()
	local g20 = nil
	local v19 = nil

	if v16 and #v16 > 0 then
		for _, v18 in string.split(v16, ",") do
			if v18 == p3 then
				v19 = true
				g20 = true
			end

			if g20 then
				break
			end
		end
	end

	if not g20 then
		v19 = false
	end

	g20 = false

	if v19 then
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

		if p5 then
			t1 = Cryo.Dictionary.join(t1, p5)
		end

		p1:setRBXEventStream(p2, "luaPageUnload", t1)
	end
end
