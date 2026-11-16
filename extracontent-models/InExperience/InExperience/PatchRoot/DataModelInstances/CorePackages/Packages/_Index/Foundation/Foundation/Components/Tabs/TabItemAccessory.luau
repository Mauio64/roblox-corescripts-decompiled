local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Badge = require(Foundation.Components.Badge)
local BuilderIcons = require(parent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
require(Foundation.Enums.IconSize)
local Image = require(Foundation.Components.Image)
local StatusIndicator = require(Foundation.Components.StatusIndicator)
require(Foundation.Enums.StatusIndicatorShape)
require(Foundation.Enums.StatusIndicatorVariant)
require(Foundation.Components.Types)
local getIconScale = require(Foundation.Utility.getIconScale)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon

local uiblox = BuilderIcons.Migration.uiblox
local TabItemAccessory = {}

function TabItemAccessory.resolve(iconName, value, value2, data)
	local v

	if value2 == nil then
		v = typeof(iconName) == "string" and { iconName = iconName } or iconName
	else
		v = typeof(value2) == "string" and { iconName = value2 }
			or { iconName = value2.name, iconVariant = value2.variant }
	end

	if data ~= nil then
		return v, {
			type = "StatusIndicator",
			variant = data.variant,
			shape = data.shape,
			value = data.value,
			max = data.max
		}
	end

	if typeof(value) == "string" then
		return v, { iconName = value }
	end

	return v, value
end

function TabItemAccessory.TabItemAccessory(props)
	local accessory = props.accessory

	if accessory.type == "Badge" then
		return React.createElement(Badge, {
			text = accessory.text,
			icon = accessory.icon,
			variant = accessory.variant,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	end

	if accessory.type == "StatusIndicator" then
		local createElement = React.createElement
		local v

		if accessory.value then
			v = {
				value = accessory.value,
				variant = accessory.variant,
				max = accessory.max,
				LayoutOrder = props.LayoutOrder,
				testId = props.testId
			}
		else
			v = {
				variant = accessory.variant,
				shape = accessory.shape,
				LayoutOrder = props.LayoutOrder,
				testId = props.testId
			}
		end

		return createElement(StatusIndicator, v)
	elseif isBuilderOrMigratedIcon(accessory.iconName) then
		local createElement = React.createElement
		local name

		if isMigrated(accessory.iconName) then
			name = uiblox[accessory.iconName].name
		else
			name = accessory.iconName
		end

		local variant

		if isMigrated(accessory.iconName) then
			variant = uiblox[accessory.iconName].variant
		else
			variant = accessory.iconVariant
		end

		return createElement(Icon, {
			name = name,
			variant = variant,
			size = props.iconSize,
			style = props.contentStyle,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	else
		local iconScale, scale = getIconScale(accessory.iconName, props.iconSize)

		if iconScale then
			return React.createElement(Image, {
				Image = accessory.iconName,
				Size = UDim2.fromOffset(iconScale.X, iconScale.Y),
				imageStyle = props.contentStyle,
				scale = scale,
				LayoutOrder = props.LayoutOrder,
				testId = props.testId
			})
		end

		return nil
	end
end

return TabItemAccessory
