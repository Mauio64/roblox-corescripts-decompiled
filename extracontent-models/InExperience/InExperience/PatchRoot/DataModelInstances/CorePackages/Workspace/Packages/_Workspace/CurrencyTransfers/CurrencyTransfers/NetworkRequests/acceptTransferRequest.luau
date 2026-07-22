local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local UrlBuilder = require(CurrencyTransfersParent.UrlBuilder)
local t = require(CurrencyTransfersParent.t)
local Promise = require(CurrencyTransfersParent.Promise)
local AcceptTransferModel = require(CurrencyTransfers.Models.AcceptTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function acceptTransferUrl(s1: string) -- line: 20
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy)
	return UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/accept-transfer/{ s1 }`
	})()
end

local v11 = t.strictInterface({
	transferRequestId = t.string
})

local function acceptTransferRequest(p1, p2, p3) -- line: 31
	-- upvalues: v11 (copy), HttpRequest (copy), UrlBuilder2 (copy), UrlBase (copy), AcceptTransferModel (copy), Promise (copy)
	assert(v11(p1))

	local v17 = if p3 == nil then HttpRequest.new(p2) else HttpRequest.fromNetworkImpl(p3)
	local transferRequestId = p1.transferRequestId

	return v17:post(UrlBuilder2.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/accept-transfer/{ transferRequestId }`
	})(), {
		recipientId = 0
	}):andThen(function(p4) -- line: 39
		-- upvalues: AcceptTransferModel (copy)
		local v20 = AcceptTransferModel.format(p4)

		print("[acceptTransferRequest] Formatted result:", v20)

		return v20
	end):catch(function(p5) -- line: 44
		-- upvalues: Promise (copy)
		print("[acceptTransferRequest] Error response:", p5)

		return Promise.reject(p5)
	end)
end

return acceptTransferRequest
