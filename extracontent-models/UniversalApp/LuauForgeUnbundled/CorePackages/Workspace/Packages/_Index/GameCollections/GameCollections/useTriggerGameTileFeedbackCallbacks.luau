local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")

local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/InteractionFeedback").useTriggerFeedback
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/InteractionFeedback")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppSduiGameTileInteractionFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSduiGameTileInteractionFeedback

local function useTriggerGameTileFeedbackCallbacks(callback)
	if not fFlagLuaAppSduiGameTileInteractionFeedback then
		callback = useTriggerFeedback()
	end

	local ref = React.useRef(nil)
	return React.useCallback(function(p2)
		local guiState = p2.GuiState

		if fFlagLuaAppSduiGameTileInteractionFeedback and not callback then
			discoveryEventErrorLogger.reportError(
				"GameTileMissingTriggerFeedback",
				"useTriggerGameTileFeedbackCallbacks called without triggerFeedbackFn; interaction feedback is disabled"
			)

			return
		end

		if ref.current == Enum.GuiState.Press then
			callback("Default", "Release")
		end

		if guiState == Enum.GuiState.Hover then
			callback("Default", "Hover")
		end

		if guiState == Enum.GuiState.Press then
			callback("Default", "Press")
		end

		ref.current = guiState
	end, { callback, ref }), (React.useCallback(function()
		if fFlagLuaAppSduiGameTileInteractionFeedback and not callback then
			discoveryEventErrorLogger.reportError(
				"GameTileMissingTriggerFeedback",
				"useTriggerGameTileFeedbackCallbacks called without triggerFeedbackFn; interaction feedback is disabled"
			)

			return
		end

		if ref.current == Enum.GuiState.Press then
			callback("Default", "Release")
		end

		ref.current = Enum.GuiState.Idle
	end, { callback, ref }))
end

return useTriggerGameTileFeedbackCallbacks
