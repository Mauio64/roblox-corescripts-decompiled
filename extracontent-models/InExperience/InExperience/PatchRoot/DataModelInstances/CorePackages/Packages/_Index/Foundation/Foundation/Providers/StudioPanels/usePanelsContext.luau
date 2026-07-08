local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local PanelsContext = require(script.Parent.PanelsContext)

require(script.Parent.Types)

local function usePanelsContext() -- line: 11
	-- upvalues: React (copy), PanelsContext (copy)
	local v5 = React.useContext(PanelsContext)

	if v5 == nil then
		error("usePanelsContext must be used within a PanelsContext")
	end

	return v5
end

return usePanelsContext
