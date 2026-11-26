require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Types")
local function transformJsonLeafFirst(list, callback)
	if type(list) ~= "table" then
		return callback(list)
	end

	local flag = false

	for k, item in pairs(list) do
		if type(k) == "number" then
			flag = true
		else
			flag = false
			break
		end
	end

	if flag then
		local v6 = {}

		for i, item in ipairs(list) do
			local v7 = transformJsonLeafFirst(item, callback)

			if v7 ~= nil then
				table.insert(v6, v7)
			end
		end

		return callback(v6)
	else
		local v6 = {}

		for k, item in pairs(list) do
			v6[k] = transformJsonLeafFirst(item, callback)
		end

		return callback(v6)
	end
end

return transformJsonLeafFirst
