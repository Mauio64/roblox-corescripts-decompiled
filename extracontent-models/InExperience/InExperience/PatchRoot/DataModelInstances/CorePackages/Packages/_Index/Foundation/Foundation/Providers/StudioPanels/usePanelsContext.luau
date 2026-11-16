local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local PanelsContext = require(script.Parent.PanelsContext)
require(script.Parent.Types)

local function usePanelsContext()
	local v = React.useContext(PanelsContext)

	if v == nil then
		error("usePanelsContext must be used within a PanelsContext")
	end

	return v
end

return usePanelsContext
