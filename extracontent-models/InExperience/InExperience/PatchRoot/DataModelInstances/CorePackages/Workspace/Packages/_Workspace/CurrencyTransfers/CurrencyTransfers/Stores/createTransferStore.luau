local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local Signals = require(parent.Signals)

local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.types)
require(CurrencyTransfers.Enums.TransferDirection)
require(CurrencyTransfers.Enums.TransferOrigination)
require(CurrencyTransfers.Models.ErrorTransferModel)
require(CurrencyTransfers.Enums.TransferRetryOrigin)
require(CurrencyTransfers.Enums.TransferBenefitSource)

return function()
	local signal, setPromptState = Signals.createSignal(PromptState.Unspecified)
	local signal2, setTransferRequestId = Signals.createSignal(nil)
	local signal3, setRecipientUserId = Signals.createSignal(0)
	local signal4, setRobuxBalanceAmount = Signals.createSignal(0)
	local signal5, setBalanceReceivedFromApi = Signals.createSignal(false)
	local signal6, setSelectedAmount = Signals.createSignal(nil)
	local signal7, setUserRelationshipDetail = Signals.createSignal(nil)
	local signal8, setRecipient = Signals.createSignal(nil)
	local signal9, setSender = Signals.createSignal(nil)
	local signal10, setDirection = Signals.createSignal(nil)
	local signal11, setTransferOrigination = Signals.createSignal(nil)
	local signal12, setRobuxTransfer = Signals.createSignal(nil)
	local signal13, setIsAlreadyAccepted = Signals.createSignal(false)
	local signal14, setErrorTransferModel = Signals.createSignal(nil)
	local signal15, setAmpRecourseActions = Signals.createSignal(nil)
	local signal16, setAmpFeatureCheck = Signals.createSignal(nil)
	local signal17, setPreviousPromptState = Signals.createSignal(nil)
	local signal18, setTransferRetryOrigin = Signals.createSignal(nil)
	local signal19, setTransferClientSessionId = Signals.createSignal("")
	local signal20, setMinimumTransferAmount = Signals.createSignal(nil)
	local signal21, setMaximumTransferAmount = Signals.createSignal(nil)
	local signal22, setTransferBenefitSource = Signals.createSignal(nil)
	local signal23, setNumFreeTransfersRemaining = Signals.createSignal(nil)
	local signal24, setFreeTransfersExhausted = Signals.createSignal(false)

	local v = nil
	local v2 = nil
	local v3 = nil
	local v4 = false

	local function setOnClose(callback)
		v = callback
	end

	local function triggerOnClose()
		if v then
			v()
		end
	end

	local function setOnPromptOptimisticHide(callback)
		v2 = callback
	end

	local function triggerOnPromptOptimisticHide()
		if v2 then
			v2()
		end
	end

	local function setOnPromptDismissCommitted(callback)
		v3 = callback
		v4 = false
	end

	local function triggerOnPromptDismissCommitted()
		if v4 or v3 == nil then
			return
		end

		v4 = true
		v3()
	end

	local networkImpl = nil
	local function setNetworkImpl(p)
		networkImpl = p
	end
	local function getNetworkImpl()
		return networkImpl
	end

	return {
		getPromptState = signal,
		setPromptState = setPromptState,
		getTransferRequestId = signal2,
		setTransferRequestId = setTransferRequestId,
		getRecipientUserId = signal3,
		setRecipientUserId = setRecipientUserId,
		getRobuxBalanceAmount = signal4,
		setRobuxBalanceAmount = setRobuxBalanceAmount,
		getBalanceReceivedFromApi = signal5,
		setBalanceReceivedFromApi = setBalanceReceivedFromApi,
		getSelectedAmount = signal6,
		setSelectedAmount = setSelectedAmount,
		getUserRelationshipDetail = signal7,
		setUserRelationshipDetail = setUserRelationshipDetail,
		getRecipient = signal8,
		setRecipient = setRecipient,
		getSender = signal9,
		setSender = setSender,
		getDirection = signal10,
		setDirection = setDirection,
		getTransferOrigination = signal11,
		setTransferOrigination = setTransferOrigination,
		getRobuxTransfer = signal12,
		setRobuxTransfer = setRobuxTransfer,
		getIsAlreadyAccepted = signal13,
		setIsAlreadyAccepted = setIsAlreadyAccepted,
		getErrorTransferModel = signal14,
		setErrorTransferModel = setErrorTransferModel,
		getAmpRecourseActions = signal15,
		setAmpRecourseActions = setAmpRecourseActions,
		getAmpFeatureCheck = signal16,
		setAmpFeatureCheck = setAmpFeatureCheck,
		getPreviousPromptState = signal17,
		setPreviousPromptState = setPreviousPromptState,
		getTransferRetryOrigin = signal18,
		setTransferRetryOrigin = setTransferRetryOrigin,
		getTransferClientSessionId = signal19,
		setTransferClientSessionId = setTransferClientSessionId,
		getMinimumTransferAmount = signal20,
		setMinimumTransferAmount = setMinimumTransferAmount,
		getMaximumTransferAmount = signal21,
		setMaximumTransferAmount = setMaximumTransferAmount,
		getTransferBenefitSource = signal22,
		setTransferBenefitSource = setTransferBenefitSource,
		getNumFreeTransfersRemaining = signal23,
		setNumFreeTransfersRemaining = setNumFreeTransfersRemaining,
		getFreeTransfersExhausted = signal24,
		setFreeTransfersExhausted = setFreeTransfersExhausted,
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
