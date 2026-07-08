local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local jest = require(InExperienceShopParent.Dev.JestGlobals).jest
local Signals = require(InExperienceShopParent.Signals)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)
require(InExperienceShop.Api.BonusPromotionEligibility)

local function createMockInExperienceShopStore() -- line: 68
	-- upvalues: Signals (copy), Constants (copy), jest (copy)
	local v7, v8 = Signals.createSignal({})
	local v9, v10 = Signals.createSignal({})
	local v11, v12 = Signals.createSignal(false)
	local v13, v14 = Signals.createSignal(nil)
	local v15, v16 = Signals.createSignal({})
	local v17, v18 = Signals.createSignal({})
	local v19, v20 = Signals.createSignal(Constants.MIN_COLUMNS)

	return {
		store = {
			getCategories = v7,
			getSections = v9,
			getLoading = v11,
			getError = v13,
			getOwnership = v15,
			getBonusPromotionEligibility = v17,
			getItemsPerRow = v19,
			onShopOpened = jest.fn(),
			fetchAllShopData = jest.fn(),
			prefetchWidgetsOnly = jest.fn(),
			refreshShopItemInfo = jest.fn(),
			fetchGamePassOwnership = jest.fn(),
			pollGamePassOwnership = jest.fn(),
			setItemsPerRow = v20
		},
		setCategories = v8,
		setSections = v10,
		setLoading = v12,
		setError = v14,
		setOwnership = v16,
		setBonusPromotionEligibility = v18,
		setItemsPerRow = v20
	}
end

return createMockInExperienceShopStore
