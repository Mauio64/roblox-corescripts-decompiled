local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local UrlBuilder = require(CurrencyTransfersParent.UrlBuilder)
local t = require(CurrencyTransfersParent.t)
local Promise = require(CurrencyTransfersParent.Promise)
local GetTransferByIdModel = require(CurrencyTransfers.Models.GetTransferByIdModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function getTransferByIdUrl(s1: string) -- line: 20
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy)
	return UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/transfer/{ s1 }`
	})()
end

local v11 = t.strictInterface({
	transferRequestId = t.string
})

local function getTransferRequestByIdRequest(p1, p2, p3) -- line: 31
	-- upvalues: v11 (copy), HttpRequest (copy), getTransferByIdUrl (copy), GetTransferByIdModel (copy), Promise (copy)
	assert(v11(p1))

	return ((if p3 == nil then HttpRequest.new(p2) else HttpRequest.fromNetworkImpl(p3))):get(getTransferByIdUrl(p1.transferRequestId)):andThen(function(p4) -- line: 39
		-- upvalues: GetTransferByIdModel (copy)
		return GetTransferByIdModel.format(p4)
	end):catch(function(p5) -- line: 42
		-- upvalues: Promise (copy)
		return Promise.reject(p5)
	end)
end

return getTransferRequestByIdRequest
