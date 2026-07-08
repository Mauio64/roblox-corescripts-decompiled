local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local uiblox = require(FoundationParent.BuilderIcons).Migration.uiblox
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local StateLayerAffordance = require(FoundationParent.Foundation.Enums.StateLayerAffordance)
local AccessoryType = require(Foundation.Enums.AccessoryType)
local Avatar = require(Foundation.Components.Avatar)
local useListAccessoryVariants = require(script.Parent.useListAccessoryVariants)

require(Foundation.Enums.InputSize)

local function ListAccessory(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), React (copy), AccessoryType (copy), isBuilderOrMigratedIcon (copy), useListAccessoryVariants (copy), Avatar (copy), Icon (copy), isMigrated (copy), uiblox (copy), Image (copy), View (copy), StateLayerAffordance (copy)
	local v18 = useTokens()
	local v19 = React.useMemo(function() -- line: 47
		-- upvalues: t1 (copy)
		if type(t1.config) == "string" then
			return {
				iconName = t1.config
			}
		end

		return t1.config
	end, { t1.config })
	local v20 = if v19.type ~= AccessoryType.Avatar then if type(t1.config) ~= "string" and not isBuilderOrMigratedIcon(v19.iconName) then AccessoryType.Media else AccessoryType.Icon else AccessoryType.Avatar
	local v21 = useListAccessoryVariants(v18, t1.size, v20)
	local v22 = if v19.type ~= AccessoryType.Avatar then if not isBuilderOrMigratedIcon(v19.iconName) then React.createElement(Image, {
		Image = v19.iconName,
		Size = v21.accessory.Size,
		cornerRadius = v21.accessory.cornerRadius
	}) else React.createElement(Icon, {
		name = if not isMigrated(v19.iconName) then v19.iconName else uiblox[v19.iconName].name,
		variant = if not isMigrated(v19.iconName) then v19.iconVariant else uiblox[v19.iconName].variant,
		size = v21.accessory.Size.Y.Offset
	}) else React.createElement(Avatar, {
		userId = v19.userId,
		backplateStyle = v18.Color.Shift.Shift_200,
		size = t1.size
	})

	return React.createElement(View, {
		tag = "align-x-center align-y-center",
		Size = v21.container.Size,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		isDisabled = t1.isDisabled,
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId
	}, v22)
end

return React.memo(ListAccessory)
