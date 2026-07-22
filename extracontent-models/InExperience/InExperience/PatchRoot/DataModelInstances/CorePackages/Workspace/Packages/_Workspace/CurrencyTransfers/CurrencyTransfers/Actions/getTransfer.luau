local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)

require(CurrencyTransfers.Models.GetTransferByIdModel)
require(CurrencyTransfers.Models.ErrorTransferModel)

local handleGetError = require(CurrencyTransfers.Actions.handleGetError)

local function getTransfer(p1) -- line: 12
	-- upvalues: handleGetError (copy), getTransferRequestByIdRequest (copy)
	local v6 = p1.getNetworkImpl()
	local setRobuxTransfer = p1.setRobuxTransfer
	local v8 = p1.getTransferRequestId(false)

	if not v8 then
		handleGetError(p1, nil)

		return
	end

	local t1 = {
		transferRequestId = v8
	}

	return getTransferRequestByIdRequest(t1, nil, v6):andThen(function(p2) -- line: 27
		-- upvalues: setRobuxTransfer (copy), handleGetError (copy), p1 (copy)
		if p2 and p2.transfer then
			setRobuxTransfer(p2.transfer)

			return
		end

		handleGetError(p1, nil)
	end):catch(function(p3) -- line: 34
		-- upvalues: handleGetError (copy), p1 (copy)
		if typeof(p3) == "table" and p3.errorMessage then
			handleGetError(p1, p3)

			return
		end

		handleGetError(p1, nil)
	end)
end

return getTransfer
