local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController)
local UniversalFeatureRestrictions = require(CorePackages.Workspace.Packages.UniversalFeatureRestrictions)

local function showUFRVoiceRestriction(data)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	local userId = localPlayer.UserId

	local manager = data.manager
	local analytics = manager.Analytics
	local banReason = data.settings.banReason
	local v = not manager.service and "" or manager.previousSessionId

	local v2 = false
	local v3 = false
	local flag = false

	local function logBanDialogEvent(p: string) -- 3 equivalent calls inferred from this helper
		analytics:reportBanMessageEvent(p)
		analytics:reportBanMessageEventV2(p, banReason, userId, v)
	end

	UniversalFeatureRestrictions.showFeatureRestriction(UniversalFeatureRestrictions.AbuseVector.Voice, {
		onShown = function()
			if not v2 then
				v2 = true
				logBanDialogEvent("Shown") -- inferred equivalent call
			end
		end,
		onAppeal = function()
			v3 = true
			logBanDialogEvent("Denied") -- inferred equivalent call
		end,
		onDismiss = function()
			if flag then
				return
			end

			flag = true

			if not v3 then
				logBanDialogEvent("Acknowledged") -- inferred equivalent call
			end
		end,
		onAcknowledgementSuccess = data.onAcknowledgementSuccess
	})
end

return showUFRVoiceRestriction
