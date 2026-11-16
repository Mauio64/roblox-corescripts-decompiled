local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
require(Foundation.Enums.ThemeName)
local getGeneratedRules = require(Foundation.Utility.getGeneratedRules)

local function useGeneratedRules(p, p2, p3)
	return React.useMemo(function()
		return getGeneratedRules(p, p2, p3)
	end, { p, p2, p3 })
end

return useGeneratedRules
