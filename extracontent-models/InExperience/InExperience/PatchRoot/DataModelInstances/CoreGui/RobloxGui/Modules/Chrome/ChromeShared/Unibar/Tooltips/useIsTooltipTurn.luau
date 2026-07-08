local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local TooltipContext = require(script.Parent.TooltipContext)

require(script.Parent.TooltipProvider)

function useIsTooltipTurn(s1: string) -- line: 9
	-- upvalues: React (copy), TooltipContext (copy)
	local v5 = React.useContext(TooltipContext)

	return v5 and v5.isCurrentTooltip(s1)
end

return useIsTooltipTurn
