local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.React)

local SduiComponent = require(SduiCoreSystem.SduiComponent)
local SduiFastPathComponent = require(SduiCoreSystem.SduiFastPathComponent)
local createSduiClientBindingWrappers = require(SduiCoreSystem.ClientBinding.createSduiClientBindingWrappers)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local FFlagSduiPoolBackedFeed = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPoolBackedFeed
local u7 = nil

local function v8(p1) -- line: 32
	-- upvalues: FFlagSduiPoolBackedFeed (copy), u7 (ref), SduiFastPathComponent (copy), SduiComponent (copy)
	if p1 and p1.__isClientBinding then
		if p1.propSignals or p1.isComponentFilteredSignal ~= nil or FFlagSduiPoolBackedFeed and p1._requiresDataBinding == true then
			return u7.SduiDataBindingWrapper
		end

		return u7.SduiClientBindingThinWrapper
	end

	if p1 and p1.__processed and p1.conditionalProps == nil and p1.children == nil and (p1.templateKey == nil or p1.templateKey == "NONE") then
		return SduiFastPathComponent
	end

	return SduiComponent
end

u7 = createSduiClientBindingWrappers(v8)

return v8
