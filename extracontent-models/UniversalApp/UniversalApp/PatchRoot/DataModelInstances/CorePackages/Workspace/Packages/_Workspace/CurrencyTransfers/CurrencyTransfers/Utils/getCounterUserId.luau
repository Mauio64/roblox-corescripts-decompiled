local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)

require(CurrencyTransfers.Stores.createTransferStore)

local function getCounterUserId(p1, p2) -- line: 10
	-- upvalues: TransferDirection (copy)
	if p2 == TransferDirection.Send then
		local v6 = p1.getRecipient(false)

		if v6 then
			return v6.targetId
		end
	else
		local v7 = p1.getSender(false)

		if v7 then
			return v7.targetId
		end
	end

	return nil
end

return getCounterUserId
