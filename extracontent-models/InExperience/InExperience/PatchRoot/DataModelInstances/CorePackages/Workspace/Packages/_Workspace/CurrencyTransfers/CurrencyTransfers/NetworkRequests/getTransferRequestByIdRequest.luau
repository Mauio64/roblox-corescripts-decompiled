local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)
local Promise = require(parent.Promise)

local GetTransferByIdModel = require(CurrencyTransfers.Models.GetTransferByIdModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function getTransferByIdUrl(transferRequestId: string)
	return urlBuilder.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/transfer/{transferRequestId}`
	})()
end

local strictInterface = t.strictInterface({ transferRequestId = t.string })

local function getTransferRequestByIdRequest(p, p2, p3)
	assert(strictInterface(p))
	local v

	if p3 == nil then
		v = HttpRequest.new(p2)
	else
		v = HttpRequest.fromNetworkImpl(p3)
	end

	return v:get(getTransferByIdUrl(p.transferRequestId)):andThen(function(p4)
		return GetTransferByIdModel.format(p4)
	end):catch(function(p4)
		return Promise.reject(p4)
	end)
end

return getTransferRequestByIdRequest
