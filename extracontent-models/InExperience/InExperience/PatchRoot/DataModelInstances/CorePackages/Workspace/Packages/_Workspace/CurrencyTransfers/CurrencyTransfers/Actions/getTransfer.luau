local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)
require(CurrencyTransfers.Models.GetTransferByIdModel)
require(CurrencyTransfers.Models.ErrorTransferModel)
local handleGetError = require(CurrencyTransfers.Actions.handleGetError)

local function getTransfer(data)
	local networkImpl = data.getNetworkImpl()
	local setRobuxTransfer = data.setRobuxTransfer
	local transferRequestId = data.getTransferRequestId(false)

	if transferRequestId then
		return getTransferRequestByIdRequest({ transferRequestId = transferRequestId }, nil, networkImpl):andThen(function(p)
			if p and p.transfer then
				setRobuxTransfer(p.transfer)
			else
				handleGetError(data, nil)
			end
		end):catch(function(p)
			if typeof(p) == "table" and p.errorMessage then
				handleGetError(data, p)
			else
				handleGetError(data, nil)
			end
		end)
	end

	handleGetError(data, nil)
end

return getTransfer
