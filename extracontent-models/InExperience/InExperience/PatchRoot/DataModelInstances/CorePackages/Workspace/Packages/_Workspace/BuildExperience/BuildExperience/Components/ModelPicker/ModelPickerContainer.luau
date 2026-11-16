local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
require(script.Parent.ModelPickerTypes)
local ModelPickerView = require(script.Parent.ModelPickerView)
local useModelPickerViewModel = require(script.Parent.useModelPickerViewModel)

local function ModelPickerContainer(p)
	local v = useModelPickerViewModel(p)
	return React.createElement(ModelPickerView, v)
end

return ModelPickerContainer
