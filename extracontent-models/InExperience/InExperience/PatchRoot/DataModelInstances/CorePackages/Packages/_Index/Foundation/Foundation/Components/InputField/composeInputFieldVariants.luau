local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.InputSize)

local InputVariant = require(Foundation.Enums.InputVariant)

require(Foundation.Enums.Radius)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local getInputVariantsFactory = require(script.Parent.getInputVariantsFactory)

require(Foundation.Providers.Style.Tokens)

local function composeInputFieldVariants(p, p2, p3, p4, flag: boolean?, flag2: boolean?, flag3: boolean?)
	local inputVariantsFactory = getInputVariantsFactory(p)
	local variant = inputVariantsFactory.variants[p3 or InputVariant.Standard]

	local common = inputVariantsFactory.common
	local siz = inputVariantsFactory.sizes[p2]
	local v = p3 == InputVariant.Utility and {} or variant
	local v2

	if p4 then
		v2 = inputVariantsFactory.radius[p4]
	else
		v2 = inputVariantsFactory.defaultRadius[p2]
	end

	return composeStyleVariant(
		common,
		siz,
		v,
		v2,
		flag2 == nil and {} or inputVariantsFactory.hoverState[flag2],
		flag == nil and {} or inputVariantsFactory.focusedState[flag],
		flag3 == nil and {} or inputVariantsFactory.errorState[flag3],
		p3 ~= InputVariant.Utility and {} or variant
	)
end

return composeInputFieldVariants
