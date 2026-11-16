local parent = script:FindFirstAncestor("AuthSignup").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local AuthAnalytics = require(parent.AuthAnalytics)
local usernameSuggestionShown = AuthAnalytics.Events.usernameSuggestionShown
local EventStreamConstants = AuthAnalytics.EventStreamConstants

return function(props)
	local children = {}

	for i, suggestionUsername in ipairs(props.suggestionUsernames) do
		children[i] = React.createElement(Foundation.Pill, {
			text = suggestionUsername,
			onActivated = function()
				props.onUsernameSelected(suggestionUsername)
			end,
			isDisabled = false
		})
	end

	React.useEffect(function()
		usernameSuggestionShown(
			props.eventContext,
			props.inputUsername,
			props.suggestionUsernames,
			EventStreamConstants.Field.Username
		)
	end, {})

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = { ["size-full-1100 padding-y-small"] = true }
	}, { React.createElement(Foundation.ScrollView, {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = ScrollBarVisibility.None
			},
			tag = { ["row gap-small no-wrap size-full-1000"] = true }
		}, children) })
end
