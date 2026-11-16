local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent
local ReactUtils = require(parent.ReactUtils)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)

local React = require(parent.React)
local useEventConnection = ReactUtils.useEventConnection

local fFlagEnablePlayerSupportPrompt = GetFFlagEnablePlayerSupportPrompt()

local memo = React.memo(function(p): nil
	useEventConnection(p.event, p.handler)
	return nil
end)

return (React.memo(function(props)
	local SocialService = game:GetService("SocialService")

	local v = React.useCallback(function()
		props.openFeedbackPrompt()
	end, { props.openFeedbackPrompt })
	local handler = React.useCallback(function(p)
		local v2 = false
		pcall(function()
			v2 = p == Enum.FeedbackType.PlayerSupport
		end)

		if v2 then
			if props.openPlayerSupportPrompt then
				props.openPlayerSupportPrompt()
			else
				props.openFeedbackPrompt()
			end
		else
			props.openFeedbackPrompt()
		end
	end, { props.openFeedbackPrompt, props.openPlayerSupportPrompt })

	if not fFlagEnablePlayerSupportPrompt then
		handler = v
	end

	local handler2 = React.useCallback(function(p: string)
		if props.openUnavailablePrompt then
			props.openUnavailablePrompt(p)
		end
	end, { props.openUnavailablePrompt })
	local v2 = React.useCallback(function(p: string, p2)
		local v2 = false
		pcall(function()
			v2 = p2 == Enum.FeedbackType.PlayerSupport
		end)

		if v2 then
			if props.openPlayerSupportUnavailablePrompt then
				props.openPlayerSupportUnavailablePrompt(p)
			end
		elseif props.openUnavailablePrompt then
			props.openUnavailablePrompt(p)
		end
	end, { props.openUnavailablePrompt, props.openPlayerSupportUnavailablePrompt })

	if fFlagEnablePlayerSupportPrompt then
		handler2 = v2
	end

	local event = nil
	local event2 = nil

	if SocialService then
		local success, result = pcall(function()
			return SocialService.ShowPromptFeedbackSubmission
		end)

		if success then
			event = result
		end

		local success2, result2 = pcall(function()
			return SocialService.ShowPromptFeedbackUnavailable
		end)

		if success2 then
			event2 = result2
		end
	end

	return React.createElement(React.Fragment, {}, {
		Show = event and React.createElement(memo, { event = event, handler = handler }) or nil,
		Unavailable = event2 and React.createElement(memo, { event = event2, handler = handler2 }) or nil
	})
end))
