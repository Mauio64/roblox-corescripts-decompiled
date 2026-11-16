local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Types)
local function transformJsonLeafFirst(list, callback)
	if type(list) ~= "table" then
		return callback(list)
	end

	local flag = false

	for k, _ in pairs(list) do
		if type(k) == "number" then
			flag = true
		else
			flag = false
			break
		end
	end

	if flag then
		local v = {}

		for _, item in ipairs(list) do
			local v2 = transformJsonLeafFirst(item, callback)

			if v2 ~= nil then
				table.insert(v, v2)
			end
		end

		return callback(v)
	else
		local v = {}

		for k, item in pairs(list) do
			v[k] = transformJsonLeafFirst(item, callback)
		end

		return callback(v)
	end
end

return transformJsonLeafFirst
