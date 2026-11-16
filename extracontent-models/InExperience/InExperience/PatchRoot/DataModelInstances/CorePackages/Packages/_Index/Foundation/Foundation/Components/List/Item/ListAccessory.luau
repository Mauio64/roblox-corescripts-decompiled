local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local StateLayerAffordance = require(parent.Foundation.Enums.StateLayerAffordance)

local AccessoryType = require(Foundation.Enums.AccessoryType)

local Avatar = require(Foundation.Components.Avatar)

local useListAccessoryVariants = require(script.Parent.useListAccessoryVariants)

require(Foundation.Enums.InputSize)

local function ListAccessory(props)
	local v = useTokens()
	local v2 = React.useMemo(function()
		if type(props.config) == "string" then
			return { iconName = props.config }
		end

		return props.config
	end, { props.config })
	local v3

	if v2.type == AccessoryType.Avatar then
		v3 = AccessoryType.Avatar
	elseif type(props.config) == "string" or isBuilderOrMigratedIcon(v2.iconName) then
		v3 = AccessoryType.Icon
	else
		v3 = AccessoryType.Media
	end

	local v4 = useListAccessoryVariants(v, props.size, v3)
	local v5

	if v2.type == AccessoryType.Avatar then
		v5 = React.createElement(Avatar, {
			userId = v2.userId,
			backplateStyle = v.Color.Shift.Shift_200,
			size = props.size
		})
	elseif isBuilderOrMigratedIcon(v2.iconName) then
		local createElement = React.createElement
		local name

		if isMigrated(v2.iconName) then
			name = uiblox[v2.iconName].name
		else
			name = v2.iconName
		end

		local variant

		if isMigrated(v2.iconName) then
			variant = uiblox[v2.iconName].variant
		else
			variant = v2.iconVariant
		end

		v5 = createElement(Icon, {
			name = name,
			variant = variant,
			size = v4.accessory.Size.Y.Offset
		})
	else
		v5 = React.createElement(Image, {
			Image = v2.iconName,
			Size = v4.accessory.Size,
			cornerRadius = v4.accessory.cornerRadius
		})
	end

	return React.createElement(View, {
		Size = v4.container.Size,
		tag = "align-x-center align-y-center",
		stateLayer = { affordance = StateLayerAffordance.None },
		isDisabled = props.isDisabled,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}, v5)
end

return React.memo(ListAccessory)
