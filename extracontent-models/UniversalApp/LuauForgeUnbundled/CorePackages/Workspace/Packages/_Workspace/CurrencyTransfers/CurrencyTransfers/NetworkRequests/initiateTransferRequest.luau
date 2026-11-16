local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")

local InitiateTransferModel = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/InitiateTransferModel")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/HttpRequest")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "transfer/v1/robux-transfer/initiate-transfer"
})()

local strictInterface = t.strictInterface({
	recipientId = t.number,
	transferOrigination = t.optional(t.string)
})

local function initiateTransferRequest(p2, p3, p4)
	assert(strictInterface(p2))
	local v6 = if p4 == nil then HttpRequest.new(p3) else HttpRequest.fromNetworkImpl(p4)

	local transferOrigination = p2.transferOrigination or TransferOrigination.Unknown
	local v7 = TransferOrigination.toEnumInteger[transferOrigination] or TransferOrigination.toEnumInteger[TransferOrigination.Unknown]
	return v6:post(v5, { recipientId = p2.recipientId, transferOrigin = v7 }):andThen(function(p5)
		return InitiateTransferModel.format(p5)
	end):catch(function(p5)
		return Promise.reject(p5)
	end)
end

return initiateTransferRequest
