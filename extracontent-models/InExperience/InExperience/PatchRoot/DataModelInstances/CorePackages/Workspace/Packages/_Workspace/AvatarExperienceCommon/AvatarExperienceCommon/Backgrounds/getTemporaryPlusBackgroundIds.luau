local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FStringAXPlusExclusiveBackgroundIds = AvatarExperienceFlags.FStringAXPlusExclusiveBackgroundIds

local v = nil
local frozen = table.freeze({})
local v2 = false

local function isNumericId(value: string): boolean -- 1 equivalent call inferred from this helper
	return string.match(value, "^%d+$") ~= nil
end

local function getTemporaryPlusBackgroundIds()
	local fStringAXPlusExclusiveBackgroundIds = FStringAXPlusExclusiveBackgroundIds()

	if fStringAXPlusExclusiveBackgroundIds == v then
		return frozen, v2
	end

	v = fStringAXPlusExclusiveBackgroundIds

	if string.gsub(fStringAXPlusExclusiveBackgroundIds, "^%s*(.-)%s*$", "%1") == "" then
		v2 = false
		frozen = table.freeze({})
		return frozen, v2
	elseif string.find(fStringAXPlusExclusiveBackgroundIds, "[;|]") == nil then
		local set = {}

		for _, v3 in string.split(fStringAXPlusExclusiveBackgroundIds, ",") do
			local v4 = string.gsub(v3, "^%s*(.-)%s*$", "%1")

			if v4 == "" then
				continue
			end

			if isNumericId(v4) then -- inferred equivalent call
				set[v4] = true
			else
				v2 = true
				frozen = table.freeze({})
				return frozen, v2
			end
		end

		v2 = false
		frozen = table.freeze(set)
		return frozen, v2
	else
		v2 = true
		frozen = table.freeze({})
		return frozen, v2
	end
end

return getTemporaryPlusBackgroundIds
