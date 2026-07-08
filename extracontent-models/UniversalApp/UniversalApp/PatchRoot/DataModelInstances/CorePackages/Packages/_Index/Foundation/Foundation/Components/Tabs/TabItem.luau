local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BuilderIcons = require(FoundationParent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
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

local function TabItem(p1, p2) -- line: 53
	-- upvalues: useTokens (copy), FillBehavior (copy), useTabItemVariants (copy), React (copy), BuilderIcons (copy), isBuilderOrMigratedIcon (copy), Icon (copy), isMigrated (copy), uiblox (copy), getIconScale (copy), Image (copy), View (copy), Constants (copy), Text (copy)
	local v21 = useTokens()
	local v22 = if not p1.isActive then v21.Color.Content.Emphasis else v21.Color.Content.Default
	local v23 = p1.fillBehavior == FillBehavior.Fill
	local v24 = useTabItemVariants(v21, p1.size, v23)
	local v25 = React.useMemo(function() -- line: 62
		-- upvalues: v21 (copy)
		return {
			offset = 0,
			radius = UDim.new(0, 0),
			borderWidth = v21.Stroke.Thicker
		}
	end, { v21 })
	local v26 = React.useMemo(function() -- line: 70
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
	local v27 = nil

	if v26 then
		if isBuilderOrMigratedIcon(v26.name) then
			v27 = React.createElement(Icon, {
				name = if not isMigrated(v26.name) then v26.name else uiblox[v26.name].name,
				variant = if not isMigrated(v26.name) then v26.variant else uiblox[v26.name].variant,
				size = v24.icon.size,
				style = v22
			})
		else
			local v28, v29 = getIconScale(v26.name, v24.icon.size)

			if v28 then
				v27 = React.createElement(Image, {
					Image = v26.name,
					Size = UDim2.fromOffset(v28.X, v28.Y),
					imageStyle = v22,
					scale = v29
				})
			end
		end
	end

	local uDim2, v31

	if v23 then
		uDim2 = UDim2.fromScale(1, 1)
		v31 = nil
	else
		local Size_100 = v21.Size.Size_100

		uDim2 = UDim2.new(1, Size_100 * 2, 1, 0)
		v31 = UDim2.fromOffset(-Size_100, 0)
	end

	return React.createElement(View, {
		tag = v24.container.tag,
		GroupTransparency = if not p1.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		testId = p1.testId
	}, {
		Interactive = React.createElement(View, {
			LayoutOrder = 1,
			Size = uDim2,
			Position = v31,
			onActivated = function() -- line: 125
				-- upvalues: p1 (copy)
				p1.onActivated(p1.id)
			end,
			selection = {
				Selectable = not p1.isDisabled
			},
			cursor = v25,
			isDisabled = p1.isDisabled,
			ref = p2
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = v24.content.tag,
			Size = v24.content.Size
		}, {
			Icon = if not p1.icon then nil else v27,
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = p1.text,
				style = v22,
				tag = v24.text.tag
			})
		})
	})
end

return React.memo(React.forwardRef(TabItem))
