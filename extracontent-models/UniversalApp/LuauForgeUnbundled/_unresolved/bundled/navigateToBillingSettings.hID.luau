local appPage = require("@luauforge/bundled/hHo").AppPage
local module = require("@luauforge/bundled/hIE")
local urlBuilder = require("@luauforge/bundled/hIF").UrlBuilder

local module2 = require("@luauforge/bundled/hHB")

local function getTitleKey(): string
	if module.getAppFeaturePolicies().getRenamePaymentsToSpendingTab() then
		return "Feature.AccountSettings.Heading.Tab.Spending"
	end

	return "Feature.AccountSettings.Heading.Tab.BillingV2"
end

local function navigateToBillingSettings(p2)
	local v5 = {
		name = appPage.SettingsSubPage,
		detail = urlBuilder.static.settings.billing(),
		extraProps = {
			titleKey = module.getAppFeaturePolicies().getRenamePaymentsToSpendingTab() and "Feature.AccountSettings.Heading.Tab.Spending" or "Feature.AccountSettings.Heading.Tab.BillingV2"
		}
	}

	module2.navigateDown(v5, p2)
end

return navigateToBillingSettings
