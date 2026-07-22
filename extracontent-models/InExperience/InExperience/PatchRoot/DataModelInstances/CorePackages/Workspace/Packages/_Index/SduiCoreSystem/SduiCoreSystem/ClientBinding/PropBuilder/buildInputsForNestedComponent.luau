local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)

require(SduiCoreSystemParent.Signals)

local FFlagSduiFormatArgFormatters = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFormatArgFormatters
local FFlagSduiClientPageScope = require(SduiCoreSystemParent.SharedFlags).FFlagSduiClientPageScope
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf

local function buildInputsForNestedComponent(p1, t1: {[any]: any}?, p2, p3, t2: {[any]: any}, p4) -- line: 28
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), SduiPropUtils (copy), FFlagSduiClientPageScope (copy), FFlagSduiFormatArgFormatters (copy)
	if t1 then
		for v15, v16 in t1 do
			if v16.kind then
				local type = v16.kind.type

				if type == "binding_path" then
					local value = v16.kind.value
					local v19 = if not FFlagSduiRenderPerf then string.split(value, ".") else splitDottedPath(value)
					local v20, _ = SduiPropUtils.resolveBindingPathValue(p3 or false, v19, p2, p1, nil, false, if not FFlagSduiClientPageScope then nil else p4)

					t2[v15] = v20
				elseif type == "literal" then
					local v22 = v16.kind.value and (v16.kind.value.kind and v16.kind.value.kind.value)

					if v22 == nil then
						error(`Failed to determine value for nested input arg { v15 }`)
					end

					t2[v15] = v22
				elseif type == "translation" then
					if p4 and p4.resolveLocalizedLiteral then
						t2[v15] = p4.resolveLocalizedLiteral(v16.kind.value)
					end
				elseif FFlagSduiFormatArgFormatters and type == "format" then
					local value = v16.kind.value

					t2[v15] = SduiPropUtils.generateFormatStringPropValue(value, p2, p4, p1)(p3 or false).data
				else
					error(`Unrecognized inputDataType for key { v15 }`)
				end
			end
		end
	end
end

return buildInputsForNestedComponent
