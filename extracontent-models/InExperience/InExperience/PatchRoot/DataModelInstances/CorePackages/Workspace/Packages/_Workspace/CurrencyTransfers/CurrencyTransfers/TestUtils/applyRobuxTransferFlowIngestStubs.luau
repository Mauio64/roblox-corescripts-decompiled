local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function applyRobuxTransferFlowIngestStubs(t1: {[any]: any}, t2: {[any]: any}?) -- line: 15
	-- upvalues: TransferDirection (copy), PromptState (copy)
	local v7 = if not t2 or t2.direction == nil then TransferDirection.Send else t2.direction

	local function stubIfNil(s1: string, p1: ((...any) -> ...any)) -- line: 18
		-- upvalues: t1 (copy)
		if t1[s1] == nil then
			t1[s1] = p1
		end
	end

	if t1.getDirection == nil then
		function t1.getDirection() -- line: 24
			-- upvalues: v7 (copy)
			return v7
		end
	end

	if t1.getRecipient == nil then
		function t1.getRecipient() -- line: 27
			return nil
		end
	end

	if t1.getRecipientUserId == nil then
		function t1.getRecipientUserId() -- line: 30
			return 0
		end
	end

	if t1.getSender == nil then
		function t1.getSender() -- line: 33
			return nil
		end
	end

	if t1.getTransferRequestId == nil then
		function t1.getTransferRequestId() -- line: 36
			return nil
		end
	end

	if t1.getSelectedAmount == nil then
		function t1.getSelectedAmount() -- line: 39
			return nil
		end
	end

	if t1.getRobuxTransfer == nil then
		function t1.getRobuxTransfer() -- line: 42
			return nil
		end
	end

	if t1.getTransferOrigination == nil then
		function t1.getTransferOrigination() -- line: 45
			return nil
		end
	end

	if t1.getPromptState == nil then
		function t1.getPromptState() -- line: 48
			-- upvalues: PromptState (copy)
			return PromptState.Unspecified
		end
	end

	if t1.getTransferClientSessionId == nil then
		function t1.getTransferClientSessionId() -- line: 51
			return ""
		end
	end

	if t1.getBalanceReceivedFromApi == nil then
		function t1.getBalanceReceivedFromApi() -- line: 54
			return false
		end
	end

	if t1.getRobuxBalanceAmount == nil then
		function t1.getRobuxBalanceAmount() -- line: 57
			return 0
		end
	end

	if t1.getNetworkImpl == nil then
		function t1.getNetworkImpl() -- line: 60
			return nil
		end
	end
end

return applyRobuxTransferFlowIngestStubs
