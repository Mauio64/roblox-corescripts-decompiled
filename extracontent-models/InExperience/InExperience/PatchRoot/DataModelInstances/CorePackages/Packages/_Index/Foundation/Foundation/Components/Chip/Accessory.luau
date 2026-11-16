local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local useCumulativeBackground = require(Foundation.Utility.useCumulativeBackground)
local useTokens = require(Foundation.Providers.Style.useTokens)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local AvatarGroup = require(Foundation.Components.AvatarGroup)

require(Foundation.Enums.AvatarGroupType)

local BackgroundStyleContext = require(Foundation.Providers.Style.BackgroundStyleContext)
local useBackgroundStyle = BackgroundStyleContext.useBackgroundStyle

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local useAccessoryVariants = require(script.Parent.useAccessoryVariants)

require(Foundation.Enums.ChipSize)

local function AvatarGroupWrapper(props)
	local v = useBackgroundStyle()
	local clone = table.clone(props.config.props)
	clone.size = props.size
	clone.backplateStyle = useCumulativeBackground(v, props.chipBackgroundStyle)
	return React.createElement(AvatarGroup, clone)
end

local function Accessory(props)
	local v = useTokens()
	local v2 = React.useMemo(function()
		if type(props.config) == "string" then
			return { iconName = props.config, isCircular = false }
		end

		return props.config
	end, { props.config })

	local size = props.size
	local isLeading = props.isLeading
	local v3

	if Flags.FoundationFixChipAccessoryLayout then
		v3 = v2.type == "AvatarGroup"
	else
		v3 = v2.type == "AvatarGroup" or (v2.isCircular or false)
	end

	local v4 = useAccessoryVariants(v, size, isLeading, v3, props.isIconOnly)
	local v5

	if v2.type == "AvatarGroup" then
		v5 = React.createElement(AvatarGroupWrapper, props)
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
			size = v4.accessory.Size.Y.Offset,
			style = props.contentStyle
		})
	else
		v5 = React.createElement(Image, {
			Image = v2.iconName,
			Size = v4.accessory.Size,
			imageStyle = props.contentStyle
		})
	end

	return React.createElement(View, {
		tag = "auto-xy",
		padding = v4.accessory.padding,
		onActivated = v2.onActivated,
		isDisabled = props.isDisabled,
		LayoutOrder = props.isLeading and 1 or 3,
		testId = props.testId
	}, v5)
end

return React.memo(Accessory)
