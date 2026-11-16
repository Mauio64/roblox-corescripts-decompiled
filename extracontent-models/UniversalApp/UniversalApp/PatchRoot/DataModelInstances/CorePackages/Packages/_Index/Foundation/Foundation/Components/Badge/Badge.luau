local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local IconVariant = BuilderIcons.IconVariant

local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getIconScale = require(Foundation.Utility.getIconScale)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local useBadgeVariants = require(script.Parent.useBadgeVariants)
local useIconSize = require(Foundation.Utility.useIconSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local Flags = require(Foundation.Utility.Flags)
local useScaledValue = require(Foundation.Utility.useScaledValue)

local BadgeVariant = require(Foundation.Enums.BadgeVariant)

local BadgeShape = require(Foundation.Enums.BadgeShape)

local BadgeSize = require(Foundation.Enums.BadgeSize)

local IconSize = require(Foundation.Enums.IconSize)

local IconPosition = require(Foundation.Enums.IconPosition)

local v = {
	variant = BadgeVariant.Contrast,
	shape = BadgeShape.Pill,
	size = BadgeSize.Small,
	testId = "--foundation-badge"
}

local v2 = { [BadgeVariant.Primary] = BadgeVariant.Contrast }
local Secondary = BadgeVariant.Secondary
local v3

if Flags.FoundationBadgeBetaUpdate then
	v3 = BadgeVariant.Standard
else
	v3 = BadgeVariant.Neutral
end

v2[Secondary] = v3
local Neutral = BadgeVariant.Neutral
local v4

if Flags.FoundationBadgeBetaUpdate then
	v4 = BadgeVariant.Standard
end

v2[Neutral] = v4

local function Badge(p, ref)
	local v5 = withDefaults(p, v)
	local v6 = v2[v5.variant] or v5.variant
	local v7 = useScaledValue(200)

	local v8 = useTokens()

	local v9 = React.useMemo(function()
		if typeof(v5.icon) == "string" then
			return { name = v5.icon, position = IconPosition.Left }
		end

		return v5.icon
	end, { v5.icon })
	local v10

	if v5.text == nil then
		v10 = false
	else
		v10 = #v5.text > 0
	end

	local v11 = not v10

	local shape = v5.shape
	local size

	if Flags.FoundationBadgeBetaUpdate then
		size = v5.size
	end

	local position

	if Flags.FoundationBadgeBetaUpdate and v9 then
		position = v9.position
	end

	if Flags.FoundationBadgeBetaUpdate then
		v11 = nil
	end

	local v12 = useBadgeVariants(v8, v6, shape, size, position, v11)
	local size2

	if Flags.FoundationBadgeBetaUpdate then
		size2 = v12.icon.size
	else
		size2 = IconSize.XSmall
	end

	local size3 = useIconSize(size2, true)

	local icon = nil

	if v9 ~= nil then
		local layoutOrder = v9.position == IconPosition.Left and 1 or 3

		if isBuilderOrMigratedIcon(v9.name) then
			local createElement = React.createElement
			local name

			if isMigrated(v9.name) then
				name = uiblox[v9.name].name
			else
				name = v9.name
			end

			local variant

			if isMigrated(v9.name) then
				variant = uiblox[v9.name].variant
			elseif Flags.FoundationBadgeBetaUpdate then
				variant = v9.variant or IconVariant.Filled
			else
				variant = v9.variant
			end

			local style

			if Flags.FoundationBadgeBetaUpdate then
				style = v12.icon.style
			else
				style = v12.content.style
			end

			icon = createElement(Icon, {
				name = name,
				variant = variant,
				size = size2,
				style = style,
				LayoutOrder = layoutOrder,
				testId = `{v5.testId}--icon`
			})
		else
			local iconScale, scale = getIconScale(v9.name, size2)

			if iconScale then
				local createElement = React.createElement

				local createElement2 = React.createElement
				local v13 = {
					Image = v9.name,
					Size = UDim2.fromOffset(iconScale.X, iconScale.Y),
					imageStyle = 0,
					scale = 0,
					AnchorPoint = 0,
					Position = 0,
					LayoutOrder = 0,
					testId = 0
				}
				local imageStyle

				if Flags.FoundationBadgeBetaUpdate then
					imageStyle = v12.icon.style
				else
					imageStyle = v12.content.style
				end

				v13.imageStyle = imageStyle

				v13.scale = scale
				v13.AnchorPoint = Vector2.new(0.5, 0.5)
				v13.Position = UDim2.fromScale(0.5, 0.5)
				v13.LayoutOrder = layoutOrder
				v13.testId = `{v5.testId}--icon`
				icon = createElement(View, { Size = size3 }, createElement2(Image, v13))
			end
		end
	end

	local createElement = React.createElement

	local v13 = withCommonProps(v5, {
		backgroundStyle = v12.container.backgroundStyle,
		stroke = v12.container.stroke,
		tag = v12.container.tag,
		ref = ref
	})
	local text

	if v10 then
		text = React.createElement(Text, {
			Text = v5.text,
			textStyle = v12.content.style,
			RichText = true,
			LayoutOrder = 2,
			tag = v12.text.tag,
			testId = `{v5.testId}--text`,
			sizeConstraint = Flags.FoundationBadgeBetaUpdate and {
				MaxSize = Vector2.new(v7, 1e999)
			} or nil
		})
	end

	return createElement(View, v13, { Icon = icon, Text = text })
end

return React.memo(React.forwardRef(Badge))
