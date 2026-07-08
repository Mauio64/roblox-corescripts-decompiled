local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.DialogSize)

local DialogContext = require(script.Parent.DialogContext)

local function useDialog() -- line: 23
	-- upvalues: React (copy), DialogContext (copy)
	return React.useContext(DialogContext)
end

return useDialog
