local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local DeepLink = require(ServerTriggeredModalsParent.DeepLink)
local UrlBuilder = require(ServerTriggeredModalsParent.UrlBuilder).UrlBuilder
local UrlBase = require(ServerTriggeredModalsParent.UrlBuilder).UrlBase
local Promise = require(ServerTriggeredModalsParent.Promise)
local SharedFlags = require(ServerTriggeredModalsParent.SharedFlags)
local t = require(ServerTriggeredModalsParent.t)
local validateSduiComponentConfig = require(ServerTriggeredModalsParent.ServerDrivenUi).validateSduiComponentConfig

require(ServerTriggeredModals.EntryPoint)

local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)

require(ServerTriggeredModals.SignalStores.createModalSignalStore)

local getModalSignalStore = require(ServerTriggeredModals.SignalStores.getModalSignalStore)
local FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI
local v15 = t.interface({
	modalId = t.string,
	modalType = t.string,
	sdui = if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then t.table else t.optional(t.table),
	isCustomHandler = if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then nil else t.optional(t.boolean)
})
local t1 = {}

local function getModalMetadataUrl(p1) -- line: 37
	-- upvalues: FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), UrlBuilder (copy), UrlBase (copy)
	local v20 = nil

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		local v21 = DeepLink.DeepLinkLuaReceiverStatusStore(false).getLastDetectedPostAuthUrl(false)

		v20 = v21 ~= nil and v21 ~= ""
	end

	return UrlBuilder.new({
		path = "modals-api/v1/modal",
		base = UrlBase.APIS,
		query = {
			entryPoint = p1,
			hasDetectedDeepLink = if not FFlagEnableDeepLinkHistoryWithModalAPI then nil else tostring(v20)
		}
	})()
end
local function parseResponseToMetadata(p2) -- line: 56
	-- upvalues: v15 (copy), FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals (copy), validateSduiComponentConfig (copy)
	local v23, v24 = v15(p2)

	if not v23 then
		return {
			metadata = nil,
			errorMessage = v24
		}
	end

	local v25 = not not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals and (p2 and p2.isCustomHandler)

	if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals or not v25 then
		local v26, v27 = validateSduiComponentConfig(p2.sdui)

		if not v26 then
			local v28 = (not v27 or not v27.message) and "Invalid sdui config" or v27.message

			return {
				metadata = nil,
				errorMessage = v28
			}
		end
	end

	return {
		errorMessage = nil,
		metadata = {
			modalId = p2.modalId,
			modalType = p2.modalType,
			sduiConfig = p2.sdui,
			isCustomHandler = if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then nil else p2.isCustomHandler
		}
	}
end

return function(p3, p4) -- line: 90
	-- upvalues: getModalSignalStore (copy), Promise (copy), t1 (copy), getModalMetadataUrl (copy), logResponseLatency (copy), parseResponseToMetadata (copy), logResponseStatus (copy)
	local v31 = getModalSignalStore(false)
	local v32 = v31.getMetadataGetter(p4)(false)

	if v32 ~= nil then
		return Promise.resolve(v32)
	end

	local v33 = t1[p4]

	if v33 then
		return v33
	end

	local v34 = getModalMetadataUrl(p4)
	local u35 = Promise.new(function(resolve, reject, onCancel) -- line: 105
		-- upvalues: p3 (copy), v34 (copy), logResponseLatency (copy), parseResponseToMetadata (copy), v31 (copy), p4 (copy), logResponseStatus (copy)
		local v39 = p3(v34, "GET")

		v39:andThen(function(p5) -- line: 108
			-- upvalues: logResponseLatency (copy), reject (copy), parseResponseToMetadata (copy), v31 (copy), p4 (copy), resolve (copy)
			local v41 = p5 and p5.responseCode or nil

			logResponseLatency("modals-api/v1/modal", p5.responseTimeMs, v41)

			if v41 ~= 200 then
				reject(`Unexpected responseCode when fetching metadata: { v41 }`)

				return
			end

			local v42 = parseResponseToMetadata(p5.responseBody)

			if not v42.metadata then
				reject(`Failed to parse modal metadata response: { v42.errorMessage }`)

				return
			end

			v31.setMetadata(p4, v42.metadata)
			resolve(v42)
		end):catch(function(p6) -- line: 125
			-- upvalues: logResponseStatus (copy), reject (copy)
			logResponseStatus("modals-api/v1/modal", p6.StatusCode)
			reject(`Failed to fetch modal metadata: { p6 }`)
		end)
		onCancel(function() -- line: 130
			-- upvalues: v39 (copy)
			v39:cancel()
		end)
	end)

	t1[p4] = u35
	u35:finally(function() -- line: 136
		-- upvalues: t1 (copy), p4 (copy), u35 (ref)
		assert(t1[p4] == u35, "In-flight request promise mismatch")
		t1[p4] = nil
	end)

	return u35
end
