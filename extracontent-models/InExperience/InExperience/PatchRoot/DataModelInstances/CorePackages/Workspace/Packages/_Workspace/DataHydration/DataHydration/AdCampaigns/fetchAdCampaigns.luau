local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.AdCampaignsTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchBillingAccounts(p)
	return asPromise((fetch({
		network = p.network,
		method = "GET",
		url = (p.baseUrl or UrlBase.APIS) .. "/ads-management/v1/billing-accounts",
		analyticsKey = "ads-billing-accounts.list",
		decode = function(p2)
			local billingAccounts

			if type(p2) == "table" then
				billingAccounts = p2.billingAccounts
			end

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

local function fetchAllCampaigns(p)
	local baseUrl = p.baseUrl or UrlBase.APIS

	return Promise.new(function(callback, callback2)
		local v = {}
		local function fetchPage(p2: string?, p3: number)
			local url = ("%s%s?maxPageSize=%d"):format(baseUrl, "/ads-management/v1/campaigns", 100)

			if p2 ~= nil and p2 ~= "" then
				url ..= "&pageToken=" .. HttpService:UrlEncode(p2)
			end

			asPromise((fetch({
				network = p.network,
				method = "GET",
				url = url,
				analyticsKey = "ads-campaigns.list",
				decode = function(p4)
					return p4
				end
			}))):andThen(function(p4)
				local campaigns

				if p4 ~= nil then
					campaigns = p4.campaigns
				end

				if campaigns ~= nil then
					for _, campaign in campaigns do
						table.insert(v, mapCampaign(campaign))
					end
				end

				local nextPageToken

				if p4 ~= nil then
					nextPageToken = p4.nextPageToken
				end

				if nextPageToken == nil or nextPageToken == "" then
					callback(v)
				elseif p3 >= 10 then
					callback2({ errorMessage = "Ad campaigns pagination exceeded the page limit" })
				else
					fetchPage(nextPageToken, p3 + 1)
				end
			end):catch(function(p4)
				callback2(p4)
			end)
		end

		fetchPage(nil, 1)
	end)
end

return {
	fetchAdCampaigns = function(options)
		local v = options or {}
		local delay = v.delay or Promise.delay
		local timeoutSec = v.timeoutSec or 25

		local v2 = {
			fetchBillingAccounts(v):andThen(function(list)
				if #list == 0 then
					return {}
				end

				return fetchAllCampaigns(v)
			end),
			(delay(timeoutSec):andThen(function()
				return Promise.reject({ errorMessage = "Ad campaigns fetch timed out" })
			end))
		}
		return Promise.race(v2)
	end
}
