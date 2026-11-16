local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Promise")
local LegallySensitiveContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/LegallySensitiveContent")

local AccountUpgradeAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Analytics/AccountUpgradeAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeSurface")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/FlowSpec")
local MarketingConsentOptInMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MarketingConsentOptInMethod")
local getMarketingConsentOptInMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Eligibility/getMarketingConsentOptInMethod")
local sendMarketingConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/sendMarketingConsent")
local FIntAccountUpgradeMarketingConsentMinimumAge = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FIntAccountUpgradeMarketingConsentMinimumAge")

local consentName = LegallySensitiveContent.ConsentName

local function noop() end

local function useMarketingConsent(data)
	local flow = data.flow
	local surface = data.surface
	local birthday = data.birthday
	local showsMarketingConsent = data.spec.showsMarketingConsent == true

	local v5, v6 = LegallySensitiveContent.useLegallySensitiveContentAndActions(
		consentName.allowMarketingEmailCheckboxAccountUpgrade,
		"email-marketing-checkbox-during-account-upgrade"
	)

	local v7, v8 = LegallySensitiveContent.useLegallySensitiveContentAndActions(
		consentName.allowMarketingEmailAutoOptInAccountUpgrade,
		"email-marketing-auto-opt-in-during-account-upgrade"
	)

	local ref = React.useRef(v6)
	ref.current = v6
	local ref2 = React.useRef(v8)
	ref2.current = v8

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if not showsMarketingConsent then
			return nil
		end

		local v9 = Promise.try(getMarketingConsentOptInMethod):andThen(setState, function()
			setState(MarketingConsentOptInMethod.None)
		end)
		return function()
			v9:cancel()
		end
	end, { showsMarketingConsent })

	local v9 = showsMarketingConsent and state == MarketingConsentOptInMethod.AutoOptIn
	local v10 = not (birthday == nil) and birthday:GetAgeInYears() < FIntAccountUpgradeMarketingConsentMinimumAge
	local v11 = not (birthday == nil) and not v10

	local consent = v5.wordsOfConsent.consent
	local v12

	if showsMarketingConsent then
		v12 = state == MarketingConsentOptInMethod.Checkbox and consent ~= nil and consent ~= ""
	else
		v12 = showsMarketingConsent
	end

	local v13 = v12 and not v10
	local state2, setState2 = React.useState(false)

	if not v13 and state2 then
		setState2(false)
	end

	React.useEffect(function()
		if v12 then
			AccountUpgradeAnalytics.reportMarketingConsentShown(flow, surface, false)
		end
	end, { v12, flow, surface })

	local v14 = React.useCallback(function()
		if not v13 then
			return
		end

		local v15 = not state2
		setState2(v15)
		AccountUpgradeAnalytics.reportMarketingConsentToggled(flow, surface, v15)
	end, { v13, state2, flow, surface })

	local v15 = React.useCallback(function()
		Promise.try(function()
			if not v11 then
				return
			end

			if v9 then
				sendMarketingConsent(ref2.current.getBase64EncodedAuditHeader, flow, surface)
				AccountUpgradeAnalytics.reportMarketingConsentAutoOptIn(flow, surface)
			elseif v12 then
				if state2 then
					sendMarketingConsent(ref.current.getBase64EncodedAuditHeader, flow, surface)
				end

				AccountUpgradeAnalytics.reportMarketingConsentSubmitted(flow, surface, state2)
			end
		end):catch(noop)
	end, { v11, v9, v12, state2, flow, surface })

	if not v12 then
		consent = nil
	end

	return {
		text = consent,
		isChecked = v13 and state2,
		isDisabled = v12 and not v13,
		onToggled = v14,
		submit = v15
	}
end

return useMarketingConsent
