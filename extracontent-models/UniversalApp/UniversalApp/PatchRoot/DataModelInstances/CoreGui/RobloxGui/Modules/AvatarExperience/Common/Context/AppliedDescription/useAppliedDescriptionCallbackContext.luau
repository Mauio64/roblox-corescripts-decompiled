local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppliedDescriptionCallbackContext = require(script.Parent.AppliedDescriptionCallbackContext)

local function useAppliedDescriptionCallbackContext() -- line: 7
	-- upvalues: React (copy), AppliedDescriptionCallbackContext (copy)
	return React.useContext(AppliedDescriptionCallbackContext)
end

return useAppliedDescriptionCallbackContext
