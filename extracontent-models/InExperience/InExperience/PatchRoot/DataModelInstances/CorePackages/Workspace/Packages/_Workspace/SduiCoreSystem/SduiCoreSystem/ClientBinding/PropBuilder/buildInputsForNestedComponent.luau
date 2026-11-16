local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)

require(parent.Signals)

local function buildInputsForNestedComponent(p, items, p2, p3, p4, p5)
	if items then
		for k, item in items do
			if not item.kind then
				continue
			end

			local kind = item.kind.type

			if kind == "binding_path" then
				local v = splitDottedPath(item.kind.value)
				local bindingPathValue, _ = SduiPropUtils.resolveBindingPathValue(p3 or false, v, p2, p, nil, false, p5)

				p4[k] = bindingPathValue
			elseif kind == "literal" then
				local value = item.kind.value and item.kind.value.kind and item.kind.value.kind.value

				if value == nil then
					error(`Failed to determine value for nested input arg {k}`)
				end

				p4[k] = value
			elseif kind == "translation" then
				if p5 and p5.resolveLocalizedLiteral then
					local resolveLocalizedLiteral = p5.resolveLocalizedLiteral
					local value = item.kind.value
					local v

					if FFlagSduiErrorPaths then
						v = p5.errorContext
					end

					p4[k] = resolveLocalizedLiteral(value, v)
				end
			elseif kind == "format" then
				local value = item.kind.value
				p4[k] = SduiPropUtils.generateFormatStringPropValue(value, p2, p5, p)(p3 or false).data
			else
				error(`Unrecognized inputDataType for key {k}`)
			end
		end
	end
end

return buildInputsForNestedComponent
