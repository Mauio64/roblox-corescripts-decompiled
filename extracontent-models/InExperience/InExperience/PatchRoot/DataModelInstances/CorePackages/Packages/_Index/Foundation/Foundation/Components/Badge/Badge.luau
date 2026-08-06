local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BuilderIcons = require(FoundationParent.BuilderIcons)
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
local t1 = {
	testId = "--foundation-badge",
	variant = BadgeVariant.Contrast,
	shape = BadgeShape.Pill,
	size = BadgeSize.XSmall
}
local t2 = {
	[BadgeVariant.Primary] = BadgeVariant.Contrast,
	[BadgeVariant.Secondary] = if not Flags.FoundationBadgeBetaUpdate then BadgeVariant.Neutral else BadgeVariant.Standard,
	[BadgeVariant.Neutral] = if not Flags.FoundationBadgeBetaUpdate then nil else BadgeVariant.Standard
}

local function Badge(p1, p2) -- line: 72
	-- upvalues: withDefaults (copy), t1 (copy), t2 (copy), useScaledValue (copy), useTokens (copy), React (copy), IconPosition (copy), useBadgeVariants (copy), Flags (copy), IconSize (copy), useIconSize (copy), isBuilderOrMigratedIcon (copy), Icon (copy), isMigrated (copy), uiblox (copy), IconVariant (copy), getIconScale (copy), View (copy), Image (copy), withCommonProps (copy), Text (copy)
	local v32 = withDefaults(p1, t1)
	local v33 = t2[v32.variant] or v32.variant
	local v34 = useScaledValue(200)
	local v35 = useTokens()
	local v36 = React.useMemo(function() -- line: 79
		-- upvalues: v32 (copy), IconPosition (copy)
		if typeof(v32.icon) == "string" then
			return {
				name = v32.icon,
				position = IconPosition.Left
			}
		end

		return v32.icon
	end, { v32.icon })
	local v37 = v32.text ~= nil and #v32.text > 0
	local v38 = useBadgeVariants(v35, v33, v32.shape, if not Flags.FoundationBadgeBetaUpdate then nil else v32.size, if not Flags.FoundationBadgeBetaUpdate or not v36 then nil else v36.position, if not Flags.FoundationBadgeBetaUpdate then not v37 else nil)
	local v39 = if not Flags.FoundationBadgeBetaUpdate then IconSize.XSmall else v38.icon.size
	local v40 = useIconSize(v39, true)
	local v41 = nil

	if v36 ~= nil then
		local v42 = v36.position ~= IconPosition.Left and 3 or 1

		if isBuilderOrMigratedIcon(v36.name) then
			v41 = React.createElement(Icon, {
				name = if not isMigrated(v36.name) then v36.name else uiblox[v36.name].name,
				variant = if not isMigrated(v36.name) then if not Flags.FoundationBadgeBetaUpdate then v36.variant else v36.variant or IconVariant.Filled else uiblox[v36.name].variant,
				size = v39,
				style = if not Flags.FoundationBadgeBetaUpdate then v38.content.style else v38.icon.style,
				LayoutOrder = v42,
				testId = `{ v32.testId }--icon`
			})
		else
			local v43, v44 = getIconScale(v36.name, v39)

			if v43 then
				v41 = React.createElement(View, {
					Size = v40
				}, React.createElement(Image, {
					Image = v36.name,
					Size = UDim2.fromOffset(v43.X, v43.Y),
					imageStyle = if not Flags.FoundationBadgeBetaUpdate then v38.content.style else v38.icon.style,
					scale = v44,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					LayoutOrder = v42,
					testId = `{ v32.testId }--icon`
				}))
			end
		end
	end

	return React.createElement(View, withCommonProps(v32, {
		backgroundStyle = v38.container.backgroundStyle,
		stroke = if not Flags.FoundationBadgeBetaUpdate then v38.container.stroke else nil,
		tag = v38.container.tag,
		ref = p2
	}), {
		Icon = v41,
		Text = if not v37 then nil else React.createElement(Text, {
			RichText = true,
			LayoutOrder = 2,
			Text = v32.text,
			textStyle = v38.content.style,
			tag = v38.text.tag,
			testId = `{ v32.testId }--text`,
			sizeConstraint = if not Flags.FoundationBadgeBetaUpdate then nil else {
				MaxSize = Vector2.new(v34, 1e999)
			}
		})
	})
end

return React.memo(React.forwardRef(Badge))
