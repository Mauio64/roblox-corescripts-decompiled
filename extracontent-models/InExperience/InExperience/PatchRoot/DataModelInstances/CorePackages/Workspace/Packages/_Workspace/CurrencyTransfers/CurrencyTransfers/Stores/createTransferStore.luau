local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local Signals = require(CurrencyTransfersParent.Signals)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

require(CurrencyTransfers.types)
require(CurrencyTransfers.Enums.TransferDirection)
require(CurrencyTransfers.Enums.TransferOrigination)
require(CurrencyTransfers.Models.ErrorTransferModel)
require(CurrencyTransfers.Enums.TransferRetryOrigin)

return function() -- line: 72
	-- upvalues: Signals (copy), PromptState (copy)
	local v5, v6 = Signals.createSignal(PromptState.Unspecified)
	local v7, v8 = Signals.createSignal(nil)
	local v9, v10 = Signals.createSignal(0)
	local v11, v12 = Signals.createSignal(0)
	local v13, v14 = Signals.createSignal(false)
	local v15, v16 = Signals.createSignal(nil)
	local v17, v18 = Signals.createSignal(nil)
	local v19, v20 = Signals.createSignal(nil)
	local v21, v22 = Signals.createSignal(nil)
	local v23, v24 = Signals.createSignal(nil)
	local v25, v26 = Signals.createSignal(nil)
	local v27, v28 = Signals.createSignal(nil)
	local v29, v30 = Signals.createSignal(false)
	local v31, v32 = Signals.createSignal(nil)
	local v33, v34 = Signals.createSignal(nil)
	local v35, v36 = Signals.createSignal(nil)
	local v37, v38 = Signals.createSignal(nil)
	local v39, v40 = Signals.createSignal(nil)
	local v41, v42 = Signals.createSignal("")
	local v43, v44 = Signals.createSignal(nil)
	local v45, v46 = Signals.createSignal(nil)
	local u47 = nil
	local u48 = nil

	return {
		getPromptState = v5,
		setPromptState = v6,
		getTransferRequestId = v7,
		setTransferRequestId = v8,
		getRecipientUserId = v9,
		setRecipientUserId = v10,
		getRobuxBalanceAmount = v11,
		setRobuxBalanceAmount = v12,
		getBalanceReceivedFromApi = v13,
		setBalanceReceivedFromApi = v14,
		getSelectedAmount = v15,
		setSelectedAmount = v16,
		getUserRelationshipDetail = v17,
		setUserRelationshipDetail = v18,
		getRecipient = v19,
		setRecipient = v20,
		getSender = v21,
		setSender = v22,
		getDirection = v23,
		setDirection = v24,
		getTransferOrigination = v25,
		setTransferOrigination = v26,
		getRobuxTransfer = v27,
		setRobuxTransfer = v28,
		getIsAlreadyAccepted = v29,
		setIsAlreadyAccepted = v30,
		getErrorTransferModel = v31,
		setErrorTransferModel = v32,
		getAmpRecourseActions = v33,
		setAmpRecourseActions = v34,
		getAmpFeatureCheck = v35,
		setAmpFeatureCheck = v36,
		getPreviousPromptState = v37,
		setPreviousPromptState = v38,
		getTransferRetryOrigin = v39,
		setTransferRetryOrigin = v40,
		getTransferClientSessionId = v41,
		setTransferClientSessionId = v42,
		getMinimumTransferAmount = v43,
		setMinimumTransferAmount = v44,
		getMaximumTransferAmount = v45,
		setMaximumTransferAmount = v46,
		setOnClose = function(p1: ((...any) -> ...any)?) -- line: 98
			-- upvalues: u47 (ref)
			u47 = p1
		end,
		triggerOnClose = function() -- line: 102
			-- upvalues: u47 (ref)
			if u47 then
				u47()
			end
		end,
		getNetworkImpl = function() -- line: 114
			-- upvalues: u48 (ref)
			return u48
		end,
		setNetworkImpl = function(p2) -- line: 111
			-- upvalues: u48 (ref)
			u48 = p2
		end
	}
end
