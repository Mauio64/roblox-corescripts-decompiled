local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local React = require(FoundationParent.React)

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
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext

local function ButtonIcon(t1: {[any]: any}) -- line: 38
	-- upvalues: useTokens (copy), useTextSizeOffset (copy), getIconScale (copy), usePresentationContext (copy), useButtonVariants (copy), isBuilderOrMigratedIcon (copy), React (copy), Text (copy), isMigrated (copy), uiblox (copy), BuilderIcons (copy), Image (copy)
	local disabledTransparencyBinding = t1.disabledTransparencyBinding
	local textTransparencyBinding = t1.textTransparencyBinding
	local v20 = useTokens()
	local v21 = useTextSizeOffset()
	local v22, v23 = getIconScale(t1.icon, t1.size)
	local v24 = usePresentationContext()
	local v25 = useButtonVariants(v20, t1.size, t1.variant, if not v24 then nil else v24.colorNamespace)

	if not t1.icon then
		return nil
	end

	if isBuilderOrMigratedIcon(t1.icon) then
		return React.createElement(Text, {
			tag = "position-center-center anchor-center-center",
			Text = if not isMigrated(t1.icon) then t1.icon else uiblox[t1.icon].name,
			fontStyle = {
				Font = BuilderIcons.Font[if not isMigrated(t1.icon) then BuilderIcons.IconVariant.Regular else uiblox[t1.icon].variant],
				FontSize = v25.icon.size.Y.Offset
			},
			Size = v25.icon.size,
			textStyle = React.joinBindings({
				disabledTransparencyBinding,
				textTransparencyBinding
			}):map(function(p1) -- line: 71
				-- upvalues: v25 (copy)
				local v27 = p1[1]
				local v28 = p1[2]

				return {
					Color3 = v25.content.style.Color3,
					Transparency = v28 + v27
				}
			end),
			testId = `{ t1.testId }--icon`
		}, {
			UITextSizeConstraint = if not (v21 > 0) then nil else React.createElement("UITextSizeConstraint", {
				MaxTextSize = v25.icon.size.Y.Offset
			})
		})
	end

	return React.createElement(Image, {
		tag = "position-center-center anchor-center-center",
		Image = t1.icon,
		Size = if not v22 then v25.icon.size else UDim2.fromOffset(v22.X, v22.Y),
		imageStyle = React.joinBindings({
			disabledTransparencyBinding,
			textTransparencyBinding
		}):map(function(p2) -- line: 97
			-- upvalues: v25 (copy)
			local v30 = p2[1]
			local v31 = p2[2]

			return {
				Color3 = v25.content.style.Color3,
				Transparency = v31 + v30
			}
		end),
		scale = v23,
		testId = `{ t1.testId }--icon`
	})
end

return ButtonIcon
