local HttpService = game:GetService("HttpService")

local appPage = require("@luauforge/bundled/hHo").AppPage
local module = require("@luauforge/bundled/hIP")
local module2 = require("@luauforge/bundled/hHx")
local sduiResponseType = module2.SduiResponseType
local sduiApiStorePostConfigContentType = module2.SduiApiStorePostConfigContentType
local sduiCapabilities = module2.SduiCapabilities
local getSduiApiStore = module2.getSduiApiStore
local getSduiTemplateStore = module2.getSduiTemplateStore

local module3 = require("@luauforge/bundled/hJA")
local module4 = require("@luauforge/bundled/hJB")
local module5 = require("@luauforge/bundled/hJC")
local module6 = require("@luauforge/bundled/hHI")
local module7 = require("@luauforge/bundled/hIc")

local module8 = require("@luauforge/bundled/hHJ")

local function getBuyRobuxPageApi()
	return require("@luauforge/bundled/hJD").apppageplatform.buyrobux.buy_robux_page
end

local function resetSduiContentReadiness()
	module7().set(module6.PageScopeFieldHasRenderedSduiContent, false)
end

local function seedFromLocalMockResponse(json, p2)
	local getBuyRobuxSduiPageResponse = require("@luauforge/bundled/hJD").apppageplatform.buyrobux.buy_robux_page.GetBuyRobuxSduiPageResponse

	if module8 then
		module7().set(module6.PageScopeFieldHasRenderedSduiContent, false)
	end

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

	local buy_robux_page = require("@luauforge/bundled/hJD").apppageplatform.buyrobux.buy_robux_page

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
		onSuccess = if module8 then resetSduiContentReadiness else nil,
		refresh = function(p5)
			return fetchBuyRobuxSduiPage(p5, true, p4)
		end
	}, p3)
end

return fetchBuyRobuxSduiPage
