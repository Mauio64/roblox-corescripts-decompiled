local DeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/DeepLink")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBase
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/t")
local validateSduiComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerDrivenUi").validateSduiComponentConfig

require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/EntryPoint")
local logResponseStatus = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseStatus")
local logResponseLatency = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseLatency")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/createModalSignalStore")
local getModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/getModalSignalStore")

local fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local fFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI

local interface = t.interface
local v5 = {
	modalId = t.string,
	modalType = t.string,
	sdui = 0,
	isCustomHandler = 0
}
local v6 = if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then t.optional(t.table) else t.table
v5.sdui = v6
local v7 = if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then t.optional(t.boolean) else nil
v5.isCustomHandler = v7
local v8 = interface(v5)

local v9 = {}

local function getModalMetadataUrl(p2)
	local v10

	if fFlagEnableDeepLinkHistoryWithModalAPI then
		local lastDetectedPostAuthUrl = DeepLink.DeepLinkLuaReceiverStatusStore(false).getLastDetectedPostAuthUrl(false)
		v10 = not (lastDetectedPostAuthUrl == nil) and lastDetectedPostAuthUrl ~= ""
	end

	local new = urlBuilder.new
	local v11 = { base = urlBase.APIS, path = "modals-api/v1/modal", query = 0 }

	local v13 = if fFlagEnableDeepLinkHistoryWithModalAPI then tostring(v10) else nil
	v11.query = { entryPoint = p2, hasDetectedDeepLink = v13 }
	return new(v11)()
end

local function parseResponseToMetadata(responseBody)
	local v10, v11 = v8(responseBody)

	if not v10 then
		return { metadata = nil, errorMessage = v11 }
	end

	local v12

	if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v12 = responseBody and responseBody.isCustomHandler
	else
		v12 = false
	end

	if not (fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals and v12) then
		local v13, v14 = validateSduiComponentConfig(responseBody.sdui)

		if not v13 then
			return {
				metadata = nil,
				errorMessage = not (v14 and v14.message) and "Invalid sdui config" or v14.message
			}
		end
	end

	local v14 = {
		modalId = responseBody.modalId,
		modalType = responseBody.modalType,
		sduiConfig = responseBody.sdui,
		isCustomHandler = 0
	}

	local v15 = if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then responseBody.isCustomHandler else nil
	v14.isCustomHandler = v15
	return { metadata = v14, errorMessage = nil }
end

return function(callback, p2)
	local v10 = getModalSignalStore(false)
	local v11 = v10.getMetadataGetter(p2)(false)

	if v11 ~= nil then
		return Promise.resolve(v11)
	end

	local v12 = v9[p2]

	if v12 then
		return v12
	end

	local modalMetadataUrl = getModalMetadataUrl(p2)

	local v13 = Promise.new(function(callback2, callback3, callback4)
		local v14 = callback(modalMetadataUrl, "GET")

		v14:andThen(function(data)
			local responseCode = if data then data.responseCode or nil else nil
			logResponseLatency("modals-api/v1/modal", data.responseTimeMs, responseCode)

			if responseCode ~= 200 then
				callback3(`Unexpected responseCode when fetching metadata: {responseCode}`)
				return
			end

			local v15 = parseResponseToMetadata(data.responseBody)

			if not v15.metadata then
				callback3(`Failed to parse modal metadata response: {v15.errorMessage}`)
				return
			end

			v10.setMetadata(p2, v15.metadata)
			callback2(v15)
		end):catch(function(p3)
			logResponseStatus("modals-api/v1/modal", p3.StatusCode)
			callback3(`Failed to fetch modal metadata: {p3}`)
		end)

		callback4(function()
			v14:cancel()
		end)
	end)
	v9[p2] = v13

	v13:finally(function()
		assert(v9[p2] == v13, "In-flight request promise mismatch")
		v9[p2] = nil
	end)

	return v13
end
