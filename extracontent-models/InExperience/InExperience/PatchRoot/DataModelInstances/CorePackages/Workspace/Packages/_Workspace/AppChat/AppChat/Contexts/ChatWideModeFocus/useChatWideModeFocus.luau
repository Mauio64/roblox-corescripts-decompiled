local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local Context = require(script.Parent.Context)

local function useChatWideModeFocus()
	return React.useContext(Context)
end

return useChatWideModeFocus
