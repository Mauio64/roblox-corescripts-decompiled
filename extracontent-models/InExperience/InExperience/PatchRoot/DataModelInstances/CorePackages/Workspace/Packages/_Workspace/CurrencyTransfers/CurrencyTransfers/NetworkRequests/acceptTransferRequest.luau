local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)
local Promise = require(parent.Promise)

local AcceptTransferModel = require(CurrencyTransfers.Models.AcceptTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function acceptTransferUrl(transferRequestId: string) -- 1 equivalent call inferred from this helper
	return urlBuilder.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/accept-transfer/{transferRequestId}`
	})()
end

local strictInterface = t.strictInterface({ transferRequestId = t.string })

local function acceptTransferRequest(p, p2, p3)
	assert(strictInterface(p))
	local v

	if p3 == nil then
		v = HttpRequest.new(p2)
	else
		v = HttpRequest.fromNetworkImpl(p3)
	end

	return v:post(acceptTransferUrl(p.transferRequestId), { recipientId = 0 }):andThen(function(p4) -- inferred equivalent call
		return AcceptTransferModel.format(p4)
	end):catch(function(p4)
		return Promise.reject(p4)
	end)
end

return acceptTransferRequest
