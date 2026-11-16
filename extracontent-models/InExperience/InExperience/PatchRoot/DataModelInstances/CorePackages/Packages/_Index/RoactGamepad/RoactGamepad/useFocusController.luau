local parent = script.Parent.Parent
local React = require(parent.React)

local FocusContext = require(script.Parent.FocusContext)

local function useFocusController()
	local v = React.useContext(FocusContext)

	return if v then v.focusNode.focusController else nil
end

return useFocusController
