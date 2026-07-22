local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local UrlBuilder = require(CurrencyTransfersParent.UrlBuilder)
local t = require(CurrencyTransfersParent.t)
local Promise = require(CurrencyTransfersParent.Promise)
local InitiateTransferModel = require(CurrencyTransfers.Models.InitiateTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local v11 = UrlBuilder2.new({
	path = "transfer/v1/robux-transfer/initiate-transfer",
	base = UrlBase.APIS
})()
local v12 = t.strictInterface({
	recipientId = t.number,
	transferOrigination = t.optional(t.string)
})

local function initiateTransferRequest(p1, p2, p3) -- line: 32
	-- upvalues: v12 (copy), HttpRequest (copy), TransferOrigination (copy), v11 (copy), InitiateTransferModel (copy), Promise (copy)
	assert(v12(p1))

	local v17 = if p3 == nil then HttpRequest.new(p2) else HttpRequest.fromNetworkImpl(p3)
	local v18 = p1.transferOrigination or TransferOrigination.Unknown
	local v19 = TransferOrigination.toEnumInteger[v18] or TransferOrigination.toEnumInteger[TransferOrigination.Unknown]
	local t1 = {
		recipientId = p1.recipientId,
		transferOrigin = v19
	}

	return v17:post(v11, t1):andThen(function(p4) -- line: 49
		-- upvalues: InitiateTransferModel (copy)
		print("[initiateTransferRequest] Backend response (success):", p4)

		return (InitiateTransferModel.format(p4))
	end):catch(function(p5) -- line: 54
		-- upvalues: Promise (copy)
		print("[initiateTransferRequest] Backend response (error):", p5)

		return Promise.reject(p5)
	end)
end

return initiateTransferRequest
