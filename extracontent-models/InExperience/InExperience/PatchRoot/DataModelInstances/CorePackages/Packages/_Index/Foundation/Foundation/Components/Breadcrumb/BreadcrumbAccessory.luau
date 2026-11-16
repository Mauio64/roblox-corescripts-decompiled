local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local AvatarIcon = require(Foundation.Components.AvatarIcon)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)

local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon

local AccessoryType = require(Foundation.Enums.AccessoryType)

require(Foundation.Enums.AvatarIconSize)

require(Foundation.Enums.IconSize)

local function BreadcrumbAccessory(props)
	local variant = props.variant
	local v

	if type(props.config) == "string" then
		v = { iconName = props.config }
	else
		v = props.config
	end

	if v.type == AccessoryType.Avatar then
		return React.createElement(AvatarIcon, {
			userId = v.userId,
			size = variant.avatarSize,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	end

	local iconName = v.iconName

	if not isBuilderOrMigratedIcon(iconName) then
		return React.createElement(Image, {
			Image = iconName,
			tag = variant.tag,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	end

	local createElement = React.createElement
	local name

	if isMigrated(iconName) then
		name = uiblox[iconName].name
	else
		name = iconName
	end

	local variant2

	if isMigrated(iconName) then
		variant2 = uiblox[iconName].variant
	else
		variant2 = v.iconVariant
	end

	return createElement(Icon, {
		name = name,
		variant = variant2,
		size = variant.iconSize,
		style = variant.style,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return React.memo(BreadcrumbAccessory)
