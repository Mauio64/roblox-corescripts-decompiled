local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)

local buildRepeatedProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildRepeatedProp)
local buildTableProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildTableProp)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory

local function isArrayLike(list): boolean -- 1 equivalent call inferred from this helper
	local count = #list
	return count > 0 and next(list, count) == nil
end

local function buildContainerProp(_, array, p, p2, p3, p4)
	if next(array) == nil then
		return array, PropResultCategory.Literal
	end

	if isArrayLike(array) then -- inferred equivalent call
		return buildRepeatedProp("literal", { array = array }, p, p2, p3, p4)
	end

	return buildTableProp("literal", array, p, p2, p3, p4)
end

return buildContainerProp
