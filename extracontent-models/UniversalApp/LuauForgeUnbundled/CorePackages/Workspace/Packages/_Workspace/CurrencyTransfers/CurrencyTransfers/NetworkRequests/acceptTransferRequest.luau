local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")

local AcceptTransferModel = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/AcceptTransferModel")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/HttpRequest")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local function acceptTransferUrl(p2)
	return urlBuilder.new({
		base = urlBase.APIS,
		path = `transfer/v1/robux-transfer/accept-transfer/{p2}`
	})()
end

local strictInterface = t.strictInterface({ transferRequestId = t.string })

local function acceptTransferRequest(p2, p3, p4)
	assert(strictInterface(p2))
	local v5 = if p4 == nil then HttpRequest.new(p3) else HttpRequest.fromNetworkImpl(p4)

	local transferRequestId = p2.transferRequestId
	return v5:post(
		urlBuilder.new({
			base = urlBase.APIS,
			path = `transfer/v1/robux-transfer/accept-transfer/{transferRequestId}`
		})(),
		{ recipientId = 0 }
	):andThen(function(p5)
		return AcceptTransferModel.format(p5)
	end):catch(function(p5)
		return Promise.reject(p5)
	end)
end

return acceptTransferRequest
