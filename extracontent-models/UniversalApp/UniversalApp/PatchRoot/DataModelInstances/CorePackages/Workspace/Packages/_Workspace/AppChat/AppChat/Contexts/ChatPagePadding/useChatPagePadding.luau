local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Context = require(script.Parent.Context)

local function useChatPagePadding() -- line: 7
	-- upvalues: React (copy), Context (copy)
	return React.useContext(Context)
end

return useChatPagePadding
