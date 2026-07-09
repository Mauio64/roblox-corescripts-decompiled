local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppliedDescriptionValueContext = require(script.Parent.AppliedDescriptionValueContext)

local function useAppliedDescriptionValueContext() -- line: 7
	-- upvalues: React (copy), AppliedDescriptionValueContext (copy)
	return React.useContext(AppliedDescriptionValueContext)
end

return useAppliedDescriptionValueContext
