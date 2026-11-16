local parent = script:FindFirstAncestor("Charts").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders

require(parent.SduiSharedUtilities)

local function hasAnyOverlap(list, items): boolean
	if list == nil or #list == 0 then
		return false
	end

	local set = {}

	for _, item in list do
		set[item] = true
	end

	for _, item in items do
		if set[item] then
			return true
		end
	end

	return false
end

local function chartsMergeStrategy(list, p, p2): nil | string
	if not FFlagSduiChartsRequestPlaceholders or #list ~= 1 or list[1] ~= "entry_order" then
		return nil
	end

	return if hasAnyOverlap(p2, p) then "replace" else "append"
end

return chartsMergeStrategy
