local HttpService = game:GetService("HttpService")

local appPage = require("@luauforge/bundled/hwj").AppPage
local module = require("@luauforge/bundled/hxC")
local module2 = require("@luauforge/bundled/hwr")
local sduiResponseType = module2.SduiResponseType
local sduiApiStorePostConfigContentType = module2.SduiApiStorePostConfigContentType
local sduiCapabilities = module2.SduiCapabilities
local getSduiApiStore = module2.getSduiApiStore
local getSduiTemplateStore = module2.getSduiTemplateStore

local module3 = require("@luauforge/bundled/hyn")
local module4 = require("@luauforge/bundled/hyo")
local module5 = require("@luauforge/bundled/hyp")

local function getBuyRobuxPageApi()
	return require("@luauforge/bundled/hyq").apppageplatform.buyrobux.buy_robux_page
end

local function seedFromLocalMockResponse(json, p2)
	local getBuyRobuxSduiPageResponse = require("@luauforge/bundled/hyq").apppageplatform.buyrobux.buy_robux_page.GetBuyRobuxSduiPageResponse
	getSduiApiStore().seedFromDecodedResponse({
		surfaceKey = appPage.BuyRobux,
		configKey = appPage.BuyRobux,
		decodedResponse = getBuyRobuxSduiPageResponse.jsonDecode(HttpService:JSONDecode(json)),
		loadTimer = p2,
		apiProto = getBuyRobuxSduiPageResponse,
		replace = true
	})
end

local function fetchBuyRobuxSduiPage(p2, p3, p4)
	if module3 then
		local v5 = module4()

		if v5 ~= nil then
			seedFromLocalMockResponse(v5, p2)
			return module.resolve()
		end
	end

	local buy_robux_page = require("@luauforge/bundled/hyq").apppageplatform.buyrobux.buy_robux_page

	local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.BuyRobux)

	return getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = module5(),
		surfaceKey = appPage.BuyRobux,
		configKey = appPage.BuyRobux,
		loadTimer = p2,
		apiProto = buy_robux_page.GetBuyRobuxSduiPageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = buy_robux_page.GetBuyRobuxSduiPageRequest,
			body = {
				purchase_flow_id = p4,
				cached_roblox_component_to_template_id = cachedRobloxComponentToTemplateId,
				client_capabilities = sduiCapabilities.buildClientCapabilities()
			}
		},
		enableTemplateCache = true,
		refresh = function(p5)
			return fetchBuyRobuxSduiPage(p5, true, p4)
		end
	}, p3)
end

return fetchBuyRobuxSduiPage
