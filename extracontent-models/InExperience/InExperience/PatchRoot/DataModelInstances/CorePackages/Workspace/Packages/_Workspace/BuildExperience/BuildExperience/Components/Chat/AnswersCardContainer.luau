local parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(parent.React)

local AnswersCardView = require(script.Parent.AnswersCardView)
local useAnswersCardViewModel = require(script.Parent.useAnswersCardViewModel)

local function AnswersCardContainer(p)
	local v = useAnswersCardViewModel(p)
	return React.createElement(AnswersCardView, v)
end

return AnswersCardContainer
