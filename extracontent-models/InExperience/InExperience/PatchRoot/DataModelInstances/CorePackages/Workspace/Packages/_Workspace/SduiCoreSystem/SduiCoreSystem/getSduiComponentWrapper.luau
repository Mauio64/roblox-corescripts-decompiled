local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
require(parent.React)

local SduiComponent = require(SduiCoreSystem.SduiComponent)
local SduiFastPathComponent = require(SduiCoreSystem.SduiFastPathComponent)
local createSduiClientBindingWrappers = require(SduiCoreSystem.ClientBinding.createSduiClientBindingWrappers)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local v = nil

local function fn(data)
	if data and data.__isClientBinding then
		if data.propSignals or data.isComponentFilteredSignal ~= nil or data._requiresDataBinding == true then
			return v.SduiDataBindingWrapper
		end

		return v.SduiClientBindingThinWrapper
	elseif
		data
		and data.__processed
		and data.conditionalProps == nil
		and data.children == nil
		and (data.templateKey == nil or data.templateKey == "NONE")
	then
		return SduiFastPathComponent
	else
		return SduiComponent
	end
end

v = createSduiClientBindingWrappers(fn)

return fn
