local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local UrlBuilder = require(CurrencyTransfersParent.UrlBuilder)
local t = require(CurrencyTransfersParent.t)
local Promise = require(CurrencyTransfersParent.Promise)
local ProcessTransferModel = require(CurrencyTransfers.Models.ProcessTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function processTransferUrl(s1: string) -- line: 21
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy)
	return UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/process-transfer/{ s1 }`
	})()
end

local v11 = t.strictInterface({
	transferRequestId = t.string,
	robuxAmount = t.number
})

local function processTransferRequest(p1, p2, p3) -- line: 33
	-- upvalues: v11 (copy), HttpRequest (copy), UrlBuilder2 (copy), UrlBase (copy), ProcessTransferModel (copy), Promise (copy)
	assert(v11(p1))

	local v17 = if p3 == nil then HttpRequest.new(p2) else HttpRequest.fromNetworkImpl(p3)
	local transferRequestId = p1.transferRequestId

	return v17:post(UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/process-transfer/{ transferRequestId }`
	})(), {
		robuxAmount = p1.robuxAmount
	}):andThen(function(p4) -- line: 43
		-- upvalues: ProcessTransferModel (copy)
		return ProcessTransferModel.format(p4)
	end):catch(function(p5) -- line: 46
		-- upvalues: Promise (copy)
		return Promise.reject(p5)
	end)
end

return processTransferRequest
