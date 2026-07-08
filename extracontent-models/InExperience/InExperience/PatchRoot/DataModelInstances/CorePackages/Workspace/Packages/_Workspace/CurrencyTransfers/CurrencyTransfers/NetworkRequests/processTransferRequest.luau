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

local function processTransferRequest(p1, p2) -- line: 33
	-- upvalues: v11 (copy), HttpRequest (copy), UrlBuilder2 (copy), UrlBase (copy), ProcessTransferModel (copy), Promise (copy)
	assert(v11(p1))

	local v16 = HttpRequest.new(p2)
	local transferRequestId = p1.transferRequestId

	return v16:post(UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/process-transfer/{ transferRequestId }`
	})(), {
		robuxAmount = p1.robuxAmount
	}):andThen(function(p3) -- line: 41
		-- upvalues: ProcessTransferModel (copy)
		return ProcessTransferModel.format(p3)
	end):catch(function(p4) -- line: 44
		-- upvalues: Promise (copy)
		return Promise.reject(p4)
	end)
end

return processTransferRequest
