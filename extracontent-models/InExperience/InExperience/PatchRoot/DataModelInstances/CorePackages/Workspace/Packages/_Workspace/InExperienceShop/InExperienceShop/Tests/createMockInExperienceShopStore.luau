local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local JestGlobals = require(parent.Dev.JestGlobals)
local jest = JestGlobals.jest
local Promise = require(parent.Promise)
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

	local signal9, setTrialRedeemThumbnail = Signals.createSignal(nil)
	local signal10, setTrialRedeemSuccessCount = Signals.createSignal(0)
	local signal11, setNotificationFreeTrialTopBarChip = Signals.createSignal(false)
	local signal12, setPurchasedOwnedGamePass = Signals.createSignal(nil)

	local signal13, setTrialRedemptionError = Signals.createSignal(nil)

	local signal14, setBonusPromotionEligibility = Signals.createSignal({})

	local signal15, setItemsPerRow = Signals.createSignal(Constants.MIN_COLUMNS)
	local signal16, setShouldOpenToRobuxTab = Signals.createSignal(false)
	local signal17, setOpenedFromBuyRobux = Signals.createSignal(false)

	local signal18, setPurchasedRobuxAmount = Signals.createSignal(nil)

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
			getTrialRedeemThumbnail = signal9,
			getTrialRedeemSuccessCount = signal10,
			getNotificationFreeTrialTopBarChip = signal11,
			getPurchasedOwnedGamePass = signal12,
			getTrialRedemptionError = signal13,
			dismissTrialRedemptionError = function()
				setTrialRedemptionError(nil)
			end,
			getBonusPromotionEligibility = signal14,
			getItemsPerRow = signal15,
			getShouldOpenToRobuxTab = signal16,
			getOpenedFromBuyRobux = signal17,
			getPurchasedRobuxAmount = signal18,
			dismissRobuxPurchaseSuccess = function()
				setPurchasedRobuxAmount(nil)
			end,
			onShopOpened = jest.fn(),
			fetchAllShopData = jest.fn(),
			prefetchWidgetsOnly = jest.fn(),
			refreshShopItemInfo = jest.fn(),
			refreshRobuxWidgetsAfterPurchase = jest.fn(),
			fetchGamePassOwnership = jest.fn(),
			currentlyOwnsGamePass = jest.fn(function()
				return Promise.resolve(false)
			end),
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
		setTrialRedeemThumbnail = setTrialRedeemThumbnail,
		setTrialRedeemSuccessCount = setTrialRedeemSuccessCount,
		setNotificationFreeTrialTopBarChip = setNotificationFreeTrialTopBarChip,
		setPurchasedOwnedGamePass = setPurchasedOwnedGamePass,
		setTrialRedemptionError = setTrialRedemptionError,
		setBonusPromotionEligibility = setBonusPromotionEligibility,
		setItemsPerRow = setItemsPerRow,
		setPurchasedRobuxAmount = setPurchasedRobuxAmount
	}
end

return createMockInExperienceShopStore
