local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local textInput = Foundation.TextInput
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local function TextQuestion(props)
	local onAnswerChanged = props.onAnswerChanged
	local v5 = React.useCallback(function(p2)
		onAnswerChanged({ text = p2 })
	end, { onAnswerChanged })

	return React.createElement(view, {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}, {
		Input = React.createElement(textInput, {
			text = props.answer.text or "",
			label = "",
			width = UDim.new(1, 0),
			isDisabled = props.isDisabled,
			onChanged = v5
		})
	})
end

return React.memo(TextQuestion)
