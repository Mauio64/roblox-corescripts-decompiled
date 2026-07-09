local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AdjustmentDataCallbacksContext = require(script.Parent.AdjustmentDataCallbacksContext)

local function useAdjustmentDataCallbacksContext() -- line: 7
	-- upvalues: React (copy), AdjustmentDataCallbacksContext (copy)
	return (React.useContext(AdjustmentDataCallbacksContext))
end

return useAdjustmentDataCallbacksContext
