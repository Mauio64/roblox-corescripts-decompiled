local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local uiblox = BuilderIcons.Migration.uiblox
local InputSize = require(Foundation.Enums.InputSize)
local FillBehavior = require(Foundation.Enums.FillBehavior)

require(Foundation.Enums.IconSize)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)

require(Foundation.Enums.Radius)

local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
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
local t1 = {
	isDisabled = false,
	isCircular = false,
	testId = "--foundation-icon-button",
	size = InputSize.Medium,
	width = UDim.new(0, 0),
	variant = ButtonVariant.Utility
}

local function IconButton(p1, p2) -- line: 79
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), isBuilderOrMigratedIcon (copy), getIconScale (copy), useIconButtonVariants (copy), useIconSize (copy), isBuilderIcon (copy), React (copy), FillBehavior (copy), View (copy), withCommonProps (copy), Constants (copy), Text (copy), isMigrated (copy), uiblox (copy), BuilderIcons (copy), Image (copy)
	local v28 = withDefaults(p1, t1)
	local v29 = useTokens()
	local v30 = usePresentationContext()
	local v31 = if typeof(v28.icon) ~= "table" then v28.icon else v28.icon.name
	local v32 = if typeof(v28.icon) ~= "table" then nil else v28.icon.variant
	local v33, n1

	if isBuilderOrMigratedIcon(v31) then
		v33 = nil
		n1 = 1
	else
		v33, n1 = getIconScale(v31, v28.size)
	end

	local v35 = useIconButtonVariants(v29, v28.size, v28.variant, if not v30 then nil else v30.colorMode)
	local size = v35.container.size
	local v37 = if not v28.isCircular then UDim.new(0, v35.container.radius or v29.Radius.Large) else UDim.new(0, v29.Radius.Circle)
	local v38 = useIconSize(v28.size, isBuilderIcon(v31), true)
	local v39 = React.useMemo(function() -- line: 111
		-- upvalues: v37 (copy), v29 (copy)
		return {
			radius = v37,
			offset = v29.Size.Size_150,
			borderWidth = v29.Stroke.Thicker
		}
	end, {
		v29,
		v37
	})
	local v40 = v28.fillBehavior == FillBehavior.Fill
	local v41 = v28.width.Scale ~= 0 or v28.width.Offset ~= 0
	local v42 = if not v40 then if not v41 then size.X else v28.width else UDim.new(1, 0)

	return React.createElement(View, withCommonProps(v28, {
		onActivated = v28.onActivated,
		Size = UDim2.new(v42, UDim.new(0, size.Y.Offset)),
		flexItem = if not v28.fillBehavior then nil else {
			FlexMode = if v28.fillBehavior ~= FillBehavior.Fill then Enum.UIFlexMode.Shrink else Enum.UIFlexMode.Fill
		},
		selection = {
			Selectable = not v28.isDisabled and v28.Selectable,
			NextSelectionUp = v28.NextSelectionUp,
			NextSelectionDown = v28.NextSelectionDown,
			NextSelectionLeft = v28.NextSelectionLeft,
			NextSelectionRight = v28.NextSelectionRight
		},
		isDisabled = v28.isDisabled,
		stateLayer = v35.container.stateLayer,
		padding = v35.container.padding,
		cornerRadius = v37,
		backgroundStyle = v35.container.style,
		stroke = v35.container.stroke,
		cursor = v39,
		GroupTransparency = if not v28.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		ref = p2
	}), {
		Icon = if not isBuilderOrMigratedIcon(v31) then React.createElement(Image, {
			tag = "position-center-center anchor-center-center",
			Image = v31,
			Size = if not v33 then v38 else UDim2.fromOffset(v33.X, v33.Y),
			imageStyle = v35.content.style,
			scale = n1,
			testId = `{ v28.testId }--image`
		}) else React.createElement(Text, {
			tag = "position-center-center anchor-center-center",
			Text = if not isMigrated(v31) then v31 else uiblox[v31].name,
			fontStyle = {
				Font = BuilderIcons.Font[if not isMigrated(v31) then v32 or BuilderIcons.IconVariant.Regular else uiblox[v31].variant],
				FontSize = v38.Y.Offset
			},
			Size = v38,
			textStyle = v35.content.style,
			testId = `{ v28.testId }--icon`
		})
	})
end

return React.memo(React.forwardRef(IconButton))
