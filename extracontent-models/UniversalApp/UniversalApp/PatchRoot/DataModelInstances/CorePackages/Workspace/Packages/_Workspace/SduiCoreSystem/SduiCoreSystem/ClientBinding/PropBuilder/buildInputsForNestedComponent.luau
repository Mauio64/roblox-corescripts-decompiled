local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)

require(SduiCoreSystemParent.Signals)

local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiFormatArgFormatters = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFormatArgFormatters
local FFlagSduiClientPageScope = require(SduiCoreSystemParent.SharedFlags).FFlagSduiClientPageScope
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf

local function buildInputsForNestedComponent(p1, t1: {[any]: any}?, p2, p3, t2: {[any]: any}, p4) -- line: 29
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), SduiPropUtils (copy), FFlagSduiClientPageScope (copy), FFlagSduiLocalizedLiterals (copy), FFlagSduiFormatArgFormatters (copy)
	if t1 then
		for v16, v17 in t1 do
			if v17.kind then
				local type = v17.kind.type

				if type == "binding_path" then
					local value = v17.kind.value
					local v20 = if not FFlagSduiRenderPerf then string.split(value, ".") else splitDottedPath(value)
					local v21, _ = SduiPropUtils.resolveBindingPathValue(p3 or false, v20, p2, p1, nil, false, if not FFlagSduiClientPageScope then nil else p4)

					t2[v16] = v21
				elseif type == "literal" then
					local v23 = v17.kind.value and (v17.kind.value.kind and v17.kind.value.kind.value)

					if v23 == nil then
						error(`Failed to determine value for nested input arg { v16 }`)
					end

					t2[v16] = v23
				elseif FFlagSduiLocalizedLiterals and type == "translation" then
					if p4 and p4.resolveLocalizedLiteral then
						t2[v16] = p4.resolveLocalizedLiteral(v17.kind.value)
					end
				elseif FFlagSduiFormatArgFormatters and type == "format" then
					local value = v17.kind.value

					t2[v16] = SduiPropUtils.generateFormatStringPropValue(value, p2, p4, p1)(p3 or false).data
				else
					error(`Unrecognized inputDataType for key { v16 }`)
				end
			end
		end
	end
end

return buildInputsForNestedComponent
