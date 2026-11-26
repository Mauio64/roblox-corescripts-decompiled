local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/t")

local function validateInterface(p2, p3, p4)
	local v5 = if p4 == nil or p4 then t.interface(p3) else t.strictInterface(p3)
	return v5(p2)
end

return validateInterface
