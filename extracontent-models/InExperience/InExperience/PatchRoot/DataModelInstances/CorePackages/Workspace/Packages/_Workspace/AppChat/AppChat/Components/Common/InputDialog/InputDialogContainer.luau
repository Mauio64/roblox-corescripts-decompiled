local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local InputDialogView = require(script.Parent.InputDialogView)
local useInputDialogViewModel = require(script.Parent.useInputDialogViewModel)

local function InputDialogContainer(p)
	local v = useInputDialogViewModel(p)
	return React.createElement(InputDialogView, v)
end

return InputDialogContainer
