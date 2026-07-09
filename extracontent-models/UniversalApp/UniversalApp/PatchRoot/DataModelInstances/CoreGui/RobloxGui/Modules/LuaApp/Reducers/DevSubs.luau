local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local SetDevSubs = require(Modules.LuaApp.Actions.SetDevSubs)
local SetDevSub = require(Modules.LuaApp.Actions.SetDevSub)

return function(p1, p2) -- line: 8
	-- upvalues: SetDevSubs (copy), Cryo (copy), SetDevSub (copy)
	local v8 = p1 or {}

	if p2.type == SetDevSubs.name then
		return (Cryo.List.join({}, p2.devSubs))
	end

	if p2.type == SetDevSub.name then
		local t1 = {}

		for _, v in pairs(v8) do
			if v.id == p2.devSub.id then
				table.insert(t1, p2.devSub)
			else
				table.insert(t1, v)
			end
		end

		v8 = t1
	end

	return v8
end
