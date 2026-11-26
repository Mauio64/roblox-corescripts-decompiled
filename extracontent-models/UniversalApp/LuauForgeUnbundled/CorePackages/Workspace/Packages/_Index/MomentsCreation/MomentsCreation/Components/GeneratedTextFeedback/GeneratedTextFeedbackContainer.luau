local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local GeneratedTextFeedbackView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/GeneratedTextFeedback/GeneratedTextFeedbackView")
local useGeneratedTextFeedbackViewModel = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/GeneratedTextFeedback/useGeneratedTextFeedbackViewModel")

local function GeneratedTextFeedbackContainer(p2)
	local v5 = useGeneratedTextFeedbackViewModel(p2)
	return React.createElement(GeneratedTextFeedbackView, v5)
end

return GeneratedTextFeedbackContainer
