local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local view = Foundation.View
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthAnalytics")
local usernameSuggestionShown = AuthAnalytics.Events.usernameSuggestionShown
local eventStreamConstants = AuthAnalytics.EventStreamConstants

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
			eventStreamConstants.Field.Username
		)
	end, {})

	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		tag = { ["size-full-1100 padding-y-small"] = true }
	}, { React.createElement(Foundation.ScrollView, {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = scrollBarVisibility.None
			},
			tag = { ["row gap-small no-wrap size-full-1000"] = true }
		}, children) })
end
