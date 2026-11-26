local fStringAXPlusExclusiveBackgroundIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FStringAXPlusExclusiveBackgroundIds

local v5 = nil
local frozen = table.freeze({})
local v6 = false

local function isNumericId(value): boolean
	return string.match(value, "^%d+$") ~= nil
end

local function getTemporaryPlusBackgroundIds()
	local v7 = fStringAXPlusExclusiveBackgroundIds()

	if v7 == v5 then
		return frozen, v6
	end

	v5 = v7

	if string.gsub(v7, "^%s*(.-)%s*$", "%1") == "" then
		v6 = false
		frozen = table.freeze({})
		return frozen, v6
	elseif string.find(v7, "[;|]") == nil then
		local set = {}

		for k, v8 in string.split(v7, ",") do
			local v9 = string.gsub(v8, "^%s*(.-)%s*$", "%1")

			if v9 == "" then
				continue
			end

			if string.match(v9, "^%d+$") ~= nil then
				set[v9] = true
			else
				v6 = true
				frozen = table.freeze({})
				return frozen, v6
			end
		end

		v6 = false
		frozen = table.freeze(set)
		return frozen, v6
	else
		v6 = true
		frozen = table.freeze({})
		return frozen, v6
	end
end

return getTemporaryPlusBackgroundIds
