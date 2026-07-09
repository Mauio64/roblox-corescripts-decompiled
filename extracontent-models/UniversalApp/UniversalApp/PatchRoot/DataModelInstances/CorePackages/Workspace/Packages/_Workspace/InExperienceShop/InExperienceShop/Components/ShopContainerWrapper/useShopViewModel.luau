local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local useTokens = require(InExperienceShopParent.Foundation).Hooks.useTokens
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization
local SignalsReact = require(InExperienceShopParent.SignalsReact)
local Constants = require(InExperienceShop.Constants)
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local AbuseVector = require(InExperienceShopParent.GenericAbuseReporting.AbuseVector)
local useShopReportOverflow = require(InExperienceShop.Hooks.useShopReportOverflow)

require(InExperienceShop.Types)

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local GetFixRobuxTileClickInShop = require(InExperienceShop.Flags.GetFixRobuxTileClickInShop)
local shopItemSelection = require(InExperienceShop.Utils.shopItemSelection)
local resolveItemForSelection = shopItemSelection.resolveItemForSelection
local t1 = {
	homeLabel = "CommonUI.Features.Label.Home"
}

require(script.Parent.ShopView)

local function isQueryValid(s1: string) -- line: 43
	-- upvalues: Constants (copy)
	local _, count = string.gsub(s1, " ", "")

	return #s1 - count >= Constants.SEARCH_MIN_LENGTH
end

local u17 = nil

local function useShopViewModel(t2: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), useLocalization (copy), t1 (copy), GetFixRobuxTileClickInShop (copy), SignalsReact (copy), getInExperienceShopStore (copy), React (copy), u17 (ref), resolveItemForSelection (copy), shopItemSelection (copy), Constants (copy), SharedFlags (copy), AbuseVector (copy), useShopReportOverflow (copy)
	local v23 = useTokens()
	local v24 = useLocalization(t1)
	local v25 = GetFixRobuxTileClickInShop()
	local v26 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v27 = SignalsReact.useSignalState(v26.getCategories)
	local v28 = SignalsReact.useSignalState(v26.getSections)
	local v29 = SignalsReact.useSignalState(v26.getItemsPerRow)
	local v30 = React.useMemo(function() -- line: 72
		-- upvalues: u17 (ref), v27 (copy), v28 (copy)
		return u17(v27, v28)
	end, {
		v27,
		v28
	})
	local homeLabel = v24.homeLabel
	local v32 = React.useMemo(function() -- line: 80
		-- upvalues: v30 (copy), homeLabel (copy)
		local t3 = table.create(#v30.categories)

		for v69, v70 in v30.categories do
			local v71 = if v70.id ~= "home" then v70.name else homeLabel

			t3[v69] = {
				id = v70.id,
				text = v71
			}
		end

		return t3
	end, {
		v30.categories,
		homeLabel
	})
	local v33, v34 = React.useState(function() -- line: 90
		-- upvalues: v30 (copy)
		if #v30.categories > 0 then
			return v30.categories[1].id
		end

		return ""
	end)
	local v35, v36 = React.useState(function() -- line: 97
		return nil
	end)
	local v37, v38 = React.useState(function() -- line: 100
		return nil
	end)

	React.useEffect(function() -- line: 103
		-- upvalues: v30 (copy), v34 (copy)
		local categories = v30.categories

		if #categories == 0 then
			return
		end

		v34(function(p1) -- line: 108
			-- upvalues: categories (copy)
			for _, v90 in categories do
				if p1 == v90.id then
					return p1
				end
			end

			return categories[1].id
		end)
	end, { v30.categories })
	React.useEffect(function() -- line: 120
		-- upvalues: v35 (copy), v37 (copy), resolveItemForSelection (copy), v30 (copy), v25 (copy), v36 (copy), v38 (copy)
		if v35 == nil or v37 == nil then
			return
		end

		if resolveItemForSelection(v30.sections, v35, v37, v25) == nil then
			v36(nil)
			v38(nil)
		end
	end, {
		v30.sections,
		v35,
		v37,
		v25
	})

	local v39 = React.useMemo(function() -- line: 137
		-- upvalues: resolveItemForSelection (copy), v30 (copy), v35 (copy), v37 (copy), v25 (copy)
		return resolveItemForSelection(v30.sections, v35, v37, v25)
	end, {
		v30.sections,
		v35,
		v37,
		v25
	})
	local v40 = React.useMemo(function() -- line: 146
		-- upvalues: shopItemSelection (copy), v30 (copy), v35 (copy), v37 (copy), v25 (copy)
		return shopItemSelection.isRobuxBonusOnlySelection(v30.sections, v35, v37, v25)
	end, {
		v30.sections,
		v35,
		v37,
		v25
	})
	local v41 = React.useCallback(function(p2) -- line: 156
		-- upvalues: v34 (copy)
		v34(p2)
	end, {})
	local v42, v43 = React.useState("")
	local v44, v45 = React.useState("")

	React.useEffect(function() -- line: 168
		-- upvalues: v42 (copy), Constants (copy), v45 (copy)
		local v74 = v42
		local _, count = string.gsub(v74, " ", "")

		if not (#v74 - count >= Constants.SEARCH_MIN_LENGTH) then
			v45("")

			return
		end

		local u77 = false

		task.delay(Constants.SEARCH_DEBOUNCE_SECONDS, function() -- line: 179
			-- upvalues: u77 (ref), v45 (copy), v42 (copy)
			if u77 then
				return
			end

			v45(v42)
		end)

		return function() -- line: 185
			-- upvalues: u77 (ref)
			u77 = true
		end
	end, { v42 })

	local v46 = React.useCallback(function(s2: string) -- line: 190
		-- upvalues: v43 (copy)
		v43(s2)
	end, {})
	local v47 = React.useCallback(function(s3: string) -- line: 196
		-- upvalues: v43 (copy), Constants (copy), v45 (copy)
		v43(s3)

		local _, count = string.gsub(s3, " ", "")

		if #s3 - count >= Constants.SEARCH_MIN_LENGTH then
			v45(s3)

			return
		end

		v45("")
	end, {})
	local v48 = React.useCallback(function(s4: string, p3) -- line: 208
		-- upvalues: resolveItemForSelection (copy), v30 (copy), v25 (copy), v36 (copy), v38 (copy)
		if p3 == nil then
			return
		end

		if resolveItemForSelection(v30.sections, s4, p3, v25) == nil then
			return
		end

		v36(s4)
		v38(p3)
	end, {
		v30.sections,
		v25
	})
	local v49 = React.useCallback(function() -- line: 219
		-- upvalues: v36 (copy), v38 (copy)
		v36(nil)
		v38(nil)
	end, {})
	local v50, v51 = React.useState(false)
	local v52 = React.useCallback(function() -- line: 226
		-- upvalues: v51 (copy)
		v51(true)
	end, {})
	local v53 = React.useCallback(function() -- line: 234
		-- upvalues: v51 (copy), v43 (copy), v45 (copy)
		v51(false)
		v43("")
		v45("")
	end, {})
	local setItemsPerRow = v26.setItemsPerRow
	local v55 = React.useCallback(function(p4) -- line: 245
		-- upvalues: Constants (copy), setItemsPerRow (copy)
		local AbsoluteSizeX = p4.AbsoluteSize.X

		if AbsoluteSizeX == 0 then
			return
		end

		local v86 = math.floor(AbsoluteSizeX / Constants.MIN_TILE_WIDTH)
		local v87 = math.max(Constants.MIN_COLUMNS, (math.min(Constants.ITEMS_PER_SECTION, v86)))

		setItemsPerRow(v87)
	end, { setItemsPerRow })
	local FFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
	local v57 = React.useCallback(function() -- line: 260
		-- upvalues: AbuseVector (copy)
		return {
			abuseVector = AbuseVector.InExperienceShop,
			targetId = tostring(game.PlaceId)
		}
	end, {})
	local v58 = useShopReportOverflow.useShopReportOverflow({
		isReportingEnabled = FFlagEnableReportingFlowForExperienceShop,
		buildReportSession = v57
	})

	return {
		fullScreen = t2.fullScreen,
		overMediaColor = v23.Color.OverMedia.OverMedia_0.Color3,
		overMediaTransparency = v23.Color.OverMedia.OverMedia_0.Transparency,
		onClose = t2.toggleWindow,
		tabs = v32,
		selectedCategoryId = v33,
		onCategorySelected = v41,
		searchQuery = v42,
		committedQuery = v44,
		onSearchQueryChanged = v46,
		onSearchSubmit = v47,
		isSearchOpen = v50,
		onSearchOpen = v52,
		onSearchCancel = v53,
		sections = v30.sections,
		selectedItem = v39,
		selectedItemDisableBuy = v40,
		onItemActivated = v48,
		onDetailsClose = v49,
		itemsPerRow = v29,
		onAbsoluteSizeChanged = v55,
		isReportingEnabled = v58.isReportingEnabled,
		isOverflowMenuOpen = v58.isOverflowMenuOpen,
		topBarReportSession = v58.reportSession,
		onOverflowActivated = v58.onOverflowActivated,
		onOverflowMenuClosed = v58.onOverflowMenuClosed,
		onMenuItemActivated = v58.onMenuItemActivated,
		onTopBarReportClose = v58.onReportClose
	}
end

function u17(t4: {[any]: any}, t5: {[any]: any}) -- line: 308
	local t6 = {}

	for _, v63 in t5 do
		t6[v63.id] = true
	end

	local v64 = #t5 > 0
	local t7 = {}

	for _, v67 in t4 do
		if t6[v67.id] or v64 then
			table.insert(t7, v67)
		end
	end

	return {
		categories = t7,
		sections = t5
	}
end

return useShopViewModel
