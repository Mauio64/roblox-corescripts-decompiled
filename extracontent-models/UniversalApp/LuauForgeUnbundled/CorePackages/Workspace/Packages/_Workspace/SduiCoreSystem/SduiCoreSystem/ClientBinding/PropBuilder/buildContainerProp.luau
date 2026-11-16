require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local buildRepeatedProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildRepeatedProp")
local buildTableProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildTableProp")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory

local function isArrayLike(list): boolean
	local count = #list
	return count > 0 and next(list, count) == nil
end

local function buildContainerProp(p2, list, p3, p4, p5, p6)
	if next(list) == nil then
		return list, propResultCategory.Literal
	end

	local count = #list
	local v5 = count > 0 and next(list, count) == nil

	if v5 then
		return buildRepeatedProp("literal", { array = list }, p3, p4, p5, p6)
	end

	return buildTableProp("literal", list, p3, p4, p5, p6)
end

return buildContainerProp
