local Foundation = script:FindFirstAncestor("Foundation")
require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
require(Foundation.Enums.ThemeName)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.createStyleSheetRules)
local getOverrideAttributes = require(script.Parent.getOverrideAttributes)
local scaleValue = require(Foundation.Utility.scaleValue)

local function updateTokenOverrides(instance, p, p2, p3, p4: number, p5, overrideAttributes)
	local overrideAttributes2 = getOverrideAttributes(p, p2, p3, p5)

	for k, overrideAttribute in overrideAttributes2 do
		if not Flags.FoundationDisableTokenScaling then
			overrideAttribute = scaleValue(overrideAttribute, p4)
		end

		instance:SetAttribute(k, overrideAttribute)

		if overrideAttributes then
			overrideAttributes[k] = overrideAttribute
		end
	end
end

return updateTokenOverrides
