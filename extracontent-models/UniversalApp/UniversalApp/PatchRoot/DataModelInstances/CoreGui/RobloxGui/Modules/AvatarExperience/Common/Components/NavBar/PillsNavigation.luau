local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local FitFrameHorizontal = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameHorizontal
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local ScrollingListWithArrowsAndGradient = require(Modules.AvatarExperience.Common.Components.ScrollingListWithArrowsAndGradient)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateMainNavigationInputBindings = AvatarExperienceFlags.FFlagAXMigrateMainNavigationInputBindings
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local mutedError = require(Modules.LuaApp.mutedError)
local MarketplaceCategoryPillWithTooltip = require(Modules.AvatarExperience.Common.Components.NavBar.MarketplaceCategoryPillWithTooltip)
local AnimatedPillsScrollableContent = require(Modules.AvatarExperience.Common.Components.NavBar.AnimatedPillsScrollableContent)
local CategoryPillCloseButton = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CategoryPillCloseButton
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local useTabNavigationFocusNavigationBindings = require(script.Parent.useTabNavigationFocusNavigationBindings)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXReduceCatalogFilterWidth = AvatarExperienceFlags.FFlagAXReduceCatalogFilterWidth
local v34 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 81
	-- upvalues: RoactGamepad (copy), React (copy), useTokens (copy), FFlagAXReduceCatalogFilterWidth (copy), useFocusGuiObject (copy), FFlagAXMigrateMainNavigationInputBindings (copy), findValueKeyInRefCache (copy), GuiService (copy), useTabNavigationFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), FFlagAXCategoryPillPositionAnimation (copy), Focusable (copy), MarketplaceCategoryPillWithTooltip (copy), FFlagAXCatalogCategoriesSDUI (copy), Constants (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy), CategoryPillCloseButton (copy), CatalogUtils (copy), Foundation (copy), mutedError (copy), FitFrameHorizontal (copy), AnimatedPillsScrollableContent (copy), FFlagAXCatalogSupportDisableFilters (copy), CatalogCategories (copy), ScrollingListWithArrowsAndGradient (copy)
	local v37 = RoactGamepad.useRefCache()
	local v38 = RoactGamepad.useRefCache()
	local v39 = React.useRef(nil)
	local v40 = useTokens()
	local v41 = if not FFlagAXReduceCatalogFilterWidth then v40.Size.Size_1400 else v40.Size.Size_1300
	local Size_600 = v40.Size.Size_600
	local v43 = useFocusGuiObject()
	local v44 = v39

	if FFlagAXMigrateMainNavigationInputBindings then
		local v45 = React.useCallback(function(p2) -- line: 94
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v37 (copy), v43 (copy)
			p2.cancelled = true

			local v60 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v37)

			if v60 and (v60 > 1 and v43) then
				v43(v37[v60 - 1].current)
			end
		end, { v43 })
		local v46 = React.useCallback(function(p3) -- line: 104
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v37 (copy), v43 (copy)
			p3.cancelled = true

			local v62 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v37)

			if v62 and (v62 < #v37 and v43) then
				v43(v37[v62 + 1].current)
			end
		end, { v43 })
		local v47 = React.useCallback(function(p4) -- line: 115
			-- upvalues: v43 (copy), t1 (copy)
			p4.cancelled = true

			if v43 and (t1.NextSelectionUp and t1.NextSelectionUp.current) then
				v43(t1.NextSelectionUp.current)
			end
		end, {
			v43,
			t1.NextSelectionUp
		})
		local v48 = useTabNavigationFocusNavigationBindings({
			onTabBackward = v45,
			onTabForward = v46,
			onNavigateBack = v47
		}, v39)

		v44 = useTableWrappedCallbackRef(v48)
	end

	if not FFlagAXCategoryPillPositionAnimation then
		local v49 = React.useCallback(function(p5, p6) -- line: 137
			-- upvalues: v39 (copy)
			local current = v39.current
			local v67 = (p5 or 0) - 50

			if current then
				local AbsoluteWindowSizeX = current.AbsoluteWindowSize.X

				if not AbsoluteWindowSizeX or AbsoluteWindowSizeX == 0 then
					return
				end

				local v69 = p5 + p6 > 0 and AbsoluteWindowSizeX > p5 + p6

				if (not (p5 > 0) or not (p5 < AbsoluteWindowSizeX)) and not v69 then
					current.CanvasPosition = Vector2.new(v67, current.CanvasPosition.Y)
				end
			end
		end, {})
		local v50 = React.useCallback(function() -- line: 161
			-- upvalues: t1 (copy), v38 (copy), v49 (copy)
			local v70 = if not t1.selectedCategoryId then nil else v38[t1.selectedCategoryId].current

			if v70 == nil then
				return false
			end

			v49(v70.AbsolutePosition.X, v70.AbsoluteSize.X)

			return true
		end, { t1.selectedCategoryId })

		React.useEffect(function() -- line: 176
			-- upvalues: v50 (copy), v39 (copy)
			v50()

			if v39.current then
				v39.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function() -- line: 179
					-- upvalues: v50 (copy)
					v50()
				end)
			end
		end, {})
		React.useEffect(function() -- line: 185
			-- upvalues: v50 (copy)
			v50()
		end, { v50 })
	else
		React.useEffect(function() -- line: 189
			-- upvalues: v39 (copy)
			local current = v39.current

			if current then
				current.CanvasPosition = Vector2.new(0, current.CanvasPosition.Y)
			end
		end, { t1.selectedCategoryId })
	end

	local v51 = React.useCallback(function(p7, n1: number, n2: number) -- line: 198
		-- upvalues: t1 (copy), React (copy), Focusable (copy), MarketplaceCategoryPillWithTooltip (copy), FFlagAXCatalogCategoriesSDUI (copy), Constants (copy), v39 (copy), v38 (copy), v37 (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy)
		local isSubcategory = p7.isSubcategory
		local v76 = ((if not isSubcategory then t1.selectedCategoryId else t1.selectedSubcategoryId)) == p7.Id
		local selectCategoryId = t1.selectCategoryId
		local selectSubcategoryId = t1.selectSubcategoryId

		return React.createElement(Focusable[MarketplaceCategoryPillWithTooltip], {
			id = p7.Id,
			title = p7.Title,
			localizedTitle = if not FFlagAXCatalogCategoriesSDUI then nil else p7.LocalizedTitle,
			isChecked = v76,
			onActivated = function() -- line: 211
				-- upvalues: p7 (copy), v76 (copy), selectSubcategoryId (copy), t1 (copy), selectCategoryId (copy), Constants (copy), v39 (copy)
				if p7.isSubcategory then
					if v76 then
						selectSubcategoryId(t1.selectedCategoryId, nil)

						return
					end

					selectSubcategoryId(t1.selectedCategoryId, p7.Id)

					return
				end

				if v76 then
					selectCategoryId(Constants.DefaultCatalogCategoryId)
				else
					selectCategoryId(p7.Id)
				end

				if v39.current then
					v39.current.CanvasPosition = Vector2.new(0, v39.current.CanvasPosition.Y)
				end
			end,
			layoutOrder = n1,
			pillIndex = n2,
			isSubcategory = isSubcategory,
			categoryButtonRefs = v38,
			navButtonRefs = v37,
			categories = t1.categories,
			navigationKey = if FFlagAXRemoveCatalogCategoryNavKey then nil else p7.NavigationKey,
			navBarHeight = t1.navHeight,
			avatarScreenOfOrigin = AvatarScreen.Catalog,
			categoryTooltipKey = if not FFlagAXMigrateCategoryTooltip and not FFlagAXCatalogCategoryTooltip then nil else p7.TooltipKey,
			categoryTooltipLocalizationKey = if not FFlagAXMigrateCategoryTooltip then nil else p7.TooltipLocalizationKey,
			categoryLocalizedTooltipBody = if not FFlagAXCatalogCategoriesSDUI then nil else p7.TooltipBody
		})
	end, {
		t1.selectedCategoryId,
		t1.selectedSubcategoryId,
		t1.selectCategoryId,
		t1.selectSubcategoryId
	})
	local v52 = React.useCallback(function(n3: number, n4: number) -- line: 258
		-- upvalues: t1 (copy), React (copy), Focusable (copy), CategoryPillCloseButton (copy), Constants (copy), v38 (copy), v37 (copy)
		local selectCategoryId = t1.selectCategoryId

		return React.createElement(Focusable[CategoryPillCloseButton], {
			layoutOrder = n3,
			pillIndex = n4,
			onActivated = function() -- line: 264
				-- upvalues: selectCategoryId (copy), Constants (copy)
				selectCategoryId(Constants.DefaultCatalogCategoryId)
			end,
			categoryButtonRefs = v38,
			navButtonRefs = v37
		})
	end, { t1.selectCategoryId })
	local v53 = React.useCallback(function(p8) -- line: 272
		-- upvalues: v39 (copy)
		local v83 = p8.AbsoluteSize.X or 0

		if v39.current then
			v39.current.CanvasSize = UDim2.new(0, v83, 1, 0)
		end
	end, {})
	local v54 = React.useCallback(function() -- line: 280
		-- upvalues: t1 (copy), CatalogUtils (copy), React (copy), Foundation (copy), v40 (copy), v38 (copy), v52 (copy), mutedError (copy), v51 (copy), v41 (copy), Size_600 (copy), Focusable (copy), FitFrameHorizontal (copy), v53 (copy)
		local categories = t1.categories
		local t2 = {}
		local v86 = CatalogUtils.extractCategoryById(t1.selectedCategoryId, categories)

		if v86 then
			local n5 = 1
			local n6 = 1

			t2.LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v40.Padding.Small, 1, 0),
				LayoutOrder = n6,
				ref = v38.LeftPadding
			})

			local v89 = n6 + 1

			if v86.Subcategories then
				t2.CloseButton = v52(v89, n5)

				local v90 = n5 + 1
				local v91 = v89 + 1

				if v86.Id == nil then
					mutedError("Selected category does not have an ID" .. v86.Name)
				else
					t2[v86.Id] = v51(v86, v91, v90)
				end

				local v92 = v90 + 1

				v89 = v91 + 1

				for _, v94 in v86.Subcategories do
					if v94.Id == nil then
						mutedError("Selected subcategory does not have an ID" .. v94.Name)
					else
						t2[v94.Id] = v51(v94, v89, v92)
					end

					v92 += 1
					v89 += 1
				end
			else
				for _, v96 in categories do
					if v96.Id == nil then
						mutedError("Selected category does not have an ID" .. v96.Name)
					else
						t2[v96.Id] = v51(v96, v89, n5)
					end

					n5 += 1
					v89 += 1
				end
			end

			t2.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v41 + Size_600, 1, 0),
				LayoutOrder = v89,
				ref = v38.RightPadding
			})
		else
			mutedError("Selected category does not exist in categories list" .. t1.selectedCategoryId)
		end

		return {
			NavFrame = React.createElement(Focusable[FitFrameHorizontal], {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v53,
				contentPadding = UDim.new(0, 6)
			}, t2)
		}
	end, {
		t1.subcategorySelected,
		v53,
		t1.categories,
		v51,
		v52
	})
	local v55 = React.useCallback(function() -- line: 374
		-- upvalues: React (copy), Foundation (copy), v40 (copy), v38 (copy), AnimatedPillsScrollableContent (copy), t1 (copy), v37 (copy), v39 (copy), v41 (copy), Size_600 (copy), Focusable (copy), FitFrameHorizontal (copy), v53 (copy)
		local t3 = {
			LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, v40.Padding.Small, 1, 0),
				ref = v38.LeftPadding
			}),
			MainContents = React.createElement(AnimatedPillsScrollableContent, {
				layoutOrder = 2,
				navHeight = t1.navHeight,
				categories = t1.categories,
				selectedCategoryId = t1.selectedCategoryId,
				selectCategoryId = t1.selectCategoryId,
				selectedSubcategoryId = t1.selectedSubcategoryId,
				selectSubcategoryId = t1.selectSubcategoryId,
				shouldShowSubcategories = t1.shouldShowSubcategories or not not t1.shouldShowSubcategories,
				navButtonRefs = v37,
				scrollingFrameRef = v39,
				categoryButtonRefs = v38
			}),
			RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(0, v41 + Size_600, 1, 0),
				ref = v38.RightPadding
			})
		}

		return {
			NavFrame = React.createElement(Focusable[FitFrameHorizontal], {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v53,
				contentPadding = UDim.new(0, 6)
			}, t3)
		}
	end, {
		v53,
		t1.navHeight,
		t1.categories,
		t1.selectedCategoryId,
		t1.selectCategoryId,
		t1.selectedSubcategoryId,
		t1.selectSubcategoryId,
		t1.shouldShowSubcategories
	})
	local v56 = CatalogUtils.findCategoryIndexById(t1.categories, t1.selectedCategoryId)
	local Surface_0Color3 = v40.Color.Surface.Surface_0.Color3

	if FFlagAXCategoryPillPositionAnimation then
		Surface_0Color3 = v40.Color.Surface.Surface_0
	end

	local v58 = if FFlagAXCatalogSupportDisableFilters then t1.hideFilterButton or false else t1.selectedCategoryId == CatalogCategories.Avatars:rawValue()

	return React.createElement(Focusable.Frame, {
		ClipsDescendants = true,
		BorderSizePixel = 0,
		BackgroundColor3 = if not FFlagAXCategoryPillPositionAnimation then Surface_0Color3 else Surface_0Color3.Color3,
		BackgroundTransparency = if not FFlagAXCategoryPillPositionAnimation then v40.Color.Surface.Surface_0.Transparency else Surface_0Color3.Transparency,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, t1.navHeight),
		ZIndex = t1.zIndex,
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		defaultChild = v37[v56]
	}, {
		ScrollingListWithArrowsAndGradient = React.createElement(ScrollingListWithArrowsAndGradient, {
			buttonPadding = 0,
			supportFilterButton = true,
			getScollingListContent = if not FFlagAXCategoryPillPositionAnimation then v54 else v55,
			listHeight = t1.navHeight,
			scrollingFrameRef = v44,
			buttonRefs = v38,
			backgroundColor = if not FFlagAXCategoryPillPositionAnimation then Surface_0Color3 else Surface_0Color3.Color3,
			hideFilterButton = v58,
			filterButtonWidth = v41,
			filterButtonGradientWidth = Size_600
		})
	})
end)

return React.memo(v34)
