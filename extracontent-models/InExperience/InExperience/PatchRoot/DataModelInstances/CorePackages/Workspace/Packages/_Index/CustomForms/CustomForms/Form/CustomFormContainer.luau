local parent = script:FindFirstAncestor("CustomForms").Parent
local React = require(parent.React)

local CustomFormView = require(script.Parent.CustomFormView)
local CustomFormSelection = require(script.Parent.CustomFormSelection)
local useCustomFormViewModel = require(script.Parent.useCustomFormViewModel)

local function CustomFormBody(p)
	local v = useCustomFormViewModel(p)
	return React.createElement(CustomFormView, v)
end

local function CustomFormContainer(p)
	local clone = table.clone(p)

	clone.key = `{CustomFormSelection.draftKey(p.definition)}:{p.response ~= nil}`
	return React.createElement(CustomFormBody, clone)
end

return React.memo(CustomFormContainer)
