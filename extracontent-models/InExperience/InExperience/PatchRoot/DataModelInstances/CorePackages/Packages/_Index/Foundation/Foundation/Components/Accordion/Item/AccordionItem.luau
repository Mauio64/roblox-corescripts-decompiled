local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.BuilderIcons)
require(FoundationParent.Otter)

local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local Divider = require(Foundation.Components.Divider)
local Icon = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useAccordion = require(script.Parent.Parent.useAccordion)
local useTokens = require(Foundation.Providers.Style.useTokens)

require(Foundation.Enums.InputSize)
require(Foundation.Providers.Style.Tokens)

local useAccordionItemVariants = require(script.Parent.Parent.useAccordionItemVariants)
local t1 = {
	hasDivider = true,
	isExpanded = false
}

local function getCommonEaseConfig(p1) -- line: 59
	return {
		easingStyle = p1.Ease.StandardOut,
		duration = p1.Time.Time_300
	}
end
local function AccordionItem(p2, p3) -- line: 66
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePreferences (copy), React (copy), ReactOtter (copy), useAccordion (copy), useAccordionItemVariants (copy), View (copy), withCommonProps (copy), Icon (copy), Text (copy), Divider (copy)
	local v21 = withDefaults(p2, t1)
	local v22 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v24 = React.useMemo(function() -- line: 71
		-- upvalues: v22 (copy)
		local v41 = v22

		return {
			easingStyle = v41.Ease.StandardOut,
			duration = v41.Time.Time_300
		}
	end, { v22 })
	local v25, v26 = React.useState(v21.isExpanded)
	local v27 = React.useRef(false)
	local v28, v29 = ReactOtter.useAnimatedBinding(0)
	local v30, v31 = ReactOtter.useAnimatedBinding(0, function() -- line: 79
		-- upvalues: v27 (copy), v26 (copy)
		if v27.current then
			v26(false)
			v27.current = false
		end
	end)
	local v32 = React.useRef(nil)
	local v33 = React.useCallback(function() -- line: 86
		-- upvalues: reducedMotion (copy), v31 (copy), ReactOtter (copy), v29 (copy), v26 (copy), v27 (copy), v24 (copy)
		if reducedMotion then
			v31((ReactOtter.instant(0)))
			v29((ReactOtter.instant(0)))
			v26(false)
			v27.current = false

			return
		end

		v27.current = true
		v31(ReactOtter.ease(0, v24))
		v29(ReactOtter.ease(0, v24))
	end, {
		reducedMotion,
		v24
	})
	local v34 = React.useCallback(function() -- line: 100
		-- upvalues: v32 (copy), v25 (copy), reducedMotion (copy), v31 (copy), ReactOtter (copy), v24 (copy)
		if v32 and (v32.current and v25) then
			if reducedMotion then
				v31((ReactOtter.instant(v32.current.AbsoluteSize.Y)))

				return
			end

			v31(ReactOtter.ease(v32.current.AbsoluteSize.Y, v24))
		end
	end, {
		v32,
		v25,
		reducedMotion,
		v24
	})

	React.useEffect(function() -- line: 110
		-- upvalues: v25 (copy), v21 (copy), v33 (copy), v26 (copy)
		if v25 and not v21.isExpanded then
			v33()

			return
		end

		v26(v21.isExpanded)
	end, { v21.isExpanded })
	React.useEffect(function() -- line: 118
		-- upvalues: v25 (copy), reducedMotion (copy), v29 (copy), ReactOtter (copy), v24 (copy)
		if v25 then
			if reducedMotion then
				v29((ReactOtter.instant(-180)))

				return
			end

			v29(ReactOtter.ease(-180, v24))
		end
	end, {
		v25,
		reducedMotion,
		v24
	})

	local v35 = useAccordion()
	local onAccordionItemActivated = v35.onAccordionItemActivated
	local itemSize = v35.itemSize
	local v38 = useAccordionItemVariants(v22, itemSize, false)
	local v39 = React.useCallback(function() -- line: 133
		-- upvalues: v25 (copy), v33 (copy), v26 (copy)
		if v25 then
			v33()

			return
		end

		v26(true)
	end, { v25 })
	local v40 = if not v21.onActivated then if not onAccordionItemActivated then v39 else onAccordionItemActivated(v21.id, v25) else v21.onActivated

	v21.testId = `{ v35.testId }--item-{ v21.id }`

	return React.createElement(View, withCommonProps(v21, {
		tag = v38.container.tag,
		AutomaticSize = Enum.AutomaticSize.Y,
		stateLayer = v38.container.stateLayer,
		ref = p3
	}), {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = v38.header.tag,
			onActivated = v40,
			testId = `{ v21.testId }--header`
		}, {
			LeadingIcon = if not v21.leadingIcon then nil else React.createElement(Icon, {
				LayoutOrder = 1,
				name = if type(v21.leadingIcon) ~= "table" then v21.leadingIcon else v21.leadingIcon.name,
				variant = if type(v21.leadingIcon) ~= "table" then nil else v21.leadingIcon.variant,
				style = v38.icon.style,
				size = v38.icon.size,
				testId = `{ v21.testId }--leading-icon`
			}),
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v21.text,
				tag = v38.text.tag,
				testId = `{ v21.testId }--title`
			}),
			CollapseIcon = React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = 3
			}, {
				Icon = React.createElement(Icon, {
					name = "chevron-large-down",
					Rotation = v28,
					style = v38.icon.style,
					size = v38.icon.size,
					testId = `{ v21.testId }--collapse-icon`
				})
			})
		}),
		Content = if not v25 then nil else React.createElement(View, {
			tag = "col",
			LayoutOrder = 2,
			ClipsDescendants = true,
			testId = `{ v21.testId }--content`,
			Size = if not v30 then nil else v30:map(function(p4) -- line: 199
				return UDim2.new(1, 0, 0, p4)
			end)
		}, {
			AnimatedContainer = React.createElement(View, {
				tag = v38.content.tag,
				ref = v32,
				onAbsoluteSizeChanged = v34,
				flexItem = {
					FlexMode = Enum.UIFlexMode.None
				},
				testId = `{ v21.testId }--animated-content`
			}, { v21.children })
		}),
		Divider = if not v21.hasDivider then nil else React.createElement(Divider, {
			LayoutOrder = 3,
			testId = `{ v21.testId }--divider`
		})
	})
end

return React.memo(React.forwardRef(AccordionItem))
