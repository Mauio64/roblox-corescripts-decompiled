local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gSK")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local categoryPill = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CategoryPill
local axTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXTooltip

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local function MarketplaceCategoryPillWithTooltip(props)
	local v5, v6, v7

	if fFlagAXMigrateCategoryTooltip then
		v6 = nil
	else
		v7, v6, v5 = module(props.id, props.avatarScreenOfOrigin, props.categoryTooltipKey)
	end

	local ref, v8

	if fFlagAXMigrateCategoryTooltip then
		ref = React.createRef()

		if props.categoryTooltipKey == nil or props.categoryTooltipLocalizationKey == nil then
			v8 = false
		else
			v8 = not fFlagAXCategoryPillPositionAnimation or props.isSelectable
		end
	else
		ref = nil
	end

	local v9 = useTokens()

	local frameRef = props.frameRef

	local v10 = useLocalization({ tooltipTitle = v5 })
	local v11

	if fFlagAXCategoryPillPositionAnimation then
		v11 = React.useCallback(function()
			props.onActivated()

			if fFlagAXMigrateCategoryTooltip then
				if ref.current then
					ref.current()
				end
			else
				v6()
			end
		end, { props.onActivated, v6 })
	end

	local ref2 = React.useRef(nil)

	local createElement = React.createElement
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, 0, 0, v9.Size.Size_800),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundTransparency = 1,
		ref = frameRef,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v16 = {
		id = props.id,
		title = props.title,
		localizedTitle = 0,
		isChecked = 0,
		onActivated = 0,
		pillIndex = 0,
		isSubcategory = 0,
		categoryButtonRefs = 0,
		navButtonRefs = 0,
		categories = 0,
		isSelectable = 0,
		pillRef = 0
	}
	local v17 = if fFlagAXCatalogCategoriesSDUI then props.localizedTitle else nil
	v16.localizedTitle = v17
	v16.isChecked = props.isChecked
	v16.onActivated = not fFlagAXCategoryPillPositionAnimation and function()
		props.onActivated()

		if fFlagAXMigrateCategoryTooltip then
			if ref.current then
				ref.current()
			end
		else
			v6()
		end
	end or v11
	v16.pillIndex = props.pillIndex
	v16.isSubcategory = props.isSubcategory
	v16.categoryButtonRefs = props.categoryButtonRefs
	v16.navButtonRefs = props.navButtonRefs
	v16.categories = props.categories
	local v18 = if fFlagAXCategoryPillPositionAnimation then props.isSelectable else nil
	v16.isSelectable = v18
	v16.pillRef = ref2
	local v14 = {
		Pill = createElement2(categoryPill, v16),
		AXTooltip = 0,
		ActionButtonPopover = 0
	}

	local v19 = fFlagAXMigrateCategoryTooltip

	if v19 then
		local createElement3 = React.createElement
		local v21 = {
			popoverSide = "Top",
			tooltipLocalizationKey = props.categoryTooltipLocalizationKey,
			tooltipStorageKey = props.categoryTooltipKey or "",
			dismissTooltipRef = ref,
			showTooltip = v8,
			localizedText = 0
		}

		local v22 = if fFlagAXCatalogCategoriesSDUI then props.categoryLocalizedTooltipBody else nil
		v21.localizedText = v22
		v19 = createElement3(axTooltip, v21)
	end

	v14.AXTooltip = v19

	local v20 = not fFlagAXMigrateCategoryTooltip

	if v20 then
		v20 = React.createElement(Foundation.Popover.Root, {
			isOpen = v7 and props.isSelectable
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = ref2 }),
			Content = React.createElement(
				Foundation.Popover.Content,
				{
					align = Foundation.Enums.PopoverAlign.Center,
					side = Foundation.Enums.PopoverSide.Top,
					radius = Foundation.Enums.Radius.Medium,
					backgroundStyle = v9.Color.System.Contrast
				},
				{ React.createElement(
						Foundation.View,
						{
							tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
						},
						{
							CategoryButtonTooltipTitle = React.createElement(
								Foundation.Text,
								{
									Text = v10.tooltipTitle,
									tag = "auto-xy text-title-medium content-inverse-emphasis"
								},
								{
									TooltipOverlayButton = React.createElement("TextButton", {
										Transparency = 1,
										[React.Event.Activated] = props.tooltipActivated,
										Size = UDim2.fromScale(1, 1)
									})
								}
							)
						}
					) }
			)
		})
	end

	v14.ActionButtonPopover = v20
	return createElement("Frame", v13, v14)
end

return MarketplaceCategoryPillWithTooltip
