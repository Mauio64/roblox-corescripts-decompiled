local parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(parent.React)

local AnswerFormView = require(script.Parent.AnswerFormView)
local useAnswerFormViewModel = require(script.Parent.useAnswerFormViewModel)

local function AnswerFormContainer(p)
	local v = useAnswerFormViewModel(p)

	if v == nil then
		return nil
	end

	return React.createElement(AnswerFormView, v)
end

return AnswerFormContainer
