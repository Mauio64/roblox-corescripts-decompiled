local StartAttributionOrchestrator = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/StartAttributionOrchestrator")
local getFFlagEnableAdConsentAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagEnableAdConsentAttribution")

local v5 = {}

function v5.toAdConsent(p2): nil | boolean
	if p2 == "Enabled" then
		return true
	elseif p2 == "Disabled" then
		return false
	end

	return nil
end

function v5.resolveAndPublish(p2, p3, callback, p4)
	if not getFFlagEnableAdConsentAttribution() then
		return
	end

	local adConsent = v5.toAdConsent(callback())
	StartAttributionOrchestrator.resolveAndPublish(p2, p3, adConsent, p4)
end

return v5
