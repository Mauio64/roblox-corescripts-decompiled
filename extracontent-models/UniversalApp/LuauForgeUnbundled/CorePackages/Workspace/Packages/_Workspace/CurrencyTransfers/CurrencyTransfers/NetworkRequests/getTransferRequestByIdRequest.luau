local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")

local GetTransferByIdModel = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/GetTransferByIdModel")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/HttpRequest")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local function getTransferByIdUrl(transferRequestId)
	return urlBuilder.new({
		base = urlBase.APIS,
		path = `transfer/v1/robux-transfer/transfer/{transferRequestId}`
	})()
end

local strictInterface = t.strictInterface({ transferRequestId = t.string })

local function getTransferRequestByIdRequest(p2, p3, p4)
	assert(strictInterface(p2))
	local v5 = if p4 == nil then HttpRequest.new(p3) else HttpRequest.fromNetworkImpl(p4)

	return v5:get(getTransferByIdUrl(p2.transferRequestId)):andThen(function(p5)
		return GetTransferByIdModel.format(p5)
	end):catch(function(p5)
		return Promise.reject(p5)
	end)
end

return getTransferRequestByIdRequest
