local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BuilderIcons = require(FoundationParent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local StatusIndicator = require(Foundation.Components.StatusIndicator)

require(Foundation.Enums.StatusIndicatorShape)
require(Foundation.Enums.StatusIndicatorVariant)

local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local uiblox = BuilderIcons.Migration.uiblox
local FillBehavior = require(Foundation.Enums.FillBehavior)

require(Foundation.Enums.InputSize)

local getIconScale = require(Foundation.Utility.getIconScale)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local Constants = require(Foundation.Constants)
local useTabItemVariants = require(script.Parent.useTabItemVariants)
local Flags = require(Foundation.Utility.Flags)

local function TabItem(p1, p2) -- line: 68
	-- upvalues: useTokens (copy), FillBehavior (copy), useTabItemVariants (copy), React (copy), BuilderIcons (copy), isBuilderOrMigratedIcon (copy), Icon (copy), isMigrated (copy), uiblox (copy), getIconScale (copy), Image (copy), Flags (copy), View (copy), Constants (copy), Text (copy), StatusIndicator (copy)
	local v23 = useTokens()
	local v24 = if not p1.isActive then v23.Color.Content.Emphasis else v23.Color.Content.Default
	local v25 = p1.fillBehavior == FillBehavior.Fill
	local v26 = useTabItemVariants(v23, p1.size, v25)
	local v27 = React.useMemo(function() -- line: 77
		-- upvalues: v23 (copy)
		return {
			offset = 0,
			radius = UDim.new(0, 0),
			borderWidth = v23.Stroke.Thicker
		}
	end, { v23 })
	local v28 = React.useMemo(function() -- line: 85
		-- upvalues: p1 (copy), BuilderIcons (copy)
		if p1.icon == nil then
			return nil
		end

		if typeof(p1.icon) == "string" then
			return {
				name = p1.icon,
				variant = BuilderIcons.IconVariant.Regular
			}
		end

		return p1.icon
	end, { p1.icon })
	local v29 = nil

	if v28 then
		if isBuilderOrMigratedIcon(v28.name) then
			v29 = React.createElement(Icon, {
				name = if not isMigrated(v28.name) then v28.name else uiblox[v28.name].name,
				variant = if not isMigrated(v28.name) then v28.variant else uiblox[v28.name].variant,
				size = v26.icon.size,
				style = v24
			})
		else
			local v30, v31 = getIconScale(v28.name, v26.icon.size)

			if v30 then
				v29 = React.createElement(Image, {
					Image = v28.name,
					Size = UDim2.fromOffset(v30.X, v30.Y),
					imageStyle = v24,
					scale = v31
				})
			end
		end
	end

	local uDim2, v33

	if v25 or Flags.FoundationFixTabsFitBorderWidth then
		uDim2 = UDim2.fromScale(1, 1)
		v33 = nil
	else
		local Size_100 = v23.Size.Size_100

		uDim2 = UDim2.new(1, Size_100 * 2, 1, 0)
		v33 = UDim2.fromOffset(-Size_100, 0)
	end

	return React.createElement(View, {
		tag = v26.container.tag,
		GroupTransparency = if not p1.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		testId = p1.testId
	}, {
		Interactive = React.createElement(View, {
			LayoutOrder = 1,
			Size = uDim2,
			Position = v33,
			onActivated = function() -- line: 140
				-- upvalues: p1 (copy)
				p1.onActivated(p1.id)
			end,
			selection = {
				Selectable = not p1.isDisabled
			},
			cursor = v27,
			isDisabled = p1.isDisabled,
			ref = p2
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = v26.content.tag,
			Size = v26.content.Size
		}, {
			Icon = if not p1.icon then nil else v29,
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = p1.text,
				style = v24,
				tag = v26.text.tag
			}),
			Indicator = if not p1.indicator then nil else React.createElement(StatusIndicator, if not p1.indicator.value then {
				LayoutOrder = 3,
				variant = p1.indicator.variant,
				shape = p1.indicator.shape,
				testId = `{ p1.testId }--indicator`
			} else {
				LayoutOrder = 3,
				value = p1.indicator.value,
				variant = p1.indicator.variant,
				max = p1.indicator.max,
				testId = `{ p1.testId }--indicator`
			})
		})
	})
end

return React.memo(React.forwardRef(TabItem))
