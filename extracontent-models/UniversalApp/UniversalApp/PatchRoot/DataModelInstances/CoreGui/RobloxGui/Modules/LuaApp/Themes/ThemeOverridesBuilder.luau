local CorePackages = game:GetService("CorePackages")
local Theme = require(CorePackages.Packages.Foundation).Enums.Theme

local function buildOverrides(p1, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 22
	-- upvalues: Theme (copy)
	local v8 = p1 == Theme.Dark
	local t4 = {}

	for v10, v11 in t1 do
		t4["Color." .. v10] = v11
		t4[if not v8 then "LightMode." .. v10 else "DarkMode." .. v10] = v11
	end

	for v12, v13 in t2 do
		t4["Inverse." .. v12] = v13
		t4[if not v8 then "DarkMode." .. v12 else "LightMode." .. v12] = v13
	end

	for v14, v15 in t3 do
		t4[v14] = v15
	end

	return t4
end

return buildOverrides
