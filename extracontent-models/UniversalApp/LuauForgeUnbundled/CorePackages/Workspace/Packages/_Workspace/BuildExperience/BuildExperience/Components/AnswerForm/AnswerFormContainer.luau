local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnswerFormView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerForm/AnswerFormView")
local useAnswerFormViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerForm/useAnswerFormViewModel")

local function AnswerFormContainer(p2)
	local v5 = useAnswerFormViewModel(p2)

	if v5 == nil then
		return nil
	end

	return React.createElement(AnswerFormView, v5)
end

return AnswerFormContainer
