local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local isSideSheetEnabled = require(parent.InExperienceSideSheetUtils.isSideSheetEnabled)

local Constants = require(InExperienceShop.Constants)
local SharedFlags = require(parent.SharedFlags)
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local useShopReportOverflow = require(InExperienceShop.Hooks.useShopReportOverflow)

require(InExperienceShop.Types)

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local FFlagCloseShopOnTrialRedemption = require(InExperienceShop.Flags.FFlagCloseShopOnTrialRedemption)
local FFlagShopRobuxPurchaseCompletionModal = require(InExperienceShop.Flags.FFlagShopRobuxPurchaseCompletionModal)
local formatPrice = require(InExperienceShop.Utils.formatPrice)
local GetFixRobuxTileClickInShop = require(InExperienceShop.Flags.GetFixRobuxTileClickInShop)
local shopItemSelection = require(InExperienceShop.Utils.shopItemSelection)
local resolveItemForSelection = shopItemSelection.resolveItemForSelection
local useShopOfferChip = require(InExperienceShop.Hooks.useShopOfferChip)
local InExperienceOffers = require(parent.InExperienceOffers)
local FFlagHideHeaderForBuyRobuxInExperienceShop = SharedFlags.FFlagHideHeaderForBuyRobuxInExperienceShop

local v = { homeLabel = "CommonUI.Features.Label.Home" }

require(script.Parent.ShopView)

local function isQueryValid(value: string): boolean -- 2 equivalent calls inferred from this helper
	local _, v2 = string.gsub(value, " ", "")
	return #value - v2 >= Constants.SEARCH_MIN_LENGTH
end

local fn

local function useShopViewModel(p)
	local v2 = useTokens()
	local v3 = useLocalization(v)
	local fixRobuxTileClickInShop = GetFixRobuxTileClickInShop()
	local v4 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v5 = SignalsReact.useSignalState(v4.getCategories)
	local v6 = SignalsReact.useSignalState(v4.getSections)
	local itemsPerRow = SignalsReact.useSignalState(v4.getItemsPerRow)
	local v7 = SignalsReact.useSignalState(v4.getShouldOpenToRobuxTab)
	local v8 = SignalsReact.useSignalState(v4.getOpenedFromBuyRobux)
	local robuxPurchaseSuccess = nil

	if FFlagShopRobuxPurchaseCompletionModal then
		local v9 = SignalsReact.useSignalState(v4.getPurchasedRobuxAmount)
		React.useEffect(function()
			if v9 == nil then
				return nil
			end

			return function()
				if v4.getPurchasedRobuxAmount(false) == v9 then
					v4.dismissRobuxPurchaseSuccess()
				end
			end
		end, { v9, v4 })
		local v10 = useLocalization({
			bodyText = v9 ~= nil and {
				"Feature.InExperienceShop.Message.RobuxPurchaseSuccess",
				ROBUX_AMOUNT = formatPrice(v9)
			} or nil
		})

		robuxPurchaseSuccess = v9 ~= nil and {
				bodyText = v10.bodyText,
				onClose = v4.dismissRobuxPurchaseSuccess
			}
			or robuxPurchaseSuccess
	end

	if FFlagCloseShopOnTrialRedemption then
		local current2 = SignalsReact.useSignalState(v4.getTrialRedeemSuccessCount)

		local v9 = SignalsReact.useSignalState(v4.getNotificationFreeTrialTopBarChip)
		local ref = React.useRef(current2)
		React.useEffect(function()
			local current = ref.current

			ref.current = current2

			if current < current2 and v9 then
				p.toggleWindow()
			end
		end, { current2, v9, p.toggleWindow })
	end

	local v9 = React.useMemo(function()
		return fn(v5, v6)
	end, { v5, v6 })

	local homeLabel = v3.homeLabel
	local tabs = React.useMemo(function()
		local result = table.create(#v9.categories)

		for k, category in v9.categories do
			local text

			if category.id == "home" then
				text = homeLabel
			else
				text = category.name
			end

			result[k] = { id = category.id, text = text }
		end

		return result
	end, { v9.categories, homeLabel })

	local v10 = React.useCallback(function()
		if not isSideSheetEnabled then
			return nil
		end

		for _, category in v9.categories do
			if category.name == "Robux" then
				return category.id
			end
		end

		return nil
	end, { v9.categories })

	local state, setState = React.useState(function()
		if isSideSheetEnabled and v7 then
			local v11 = v10()

			if v11 ~= nil then
				return v11
			end
		end

		return if #v9.categories > 0 then v9.categories[1].id else ""
	end)

	local state2, setState2 = React.useState(function(): nil
		return nil
	end)

	local state3, setState3 = React.useState(function(): nil
		return nil
	end)

	React.useEffect(function()
		local categories = v9.categories

		if #categories == 0 then
			return
		end

		setState(function(p2)
			for _, category in categories do
				if category.id == p2 then
					return p2
				end
			end

			return categories[1].id
		end)
	end, { v9.categories })

	React.useEffect(function()
		if isSideSheetEnabled and v7 and #v9.categories > 0 then
			v4.setShouldOpenToRobuxTab(false)
			local v11 = v10()

			if v11 ~= nil then
				setState(v11)
			end
		end
	end, { v10, v9.categories, v7, v4.setShouldOpenToRobuxTab })
	local v11

	if FFlagHideHeaderForBuyRobuxInExperienceShop then
		v11 = React.useMemo(function()
			if #v9.categories ~= 2 then
				return false
			end

			local v12 = false
			local v13 = false

			for _, category in v9.categories do
				if category.name == "CommonUI.Features.Label.Home" then
					v12 = true
				elseif category.name == "Robux" then
					v13 = true
				end
			end

			return v12 and v13
		end, { v9.categories })

		React.useEffect(function()
			return function()
				v4.setOpenedFromBuyRobux(false)
			end
		end, { v4.setOpenedFromBuyRobux })
	else
		v11 = false
	end

	React.useEffect(function()
		if state2 == nil or state3 == nil then
			return
		end

		if resolveItemForSelection(v9.sections, state2, state3, fixRobuxTileClickInShop) == nil then
			setState2(nil)
			setState3(nil)
		end
	end, { v9.sections, state2, state3, fixRobuxTileClickInShop })

	local selectedItem = React.useMemo(function()
		return resolveItemForSelection(v9.sections, state2, state3, fixRobuxTileClickInShop)
	end, { v9.sections, state2, state3, fixRobuxTileClickInShop })

	local selectedItemDisableBuy = React.useMemo(function()
		return shopItemSelection.isRobuxBonusOnlySelection(v9.sections, state2, state3, fixRobuxTileClickInShop)
	end, { v9.sections, state2, state3, fixRobuxTileClickInShop })

	local onCategorySelected = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local state4, setState4 = React.useState("")
	local state5, setState5 = React.useState("")

	React.useEffect(function()
		if isQueryValid(state4) then -- inferred equivalent call
			local flag = false
			task.delay(Constants.SEARCH_DEBOUNCE_SECONDS, function()
				if flag then
					return
				end

				setState5(state4)
			end)
			return function()
				flag = true
			end
		end

		setState5("")
	end, { state4 })

	local onSearchQueryChanged = React.useCallback(function(p2: string)
		setState4(p2)
	end, {})

	local onSearchSubmit = React.useCallback(function(value: string)
		setState4(value)

		if isQueryValid(value) then -- inferred equivalent call
			setState5(value)
		else
			setState5("")
		end
	end, {})

	local onItemActivated = React.useCallback(function(p2: string, p3)
		if not (p3 ~= nil and resolveItemForSelection(v9.sections, p2, p3, fixRobuxTileClickInShop) ~= nil) then
			return
		end

		setState2(p2)
		setState3(p3)
	end, { v9.sections, fixRobuxTileClickInShop })

	local onDetailsClose = React.useCallback(function()
		setState2(nil)
		setState3(nil)
	end, {})

	local state6, setState6 = React.useState(false)

	local onSearchOpen = React.useCallback(function()
		setState6(true)
	end, {})

	local onSearchCancel = React.useCallback(function()
		setState6(false)
		setState4("")
		setState5("")
	end, {})

	local setItemsPerRow = v4.setItemsPerRow

	local state7, setState7 = React.useState(false)

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X

		if x == 0 then
			return
		end

		local v12 = math.floor(x / Constants.MIN_TILE_WIDTH)
		setItemsPerRow((math.max(Constants.MIN_COLUMNS, (math.min(Constants.ITEMS_PER_SECTION, v12)))))
		setState7(x < Constants.COMPACT_BREAKPOINT_WIDTH)
	end, { setItemsPerRow, setState7 })

	local fFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop

	local buildReportSession = React.useCallback(function()
		return { abuseVector = AbuseVector.InExperienceShop, targetId = tostring(game.PlaceId) }
	end, {})

	local v12 = useShopReportOverflow.useShopReportOverflow({
		isReportingEnabled = fFlagEnableReportingFlowForExperienceShop,
		buildReportSession = buildReportSession
	})

	local offer = useShopOfferChip(InExperienceOffers.FeatureKeys.RobloxShop, state7)

	return {
		fullScreen = p.fullScreen,
		overMediaColor = v2.Color.OverMedia.OverMedia_0.Color3,
		overMediaTransparency = v2.Color.OverMedia.OverMedia_0.Transparency,
		onClose = p.toggleWindow,
		robuxPurchaseSuccess = robuxPurchaseSuccess,
		tabs = tabs,
		hideTabs = FFlagHideHeaderForBuyRobuxInExperienceShop and v8 and v11,
		selectedCategoryId = state,
		onCategorySelected = onCategorySelected,
		searchQuery = state4,
		committedQuery = state5,
		onSearchQueryChanged = onSearchQueryChanged,
		onSearchSubmit = onSearchSubmit,
		isSearchOpen = state6,
		onSearchOpen = onSearchOpen,
		onSearchCancel = onSearchCancel,
		sections = v9.sections,
		selectedItem = selectedItem,
		selectedItemDisableBuy = selectedItemDisableBuy,
		onItemActivated = onItemActivated,
		onDetailsClose = onDetailsClose,
		itemsPerRow = itemsPerRow,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		isReportingEnabled = v12.isReportingEnabled,
		isOverflowMenuOpen = v12.isOverflowMenuOpen,
		topBarReportSession = v12.reportSession,
		onOverflowActivated = v12.onOverflowActivated,
		onOverflowMenuClosed = v12.onOverflowMenuClosed,
		onMenuItemActivated = v12.onMenuItemActivated,
		onTopBarReportClose = v12.onReportClose,
		offer = offer
	}
end

fn = function(items, sections)
	local idSet = {}

	for _, item in sections do
		idSet[item.id] = true
	end

	local v2 = #sections > 0

	local categories = {}

	for _, item in items do
		if idSet[item.id] or v2 then
			table.insert(categories, item)
		end
	end

	return { categories = categories, sections = sections }
end

return useShopViewModel
