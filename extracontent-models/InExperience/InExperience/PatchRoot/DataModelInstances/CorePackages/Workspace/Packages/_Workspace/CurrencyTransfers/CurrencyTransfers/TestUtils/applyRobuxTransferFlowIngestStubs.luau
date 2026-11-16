local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function applyRobuxTransferFlowIngestStubs(p, p2)
	local v

	if p2 and p2.direction ~= nil then
		v = p2.direction
	else
		v = TransferDirection.Send
	end

	local function stubIfNil(p3: string, fn) -- 15 equivalent calls inferred from this helper
		if p[p3] == nil then
			p[p3] = fn
		end
	end

	local function fn()
		return v
	end

	stubIfNil("getDirection", fn) -- inferred equivalent call

	local function fn2(): nil
		return nil
	end

	stubIfNil("getRecipient", fn2) -- inferred equivalent call

	local function fn3(): number
		return 0
	end

	stubIfNil("getRecipientUserId", fn3) -- inferred equivalent call

	local function fn4(): nil
		return nil
	end

	stubIfNil("getSender", fn4) -- inferred equivalent call

	local function fn5(): nil
		return nil
	end

	stubIfNil("getTransferRequestId", fn5) -- inferred equivalent call

	local function fn6(): nil
		return nil
	end

	stubIfNil("getSelectedAmount", fn6) -- inferred equivalent call

	local function fn7(): nil
		return nil
	end

	stubIfNil("getRobuxTransfer", fn7) -- inferred equivalent call

	local function fn8(): nil
		return nil
	end

	stubIfNil("getTransferOrigination", fn8) -- inferred equivalent call

	local function fn9()
		return PromptState.Unspecified
	end

	stubIfNil("getPromptState", fn9) -- inferred equivalent call

	local function fn10(): string
		return ""
	end

	stubIfNil("getTransferClientSessionId", fn10) -- inferred equivalent call

	local function fn11(): boolean
		return false
	end

	stubIfNil("getBalanceReceivedFromApi", fn11) -- inferred equivalent call

	local function fn12(): number
		return 0
	end

	stubIfNil("getRobuxBalanceAmount", fn12) -- inferred equivalent call

	local function fn13(): nil
		return nil
	end

	stubIfNil("getNetworkImpl", fn13) -- inferred equivalent call

	local function fn14(): nil
		return nil
	end

	stubIfNil("triggerOnPromptOptimisticHide", fn14) -- inferred equivalent call

	local function fn15(): nil
		return nil
	end

	stubIfNil("triggerOnPromptDismissCommitted", fn15) -- inferred equivalent call
end

return applyRobuxTransferFlowIngestStubs
