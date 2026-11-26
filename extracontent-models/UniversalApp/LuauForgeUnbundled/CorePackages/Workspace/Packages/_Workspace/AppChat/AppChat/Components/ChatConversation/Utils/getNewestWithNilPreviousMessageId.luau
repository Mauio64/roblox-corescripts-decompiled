local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

return function(p2)
	local v5 = getDeepValue(p2, "keys")
	local v6 = getDeepValue(p2, "values")

	for k, v8 in pairs(v5) do
		if v6[v8] and v6[v8].previousMessageId == nil then
			return v8
		end
	end

	return nil
end
