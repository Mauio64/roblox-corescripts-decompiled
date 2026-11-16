local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local TextInput = Foundation.TextInput
local View = Foundation.View

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function TextQuestion(props)
	local onAnswerChanged = props.onAnswerChanged
	local onChanged = React.useCallback(function(text: string)
		onAnswerChanged({ text = text })
	end, { onAnswerChanged })

	return React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder }, {
		Input = React.createElement(TextInput, {
			text = props.answer.text or "",
			label = "",
			width = UDim.new(1, 0),
			isDisabled = props.isDisabled,
			onChanged = onChanged
		})
	})
end

return React.memo(TextQuestion)
