local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.DialogSize)

local DialogContext = require(script.Parent.DialogContext)

local function useDialog()
	return React.useContext(DialogContext)
end

return useDialog
