local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)
local Promise = require(parent.Promise)

local InitiateTransferModel = require(CurrencyTransfers.Models.InitiateTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "transfer/v1/robux-transfer/initiate-transfer"
})()

local strictInterface = t.strictInterface({
	recipientId = t.number,
	transferOrigination = t.optional(t.string)
})

local function initiateTransferRequest(p, p2, p3)
	assert(strictInterface(p))
	local v2

	if p3 == nil then
		v2 = HttpRequest.new(p2)
	else
		v2 = HttpRequest.fromNetworkImpl(p3)
	end

	local transferOrigination = p.transferOrigination or TransferOrigination.Unknown
	local transferOrigin = TransferOrigination.toEnumInteger[transferOrigination]
		or TransferOrigination.toEnumInteger[TransferOrigination.Unknown]
	return v2:post(v, { recipientId = p.recipientId, transferOrigin = transferOrigin }):andThen(function(p4)
		return InitiateTransferModel.format(p4)
	end):catch(function(p4)
		return Promise.reject(p4)
	end)
end

return initiateTransferRequest
