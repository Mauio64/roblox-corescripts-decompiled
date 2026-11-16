local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local axTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXTooltip

local fFlagAXShowFavoritePillFtuxTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXShowFavoritePillFtuxTooltip

local chip = Foundation.Chip
local enums = Foundation.Enums
local iconName = enums.IconName
local iconVariant = enums.IconVariant

local function FavoritePillView(props)
	local tooltipProps = props.tooltipProps

	local layoutOrder = if not fFlagAXShowFavoritePillFtuxTooltip then props.LayoutOrder else nil
	local v5

	if props.favoritesCount == nil then
		v5 = React.createElement(Foundation.Skeleton, {
			Size = UDim2.fromOffset(120, 36),
			LayoutOrder = layoutOrder,
			testId = "FavoritePillSkeleton"
		})
	else
		local createElement = React.createElement
		local v7 = {
			text = `{props.formatCount(props.favoritesCount)} {props.favoritesLabel}`,
			leading = 0,
			onActivated = 0,
			isDisabled = 0,
			LayoutOrder = 0,
			testId = "FavoritePillView"
		}
		local v8 = { iconName = iconName.Star, iconVariant = 0 }

		local v9 = if props.isFavorited == true then iconVariant.Filled else iconVariant.Regular
		v8.iconVariant = v9
		v7.leading = v8

		v7.onActivated = props.onActivated or function() end
		v7.isDisabled = props.isDisabled
		v7.LayoutOrder = layoutOrder
		v5 = createElement(chip, v7)
	end

	if fFlagAXShowFavoritePillFtuxTooltip and tooltipProps ~= nil then
		return React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = props.LayoutOrder
		}, {
			Pill = v5,
			FtuxTooltip = React.createElement(axTooltip, tooltipProps)
		})
	end

	return v5
end

return React.memo(FavoritePillView)
