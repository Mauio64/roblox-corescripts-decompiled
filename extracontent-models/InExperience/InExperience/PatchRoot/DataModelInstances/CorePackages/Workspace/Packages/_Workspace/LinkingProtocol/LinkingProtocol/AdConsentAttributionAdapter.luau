local LinkingProtocol = script:FindFirstAncestor("LinkingProtocol")

local StartAttributionOrchestrator = require(script.Parent.StartAttributionOrchestrator)
local getFFlagEnableAdConsentAttribution = require(LinkingProtocol.Flags.getFFlagEnableAdConsentAttribution)

local AdConsentAttributionAdapter = {}

function AdConsentAttributionAdapter.toAdConsent(p: string?): nil | boolean
	if p == "Enabled" then
		return true
	elseif p == "Disabled" then
		return false
	end

	return nil
end

function AdConsentAttributionAdapter.resolveAndPublish(p, p2, callback, p3: string?)
	if not getFFlagEnableAdConsentAttribution() then
		return
	end

	local adConsent = AdConsentAttributionAdapter.toAdConsent(callback())
	StartAttributionOrchestrator.resolveAndPublish(p, p2, adConsent, p3)
end

return AdConsentAttributionAdapter
