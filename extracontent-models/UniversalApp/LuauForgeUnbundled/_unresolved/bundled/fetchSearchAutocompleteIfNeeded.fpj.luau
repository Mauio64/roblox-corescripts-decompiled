local HttpService = game:GetService("HttpService")

local dataStatus = require("@luauforge/bundled/fpk").DataStatus
local url = require("@luauforge/bundled/foT").Url
local module = require("@luauforge/bundled/foM")
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore
local getSduiTemplateStore = module.getSduiTemplateStore

local module2 = require("@luauforge/bundled/fpg")
local module3 = require("@luauforge/bundled/fpl")
local module4 = require("@luauforge/bundled/fpn")
local module5 = require("@luauforge/bundled/fpi")

local function getSearchAutocompleteUrl(p2)
	return string.format(
		"%sgames-autocomplete/v2/get-suggestion/%s",
		url.APIS_URL,
		HttpService:UrlEncode(p2)
	)
end

local function fetchSearchAutocompleteIfNeeded(p2, loadTimer, callback)
	local v5 = module2(p2)
	return module3():andThen(function()
		if callback and not callback() then
			return nil
		end

		local search_autocomplete = require("@luauforge/bundled/foX").apppageplatform.search.search_autocomplete
		local sduiApiStore = getSduiApiStore()
		local data, v6 = sduiApiStore.getData(v5)
		local v7 = data.status(false) == dataStatus.Failed

		local v8 = not (v7 or v6)
			and not sduiApiStore.isInFlight(v5)
			and sduiApiStore.getInputData(v5, module4) ~= nil
		return sduiApiStore.fetchIfNeeded({
			responseType = sduiResponseType.Protobuf,
			url = string.format(
				"%sgames-autocomplete/v2/get-suggestion/%s",
				url.APIS_URL,
				HttpService:UrlEncode(p2)
			),
			surfaceKey = module5,
			configKey = v5,
			loadTimer = loadTimer,
			apiProto = search_autocomplete.GetSearchAutocompleteResponse,
			parseTemplateEntriesFromResponse = function()
				return {}, {}, {}
			end,
			parseLocalizedLiteralsFromResponse = function()
				return getSduiTemplateStore().getLocalizedLiterals()
			end,
			enableTemplateCache = true,
			isResponseCurrent = function(): boolean
				return module2(p2) == v5
			end
		}, v7):andThen(function()
			return v8
		end)
	end)
end

return fetchSearchAutocompleteIfNeeded
