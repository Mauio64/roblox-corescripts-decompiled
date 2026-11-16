local Foundation = script:FindFirstAncestor("Foundation")
local Constants = require(Foundation.Constants)
require(Foundation.Components.Types)

return function(p, flag: boolean?)
	if flag then
		return {
			Color3 = p.Color3,
			Transparency = 1 - (1 - (p.Transparency or 0)) * Constants.DISABLED_TRANSPARENCY
		}
	end

	return p
end
