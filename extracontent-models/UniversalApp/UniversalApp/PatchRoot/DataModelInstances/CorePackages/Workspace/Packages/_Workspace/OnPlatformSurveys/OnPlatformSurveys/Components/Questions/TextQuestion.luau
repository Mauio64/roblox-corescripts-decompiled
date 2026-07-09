local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local TextInput = Foundation.TextInput
local View = Foundation.View

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function TextQuestion(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), View (copy), TextInput (copy)
	local onAnswerChanged = t1.onAnswerChanged
	local v10 = React.useCallback(function(s1: string) -- line: 23
		-- upvalues: onAnswerChanged (copy)
		onAnswerChanged({
			text = s1
		})
	end, { onAnswerChanged })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		Input = React.createElement(TextInput, {
			label = "",
			text = t1.answer.text or "",
			width = UDim.new(1, 0),
			isDisabled = t1.isDisabled,
			onChanged = v10
		})
	})
end

return React.memo(TextQuestion)
