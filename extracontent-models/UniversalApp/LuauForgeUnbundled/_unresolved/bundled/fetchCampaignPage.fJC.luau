local HttpService = game:GetService("HttpService")

local appPage = require("@luauforge/bundled/fJz").AppPage
local module = require("@luauforge/bundled/fJA")
local sduiResponseType = module.SduiResponseType
local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
local sduiRequestConcurrencyPolicy = module.SduiRequestConcurrencyPolicy
local getSduiApiStore = module.getSduiApiStore

local module2 = require("@luauforge/bundled/fJD")
local module3 = require("@luauforge/bundled/fJH")
local module4 = require("@luauforge/bundled/fJI")

local fFlagAppIaHomeShowCampaignTab = require("@luauforge/bundled/fJv").FFlagAppIaHomeShowCampaignTab

local function fetchCampaignPage(p2, p3, p4)
	local campaign_page = require("@luauforge/bundled/fJL").apppageplatform.campaign.campaign_page

	local v5 = module3(p3)

	local v6 = not fFlagAppIaHomeShowCampaignTab and 0 or module4.getGeneration()
	local v7 = fFlagAppIaHomeShowCampaignTab and module4.isStale(v5) and true or p4

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v8 = {
		responseType = sduiResponseType.Protobuf,
		url = module2(),
		surfaceKey = appPage.Campaign,
		configKey = v5,
		loadTimer = p2,
		apiProto = campaign_page.CampaignPageResponse,
		concurrencyPolicy = 0,
		postConfig = 0
	}

	local v9 = if fFlagAppIaHomeShowCampaignTab and v7 then sduiRequestConcurrencyPolicy.LatestWins else nil
	v8.concurrencyPolicy = v9

	v8.postConfig = {
		contentType = sduiApiStorePostConfigContentType.Json,
		body = {
			requestId = HttpService:GenerateGUID(false),
			screenSize = p3
		}
	}
	local v10 = fetchIfNeeded(v8, v7)

	if fFlagAppIaHomeShowCampaignTab then
		v10 = v10:andThen(function(p5)
			if p5 ~= nil then
				module4.markFetched(v5, v6)
			end

			return p5
		end)
	end

	return v10, v5
end

return fetchCampaignPage
