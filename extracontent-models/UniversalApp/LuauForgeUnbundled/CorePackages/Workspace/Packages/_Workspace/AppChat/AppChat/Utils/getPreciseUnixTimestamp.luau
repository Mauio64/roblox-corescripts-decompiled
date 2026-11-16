local parseIsoDateUnixMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/parseIsoDateUnixMillis")

local function getPreciseUnixTimestamp(value)
	if typeof(value) == "DateTime" then
		return value.UnixTimestampMillis / 1000
	end

	if type(value) == "string" then
		local v5 = parseIsoDateUnixMillis(value)

		if v5 == nil then
			return nil
		end

		return v5 / 1000
	elseif type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	else
		return nil
	end
end

return getPreciseUnixTimestamp
