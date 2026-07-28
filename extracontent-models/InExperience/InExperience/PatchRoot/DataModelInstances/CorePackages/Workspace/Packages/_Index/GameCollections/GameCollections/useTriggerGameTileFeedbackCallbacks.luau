local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback

local function useTriggerGameTileFeedbackCallbacks() -- line: 8
	-- upvalues: useTriggerFeedback (copy), React (copy)
	local v5 = useTriggerFeedback()
	local v6 = React.useRef(nil)

	return React.useCallback(function(p1) -- line: 11
		-- upvalues: v6 (copy), v5 (copy)
		local GuiState = p1.GuiState

		if v6.current == Enum.GuiState.Press then
			v5("Default", "Release")
		end

		if GuiState == Enum.GuiState.Hover then
			v5("Default", "Hover")
		end

		if GuiState == Enum.GuiState.Press then
			v5("Default", "Press")
		end

		v6.current = GuiState
	end, {
		v5,
		v6
	}), (React.useCallback(function() -- line: 25
		-- upvalues: v6 (copy), v5 (copy)
		if v6.current == Enum.GuiState.Press then
			v5("Default", "Release")
		end

		v6.current = Enum.GuiState.Idle
	end, {
		v5,
		v6
	}))
end

return useTriggerGameTileFeedbackCallbacks
