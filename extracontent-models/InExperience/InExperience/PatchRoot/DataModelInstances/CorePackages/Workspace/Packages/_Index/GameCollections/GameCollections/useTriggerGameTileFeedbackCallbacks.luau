local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)

local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback

local function useTriggerGameTileFeedbackCallbacks()
	local v = useTriggerFeedback()
	local ref = React.useRef(nil)
	return React.useCallback(function(p)
		local guiState = p.GuiState

		if ref.current == Enum.GuiState.Press then
			v("Default", "Release")
		end

		if guiState == Enum.GuiState.Hover then
			v("Default", "Hover")
		end

		if guiState == Enum.GuiState.Press then
			v("Default", "Press")
		end

		ref.current = guiState
	end, { v, ref }), (React.useCallback(function()
		if ref.current == Enum.GuiState.Press then
			v("Default", "Release")
		end

		ref.current = Enum.GuiState.Idle
	end, { v, ref }))
end

return useTriggerGameTileFeedbackCallbacks
