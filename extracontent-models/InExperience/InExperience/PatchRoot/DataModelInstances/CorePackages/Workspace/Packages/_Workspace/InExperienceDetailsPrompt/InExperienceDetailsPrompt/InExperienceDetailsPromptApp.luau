local TeleportService = game:GetService("TeleportService")
local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local InExperienceDetailsPromptParent = InExperienceDetailsPrompt.Parent
local React = require(InExperienceDetailsPromptParent.React)
local InExperienceDetailsPromptContainer = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptContainer)
local fireInExperienceDetailsPromptOpenedEvent = require(InExperienceDetailsPromptParent.DiscoveryAnalytics).Events.fireInExperienceDetailsPromptOpenedEvent
local DiscoveryEventErrorLogger = require(InExperienceDetailsPromptParent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagLuaAppIedpOverlayAndNavigationFix = require(InExperienceDetailsPromptParent.SharedFlags).FFlagLuaAppIedpOverlayAndNavigationFix
local FFlagLuaAppIedpControlledJoin = require(InExperienceDetailsPromptParent.SharedFlags).FFlagLuaAppIedpControlledJoin

local function InExperienceDetailsPromptApp() -- line: 16
	-- upvalues: React (copy), TeleportService (copy), fireInExperienceDetailsPromptOpenedEvent (copy), FFlagLuaAppIedpControlledJoin (copy), DiscoveryEventErrorLogger (copy), FFlagLuaAppIedpOverlayAndNavigationFix (copy), InExperienceDetailsPromptContainer (copy)
	local v11, v12 = React.useState(nil)
	local v13, v14 = React.useState(false)

	React.useEffect(function() -- line: 20
		-- upvalues: TeleportService (copy), v12 (copy), v14 (copy), fireInExperienceDetailsPromptOpenedEvent (copy)
		local connection = TeleportService.OpenExperienceDetailsPrompt:Connect(function(p1) -- line: 21
			-- upvalues: v12 (copy), v14 (copy), fireInExperienceDetailsPromptOpenedEvent (copy)
			v12((tostring(p1)))
			v14(true)
			fireInExperienceDetailsPromptOpenedEvent({
				targetUniverseId = tostring(p1)
			})
		end)

		return function() -- line: 28
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	if not v13 or not v11 then
		return nil
	end

	local function closePrompt() -- line: 39
		-- upvalues: v12 (copy), v14 (copy)
		v12(nil)
		v14(false)
	end

	local v16 = if not FFlagLuaAppIedpControlledJoin then {
		universeId = v11,
		onClose = closePrompt
	} else {
		universeId = v11,
		onJoin = function(n1: number?) -- line: 47
			-- upvalues: TeleportService (copy), v12 (copy), v14 (copy), DiscoveryEventErrorLogger (copy), v11 (copy)
			if n1 then
				TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.TeleportAttempted)
				TeleportService:Teleport(n1)
				v12(nil)
				v14(false)

				return
			end

			DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptAppOnJoinMissingRootPlaceId", "Missing valid root place id for universe id", {
				universeId = v11
			})
		end,
		onClose = function() -- line: 62
			-- upvalues: TeleportService (copy), v12 (copy), v14 (copy)
			TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.PromptClosed)
			v12(nil)
			v14(false)
		end
	}

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		return (React.createElement(InExperienceDetailsPromptContainer, v16))
	end

	return (React.createElement("ScreenGui", {
		ScreenInsets = Enum.ScreenInsets.None
	}, {
		InExperienceDetailsPrompt = React.createElement(InExperienceDetailsPromptContainer, v16)
	}))
end

return InExperienceDetailsPromptApp
