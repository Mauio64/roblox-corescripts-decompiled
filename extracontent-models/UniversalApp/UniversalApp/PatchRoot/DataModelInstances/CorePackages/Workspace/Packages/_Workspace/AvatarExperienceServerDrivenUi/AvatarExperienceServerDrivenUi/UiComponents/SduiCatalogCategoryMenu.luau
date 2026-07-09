local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local React = require(AvatarExperienceServerDrivenUiParent.React)
local SignalsReact = require(AvatarExperienceServerDrivenUiParent.SignalsReact)
local AvatarExperienceUIKit = require(AvatarExperienceServerDrivenUiParent.AvatarExperienceUIKit)
local Foundation = require(AvatarExperienceServerDrivenUiParent.Foundation)
local mutedError = require(AvatarExperienceServerDrivenUiParent.Loggers).mutedError
local SduiCoreSystem = require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
local MarketplaceCatalogSduiSelectionBridge = require(AvatarExperienceServerDrivenUi.System.MarketplaceCatalogSduiSelectionBridge)
local useMarketplaceCatalogCategoryMenuSubcategories = require(AvatarExperienceServerDrivenUi.hooks.useMarketplaceCatalogCategoryMenuSubcategories)
local useMarketplaceCatalogCategoryMenuDefaultSubcategoryId = require(AvatarExperienceServerDrivenUi.hooks.useMarketplaceCatalogCategoryMenuDefaultSubcategoryId)
local CategoryMenu = AvatarExperienceUIKit.CategoryMenu
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local t1 = {}

for v15, v16 in Foundation.Enums.IconName do
	t1[v15] = true

	if typeof(v16) == "string" then
		t1[v16] = true
	end
end

local function wrapZeroArgAction(p1: ((...any) -> ...any)) -- line: 46
	-- upvalues: mutedError (copy)
	return function() -- line: 47
		-- upvalues: p1 (copy), mutedError (copy)
		if typeof(p1) == "function" then
			p1(nil, nil, nil)

			return
		end

		mutedError(`Expected function, got { typeof(p1) }`)
	end
end
local function mapButtons(t2: {[any]: any}?, p2) -- line: 63
	-- upvalues: t1 (copy), SduiErrorType (copy), mutedError (copy)
	if not t2 then
		return nil
	end

	local t3 = {}

	for _, v26 in t2 do
		if not t1[v26.icon] then
			p2.dependencies.logger.reportError(SduiErrorType.InvalidProps, {
				name = "CatalogCategoryMenu",
				message = `Skipping button "{ v26.id }": unknown icon "{ v26.icon }"`
			}, p2.appPage)
		else
			local v27 = table.clone(v26)
			local onActivated = v26.onActivated

			function v27.onActivated() -- line: 47
				-- upvalues: onActivated (copy), mutedError (copy)
				if typeof(onActivated) == "function" then
					onActivated(nil, nil, nil)

					return
				end

				mutedError(`Expected function, got { typeof(onActivated) }`)
			end

			table.insert(t3, v27)
		end
	end

	return t3
end
local function mapTooltips(t4: {[any]: any}?) -- line: 83
	-- upvalues: mutedError (copy)
	if not t4 then
		return nil
	end

	local t5 = {}

	for v31, v32 in t4 do
		local v33 = table.clone(v32)

		if v33.actions then
			local t6 = {}

			for v35, v36 in v33.actions do
				local v37 = table.clone(v36)
				local onActivated = v37.onActivated

				function v37.onActivated() -- line: 47
					-- upvalues: onActivated (copy), mutedError (copy)
					if typeof(onActivated) == "function" then
						onActivated(nil, nil, nil)

						return
					end

					mutedError(`Expected function, got { typeof(onActivated) }`)
				end

				t6[v35] = v37
			end

			v33.actions = t6
		end

		if v33.onClose then
			local onClose = v33.onClose

			function v33.onClose() -- line: 47
				-- upvalues: onClose (copy), mutedError (copy)
				if typeof(onClose) == "function" then
					onClose(nil, nil, nil)

					return
				end

				mutedError(`Expected function, got { typeof(onClose) }`)
			end
		end

		t5[v31] = v33
	end

	return t5
end
local function SduiCatalogCategoryMenu(t7: {[any]: any}) -- line: 122
	-- upvalues: SignalsReact (copy), MarketplaceCatalogSduiSelectionBridge (copy), useMarketplaceCatalogCategoryMenuSubcategories (copy), useMarketplaceCatalogCategoryMenuDefaultSubcategoryId (copy), React (copy), mapButtons (copy), mapTooltips (copy), CategoryMenu (copy)
	local v41 = SignalsReact.useSignalState(MarketplaceCatalogSduiSelectionBridge.activeCategoryId)
	local v42 = SignalsReact.useSignalState(MarketplaceCatalogSduiSelectionBridge.activeSubcategoryId)
	local v43 = v41 or t7.activeCategoryId
	local v44 = useMarketplaceCatalogCategoryMenuSubcategories(v43)
	local v45 = useMarketplaceCatalogCategoryMenuDefaultSubcategoryId(v43)
	local v46 = v42 or (v45 or t7.activeSubcategoryId)
	local t8 = {
		activeCategoryId = v43,
		activeSubcategoryId = v46,
		categories = t7.categories,
		buttonsLocation = t7.buttonsLocation,
		onCategoryActivated = React.useCallback(function(s1: string) -- line: 151
			-- upvalues: t7 (copy)
			if typeof(t7.onCategoryActivated) == "function" then
				t7.onCategoryActivated(nil, nil, {
					categoryId = s1
				})
			end
		end, { t7.onCategoryActivated }),
		onSubcategoryActivated = React.useCallback(function(s2: string) -- line: 157
			-- upvalues: t7 (copy)
			if typeof(t7.onSubcategoryActivated) == "function" then
				t7.onSubcategoryActivated(nil, nil, {
					subcategoryId = s2
				})
			end
		end, { t7.onSubcategoryActivated }),
		buttons = React.useMemo(function() -- line: 163
			-- upvalues: mapButtons (copy), t7 (copy)
			return (mapButtons(t7.buttons, t7.sduiContext))
		end, {
			t7.buttons,
			t7.sduiContext
		}),
		tooltips = React.useMemo(function() -- line: 167
			-- upvalues: mapTooltips (copy), t7 (copy)
			return (mapTooltips(t7.tooltips))
		end, { t7.tooltips }),
		subcategories = React.useMemo(function() -- line: 171
			-- upvalues: v44 (copy)
			return v44
		end, { v44 })
	}

	return React.createElement(CategoryMenu, t8)
end

return React.memo(SduiCatalogCategoryMenu)
