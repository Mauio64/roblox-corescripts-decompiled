local TeleportService = game:GetService("TeleportService")
local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local parent = InExperienceDetailsPrompt.Parent
local React = require(parent.React)
local InExperienceDetailsPromptContainer = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptContainer)

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local fireInExperienceDetailsPromptOpenedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptOpenedEvent
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpOverlayAndNavigationFix = SharedFlags.FFlagLuaAppIedpOverlayAndNavigationFix

local function InExperienceDetailsPromptApp()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		local openExperienceDetailsPromptConnection = TeleportService.OpenExperienceDetailsPrompt:Connect(function(p)
			setState((tostring(p)))
			setState2(true)
			fireInExperienceDetailsPromptOpenedEvent({ targetUniverseId = tostring(p) })
		end)
		return function()
			if openExperienceDetailsPromptConnection then
				openExperienceDetailsPromptConnection:Disconnect()
			end
		end
	end, {})

	if not (state2 and state) then
		return nil
	end

	local function closePrompt() -- 2 equivalent calls inferred from this helper
		setState(nil)
		setState2(false)
	end

	local v = {
		universeId = state,
		onJoin = function(p: number?)
			if not p then
				DiscoveryEventErrorLogger.reportError(
					"InExperienceDetailsPromptAppOnJoinMissingRootPlaceId",
					"Missing valid root place id for universe id",
					{ universeId = state }
				)

				return
			end

			TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.TeleportAttempted)
			TeleportService:Teleport(p)
			closePrompt() -- inferred equivalent call
		end,
		onClose = function()
			TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.PromptClosed)
			closePrompt() -- inferred equivalent call
		end
	}

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		return (React.createElement(InExperienceDetailsPromptContainer, v))
	end

	return (React.createElement("ScreenGui", { ScreenInsets = Enum.ScreenInsets.None }, {
		InExperienceDetailsPrompt = React.createElement(InExperienceDetailsPromptContainer, v)
	}))
end

return InExperienceDetailsPromptApp
