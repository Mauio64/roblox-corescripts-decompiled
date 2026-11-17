local HttpService = game:GetService("HttpService")

local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

require(NotificationsOrchestrator.Types)

local v = {
	suppressed = true,
	submitDropped = true,
	capReached = true,
	promoteDropped = true,
	revoked = true
}

local function metadataString(p: string?) -- 5 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function actionFor(data) -- 1 equivalent call inferred from this helper
	if data.eventType == "mounted" then
		return nil
	end

	if data.eventType == "viewed" then
		return MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION
	end

	if data.eventType == "activated" or data.eventType == "dismissed" then
		return MarketplaceUnifiedAction.UI_ELEMENT_CLICK
	end

	if data.eventType == "queued" then
		return 12
	end

	return if v[data.eventType] then 13 else nil
end

local function metadataFor(data)
	return HttpService:JSONEncode({
		eventType = tostring(data.eventType),
		reason = metadataString(data.reason), -- inferred equivalent call
		actionId = metadataString(data.actionId), -- inferred equivalent call
		handle = metadataString(data.handle), -- inferred equivalent call
		lifecycleKey = metadataString(data.lifecycleKey), -- inferred equivalent call
		source = metadataString(data.source) -- inferred equivalent call
	})
end

return {
	send = function(data)
		local action = actionFor(data) -- inferred equivalent call

		if action == nil then
			return
		end

		local v2 = {
			action = action,
			surface = UnifiedLoggingSurface.IN_EXPERIENCE_NOTIFICATIONS,
			elementName = data.slot,
			elementMetadata = metadataFor(data),
			universeId = game.GameId,
			itemId = data.itemId,
			itemType = data.itemType
		}

		if AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads then
			sendPassthroughUnifiedEventLog(v2)
		else
			sendUnifiedEventLog(v2)
		end
	end
}
