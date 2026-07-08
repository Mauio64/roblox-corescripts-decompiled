local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Device)

local Flags = require(Foundation.Utility.Flags)

require(Foundation.Enums.Theme)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.createStyleSheetRules)

local getOverrideAttributes = require(script.Parent.getOverrideAttributes)
local scaleValue = require(Foundation.Utility.scaleValue)

local function updateTokenOverrides(p1, p2, p3, n1: number, p4, p5) -- line: 15
	-- upvalues: getOverrideAttributes (copy), Flags (copy), scaleValue (copy)
	for v12, v13 in (getOverrideAttributes(p2, p3, p4)) do
		local v14 = if not Flags.FoundationDisableTokenScaling then scaleValue(v13, n1) else v13

		p1:SetAttribute(v12, v14)

		if p5 then
			p5[v12] = v14
		end
	end
end

return updateTokenOverrides
