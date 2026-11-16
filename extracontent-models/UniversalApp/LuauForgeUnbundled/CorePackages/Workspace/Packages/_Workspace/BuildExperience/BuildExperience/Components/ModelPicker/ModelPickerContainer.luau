local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local ModelPickerView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerView")
local useModelPickerViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/useModelPickerViewModel")

local function ModelPickerContainer(p2)
	local v5 = useModelPickerViewModel(p2)
	return React.createElement(ModelPickerView, v5)
end

return ModelPickerContainer
