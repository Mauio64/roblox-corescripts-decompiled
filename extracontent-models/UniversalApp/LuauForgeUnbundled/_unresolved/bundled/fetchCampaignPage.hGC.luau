local HttpService = game:GetService("HttpService")

local appPage = require("@luauforge/bundled/hGz").AppPage
local module = require("@luauforge/bundled/hGA")
local sduiResponseType = module.SduiResponseType
local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
local getSduiApiStore = module.getSduiApiStore

local module2 = require("@luauforge/bundled/hGD")
local module3 = require("@luauforge/bundled/hGH")

local function fetchCampaignPage(p2, p3, p4)
	local campaign_page = require("@luauforge/bundled/hGI").apppageplatform.campaign.campaign_page

	local v5 = module3(p3)
	return getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = module2(),
		surfaceKey = appPage.Campaign,
		configKey = v5,
		loadTimer = p2,
		apiProto = campaign_page.CampaignPageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Json,
			body = {
				requestId = HttpService:GenerateGUID(false),
				screenSize = p3
			}
		}
	}, p4), v5
end

return fetchCampaignPage
