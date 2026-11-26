local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Signals")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/types")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferBenefitSource")

return function()
	local signal, v5 = Signals.createSignal(PromptState.Unspecified)
	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal(0)
	local signal4, v8 = Signals.createSignal(0)
	local signal5, v9 = Signals.createSignal(false)
	local signal6, v10 = Signals.createSignal(nil)
	local signal7, v11 = Signals.createSignal(nil)
	local signal8, v12 = Signals.createSignal(nil)
	local signal9, v13 = Signals.createSignal(nil)
	local signal10, v14 = Signals.createSignal(nil)
	local signal11, v15 = Signals.createSignal(nil)
	local signal12, v16 = Signals.createSignal(nil)
	local signal13, v17 = Signals.createSignal(false)
	local signal14, v18 = Signals.createSignal(nil)
	local signal15, v19 = Signals.createSignal(nil)
	local signal16, v20 = Signals.createSignal(nil)
	local signal17, v21 = Signals.createSignal(nil)
	local signal18, v22 = Signals.createSignal(nil)
	local signal19, v23 = Signals.createSignal("")
	local signal20, v24 = Signals.createSignal(nil)
	local signal21, v25 = Signals.createSignal(nil)
	local signal22, v26 = Signals.createSignal(nil)
	local signal23, v27 = Signals.createSignal(nil)
	local signal24, v28 = Signals.createSignal(false)

	local v29 = nil
	local v30 = nil
	local v31 = nil
	local v32 = false

	local function setOnClose(p2)
		v29 = p2
	end

	local function triggerOnClose()
		if v29 then
			v29()
		end
	end

	local function setOnPromptOptimisticHide(p2)
		v30 = p2
	end

	local function triggerOnPromptOptimisticHide()
		if v30 then
			v30()
		end
	end

	local function setOnPromptDismissCommitted(p2)
		v31 = p2
		v32 = false
	end

	local function triggerOnPromptDismissCommitted()
		if v32 or v31 == nil then
			return
		end

		v32 = true
		v31()
	end

	local networkImpl = nil
	local function setNetworkImpl(p2)
		networkImpl = p2
	end
	local function getNetworkImpl()
		return networkImpl
	end

	return {
		getPromptState = signal,
		setPromptState = v5,
		getTransferRequestId = signal2,
		setTransferRequestId = v6,
		getRecipientUserId = signal3,
		setRecipientUserId = v7,
		getRobuxBalanceAmount = signal4,
		setRobuxBalanceAmount = v8,
		getBalanceReceivedFromApi = signal5,
		setBalanceReceivedFromApi = v9,
		getSelectedAmount = signal6,
		setSelectedAmount = v10,
		getUserRelationshipDetail = signal7,
		setUserRelationshipDetail = v11,
		getRecipient = signal8,
		setRecipient = v12,
		getSender = signal9,
		setSender = v13,
		getDirection = signal10,
		setDirection = v14,
		getTransferOrigination = signal11,
		setTransferOrigination = v15,
		getRobuxTransfer = signal12,
		setRobuxTransfer = v16,
		getIsAlreadyAccepted = signal13,
		setIsAlreadyAccepted = v17,
		getErrorTransferModel = signal14,
		setErrorTransferModel = v18,
		getAmpRecourseActions = signal15,
		setAmpRecourseActions = v19,
		getAmpFeatureCheck = signal16,
		setAmpFeatureCheck = v20,
		getPreviousPromptState = signal17,
		setPreviousPromptState = v21,
		getTransferRetryOrigin = signal18,
		setTransferRetryOrigin = v22,
		getTransferClientSessionId = signal19,
		setTransferClientSessionId = v23,
		getMinimumTransferAmount = signal20,
		setMinimumTransferAmount = v24,
		getMaximumTransferAmount = signal21,
		setMaximumTransferAmount = v25,
		getTransferBenefitSource = signal22,
		setTransferBenefitSource = v26,
		getNumFreeTransfersRemaining = signal23,
		setNumFreeTransfersRemaining = v27,
		getFreeTransfersExhausted = signal24,
		setFreeTransfersExhausted = v28,
		setOnClose = setOnClose,
		triggerOnClose = triggerOnClose,
		setOnPromptOptimisticHide = setOnPromptOptimisticHide,
		triggerOnPromptOptimisticHide = triggerOnPromptOptimisticHide,
		setOnPromptDismissCommitted = setOnPromptDismissCommitted,
		triggerOnPromptDismissCommitted = triggerOnPromptDismissCommitted,
		getNetworkImpl = getNetworkImpl,
		setNetworkImpl = setNetworkImpl
	}
end
