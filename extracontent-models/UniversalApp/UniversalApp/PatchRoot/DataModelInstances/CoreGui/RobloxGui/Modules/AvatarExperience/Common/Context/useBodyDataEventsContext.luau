local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BodyDataEventsContext = require(script.Parent.BodyDataEventsContext)

local function useBodyDataEventsContext() -- line: 7
	-- upvalues: React (copy), BodyDataEventsContext (copy)
	return React.useContext(BodyDataEventsContext)
end

return useBodyDataEventsContext
