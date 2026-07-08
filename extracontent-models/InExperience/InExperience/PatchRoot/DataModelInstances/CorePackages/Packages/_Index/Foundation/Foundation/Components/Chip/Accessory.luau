local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local uiblox = require(FoundationParent.BuilderIcons).Migration.uiblox
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

local useBackgroundStyle = require(Foundation.Providers.Style.BackgroundStyleContext).useBackgroundStyle

require(Foundation.Components.Types)

local useAccessoryVariants = require(script.Parent.useAccessoryVariants)

require(Foundation.Enums.ChipSize)

local function AvatarGroupWrapper(t1: {[any]: any}) -- line: 64
	-- upvalues: useBackgroundStyle (copy), useCumulativeBackground (copy), React (copy), AvatarGroup (copy)
	local v19 = useBackgroundStyle()
	local v20 = table.clone(t1.config.props)

	v20.size = t1.size
	v20.backplateStyle = useCumulativeBackground(v19, t1.chipBackgroundStyle)

	return React.createElement(AvatarGroup, v20)
end
local function Accessory(t2: {[any]: any}) -- line: 72
	-- upvalues: useTokens (copy), React (copy), useAccessoryVariants (copy), AvatarGroupWrapper (copy), isBuilderOrMigratedIcon (copy), Icon (copy), isMigrated (copy), uiblox (copy), Image (copy), View (copy)
	local v22 = useTokens()
	local v23 = React.useMemo(function() -- line: 74
		-- upvalues: t2 (copy)
		if type(t2.config) == "string" then
			return {
				isCircular = false,
				iconName = t2.config
			}
		end

		return t2.config
	end, { t2.config })
	local v24 = useAccessoryVariants(v22, t2.size, t2.isLeading, v23.type == "AvatarGroup" or (v23.isCircular or false))
	local v25 = if v23.type ~= "AvatarGroup" then if not isBuilderOrMigratedIcon(v23.iconName) then React.createElement(Image, {
		Image = v23.iconName,
		Size = v24.accessory.Size,
		imageStyle = t2.contentStyle
	}) else React.createElement(Icon, {
		name = if not isMigrated(v23.iconName) then v23.iconName else uiblox[v23.iconName].name,
		variant = if not isMigrated(v23.iconName) then v23.iconVariant else uiblox[v23.iconName].variant,
		size = v24.accessory.Size.Y.Offset,
		style = t2.contentStyle
	}) else React.createElement(AvatarGroupWrapper, t2)

	return React.createElement(View, {
		tag = "auto-xy",
		padding = v24.accessory.padding,
		onActivated = v23.onActivated,
		isDisabled = t2.isDisabled,
		LayoutOrder = not t2.isLeading and 3 or 1,
		testId = t2.testId
	}, v25)
end

return React.memo(Accessory)
