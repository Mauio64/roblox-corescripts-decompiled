local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local FocusContext = require(script.Parent.FocusContext)

local function useFocusController() -- line: 10
	-- upvalues: React (copy), FocusContext (copy)
	local v5 = React.useContext(FocusContext)

	if v5 then
		return v5.focusNode.focusController
	end

	return nil
end

return useFocusController
