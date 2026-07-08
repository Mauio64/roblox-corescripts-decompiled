local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local ReactUtils = require(CoreScriptsPlayerFeedbackParent.ReactUtils)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)
local React = require(CoreScriptsPlayerFeedbackParent.React)
local useEventConnection = ReactUtils.useEventConnection
local v7 = GetFFlagEnablePlayerSupportPrompt()
local v8 = React.memo(function(t1: {[any]: any}) -- line: 21
	-- upvalues: useEventConnection (copy)
	useEventConnection(t1.event, t1.handler)

	return nil
end)

return (React.memo(function(t2: {[any]: any}) -- line: 26
	-- upvalues: React (copy), v7 (copy), v8 (copy)
	local SocialService = game:GetService("SocialService")
	local v12 = React.useCallback(function() -- line: 29
		-- upvalues: t2 (copy)
		t2.openFeedbackPrompt()
	end, { t2.openFeedbackPrompt })
	local v13 = React.useCallback(function(p1) -- line: 32
		-- upvalues: t2 (copy)
		local u25 = false

		pcall(function() -- line: 34
			-- upvalues: u25 (ref), p1 (copy)
			u25 = p1 == Enum.FeedbackType.PlayerSupport
		end)

		if u25 then
			if t2.openPlayerSupportPrompt then
				t2.openPlayerSupportPrompt()
			else
				t2.openFeedbackPrompt()
			end
		else
			t2.openFeedbackPrompt()
		end
	end, {
		t2.openFeedbackPrompt,
		t2.openPlayerSupportPrompt
	})
	local v14 = if not v7 then v12 else v13
	local v15 = React.useCallback(function(s1: string) -- line: 51
		-- upvalues: t2 (copy)
		if t2.openUnavailablePrompt then
			t2.openUnavailablePrompt(s1)
		end
	end, { t2.openUnavailablePrompt })
	local v16 = React.useCallback(function(s2: string, p2) -- line: 56
		-- upvalues: t2 (copy)
		local u29 = false

		pcall(function() -- line: 58
			-- upvalues: u29 (ref), p2 (copy)
			u29 = p2 == Enum.FeedbackType.PlayerSupport
		end)

		if u29 then
			if t2.openPlayerSupportUnavailablePrompt then
				t2.openPlayerSupportUnavailablePrompt(s2)
			end
		elseif t2.openUnavailablePrompt then
			t2.openUnavailablePrompt(s2)
		end
	end, {
		t2.openUnavailablePrompt,
		t2.openPlayerSupportUnavailablePrompt
	})
	local v17 = if not v7 then v15 else v16
	local v18 = nil
	local v19 = nil

	if SocialService then
		local ok, result = pcall(function() -- line: 79
			-- upvalues: SocialService (copy)
			return SocialService.ShowPromptFeedbackSubmission
		end)

		if ok then
			v18 = result
		end

		local ok2, result2 = pcall(function() -- line: 86
			-- upvalues: SocialService (copy)
			return SocialService.ShowPromptFeedbackUnavailable
		end)

		if ok2 then
			v19 = result2
		end
	end

	return React.createElement(React.Fragment, {}, {
		Show = v18 and React.createElement(v8, {
			event = v18,
			handler = v14
		}) or nil,
		Unavailable = v19 and React.createElement(v8, {
			event = v19,
			handler = v17
		}) or nil
	})
end))
