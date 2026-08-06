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
local Flags = require(Foundation.Utility.Flags)
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

local function getTransparency(n1: number?, p1) -- line: 36
	return p1:map(function(p2) -- line: 40
		-- upvalues: n1 (copy)
		if n1 ~= nil then
			return n1 + (1 - n1) * p2
		end

		return p2
	end)
end
local function getTextStyle(p3, p4, color3: Color3) -- line: 48
	-- upvalues: React (copy)
	return React.joinBindings({
		p3,
		p4
	}):map(function(p5) -- line: 53
		-- upvalues: color3 (copy)
		local v60 = p5[2]

		return {
			Color3 = color3,
			Transparency = v60
		}
	end)
end

local t1 = {
	isDisabled = false,
	size = InputSize.Medium,
	width = UDim.new(0, 0)
}

local function OptionSelectorGroupItem(p6, p7) -- line: 95
	-- upvalues: withDefaults (copy), t1 (copy), useOptionSelectorGroup (copy), Orientation (copy), Flags (copy), FillBehavior (copy), useTokens (copy), useOptionSelectorGroupItemVariants (copy), useOptionSelectorGroupItemMotionStates (copy), Constants (copy), useMotion (copy), React (copy), Text (copy), escapeRichText (copy), getTextStyle (copy), View (copy), withCommonProps (copy), Icon (copy)
	local v32 = withDefaults(p6, t1)
	local v33 = useOptionSelectorGroup()
	local v34 = v33.value == v32.value
	local v35 = v32.label or v32.value
	local v36 = if v33.orientation ~= Orientation.Vertical then Orientation.Vertical else Orientation.Horizontal
	local v37 = if not Flags.FoundationOptionSelectorGroupFixes then if v36 ~= Orientation.Horizontal then v32.fillBehavior or FillBehavior.Fill else FillBehavior.Fit else if v36 ~= Orientation.Horizontal then v32.fillBehavior or FillBehavior.Fit else FillBehavior.Fill
	local v38 = v36 == Orientation.Vertical and v37 == FillBehavior.Fit
	local v39 = if not Flags.FoundationOptionSelectorGroupFixes or not v38 then UDim2.fromScale(1, 0) else nil
	local v40 = useTokens()
	local v41 = useOptionSelectorGroupItemVariants(v40, v32.size, v36, v37)
	local contentColor3 = v41.content.Color3
	local v43 = if not v34 then v40.Color.Stroke.Emphasis else v40.Color.System.Contrast
	local v44 = useOptionSelectorGroupItemMotionStates(0, Constants.DISABLED_TRANSPARENCY)
	local v45, v46 = useMotion(v44.Default)
	local v47, _ = useMotion(v44.Default)

	React.useEffect(function() -- line: 137
		-- upvalues: v32 (copy), v46 (copy), v44 (copy)
		if v32.isDisabled then
			v46(v44.Disabled)

			return
		end

		v46(v44.Default)
	end, { v32.isDisabled })

	local v49 = React.useCallback(function() -- line: 146
		-- upvalues: v33 (copy), v32 (copy)
		v33.onValueChanged(if v33.value ~= v32.value then v32.value else nil)
	end, {
		v32.isDisabled,
		v32.value,
		v33.onValueChanged,
		v33.value
	})

	v32.testId = `{ v33.testId }--item-{ v32.value }`

	local v50 = React.useMemo(function() -- line: 156
		-- upvalues: v41 (copy), v40 (copy)
		return {
			radius = UDim.new(0, v41.container.radius),
			offset = v40.Size.Size_200,
			borderWidth = v40.Stroke.Thicker
		}
	end, {
		v40,
		v41.container.radius
	})
	local v51 = React.createElement(Text, {
		TextWrapped = true,
		RichText = true,
		LayoutOrder = 2,
		Text = escapeRichText(v35),
		TextXAlignment = Enum.TextXAlignment.Left,
		tag = v41.label.tag,
		textStyle = getTextStyle(v47.textTransparency, v45.transparency, contentColor3),
		testId = `{ v32.testId }--label`
	})
	local createElement = React.createElement
	local v53 = View
	local v54 = withCommonProps
	local t2 = {}
	local t3 = {
		Color = v43.Color3
	}
	local Transparency = v43.Transparency

	t3.Transparency = v45.transparency:map(function(p8) -- line: 40
		-- upvalues: Transparency (copy)
		if Transparency ~= nil then
			return Transparency + (1 - Transparency) * p8
		end

		return p8
	end)
	t2.stroke = t3
	t2.Size = v39
	t2.selection = {
		Selectable = not v32.isDisabled and v33.Selectable
	}
	t2.cursor = v50
	t2.onActivated = v49
	t2.isDisabled = v32.isDisabled
	t2.tag = if not Flags.FoundationOptionSelectorGroupFixes then {
		["auto-xy"] = v37 ~= FillBehavior.Fill,
		["fill auto-y"] = v37 == FillBehavior.Fill,
		[v41.container.tag] = true
	} else v41.container.tag
	t2.ref = p7

	return createElement(v53, v54(v32, t2), {
		ItemInner = React.createElement(View, {
			tag = v41.itemInner.tag,
			Size = v39
		}, {
			Header = React.createElement(View, {
				LayoutOrder = 1,
				tag = not Flags.FoundationOptionSelectorGroupFixes and "row align-y-center gap-small size-full-0 auto-y" or v41.header.tag
			}, {
				Icon = if not v32.icon then nil else React.createElement(Icon, {
					LayoutOrder = 0,
					name = v32.icon,
					size = v41.icon.size,
					style = v45.transparency:map(function(p9) -- line: 213
						-- upvalues: contentColor3 (copy)
						return {
							Color3 = contentColor3,
							Transparency = p9
						}
					end),
					testId = `{ v32.testId }--icon`
				}),
				Label = if v36 ~= Orientation.Horizontal then if not Flags.FoundationOptionSelectorGroupFixes or not v38 then React.createElement(View, {
					tag = "grow"
				}) else nil else v51,
				LeadingSpacer = if not Flags.FoundationOptionSelectorGroupFixes or (not v38 or v32.icon) then nil else React.createElement(View, {
					LayoutOrder = 0,
					Size = UDim2.fromOffset(0, 0)
				}),
				Checkmark = React.createElement(Icon, {
					name = "check-large",
					LayoutOrder = 3,
					size = v41.icon.size,
					style = v45.transparency:map(function(p10) -- line: 240
						-- upvalues: contentColor3 (copy), v34 (copy)
						return {
							Color3 = contentColor3,
							Transparency = not v34 and 1 or p10
						}
					end),
					testId = if not v34 then `{ v32.testId }--checkmark-unselected` else `{ v32.testId }--checkmark-selected`
				})
			}),
			TextContainer = if not Flags.FoundationOptionSelectorGroupFixes or not v38 then nil else React.createElement(View, {
				LayoutOrder = 2,
				tag = v41.textContainer.tag
			}, {
				Label = if v36 ~= Orientation.Vertical then nil else v51,
				Metadata = if not v32.metadata then nil else React.createElement(Text, {
					RichText = true,
					LayoutOrder = 3,
					Text = escapeRichText(v32.metadata),
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					tag = v41.metadata.tag,
					textStyle = getTextStyle(v47.textTransparency, v45.transparency, contentColor3),
					testId = `{ v32.testId }--metadata`
				}),
				Description = if not v32.description then nil else React.createElement(Text, {
					TextWrapped = true,
					RichText = true,
					LayoutOrder = 4,
					Text = escapeRichText(v32.description),
					TextXAlignment = Enum.TextXAlignment.Left,
					tag = v41.description.tag,
					textStyle = getTextStyle(v47.textTransparency, v45.transparency, contentColor3),
					testId = `{ v32.testId }--description`
				})
			}),
			Label = if not Flags.FoundationOptionSelectorGroupFixes or not v38 then if v36 ~= Orientation.Vertical then nil else v51 else nil,
			Metadata = if not Flags.FoundationOptionSelectorGroupFixes or not v38 then if not v32.metadata then nil else React.createElement(Text, {
				RichText = true,
				LayoutOrder = 3,
				Text = escapeRichText(v32.metadata),
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = v41.metadata.tag,
				textStyle = getTextStyle(v47.textTransparency, v45.transparency, contentColor3),
				testId = `{ v32.testId }--metadata`
			}) else nil,
			Description = if not Flags.FoundationOptionSelectorGroupFixes or not v38 then if not v32.description then nil else React.createElement(Text, {
				TextWrapped = true,
				RichText = true,
				LayoutOrder = 4,
				Text = escapeRichText(v32.description),
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = v41.description.tag,
				textStyle = getTextStyle(v47.textTransparency, v45.transparency, contentColor3),
				testId = `{ v32.testId }--description`
			}) else nil
		})
	})
end

return React.memo(React.forwardRef(OptionSelectorGroupItem))
