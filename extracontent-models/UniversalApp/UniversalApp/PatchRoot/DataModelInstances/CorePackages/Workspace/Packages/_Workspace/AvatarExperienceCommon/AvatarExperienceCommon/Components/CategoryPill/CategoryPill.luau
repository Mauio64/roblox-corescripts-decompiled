local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(AvatarExperienceCommonParent.Localization).Hooks.useLocalization
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXCategoryPillColorAnimation = AvatarExperienceFlags.FFlagAXCategoryPillColorAnimation
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local FFlagAXDisableHiddenCatalogCategoryPills = AvatarExperienceFlags.FFlagAXDisableHiddenCatalogCategoryPills
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local useCategoryPillColorAnimation = require(AvatarExperienceCommon.Hooks.useCategoryPillColorAnimation)

local function CategoryPill(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), useLocalization (copy), FFlagAXCatalogCategoriesSDUI (copy), React (copy), FFlagAXCategoryPillColorAnimation (copy), useCategoryPillColorAnimation (copy), Foundation (copy), FFlagAXCategoryPillPositionAnimation (copy), FFlagAXDisableHiddenCatalogCategoryPills (copy)
	local v15 = useTokens()
	local v16 = useLocalization({
		title = if not FFlagAXCatalogCategoriesSDUI or not t1.localizedTitle then t1.title else nil
	})
	local pillIndex = t1.pillIndex
	local navButtonRefs = t1.navButtonRefs
	local categories = t1.categories
	local u20 = React.useRef(nil)

	if t1.pillRef then
		u20 = t1.pillRef
	end

	local v21 = if not FFlagAXCategoryPillColorAnimation then nil else useCategoryPillColorAnimation(t1.isChecked)

	React.useEffect(function() -- line: 64
		-- upvalues: u20 (ref), t1 (copy), pillIndex (copy)
		if u20.current then
			t1.categoryButtonRefs[t1.id] = u20
			t1.navButtonRefs[pillIndex] = u20
		end
	end, {})

	local ActionStandard = v15.Color.ActionStandard

	if t1.isChecked and not t1.isSubcategory then
		ActionStandard = v15.Color.ActionSubEmphasis
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, v15.Size.Size_800),
		backgroundStyle = if not FFlagAXCategoryPillColorAnimation or (t1.isSubcategory or v21 == nil) then ActionStandard.Background else v21.animatedBackgroundStyle,
		onActivated = t1.onActivated,
		LayoutOrder = t1.layoutOrder or nil,
		ref = u20,
		NextSelectionLeft = if not FFlagAXCategoryPillPositionAnimation then pillIndex > 1 and navButtonRefs[pillIndex - 1] or nil else nil,
		NextSelectionRight = if not FFlagAXCategoryPillPositionAnimation then pillIndex < #categories and navButtonRefs[pillIndex + 1] or nil else nil,
		isDisabled = if not FFlagAXDisableHiddenCatalogCategoryPills then nil else not t1.isSelectable,
		selection = if not FFlagAXCategoryPillPositionAnimation then nil else {
			Selectable = t1.isSelectable
		},
		stroke = if not t1.isSubcategory or not t1.isChecked then nil else {
			Thickness = 1,
			Color = v15.Color.System.Contrast.Color3,
			Transparency = v15.Color.System.Contrast.Transparency
		}
	}, {
		PillText = React.createElement(Foundation.Text, {
			tag = "auto-xy text-align-x-center text-align-y-center text-no-wrap padding-x-xsmall text-truncate-end",
			Text = if not FFlagAXCatalogCategoriesSDUI or not t1.localizedTitle then v16.title else t1.localizedTitle,
			textStyle = if not FFlagAXCategoryPillColorAnimation or (t1.isSubcategory or v21 == nil) then ActionStandard.Foreground else v21.animatedTextStyle,
			fontStyle = v15.Typography.CaptionLarge
		})
	})
end

return CategoryPill
