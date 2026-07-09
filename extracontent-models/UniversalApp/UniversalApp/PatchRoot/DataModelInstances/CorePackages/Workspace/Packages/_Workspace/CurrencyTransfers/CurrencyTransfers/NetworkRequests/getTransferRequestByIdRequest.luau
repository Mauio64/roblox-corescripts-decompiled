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

local function getTransferRequestByIdRequest(p1, p2) -- line: 31
	-- upvalues: v11 (copy), HttpRequest (copy), getTransferByIdUrl (copy), GetTransferByIdModel (copy), Promise (copy)
	assert(v11(p1))

	return HttpRequest.new(p2):get(getTransferByIdUrl(p1.transferRequestId)):andThen(function(p3) -- line: 37
		-- upvalues: GetTransferByIdModel (copy)
		return GetTransferByIdModel.format(p3)
	end):catch(function(p4) -- line: 40
		-- upvalues: Promise (copy)
		return Promise.reject(p4)
	end)
end

return getTransferRequestByIdRequest
