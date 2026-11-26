local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/AdCampaignsTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchBillingAccounts(p2)
	return asPromise((fetch({
		network = p2.network,
		method = "GET",
		url = (p2.baseUrl or urlBase.APIS) .. "/ads-management/v1/billing-accounts",
		analyticsKey = "ads-billing-accounts.list",
		decode = function(p3)
			local billingAccounts = if type(p3) == "table" then p3.billingAccounts else nil

			if type(billingAccounts) ~= "table" then
				error("Billing accounts response is missing billingAccounts")
			end

			return billingAccounts
		end
	})))
end

local function mapCampaign(campaign)
	local schedule = campaign.schedule or {}
	return {
		id = campaign.id,
		name = campaign.name,
		status = campaign.status,
		deliveryStatus = campaign.deliveryStatus,
		targetUniverseId = campaign.targetUniverseId,
		schedule = {
			startTime = schedule.startTime,
			durationInDays = type(schedule.durationInDays) ~= "number" and 0 or schedule.durationInDays
		}
	}
end

local function fetchAllCampaigns(p2)
	local baseUrl = p2.baseUrl or urlBase.APIS

	return Promise.new(function(callback, callback2)
		local v6 = {}
		local function fetchPage(p3, p4)
			local v7 = ("%s%s?maxPageSize=%d"):format(baseUrl, "/ads-management/v1/campaigns", 100)

			if p3 ~= nil and p3 ~= "" then
				v7 ..= "&pageToken=" .. HttpService:UrlEncode(p3)
			end

			asPromise((fetch({
				network = p2.network,
				method = "GET",
				url = v7,
				analyticsKey = "ads-campaigns.list",
				decode = function(p5)
					return p5
				end
			}))):andThen(function(p5)
				local campaigns = if p5 ~= nil then p5.campaigns else nil

				if campaigns ~= nil then
					for k, campaign in campaigns do
						table.insert(v6, mapCampaign(campaign))
					end
				end

				local nextPageToken = if p5 ~= nil then p5.nextPageToken else nil

				if nextPageToken == nil or nextPageToken == "" then
					callback(v6)
				elseif p4 >= 10 then
					callback2({
						errorMessage = "Ad campaigns pagination exceeded the page limit"
					})
				else
					fetchPage(nextPageToken, p4 + 1)
				end
			end):catch(function(p5)
				callback2(p5)
			end)
		end

		fetchPage(nil, 1)
	end)
end

return {
	fetchAdCampaigns = function(options)
		local v6 = options or {}
		local delay2 = v6.delay or Promise.delay
		local timeoutSec = v6.timeoutSec or 25

		local v7 = {
			fetchBillingAccounts(v6):andThen(function(list)
				if #list == 0 then
					return {}
				end

				return fetchAllCampaigns(v6)
			end),
			(delay2(timeoutSec):andThen(function()
				return Promise.reject({ errorMessage = "Ad campaigns fetch timed out" })
			end))
		}
		return Promise.race(v7)
	end
}
