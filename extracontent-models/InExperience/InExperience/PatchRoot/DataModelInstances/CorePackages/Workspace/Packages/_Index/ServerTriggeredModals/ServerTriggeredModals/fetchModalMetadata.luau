local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local DeepLink = require(parent.DeepLink)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local t = require(parent.t)
local ServerDrivenUi = require(parent.ServerDrivenUi)
local validateSduiComponentConfig = ServerDrivenUi.validateSduiComponentConfig

require(ServerTriggeredModals.EntryPoint)
local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)
require(ServerTriggeredModals.SignalStores.createModalSignalStore)
local getModalSignalStore = require(ServerTriggeredModals.SignalStores.getModalSignalStore)

local FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI

local interface = t.interface
local v = { modalId = t.string, modalType = t.string, sdui = 0, isCustomHandler = 0 }
local sdui

if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
	sdui = t.optional(t.table)
else
	sdui = t.table
end

v.sdui = sdui
local isCustomHandler

if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
	isCustomHandler = t.optional(t.boolean)
end

v.isCustomHandler = isCustomHandler
local v2 = interface(v)

local v3 = {}

local function getModalMetadataUrl(entryPoint)
	local v4

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		local lastDetectedPostAuthUrl = DeepLink.DeepLinkLuaReceiverStatusStore(false).getLastDetectedPostAuthUrl(false)

		if lastDetectedPostAuthUrl == nil then
			v4 = false
		else
			v4 = lastDetectedPostAuthUrl ~= ""
		end
	end

	local new = urlBuilder.new
	local v5 = { base = UrlBase.APIS, path = "modals-api/v1/modal", query = 0 }
	local hasDetectedDeepLink

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		hasDetectedDeepLink = tostring(v4)
	end

	v5.query = { entryPoint = entryPoint, hasDetectedDeepLink = hasDetectedDeepLink }
	return new(v5)()
end

local function parseResponseToMetadata(responseBody)
	local v4, errorMessage = v2(responseBody)

	if not v4 then
		return { metadata = nil, errorMessage = errorMessage }
	end

	local v5

	if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v5 = responseBody and responseBody.isCustomHandler
	else
		v5 = false
	end

	if not (FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals and v5) then
		local v6, v7 = validateSduiComponentConfig(responseBody.sdui)

		if not v6 then
			return {
				metadata = nil,
				errorMessage = not (v7 and v7.message) and "Invalid sdui config" or v7.message
			}
		end
	end

	local metadata = {
		modalId = responseBody.modalId,
		modalType = responseBody.modalType,
		sduiConfig = responseBody.sdui,
		isCustomHandler = 0
	}
	local isCustomHandler2

	if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		isCustomHandler2 = responseBody.isCustomHandler
	end

	metadata.isCustomHandler = isCustomHandler2
	return { metadata = metadata, errorMessage = nil }
end

return function(callback, p)
	local modalSignalStore = getModalSignalStore(false)
	local v4 = modalSignalStore.getMetadataGetter(p)(false)

	if v4 ~= nil then
		return Promise.resolve(v4)
	end

	local v5 = v3[p]

	if v5 then
		return v5
	end

	local modalMetadataUrl = getModalMetadataUrl(p)

	local v6 = Promise.new(function(callback2, callback3, callback4)
		local v6 = callback(modalMetadataUrl, "GET")

		v6:andThen(function(data)
			local responseCode

			if data then
				responseCode = data.responseCode or nil
			end

			logResponseLatency("modals-api/v1/modal", data.responseTimeMs, responseCode)

			if responseCode ~= 200 then
				callback3(`Unexpected responseCode when fetching metadata: {responseCode}`)
				return
			end

			local v7 = parseResponseToMetadata(data.responseBody)

			if not v7.metadata then
				callback3(`Failed to parse modal metadata response: {v7.errorMessage}`)
				return
			end

			modalSignalStore.setMetadata(p, v7.metadata)
			callback2(v7)
		end):catch(function(p2)
			logResponseStatus("modals-api/v1/modal", p2.StatusCode)
			callback3(`Failed to fetch modal metadata: {p2}`)
		end)

		callback4(function()
			v6:cancel()
		end)
	end)
	v3[p] = v6

	v6:finally(function()
		assert(v3[p] == v6, "In-flight request promise mismatch")
		v3[p] = nil
	end)

	return v6
end
