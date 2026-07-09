local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local mutedError = require(Modules.LuaApp.mutedError)
local MarketplaceCategoryPillWithTooltip = require(Modules.AvatarExperience.Common.Components.NavBar.MarketplaceCategoryPillWithTooltip)
local CategoryPillCloseButton = AvatarExperienceCommon.Components.CategoryPillCloseButton
local AnimatedCategoryPill = AvatarExperienceCommon.Components.AnimatedCategoryPill
local AnimatedSubcategoryPill = AvatarExperienceCommon.Components.AnimatedSubcategoryPill
local useSubcategoryPillAnimation = AvatarExperienceCommon.Hooks.useSubcategoryPillAnimation
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

return function(t1: {[any]: any}) -- line: 64
	-- upvalues: React (copy), CatalogUtils (copy), useTokens (copy), useSubcategoryPillAnimation (copy), Constants (copy), Focusable (copy), CategoryPillCloseButton (copy), MarketplaceCategoryPillWithTooltip (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy), Foundation (copy), mutedError (copy), AnimatedCategoryPill (copy), AnimatedSubcategoryPill (copy)
	local shouldShowSubcategories = t1.shouldShowSubcategories
	local v24 = React.useMemo(function() -- line: 67
		-- upvalues: CatalogUtils (copy), t1 (copy)
		return CatalogUtils.extractCategoryById(t1.selectedCategoryId, t1.categories)
	end, {
		t1.selectedCategoryId,
		t1.categories
	})
	local v25 = useTokens()
	local Surface_0 = v25.Color.Surface.Surface_0
	local navButtonRefs = t1.navButtonRefs
	local categoryButtonRefs = t1.categoryButtonRefs
	local v29 = React.useRef(nil)
	local v30 = React.useRef({})
	local v31 = React.useRef(0)
	local v32 = useSubcategoryPillAnimation(v24)
	local subcategoriesState = v32.subcategoriesState
	local isFadingOut = v32.isFadingOut
	local v35 = React.useCallback(function() -- line: 85
		-- upvalues: t1 (copy), Constants (copy)
		t1.selectCategoryId(Constants.DefaultCatalogCategoryId)
	end, { t1.selectCategoryId })
	local v36 = React.useCallback(function() -- line: 89
		-- upvalues: React (copy), Focusable (copy), CategoryPillCloseButton (copy), v35 (copy), categoryButtonRefs (copy), navButtonRefs (copy)
		return React.createElement(Focusable[CategoryPillCloseButton], {
			pillIndex = 1,
			onActivated = v35,
			categoryButtonRefs = categoryButtonRefs,
			navButtonRefs = navButtonRefs
		})
	end, { v35 })
	local v37 = React.useCallback(function(p1, n1: number, b1: boolean?) -- line: 99
		-- upvalues: t1 (copy), React (copy), Focusable (copy), MarketplaceCategoryPillWithTooltip (copy), FFlagAXCatalogCategoriesSDUI (copy), Constants (copy), categoryButtonRefs (copy), navButtonRefs (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy)
		local isSubcategory = p1.isSubcategory
		local v43 = ((if not isSubcategory then t1.selectedCategoryId else t1.selectedSubcategoryId)) == p1.Id
		local selectCategoryId = t1.selectCategoryId
		local selectSubcategoryId = t1.selectSubcategoryId

		return React.createElement(Focusable[MarketplaceCategoryPillWithTooltip], {
			id = p1.Id,
			title = p1.Title,
			localizedTitle = if not FFlagAXCatalogCategoriesSDUI then nil else p1.LocalizedTitle,
			isChecked = v43,
			onActivated = function() -- line: 111
				-- upvalues: p1 (copy), v43 (copy), selectSubcategoryId (copy), t1 (copy), selectCategoryId (copy), Constants (copy)
				if p1.isSubcategory then
					if v43 then
						selectSubcategoryId(t1.selectedCategoryId, nil)

						return
					end

					selectSubcategoryId(t1.selectedCategoryId, p1.Id)

					return
				end

				if v43 then
					selectCategoryId(Constants.DefaultCatalogCategoryId)

					return
				end

				selectCategoryId(p1.Id)
			end,
			pillIndex = n1,
			isSubcategory = isSubcategory,
			categoryButtonRefs = categoryButtonRefs,
			navButtonRefs = navButtonRefs,
			categories = t1.categories,
			isSelectable = b1,
			navigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then p1.NavigationKey else nil,
			navBarHeight = t1.navHeight,
			avatarScreenOfOrigin = AvatarScreen.Catalog,
			categoryTooltipKey = if not FFlagAXMigrateCategoryTooltip and not FFlagAXCatalogCategoryTooltip then nil else p1.TooltipKey,
			categoryTooltipLocalizationKey = if not FFlagAXMigrateCategoryTooltip then nil else p1.TooltipLocalizationKey,
			categoryLocalizedTooltipBody = if not FFlagAXCatalogCategoriesSDUI then nil else p1.TooltipBody
		})
	end, {
		t1.selectedCategoryId,
		t1.selectedSubcategoryId,
		t1.selectCategoryId,
		t1.selectSubcategoryId,
		t1.navHeight
	})
	local XSmall = v25.Padding.XSmall

	return React.createElement(Foundation.View, {
		tag = "auto-xy",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t1.layoutOrder
	}, {
		CloseButtonFrame = React.createElement(Foundation.View, {
			tag = "auto-xy radius-circle align-x-center align-y-center",
			ZIndex = 3,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			backgroundStyle = Surface_0,
			ref = v29,
			Visible = shouldShowSubcategories
		}, {
			CloseButton = v36()
		}),
		CategoriesFrame = React.createElement(Foundation.View, {
			tag = "auto-xy",
			BackgroundTransparency = 1,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X
		}, ((function() -- line: 187
			-- upvalues: t1 (copy), mutedError (copy), v29 (copy), XSmall (copy), React (copy), AnimatedCategoryPill (copy), v37 (copy), v30 (copy), v31 (copy)
			local n2 = 2
			local t2 = {}
			local n3 = 0

			for _, v50 in t1.categories do
				if v50.Id == nil then
					mutedError("AnimatedPillsScrollableContent: Selected category does not have an ID" .. v50.Name)
				else
					local n4 = 0

					if v29.current and v29.current.AbsoluteSize then
						n4 = v29.current.AbsoluteSize.X
					end

					local v52 = t1.selectedCategoryId == v50.Id and t1.shouldShowSubcategories
					local v53 = n3

					if v52 then
						v53 = n4 + XSmall
					end

					t2[v50.Id] = React.createElement(AnimatedCategoryPill, {
						catInfo = v50,
						pillIndex = n2,
						isSelected = t1.selectedCategoryId == v50.Id,
						shouldShowSubcategories = t1.shouldShowSubcategories,
						closeButtonWidth = n4,
						targetX = v53,
						renderCategoryPill = v37,
						onRef = function(p2) -- line: 224
							-- upvalues: v30 (copy), v50 (copy)
							if p2 then
								v30.current[v50.Id] = p2
							end
						end
					})

					local n5 = 0

					if v30.current[v50.Id] and v30.current[v50.Id].AbsoluteSize then
						n5 = v30.current[v50.Id].AbsoluteSize.X
					end

					n3 = n3 + XSmall + n5

					if v52 then
						v31.current = v53 + XSmall + n5
					end

					n2 += 1
				end
			end

			return t2
		end)())),
		SubcategoriesFrame = React.createElement(Foundation.View, {
			tag = "auto-xy",
			BackgroundTransparency = 1,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v31.current, 0.5, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}, ((function() -- line: 273
			-- upvalues: subcategoriesState (copy), mutedError (copy), React (copy), AnimatedSubcategoryPill (copy), v37 (copy), isFadingOut (copy)
			local t3 = {}
			local n6 = 3

			for _, v58 in subcategoriesState do
				if v58.Id == nil then
					mutedError("AnimatedPillsScrollableContent: Selected subcategory does not have an ID" .. v58.Name)
				else
					t3[v58.Id] = React.createElement(AnimatedSubcategoryPill, {
						subcategory = v58,
						pillIndex = n6,
						renderCategoryPill = v37,
						isFadingOut = isFadingOut,
						isSelectable = not isFadingOut
					})
					n6 += 1
				end
			end

			return t3
		end)()))
	})
end
