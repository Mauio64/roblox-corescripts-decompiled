local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fsI")

local function useTopBarSearchSignal()
	local v5 = React.useContext(module.Context)

	if v5 then
		return v5
	end

	return nil
end

return useTopBarSearchSignal
