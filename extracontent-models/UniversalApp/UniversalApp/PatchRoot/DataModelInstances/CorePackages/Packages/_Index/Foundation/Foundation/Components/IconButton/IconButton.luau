local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)
local uiblox = BuilderIcons.Migration.uiblox

local InputSize = require(Foundation.Enums.InputSize)

local FillBehavior = require(Foundation.Enums.FillBehavior)

require(Foundation.Enums.IconSize)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)

require(Foundation.Enums.Radius)

local useTokens = require(Foundation.Providers.Style.useTokens)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext
local getIconScale = require(Foundation.Utility.getIconScale)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local useIconButtonVariants = require(script.Parent.useIconButtonVariants)
local useIconSize = require(Foundation.Utility.useIconSize)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon

local Constants = require(Foundation.Constants)

local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local v = {
	isDisabled = false,
	size = InputSize.Medium,
	width = UDim.new(0, 0),
	isCircular = false,
	variant = ButtonVariant.Utility,
	testId = "--foundation-icon-button"
}

local function IconButton(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePresentationContext()
	local image

	if typeof(v2.icon) == "table" then
		image = v2.icon.name
	else
		image = v2.icon
	end

	local variant

	if typeof(v2.icon) == "table" then
		variant = v2.icon.variant
	end

	local v5, scale

	if isBuilderOrMigratedIcon(image) then
		scale = 1
	else
		v5, scale = getIconScale(image, v2.size)
	end

	local size = v2.size
	local variant2 = v2.variant
	local v6

	if v4 then
		v6 = v4.colorNamespace
	end

	local v7 = useIconButtonVariants(v3, size, variant2, v6)

	local size2 = v7.container.size
	local udim

	if v2.isCircular then
		udim = UDim.new(0, v3.Radius.Circle)
	else
		udim = UDim.new(0, v7.container.radius or v3.Radius.Large)
	end

	local size3 = useIconSize(v2.size, isBuilderIcon(image), true)

	local cursor = React.useMemo(function()
		return { radius = udim, offset = v3.Size.Size_150, borderWidth = v3.Stroke.Thicker }
	end, { v3, udim })

	local v8 = v2.fillBehavior == FillBehavior.Fill

	local v9 = v2.width.Scale ~= 0 or v2.width.Offset ~= 0
	local v10

	if v8 then
		v10 = UDim.new(1, 0)
	else
		v10 = if v9 then v2.width else size2.X
	end

	local createElement = React.createElement

	local v11 = {
		onActivated = v2.onActivated,
		Size = UDim2.new(v10, UDim.new(0, size2.Y.Offset)),
		flexItem = 0,
		selection = 0,
		isDisabled = 0,
		stateLayer = 0,
		padding = 0,
		cornerRadius = 0,
		backgroundStyle = 0,
		stroke = 0,
		cursor = 0,
		GroupTransparency = 0,
		ref = 0
	}
	local flexItem

	if v2.fillBehavior then
		flexItem = { FlexMode = 0 }
		local flexMode

		if v2.fillBehavior == FillBehavior.Fill then
			flexMode = Enum.UIFlexMode.Fill
		else
			flexMode = Enum.UIFlexMode.Shrink
		end

		flexItem.FlexMode = flexMode
	end

	v11.flexItem = flexItem

	v11.selection = {
		Selectable = not v2.isDisabled and v2.Selectable,
		NextSelectionUp = v2.NextSelectionUp,
		NextSelectionDown = v2.NextSelectionDown,
		NextSelectionLeft = v2.NextSelectionLeft,
		NextSelectionRight = v2.NextSelectionRight
	}

	v11.isDisabled = v2.isDisabled
	v11.stateLayer = v7.container.stateLayer
	v11.padding = v7.container.padding
	v11.cornerRadius = udim
	v11.backgroundStyle = v7.container.style
	v11.stroke = v7.container.stroke
	v11.cursor = cursor
	local groupTransparency

	if v2.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	v11.GroupTransparency = groupTransparency
	v11.ref = ref
	local v12 = withCommonProps(v2, v11)
	local icon

	if isBuilderOrMigratedIcon(image) then
		local createElement2 = React.createElement
		local text

		if isMigrated(image) then
			text = uiblox[image].name
		else
			text = image
		end

		local font = BuilderIcons.Font
		local v13

		if isMigrated(image) then
			v13 = uiblox[image].variant
		else
			v13 = variant or BuilderIcons.IconVariant.Regular
		end

		icon = createElement2(Text, {
			Text = text,
			fontStyle = { Font = font[v13], FontSize = size3.Y.Offset },
			tag = "position-center-center anchor-center-center",
			Size = size3,
			textStyle = v7.content.style,
			testId = `{v2.testId}--icon`
		})
	else
		local createElement2 = React.createElement

		if v5 then
			size3 = UDim2.fromOffset(v5.X, v5.Y)
		end

		icon = createElement2(Image, {
			tag = "position-center-center anchor-center-center",
			Image = image,
			Size = size3,
			imageStyle = v7.content.style,
			scale = scale,
			testId = `{v2.testId}--image`
		})
	end

	return createElement(View, v12, { Icon = icon })
end

return React.memo(React.forwardRef(IconButton))
