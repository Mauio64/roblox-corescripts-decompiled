local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

local GeneratedTextFeedbackView = require(script.Parent.GeneratedTextFeedbackView)
local useGeneratedTextFeedbackViewModel = require(script.Parent.useGeneratedTextFeedbackViewModel)

local function GeneratedTextFeedbackContainer(p)
	local v = useGeneratedTextFeedbackViewModel(p)
	return React.createElement(GeneratedTextFeedbackView, v)
end

return GeneratedTextFeedbackContainer
