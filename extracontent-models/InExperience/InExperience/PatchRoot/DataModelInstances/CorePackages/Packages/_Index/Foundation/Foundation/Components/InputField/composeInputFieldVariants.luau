local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.InputSize)

local InputVariant = require(Foundation.Enums.InputVariant)

require(Foundation.Enums.Radius)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local getInputVariantsFactory = require(script.Parent.getInputVariantsFactory)

require(Foundation.Providers.Style.Tokens)

local function composeInputFieldVariants(p1, p2, p3, p4, b1: boolean?, b2: boolean?, b3: boolean?) -- line: 22
	-- upvalues: getInputVariantsFactory (copy), InputVariant (copy), composeStyleVariant (copy)
	local v13 = getInputVariantsFactory(p1)
	local v14 = v13.variants[p3 or InputVariant.Standard]

	return composeStyleVariant(v13.common, v13.sizes[p2], if p3 == InputVariant.Utility then {} else v14, if not p4 then v13.defaultRadius[p2] else v13.radius[p4], if b2 == nil then {} else v13.hoverState[b2], if b1 == nil then {} else v13.focusedState[b1], if b3 == nil then {} else v13.errorState[b3], if p3 ~= InputVariant.Utility then {} else v14)
end

return composeInputFieldVariants
