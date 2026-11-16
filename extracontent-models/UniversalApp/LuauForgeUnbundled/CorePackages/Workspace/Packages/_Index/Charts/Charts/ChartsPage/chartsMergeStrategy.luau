local fFlagSduiChartsRequestPlaceholders = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags").FFlagSduiChartsRequestPlaceholders

require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")

local function hasAnyOverlap(list, items): boolean
	if list == nil or #list == 0 then
		return false
	end

	local set = {}

	for k, item in list do
		set[item] = true
	end

	for k, item in items do
		if set[item] then
			return true
		end
	end

	return false
end

local function chartsMergeStrategy(list, p2, p3): nil | string
	if not fFlagSduiChartsRequestPlaceholders or #list ~= 1 or list[1] ~= "entry_order" then
		return nil
	end

	if hasAnyOverlap(p3, p2) then
		return "replace"
	end

	return "append"
end

return chartsMergeStrategy
