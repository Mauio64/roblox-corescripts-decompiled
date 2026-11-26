require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

local SduiComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponent")
local SduiFastPathComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiFastPathComponent")
local createSduiClientBindingWrappers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/createSduiClientBindingWrappers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")

local v5 = nil

local function fn(data)
	if data and data.__isClientBinding then
		if
			data.propSignals
			or data.isComponentFilteredSignal ~= nil
			or data._requiresDataBinding == true
		then
			return v5.SduiDataBindingWrapper
		end

		return v5.SduiClientBindingThinWrapper
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

v5 = createSduiClientBindingWrappers(fn)

return fn
