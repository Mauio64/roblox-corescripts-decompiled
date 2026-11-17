local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)

local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback
require(parent.InteractionFeedback)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileInteractionFeedback = SharedFlags.FFlagLuaAppSduiGameTileInteractionFeedback

local function useTriggerGameTileFeedbackCallbacks(callback)
	if not FFlagLuaAppSduiGameTileInteractionFeedback then
		callback = useTriggerFeedback()
	end

	local ref = React.useRef(nil)
	return React.useCallback(function(p)
		local guiState = p.GuiState

		if FFlagLuaAppSduiGameTileInteractionFeedback and not callback then
			DiscoveryEventErrorLogger.reportError(
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
		if FFlagLuaAppSduiGameTileInteractionFeedback and not callback then
			DiscoveryEventErrorLogger.reportError(
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
