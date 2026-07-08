local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useMotion = require(FoundationParent.Motion).useMotion
local Components = Foundation.Components
local Icon = require(Components.Icon)
local Text = require(Components.Text)

require(Components.Types)

local View = require(Components.View)
local Constants = require(Foundation.Constants)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useOptionSelectorGroupItemMotionStates = require(script.Parent.useOptionSelectorGroupItemMotionStates)
local useOptionSelectorGroupItemVariants = require(script.Parent.useOptionSelectorGroupItemVariants)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local InputSize = require(Foundation.Enums.InputSize)
local Orientation = require(Foundation.Enums.Orientation)
local useOptionSelectorGroup = require(script.Parent.Parent.useOptionSelectorGroup)

local function getTransparency(n1: number?, p1) -- line: 35
	return p1:map(function(p2) -- line: 39
		-- upvalues: n1 (copy)
		if n1 ~= nil then
			return n1 + (1 - n1) * p2
		end

		return p2
	end)
end
local function getTextStyle(p3, p4, color3: Color3) -- line: 47
	-- upvalues: React (copy)
	return React.joinBindings({
		p3,
		p4
	}):map(function(p5) -- line: 52
		-- upvalues: color3 (copy)
		local v58 = p5[2]

		return {
			Color3 = color3,
			Transparency = v58
		}
	end)
end

local t1 = {
	isDisabled = false,
	size = InputSize.Medium,
	width = UDim.new(0, 0)
}

local function OptionSelectorGroupItem(p6, p7) -- line: 89
	-- upvalues: withDefaults (copy), t1 (copy), useOptionSelectorGroup (copy), Orientation (copy), FillBehavior (copy), useTokens (copy), useOptionSelectorGroupItemVariants (copy), useOptionSelectorGroupItemMotionStates (copy), Constants (copy), useMotion (copy), React (copy), Text (copy), escapeRichText (copy), getTextStyle (copy), View (copy), withCommonProps (copy), Icon (copy)
	local v31 = withDefaults(p6, t1)
	local v32 = useOptionSelectorGroup()
	local v33 = v32.value == v31.value
	local v34 = v31.label or v31.value
	local v35 = if v32.orientation ~= Orientation.Vertical then Orientation.Vertical else Orientation.Horizontal
	local v36 = if v35 ~= Orientation.Horizontal then v31.fillBehavior or FillBehavior.Fill else FillBehavior.Fit
	local uDim2 = UDim2.fromScale(1, 0)
	local v38 = useTokens()
	local v39 = useOptionSelectorGroupItemVariants(v38, v31.size)
	local contentColor3 = v39.content.Color3
	local v41 = if not v33 then v38.Color.Stroke.Emphasis else v38.Color.System.Contrast
	local v42 = useOptionSelectorGroupItemMotionStates(0, Constants.DISABLED_TRANSPARENCY)
	local v43, v44 = useMotion(v42.Default)
	local v45, _ = useMotion(v42.Default)

	React.useEffect(function() -- line: 119
		-- upvalues: v31 (copy), v44 (copy), v42 (copy)
		if v31.isDisabled then
			v44(v42.Disabled)

			return
		end

		v44(v42.Default)
	end, { v31.isDisabled })

	local v47 = React.useCallback(function() -- line: 128
		-- upvalues: v32 (copy), v31 (copy)
		v32.onValueChanged(if v32.value ~= v31.value then v31.value else nil)
	end, {
		v31.isDisabled,
		v31.value,
		v32.onValueChanged,
		v32.value
	})

	v31.testId = `{ v32.testId }--item-{ v31.value }`

	local v48 = React.useMemo(function() -- line: 138
		-- upvalues: v39 (copy), v38 (copy)
		return {
			radius = UDim.new(0, v39.container.radius),
			offset = v38.Size.Size_200,
			borderWidth = v38.Stroke.Thicker
		}
	end, {
		v38,
		v39.container.radius
	})
	local v49 = React.createElement(Text, {
		TextWrapped = true,
		RichText = true,
		LayoutOrder = 2,
		Text = escapeRichText(v34),
		TextXAlignment = Enum.TextXAlignment.Left,
		tag = v39.label.tag,
		textStyle = getTextStyle(v45.textTransparency, v43.transparency, contentColor3)
	})
	local createElement = React.createElement
	local v51 = View
	local v52 = withCommonProps
	local t2 = {}
	local t3 = {
		Color = v41.Color3
	}
	local Transparency = v41.Transparency

	t3.Transparency = v43.transparency:map(function(p8) -- line: 39
		-- upvalues: Transparency (copy)
		if Transparency ~= nil then
			return Transparency + (1 - Transparency) * p8
		end

		return p8
	end)
	t2.stroke = t3
	t2.Size = uDim2
	t2.selection = {
		Selectable = not v31.isDisabled and v32.Selectable
	}
	t2.cursor = v48
	t2.onActivated = v47
	t2.isDisabled = v31.isDisabled
	t2.tag = {
		["auto-xy"] = v36 ~= FillBehavior.Fill,
		["fill auto-y"] = v36 == FillBehavior.Fill,
		[v39.container.tag] = true
	}
	t2.ref = p7

	return createElement(v51, v52(v31, t2), {
		ItemInner = React.createElement(View, {
			tag = v39.itemInner.tag,
			Size = uDim2
		}, {
			IconRow = React.createElement(View, {
				tag = "row align-y-center gap-small size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Icon = if not v31.icon then nil else React.createElement(Icon, {
					LayoutOrder = 0,
					name = v31.icon,
					size = v39.icon.size,
					style = v43.transparency:map(function(p9) -- line: 190
						-- upvalues: contentColor3 (copy)
						return {
							Color3 = contentColor3,
							Transparency = p9
						}
					end)
				}),
				Label = if v35 ~= Orientation.Horizontal then React.createElement(View, {
					tag = "grow"
				}) else v49,
				Checkmark = React.createElement(Icon, {
					name = "check-large",
					LayoutOrder = 3,
					size = v39.icon.size,
					style = v43.transparency:map(function(p10) -- line: 205
						-- upvalues: contentColor3 (copy), v33 (copy)
						return {
							Color3 = contentColor3,
							Transparency = not v33 and 1 or p10
						}
					end)
				})
			}),
			Label = if v35 ~= Orientation.Vertical then nil else v49,
			Metadata = if not v31.metadata then nil else React.createElement(Text, {
				RichText = true,
				LayoutOrder = 3,
				Text = escapeRichText(v31.metadata),
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = v39.metadata.tag,
				textStyle = getTextStyle(v45.textTransparency, v43.transparency, contentColor3)
			}),
			Description = if not v31.description then nil else React.createElement(Text, {
				TextWrapped = true,
				RichText = true,
				LayoutOrder = 4,
				Text = escapeRichText(v31.description),
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = v39.description.tag,
				textStyle = getTextStyle(v45.textTransparency, v43.transparency, contentColor3)
			})
		})
	})
end

return React.memo(React.forwardRef(OptionSelectorGroupItem))
