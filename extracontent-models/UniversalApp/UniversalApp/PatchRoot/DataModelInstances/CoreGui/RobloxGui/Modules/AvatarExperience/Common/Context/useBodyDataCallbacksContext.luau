local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BodyDataCallbacksContext = require(script.Parent.BodyDataCallbacksContext)

local function useBodyDataCallbacksContext() -- line: 7
	-- upvalues: React (copy), BodyDataCallbacksContext (copy)
	return React.useContext(BodyDataCallbacksContext)
end

return useBodyDataCallbacksContext
