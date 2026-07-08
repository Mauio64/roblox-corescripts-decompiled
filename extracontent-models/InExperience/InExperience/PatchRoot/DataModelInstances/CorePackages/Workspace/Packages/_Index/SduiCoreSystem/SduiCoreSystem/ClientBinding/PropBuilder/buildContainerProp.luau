local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)

local buildRepeatedProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildRepeatedProp)
local buildTableProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildTableProp)

require(SduiCoreSystem.SduiBuilderTypes)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory

local function isArrayLike(t1: {[any]: any}) -- line: 21
	local v9 = #t1

	return v9 > 0 and next(t1, v9) == nil
end
local function buildContainerProp(_, p2, p3, p4, p5, p6) -- line: 26
	-- upvalues: PropResultCategory (copy), buildRepeatedProp (copy), buildTableProp (copy)
	if next(p2) == nil then
		return p2, PropResultCategory.Literal
	end

	local v16 = #p2

	if v16 > 0 and next(p2, v16) == nil then
		return buildRepeatedProp("literal", {
			array = p2
		}, p3, p4, p5, p6)
	end

	return buildTableProp("literal", p2, p3, p4, p5, p6)
end

return buildContainerProp
