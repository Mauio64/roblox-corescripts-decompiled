local parent = script.Parent.Parent
local React = require(parent.React)

local FocusController = require(script.Parent.FocusController)

local function useRootFocusController()
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = FocusController.createPublicApiWrapper()
	end

	return ref.current
end

return useRootFocusController
