local Parent = script:FindFirstAncestor("AuthSignup").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local AuthAnalytics = require(Parent.AuthAnalytics)
local usernameSuggestionShown = AuthAnalytics.Events.usernameSuggestionShown
local EventStreamConstants = AuthAnalytics.EventStreamConstants

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Foundation (copy), usernameSuggestionShown (copy), EventStreamConstants (copy), View (copy), ScrollBarVisibility (copy)
	local t2 = {}

	for i, v in ipairs(t1.suggestionUsernames) do
		t2[i] = React.createElement(Foundation.Pill, {
			isDisabled = false,
			text = v,
			onActivated = function() -- line: 25
				-- upvalues: t1 (copy), v (copy)
				t1.onUsernameSelected(v)
			end
		})
	end

	React.useEffect(function() -- line: 32
		-- upvalues: usernameSuggestionShown (copy), t1 (copy), EventStreamConstants (copy)
		usernameSuggestionShown(t1.eventContext, t1.inputUsername, t1.suggestionUsernames, EventStreamConstants.Field.Username)
	end, {})

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		tag = {
			["size-full-1100 padding-y-small"] = true
		}
	}, { React.createElement(Foundation.ScrollView, {
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = ScrollBarVisibility.None
		},
		tag = {
			["row gap-small no-wrap size-full-1000"] = true
		}
	}, t2) })
end
