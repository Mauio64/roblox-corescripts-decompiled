local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnswersCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnswersCardView")
local useAnswersCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/useAnswersCardViewModel")

local function AnswersCardContainer(p2)
	local v5 = useAnswersCardViewModel(p2)
	return React.createElement(AnswersCardView, v5)
end

return AnswersCardContainer
