local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local FocusController = require(script.Parent.FocusController)

local function useRootFocusController() -- line: 19
	-- upvalues: React (copy), FocusController (copy)
	local v5 = React.useRef(nil)

	if v5.current == nil then
		v5.current = FocusController.createPublicApiWrapper()
	end

	return v5.current
end

return useRootFocusController
