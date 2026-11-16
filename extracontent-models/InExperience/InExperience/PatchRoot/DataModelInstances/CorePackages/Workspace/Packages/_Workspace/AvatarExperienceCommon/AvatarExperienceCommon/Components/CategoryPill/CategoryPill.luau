local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryPillColorAnimation = AvatarExperienceFlags.FFlagAXCategoryPillColorAnimation
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local FFlagAXDisableHiddenCatalogCategoryPills = AvatarExperienceFlags.FFlagAXDisableHiddenCatalogCategoryPills
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local useCategoryPillColorAnimation = require(AvatarExperienceCommon.Hooks.useCategoryPillColorAnimation)

local function CategoryPill(props)
	local v = useTokens()
	local title

	if not (FFlagAXCatalogCategoriesSDUI and props.localizedTitle) then
		title = props.title
	end

	local v2 = useLocalization({ title = title })

	local pillIndex = props.pillIndex
	local navButtonRefs = props.navButtonRefs
	local categories = props.categories

	local ref = React.useRef(nil)

	if props.pillRef then
		ref = props.pillRef
	end

	local v3

	if FFlagAXCategoryPillColorAnimation then
		v3 = useCategoryPillColorAnimation(props.isChecked)
	end

	React.useEffect(function()
		if ref.current then
			props.categoryButtonRefs[props.id] = ref
			props.navButtonRefs[pillIndex] = ref
		end
	end, {})

	local v4 = v.Color.ActionStandard

	if props.isChecked and not props.isSubcategory then
		v4 = v.Color.ActionSubEmphasis
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, v.Size.Size_800),
		backgroundStyle = 0,
		onActivated = 0,
		LayoutOrder = 0,
		ref = 0,
		NextSelectionLeft = 0,
		NextSelectionRight = 0,
		isDisabled = 0,
		selection = 0,
		stroke = 0
	}
	local backgroundStyle

	if FFlagAXCategoryPillColorAnimation and not props.isSubcategory and v3 ~= nil then
		backgroundStyle = v3.animatedBackgroundStyle
	else
		backgroundStyle = v4.Background
	end

	v5.backgroundStyle = backgroundStyle

	v5.onActivated = props.onActivated
	v5.LayoutOrder = props.layoutOrder or nil
	v5.ref = ref
	local nextSelectionLeft

	if not (FFlagAXCategoryPillPositionAnimation or not (pillIndex > 1)) then
		nextSelectionLeft = navButtonRefs[pillIndex - 1] or nil
	end

	v5.NextSelectionLeft = nextSelectionLeft
	local nextSelectionRight

	if not FFlagAXCategoryPillPositionAnimation then
		nextSelectionRight = pillIndex < #categories and navButtonRefs[pillIndex + 1] or nil
	end

	v5.NextSelectionRight = nextSelectionRight
	local isDisabled

	if FFlagAXDisableHiddenCatalogCategoryPills then
		isDisabled = not props.isSelectable
	end

	v5.isDisabled = isDisabled
	v5.selection = FFlagAXCategoryPillPositionAnimation and { Selectable = props.isSelectable } or nil

	v5.stroke = props.isSubcategory
		and props.isChecked
		and {
			Color = v.Color.System.Contrast.Color3,
			Transparency = v.Color.System.Contrast.Transparency,
			Thickness = 1
		}
		or nil

	local createElement2 = React.createElement
	local text = Foundation.Text
	local text2

	if FFlagAXCatalogCategoriesSDUI and props.localizedTitle then
		text2 = props.localizedTitle
	else
		text2 = v2.title
	end

	local textStyle

	if FFlagAXCategoryPillColorAnimation and not props.isSubcategory and v3 ~= nil then
		textStyle = v3.animatedTextStyle
	else
		textStyle = v4.Foreground
	end

	return createElement(view, v5, {
		PillText = createElement2(text, {
			Text = text2,
			textStyle = textStyle,
			fontStyle = v.Typography.CaptionLarge,
			tag = "auto-xy text-align-x-center text-align-y-center text-no-wrap padding-x-xsmall text-truncate-end"
		})
	})
end

return CategoryPill
