local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")

local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/InteractionFeedback").useTriggerFeedback

local function useTriggerGameTileFeedbackCallbacks()
	local v5 = useTriggerFeedback()
	local ref = React.useRef(nil)
	return React.useCallback(function(p2)
		local guiState = p2.GuiState

		if ref.current == Enum.GuiState.Press then
			v5("Default", "Release")
		end

		if guiState == Enum.GuiState.Hover then
			v5("Default", "Hover")
		end

		if guiState == Enum.GuiState.Press then
			v5("Default", "Press")
		end

		ref.current = guiState
	end, { v5, ref }), (React.useCallback(function()
		if ref.current == Enum.GuiState.Press then
			v5("Default", "Release")
		end

		ref.current = Enum.GuiState.Idle
	end, { v5, ref }))
end

return useTriggerGameTileFeedbackCallbacks
