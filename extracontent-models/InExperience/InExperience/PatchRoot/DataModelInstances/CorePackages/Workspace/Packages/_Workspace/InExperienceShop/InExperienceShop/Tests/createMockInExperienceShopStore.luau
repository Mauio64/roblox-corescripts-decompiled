local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local JestGlobals = require(parent.Dev.JestGlobals)
local jest = JestGlobals.jest
local Signals = require(parent.Signals)

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
require(InExperienceShop.Api.BonusPromotionEligibility)

local function createMockInExperienceShopStore()
	local signal, setCategories = Signals.createSignal({})
	local signal2, setSections = Signals.createSignal({})
	local signal3, setLoading = Signals.createSignal(false)
	local signal4, setError = Signals.createSignal(nil)
	local signal5, setOwnership = Signals.createSignal({})

	local signal6, setTrialAvailabilities = Signals.createSignal({
		available = {},
		active = {},
		redeemed = {}
	})
	local signal7, setTrialAvailabilityPhase = Signals.createSignal("settled")
	local signal8, setTrialRedemptionInFlight = Signals.createSignal({})
	local signal9, setTrialRedeemSuccessCount = Signals.createSignal(0)
	local signal10, setNotificationFreeTrialTopBarChip = Signals.createSignal(false)

	local signal11, setTrialRedemptionError = Signals.createSignal(nil)

	local signal12, setBonusPromotionEligibility = Signals.createSignal({})

	local signal13, setItemsPerRow = Signals.createSignal(Constants.MIN_COLUMNS)
	local signal14, setShouldOpenToRobuxTab = Signals.createSignal(false)
	local signal15, setOpenedFromBuyRobux = Signals.createSignal(false)

	local signal16, setPurchasedRobuxAmount = Signals.createSignal(nil)

	return {
		store = {
			getCategories = signal,
			getSections = signal2,
			getLoading = signal3,
			getError = signal4,
			getOwnership = signal5,
			getTrialAvailabilities = signal6,
			getTrialAvailabilityPhase = signal7,
			getTrialRedemptionInFlight = signal8,
			getTrialRedeemSuccessCount = signal9,
			getNotificationFreeTrialTopBarChip = signal10,
			getTrialRedemptionError = signal11,
			dismissTrialRedemptionError = function()
				setTrialRedemptionError(nil)
			end,
			getBonusPromotionEligibility = signal12,
			getItemsPerRow = signal13,
			getShouldOpenToRobuxTab = signal14,
			getOpenedFromBuyRobux = signal15,
			getPurchasedRobuxAmount = signal16,
			dismissRobuxPurchaseSuccess = function()
				setPurchasedRobuxAmount(nil)
			end,
			onShopOpened = jest.fn(),
			fetchAllShopData = jest.fn(),
			prefetchWidgetsOnly = jest.fn(),
			refreshShopItemInfo = jest.fn(),
			refreshRobuxWidgetsAfterPurchase = jest.fn(),
			fetchGamePassOwnership = jest.fn(),
			redeemGamePassTrial = jest.fn(),
			pollGamePassOwnership = jest.fn(),
			bonusGamePassIdForNativePurchase = jest.fn(),
			setItemsPerRow = setItemsPerRow,
			setShouldOpenToRobuxTab = setShouldOpenToRobuxTab,
			setOpenedFromBuyRobux = setOpenedFromBuyRobux
		},
		setCategories = setCategories,
		setSections = setSections,
		setLoading = setLoading,
		setError = setError,
		setOwnership = setOwnership,
		setTrialAvailabilities = setTrialAvailabilities,
		setTrialAvailabilityPhase = setTrialAvailabilityPhase,
		setTrialRedemptionInFlight = setTrialRedemptionInFlight,
		setTrialRedeemSuccessCount = setTrialRedeemSuccessCount,
		setNotificationFreeTrialTopBarChip = setNotificationFreeTrialTopBarChip,
		setTrialRedemptionError = setTrialRedemptionError,
		setBonusPromotionEligibility = setBonusPromotionEligibility,
		setItemsPerRow = setItemsPerRow,
		setPurchasedRobuxAmount = setPurchasedRobuxAmount
	}
end

return createMockInExperienceShopStore
