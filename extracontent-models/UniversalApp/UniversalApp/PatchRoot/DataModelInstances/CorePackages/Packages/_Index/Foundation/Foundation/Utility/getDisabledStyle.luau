local Foundation = script:FindFirstAncestor("Foundation")
local Constants = require(Foundation.Constants)

require(Foundation.Components.Types)

return function(p1, b1: boolean?) -- line: 6
	-- upvalues: Constants (copy)
	if not b1 then
		return p1
	end

	return {
		Color3 = p1.Color3,
		Transparency = 1 - (1 - (p1.Transparency or 0)) * Constants.DISABLED_TRANSPARENCY
	}
end
