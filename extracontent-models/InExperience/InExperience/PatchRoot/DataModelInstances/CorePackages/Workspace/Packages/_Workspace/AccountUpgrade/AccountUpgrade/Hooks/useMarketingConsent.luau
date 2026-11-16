local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Promise = require(parent.Promise)
local LegallySensitiveContent = require(parent.LegallySensitiveContent)

local AccountUpgradeAnalytics = require(AccountUpgrade.Analytics.AccountUpgradeAnalytics)
require(AccountUpgrade.AccountUpgradeFlow)
require(AccountUpgrade.AccountUpgradeSurface)
require(AccountUpgrade.FlowSpec)
local MarketingConsentOptInMethod = require(AccountUpgrade.MarketingConsentOptInMethod)
local getMarketingConsentOptInMethod = require(AccountUpgrade.Eligibility.getMarketingConsentOptInMethod)
local sendMarketingConsent = require(AccountUpgrade.Utils.sendMarketingConsent)
local FIntAccountUpgradeMarketingConsentMinimumAge = require(AccountUpgrade.Flags.FIntAccountUpgradeMarketingConsentMinimumAge)

local ConsentName = LegallySensitiveContent.ConsentName

local function noop() end

local function useMarketingConsent(data)
	local flow = data.flow
	local surface = data.surface
	local birthday = data.birthday
	local showsMarketingConsent = data.spec.showsMarketingConsent == true

	local v, current = LegallySensitiveContent.useLegallySensitiveContentAndActions(
		ConsentName.allowMarketingEmailCheckboxAccountUpgrade,
		"email-marketing-checkbox-during-account-upgrade"
	)

	local _, current2 = LegallySensitiveContent.useLegallySensitiveContentAndActions(
		ConsentName.allowMarketingEmailAutoOptInAccountUpgrade,
		"email-marketing-auto-opt-in-during-account-upgrade"
	)

	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if not showsMarketingConsent then
			return nil
		end

		local v2 = Promise.try(getMarketingConsentOptInMethod):andThen(setState, function()
			setState(MarketingConsentOptInMethod.None)
		end)
		return function()
			v2:cancel()
		end
	end, { showsMarketingConsent })

	local v2 = showsMarketingConsent and state == MarketingConsentOptInMethod.AutoOptIn
	local v3

	if birthday == nil then
		v3 = false
	else
		v3 = birthday:GetAgeInYears() < FIntAccountUpgradeMarketingConsentMinimumAge
	end

	local v4

	if birthday == nil then
		v4 = false
	else
		v4 = not v3
	end

	local consent = v.wordsOfConsent.consent
	local v5

	if showsMarketingConsent then
		if state == MarketingConsentOptInMethod.Checkbox and consent ~= nil then
			v5 = consent ~= ""
		else
			v5 = false
		end
	else
		v5 = showsMarketingConsent
	end

	local v6 = v5 and not v3
	local state2, setState2 = React.useState(false)

	if not v6 and state2 then
		setState2(false)
	end

	React.useEffect(function()
		if v5 then
			AccountUpgradeAnalytics.reportMarketingConsentShown(flow, surface, false)
		end
	end, { v5, flow, surface })

	local onToggled = React.useCallback(function()
		if not v6 then
			return
		end

		local v7 = not state2
		setState2(v7)
		AccountUpgradeAnalytics.reportMarketingConsentToggled(flow, surface, v7)
	end, { v6, state2, flow, surface })

	local submit = React.useCallback(function()
		Promise.try(function()
			if not v4 then
				return
			end

			if v2 then
				sendMarketingConsent(ref2.current.getBase64EncodedAuditHeader, flow, surface)
				AccountUpgradeAnalytics.reportMarketingConsentAutoOptIn(flow, surface)
			elseif v5 then
				if state2 then
					sendMarketingConsent(ref.current.getBase64EncodedAuditHeader, flow, surface)
				end

				AccountUpgradeAnalytics.reportMarketingConsentSubmitted(flow, surface, state2)
			end
		end):catch(noop)
	end, { v4, v2, v5, state2, flow, surface })

	if not v5 then
		consent = nil
	end

	return {
		text = consent,
		isChecked = v6 and state2,
		isDisabled = v5 and not v6,
		onToggled = onToggled,
		submit = submit
	}
end

return useMarketingConsent
