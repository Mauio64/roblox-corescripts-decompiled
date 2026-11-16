local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local buildLegacyVoiceRestrictionDetail = require(script.Parent.buildLegacyVoiceRestrictionDetail)

require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController)
local getRestrictionType = require(script.Parent.getRestrictionType)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local UniversalFeatureRestrictions = require(CorePackages.Workspace.Packages.UniversalFeatureRestrictions)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local v = Localization.new(LocalizationService.RobloxLocaleId)

local function format(p: string, p2)
	return v:Format(p, p2)
end

local function showLegacyVoiceRestriction(data)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	local userId = localPlayer.UserId

	local manager = data.manager
	local settings = data.settings
	local trigger = data.trigger
	local isCurrent = data.isCurrent

	local v2 = not manager.service and "" or manager.previousSessionId
	local analytics = manager.Analytics

	local restrictionType = getRestrictionType(settings)
	local banReason

	if settings then
		banReason = settings.banReason
	else
		banReason = nil
	end

	local nudgeAnalyticsData, v3

	if settings then
		nudgeAnalyticsData = nil
		v3 = nil
	else
		nudgeAnalyticsData, v3 = manager:GetNudgeAnalyticsData()
	end

	local legacyVoiceRestrictionDetail = buildLegacyVoiceRestrictionDetail({
		settings = settings,
		userId = userId,
		now = DateTime.now().UnixTimestamp,
		format = format
	})

	local flag = false
	local v4 = false
	local v5 = false

	local function logBanDialogEvent(p: string) -- 3 equivalent calls inferred from this helper
		analytics:reportBanMessageEvent(p)
		analytics:reportBanMessageEventV2(p, banReason, userId, v2)
	end

	local function onShown()
		if not v5 then
			v5 = true

			if restrictionType ~= "Nudge" then
				logBanDialogEvent("Shown") -- inferred equivalent call
			end
		end
	end

	local function onAppeal()
		v4 = true

		if restrictionType == "Nudge" then
			analytics:reportDeniedNudge(nudgeAnalyticsData, v3)
			return
		end

		logBanDialogEvent("Denied") -- inferred equivalent call
	end

	local function onDismiss()
		if flag then
			return
		end

		flag = true

		local v6 = restrictionType == "TemporaryBan" or restrictionType == "NudgeBan"

		if trigger ~= "micTap" and v6 and isCurrent() then
			VoiceChat.PostInformedOfBan(function(p, p2, p3)
				return manager:PostRequest(p, p2, p3)
			end, true)
		end

		if restrictionType == "Nudge" then
			analytics:reportClosedNudge(nudgeAnalyticsData, v3)

			if not v4 then
				analytics:reportAcknowledgedNudge(nudgeAnalyticsData, v3)
			end
		elseif not v4 then
			logBanDialogEvent(restrictionType == "NudgeBan" and "Understood" or "Acknowledged") -- inferred equivalent call
		end
	end

	local showFeatureRestrictionDirect = UniversalFeatureRestrictions.showFeatureRestrictionDirect
	local voice = UniversalFeatureRestrictions.AbuseVector.Voice

	if restrictionType ~= "Nudge" and restrictionType ~= "NudgeBan" then
		onAppeal = nil
	end

	showFeatureRestrictionDirect(voice, legacyVoiceRestrictionDetail, {
		onShown = onShown,
		onDismiss = onDismiss,
		onAppeal = onAppeal
	})
end

return showLegacyVoiceRestriction
