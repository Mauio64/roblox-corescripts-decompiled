local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXCategoryPillColorAnimation = AvatarExperienceFlags.FFlagAXCategoryPillColorAnimation
local fFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local fFlagAXDisableHiddenCatalogCategoryPills = AvatarExperienceFlags.FFlagAXDisableHiddenCatalogCategoryPills
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local useCategoryPillColorAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useCategoryPillColorAnimation")

local function CategoryPill(props)
	local v5 = useTokens()

	local v8 = if not (fFlagAXCatalogCategoriesSDUI and props.localizedTitle) then props.title else nil
	local v9 = useLocalization({ title = v8 })

	local pillIndex = props.pillIndex
	local navButtonRefs = props.navButtonRefs
	local categories = props.categories

	local v10 = React.useRef(nil)

	if props.pillRef then
		v10 = props.pillRef
	end

	local v11 = if fFlagAXCategoryPillColorAnimation then useCategoryPillColorAnimation(props.isChecked) else nil

	React.useEffect(function()
		if v10.current then
			props.categoryButtonRefs[props.id] = v10
			props.navButtonRefs[pillIndex] = v10
		end
	end, {})

	local v12 = v5.Color.ActionStandard

	if props.isChecked and not props.isSubcategory then
		v12 = v5.Color.ActionSubEmphasis
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v13 = {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, v5.Size.Size_800),
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

	local v14 = if fFlagAXCategoryPillColorAnimation and not props.isSubcategory and v11 ~= nil then v11.animatedBackgroundStyle else v12.Background
	v13.backgroundStyle = v14

	v13.onActivated = props.onActivated
	v13.LayoutOrder = props.layoutOrder or nil
	v13.ref = v10

	local v15 = if not fFlagAXCategoryPillPositionAnimation and pillIndex > 1 then navButtonRefs[pillIndex - 1] or nil else nil
	v13.NextSelectionLeft = v15

	local v16 = if not fFlagAXCategoryPillPositionAnimation then pillIndex < #categories and navButtonRefs[pillIndex + 1] or nil else nil
	v13.NextSelectionRight = v16

	local v17 = if fFlagAXDisableHiddenCatalogCategoryPills then not props.isSelectable else nil
	v13.isDisabled = v17
	v13.selection = fFlagAXCategoryPillPositionAnimation and {
		Selectable = props.isSelectable
	} or nil

	v13.stroke = props.isSubcategory
		and props.isChecked
		and {
			Color = v5.Color.System.Contrast.Color3,
			Transparency = v5.Color.System.Contrast.Transparency,
			Thickness = 1
		}
		or nil

	local createElement2 = React.createElement
	local text = Foundation.Text
	local v20 = if fFlagAXCatalogCategoriesSDUI and props.localizedTitle then props.localizedTitle else v9.title

	local v21 = if fFlagAXCategoryPillColorAnimation and not props.isSubcategory and v11 ~= nil then v11.animatedTextStyle else v12.Foreground
	return createElement(view, v13, {
		PillText = createElement2(text, {
			Text = v20,
			textStyle = v21,
			fontStyle = v5.Typography.CaptionLarge,
			tag = "auto-xy text-align-x-center text-align-y-center text-no-wrap padding-x-xsmall text-truncate-end"
		})
	})
end

return CategoryPill
