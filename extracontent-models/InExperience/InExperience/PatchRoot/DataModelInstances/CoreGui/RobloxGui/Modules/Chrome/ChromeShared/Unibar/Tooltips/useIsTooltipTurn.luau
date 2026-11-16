local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local TooltipContext = require(script.Parent.TooltipContext)
require(script.Parent.TooltipProvider)

function useIsTooltipTurn(p: string)
	local v = React.useContext(TooltipContext)

	return v and v.isCurrentTooltip(p)
end

return useIsTooltipTurn
