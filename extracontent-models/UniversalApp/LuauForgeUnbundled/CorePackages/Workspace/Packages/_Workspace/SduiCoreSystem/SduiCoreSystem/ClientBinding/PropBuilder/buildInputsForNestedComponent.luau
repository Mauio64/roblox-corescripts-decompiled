local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local splitDottedPath = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/splitDottedPath")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local function buildInputsForNestedComponent(p2, items, p3, p4, p5, p6)
	if items then
		for k, item in items do
			if not item.kind then
				continue
			end

			local kind = item.kind.type

			if kind == "binding_path" then
				local v5 = splitDottedPath(item.kind.value)
				local bindingPathValue, v6 = SduiPropUtils.resolveBindingPathValue(
					p4 or false,
					v5,
					p3,
					p2,
					nil,
					false,
					p6
				)

				p5[k] = bindingPathValue
			elseif kind == "literal" then
				local value = item.kind.value and item.kind.value.kind and item.kind.value.kind.value

				if value == nil then
					error(`Failed to determine value for nested input arg {k}`)
				end

				p5[k] = value
			elseif kind == "translation" then
				if p6 and p6.resolveLocalizedLiteral then
					local resolveLocalizedLiteral = p6.resolveLocalizedLiteral
					local value = item.kind.value
					local v5 = if fFlagSduiErrorPaths then p6.errorContext else nil
					p5[k] = resolveLocalizedLiteral(value, v5)
				end
			elseif kind == "format" then
				local value = item.kind.value
				p5[k] = SduiPropUtils.generateFormatStringPropValue(value, p3, p6, p2)(p4 or false).data
			else
				error(`Unrecognized inputDataType for key {k}`)
			end
		end
	end
end

return buildInputsForNestedComponent
