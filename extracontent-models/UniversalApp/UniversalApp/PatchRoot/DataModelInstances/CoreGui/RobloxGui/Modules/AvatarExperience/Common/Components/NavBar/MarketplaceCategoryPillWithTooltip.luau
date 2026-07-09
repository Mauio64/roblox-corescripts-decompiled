local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useCategoryButtonTooltip = require(Modules.AvatarExperience.Common.Components.NavBar.useCategoryButtonTooltip)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local CategoryPill = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CategoryPill
local AXTooltip = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AXTooltip
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local function MarketplaceCategoryPillWithTooltip(t1: {[any]: any}) -- line: 50
	-- upvalues: FFlagAXMigrateCategoryTooltip (copy), useCategoryButtonTooltip (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), FFlagAXCatalogCategoryTooltip (copy), React (copy), FFlagAXCategoryPillPositionAnimation (copy), useTokens (copy), useLocalization (copy), CategoryPill (copy), FFlagAXCatalogCategoriesSDUI (copy), AXTooltip (copy), Foundation (copy)
	local v18 = nil
	local u19 = nil
	local v20 = nil

	if not FFlagAXMigrateCategoryTooltip then
		local v21

		v18, v21, v20 = useCategoryButtonTooltip(if not FFlagAXRemoveCatalogCategoryNavKey then t1.navigationKey else t1.id, t1.avatarScreenOfOrigin, if not FFlagAXCatalogCategoryTooltip then nil else t1.categoryTooltipKey)
		u19 = v21
	end

	local u22 = nil
	local v23 = nil

	if FFlagAXMigrateCategoryTooltip then
		u22 = React.createRef()
		v23 = t1.categoryTooltipKey ~= nil and (t1.categoryTooltipLocalizationKey ~= nil and (not FFlagAXCategoryPillPositionAnimation or t1.isSelectable))
	end

	local v24 = useTokens()
	local frameRef = t1.frameRef
	local v26 = useLocalization({
		tooltipTitle = v20
	})
	local v27 = if not FFlagAXCategoryPillPositionAnimation then nil else React.useCallback(function() -- line: 77
		-- upvalues: t1 (copy), FFlagAXMigrateCategoryTooltip (copy), u22 (ref), u19 (ref)
		t1.onActivated()

		if FFlagAXMigrateCategoryTooltip then
			if u22.current then
				u22.current()

				return
			end
		else
			u19()
		end
	end, {
		t1.onActivated,
		u19
	})
	local v28 = React.useRef(nil)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, 0, 0, v24.Size.Size_800),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		ref = frameRef,
		LayoutOrder = t1.layoutOrder
	}, {
		Pill = React.createElement(CategoryPill, {
			id = t1.id,
			title = t1.title,
			localizedTitle = if not FFlagAXCatalogCategoriesSDUI then nil else t1.localizedTitle,
			isChecked = t1.isChecked,
			onActivated = not FFlagAXCategoryPillPositionAnimation and function() -- line: 107
				-- upvalues: t1 (copy), FFlagAXMigrateCategoryTooltip (copy), u22 (ref), u19 (ref)
				t1.onActivated()

				if FFlagAXMigrateCategoryTooltip then
					if u22.current then
						u22.current()

						return
					end
				else
					u19()
				end
			end or v27,
			pillIndex = t1.pillIndex,
			isSubcategory = t1.isSubcategory,
			categoryButtonRefs = t1.categoryButtonRefs,
			navButtonRefs = t1.navButtonRefs,
			categories = t1.categories,
			isSelectable = if not FFlagAXCategoryPillPositionAnimation then nil else t1.isSelectable,
			pillRef = v28
		}),
		AXTooltip = FFlagAXMigrateCategoryTooltip and React.createElement(AXTooltip, {
			popoverSide = "Top",
			tooltipLocalizationKey = t1.categoryTooltipLocalizationKey,
			tooltipStorageKey = t1.categoryTooltipKey or "",
			dismissTooltipRef = u22,
			showTooltip = v23,
			localizedText = if not FFlagAXCatalogCategoriesSDUI then nil else t1.categoryLocalizedTooltipBody
		}),
		ActionButtonPopover = not FFlagAXMigrateCategoryTooltip and React.createElement(Foundation.Popover.Root, {
			isOpen = v18 and t1.isSelectable
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, {
				anchorRef = v28
			}),
			Content = React.createElement(Foundation.Popover.Content, {
				align = Foundation.Enums.PopoverAlign.Center,
				side = Foundation.Enums.PopoverSide.Top,
				radius = Foundation.Enums.Radius.Medium,
				backgroundStyle = v24.Color.System.Contrast
			}, { React.createElement(Foundation.View, {
				tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
			}, {
				CategoryButtonTooltipTitle = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-medium content-inverse-emphasis",
					Text = v26.tooltipTitle
				}, {
					TooltipOverlayButton = React.createElement("TextButton", {
						Transparency = 1,
						[React.Event.Activated] = t1.tooltipActivated,
						Size = UDim2.fromScale(1, 1)
					})
				})
			}) })
		})
	})
end

return MarketplaceCategoryPillWithTooltip
