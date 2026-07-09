local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AdjustmentDataEventsContext = require(script.Parent.AdjustmentDataEventsContext)

local function useAdjustmentDataEventsContext() -- line: 7
	-- upvalues: React (copy), AdjustmentDataEventsContext (copy)
	return React.useContext(AdjustmentDataEventsContext)
end

return useAdjustmentDataEventsContext
