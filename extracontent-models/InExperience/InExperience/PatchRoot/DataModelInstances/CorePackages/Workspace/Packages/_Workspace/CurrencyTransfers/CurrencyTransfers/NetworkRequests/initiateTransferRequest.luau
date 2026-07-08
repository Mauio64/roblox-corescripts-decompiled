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

local function initiateTransferRequest(p1, p2) -- line: 32
	-- upvalues: v12 (copy), HttpRequest (copy), TransferOrigination (copy), v11 (copy), InitiateTransferModel (copy), Promise (copy)
	assert(v12(p1))

	local v16 = HttpRequest.new(p2)
	local v17 = p1.transferOrigination or TransferOrigination.Unknown
	local v18 = TransferOrigination.toEnumInteger[v17] or TransferOrigination.toEnumInteger[TransferOrigination.Unknown]
	local t1 = {
		recipientId = p1.recipientId,
		transferOrigin = v18
	}

	return v16:post(v11, t1):andThen(function(p3) -- line: 47
		-- upvalues: InitiateTransferModel (copy)
		print("[initiateTransferRequest] Backend response (success):", p3)

		return (InitiateTransferModel.format(p3))
	end):catch(function(p4) -- line: 52
		-- upvalues: Promise (copy)
		print("[initiateTransferRequest] Backend response (error):", p4)

		return Promise.reject(p4)
	end)
end

return initiateTransferRequest
