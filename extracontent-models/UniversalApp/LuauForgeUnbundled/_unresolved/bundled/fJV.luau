local localUserIdStore = require("@luauforge/bundled/fJW").LocalUserIdStore
local module = require("@luauforge/bundled/fJN")
require("@luauforge/bundled/fJJ")
local createSessionScopedSignal = require("@luauforge/bundled/fJX").createSessionScopedSignal
local url = require("@luauforge/bundled/fJF").Url

local fFlagAppIaHomeCampaignDeepLink = require("@luauforge/bundled/fJv").FFlagAppIaHomeCampaignDeepLink
local fFlagAppIaHomeShowCampaignTab = require("@luauforge/bundled/fJv").FFlagAppIaHomeShowCampaignTab
local module2 = require("@luauforge/bundled/fJY")
local module3 = require("@luauforge/bundled/fJZ")

local sessionScopedSignal, v5 = createSessionScopedSignal(false)

local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)

local campaignLocalizations = require("@luauforge/bundled/fJO").CampaignLocalizations
local getCampaignLocalizations = campaignLocalizations.getCampaignLocalizations
local setCampaignLocalizations = campaignLocalizations.setCampaignLocalizations

local sessionScopedSignal3, v7 = createSessionScopedSignal(nil)

local function parseLocalizations(localizedStrings)
	local localizations = {}

	for k, item in localizedStrings do
		if not (type(k) == "string" and type(item) == "string") then
			continue
		end

		localizations[k] = item
	end

	return localizations
end

local function isForPreviousUser(p2): boolean
	return localUserIdStore.getCurrentUserId(false) ~= p2
end

local function requestEligibility(callback)
	return callback(`{url.APIS_URL}marketplace-widgets/v1/campaign/eligibility`, "GET")
end

local function fetchCampaignEligibility(callback)
	local currentUserId = localUserIdStore.getCurrentUserId(false)
	local v8 = if fFlagAppIaHomeCampaignDeepLink then sessionScopedSignal3(false) else nil

	if v8 and v8:getStatus() == module.Status.Started then
		return v8
	end

	local v9

	if fFlagAppIaHomeShowCampaignTab then
		v9 = module.retryWithDelay(requestEligibility, module2, module3 / 1000, callback)
	else
		v9 = callback(`{url.APIS_URL}marketplace-widgets/v1/campaign/eligibility`, "GET")
	end

	local v10 = v9:andThen(function(p2)
		if fFlagAppIaHomeShowCampaignTab and localUserIdStore.getCurrentUserId(false) ~= currentUserId then
			return
		end

		local tabTitle = p2.responseBody.tabTitle
		v5(p2.responseBody.isEligible == true)

		if type(tabTitle) ~= "string" or tabTitle == "" then
			tabTitle = nil
		end

		v6(tabTitle)
		local localizedStrings = p2.responseBody.localizedStrings

		if type(localizedStrings) == "table" then
			setCampaignLocalizations(parseLocalizations(localizedStrings))
		end
	end):catch(function(p2)
		if fFlagAppIaHomeShowCampaignTab then
			if localUserIdStore.getCurrentUserId(false) == currentUserId then
				v5(false)
				v6(nil)
			end
		else
			v5(false)
			v6(nil)
		end

		return module.reject(p2)
	end)

	if fFlagAppIaHomeCampaignDeepLink then
		v7(v10)
	end

	return v10
end

return {
	getIsEligible = sessionScopedSignal,
	getTabTitle = sessionScopedSignal2,
	getCampaignLocalizations = getCampaignLocalizations,
	setCampaignLocalizations = setCampaignLocalizations,
	fetchCampaignEligibility = fetchCampaignEligibility,
	awaitIsEligible = function(p2)
		local v8 = sessionScopedSignal3(false)

		if not v8 or v8:getStatus() == module.Status.Rejected then
			v8 = fetchCampaignEligibility(p2)
		end

		return v8:andThen(function()
			return sessionScopedSignal(false) and sessionScopedSignal2(false) ~= nil
		end):catch(function(): boolean
			return false
		end)
	end
}
