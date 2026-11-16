local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local React = require(parent.React)

require(Foundation.Enums.ButtonVariant)

require(Foundation.Enums.InputSize)

local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)

local getIconScale = require(Foundation.Utility.getIconScale)

local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon

local useButtonVariants = require(script.Parent.useButtonVariants)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTokens = require(Foundation.Providers.Style.useTokens)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext

local function ButtonIcon(props)
	local disabledTransparencyBinding = props.disabledTransparencyBinding
	local textTransparencyBinding = props.textTransparencyBinding

	local v = useTokens()
	local v2 = useTextSizeOffset()
	local iconScale, scale = getIconScale(props.icon, props.size)
	local v3 = usePresentationContext()

	local size = props.size
	local variant = props.variant
	local v4

	if v3 then
		v4 = v3.colorNamespace
	end

	local v5 = useButtonVariants(v, size, variant, v4)

	if not props.icon then
		return nil
	end

	if isBuilderOrMigratedIcon(props.icon) then
		local createElement = React.createElement
		local text

		if isMigrated(props.icon) then
			text = uiblox[props.icon].name
		else
			text = props.icon
		end

		local font = BuilderIcons.Font
		local v6

		if isMigrated(props.icon) then
			v6 = uiblox[props.icon].variant
		else
			v6 = BuilderIcons.IconVariant.Regular
		end

		local v7 = {
			Text = text,
			fontStyle = { Font = font[v6], FontSize = v5.icon.size.Y.Offset },
			tag = "position-center-center anchor-center-center",
			Size = v5.icon.size,
			textStyle = React.joinBindings({ disabledTransparencyBinding, textTransparencyBinding }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return {
					Color3 = v5.content.style.Color3,
					Transparency = item2 + item
				}
			end),
			testId = `{props.testId}--icon`
		}
		local uiTextSizeConstraint

		if v2 > 0 then
			uiTextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = v5.icon.size.Y.Offset
			})
		end

		return createElement(Text, v7, { UITextSizeConstraint = uiTextSizeConstraint })
	else
		local createElement = React.createElement
		local v6 = {
			tag = "position-center-center anchor-center-center",
			Image = props.icon,
			Size = 0,
			imageStyle = 0,
			scale = 0,
			testId = 0
		}
		local size2

		if iconScale then
			size2 = UDim2.fromOffset(iconScale.X, iconScale.Y)
		else
			size2 = v5.icon.size
		end

		v6.Size = size2

		v6.imageStyle = React.joinBindings({ disabledTransparencyBinding, textTransparencyBinding }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return {
				Color3 = v5.content.style.Color3,
				Transparency = item2 + item
			}
		end)

		v6.scale = scale
		v6.testId = `{props.testId}--icon`
		return createElement(Image, v6)
	end
end

return ButtonIcon
