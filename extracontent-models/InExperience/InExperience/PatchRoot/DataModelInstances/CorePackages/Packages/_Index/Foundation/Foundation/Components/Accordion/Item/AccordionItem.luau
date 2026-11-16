local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
require(parent.Otter)
local React = require(parent.React)

local ReactOtter = require(parent.ReactOtter)

local Icon = BuilderIcons.Icon

local Divider = require(Foundation.Components.Divider)
local Icon2 = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useAccordion = require(script.Parent.Parent.useAccordion)
local useTokens = require(Foundation.Providers.Style.useTokens)

local InputPlacement = require(Foundation.Enums.InputPlacement)
require(Foundation.Enums.InputSize)

require(Foundation.Providers.Style.Tokens)

local useAccordionItemVariants = require(script.Parent.Parent.useAccordionItemVariants)

local v = { hasDivider = true, isExpanded = false }

local function getCommonEaseConfig(p) -- 1 equivalent call inferred from this helper
	return { easingStyle = p.Ease.StandardOut, duration = p.Time.Time_300 }
end

local function AccordionItem(p, ref3)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v4 = React.useMemo(function()
		return getCommonEaseConfig(v3) -- inferred equivalent call
	end, { v3 })

	local state, setState = React.useState(v2.isExpanded)

	local ref = React.useRef(false)
	local rotation, v5 = ReactOtter.useAnimatedBinding(0)
	local v6, v7 = ReactOtter.useAnimatedBinding(0, function()
		if ref.current then
			setState(false)
			ref.current = false
		end
	end)
	local ref2 = React.useRef(nil)
	local v8 = React.useCallback(function()
		if reducedMotion then
			v7((ReactOtter.instant(0)))
			v5((ReactOtter.instant(0)))
			setState(false)
			ref.current = false
		else
			ref.current = true
			v7(ReactOtter.ease(0, v4))
			v5(ReactOtter.ease(0, v4))
		end
	end, { reducedMotion, v4 })

	local onAbsoluteSizeChanged = React.useCallback(function()
		if ref2 and ref2.current and state then
			if reducedMotion then
				v7((ReactOtter.instant(ref2.current.AbsoluteSize.Y)))
			else
				v7(ReactOtter.ease(ref2.current.AbsoluteSize.Y, v4))
			end
		end
	end, { ref2, state, reducedMotion, v4 })

	React.useEffect(function()
		if state and not v2.isExpanded then
			v8()
		else
			setState(v2.isExpanded)
		end
	end, { v2.isExpanded })

	React.useEffect(function()
		if state then
			if reducedMotion then
				v5((ReactOtter.instant(-180)))
			else
				v5(ReactOtter.ease(-180, v4))
			end
		end
	end, { state, reducedMotion, v4 })

	local v9 = useAccordion()
	local onAccordionItemActivated = v9.onAccordionItemActivated
	local itemSize = v9.itemSize
	local isContained = v9.isContained
	local chevronPosition = v9.chevronPosition

	local v10 = useAccordionItemVariants(v3, itemSize, isContained)
	local v11 = chevronPosition == InputPlacement.Start
	local layoutOrder = v11 and 3 or 1
	local onActivated = React.useCallback(function()
		if state then
			v8()
		else
			setState(true)
		end
	end, { state })

	if v2.onActivated then
		onActivated = v2.onActivated
	elseif onAccordionItemActivated then
		onActivated = onAccordionItemActivated(v2.id, state)
	end

	v2.testId = `{v9.testId}--item-{v2.id}`

	local sizefull = v2.description ~= nil
	local element = React.createElement(Text, {
		LayoutOrder = 2,
		Text = v2.text,
		tag = {
			[v10.text.tag] = true,
			grow = not sizefull,
			["size-full-0"] = sizefull
		},
		testId = `{v2.testId}--title`
	})

	local v12 = if v2.icon then v2.icon else v2.leadingIcon

	local createElement = React.createElement

	local v13 = withCommonProps(v2, {
		tag = v10.container.tag,
		AutomaticSize = Enum.AutomaticSize.Y,
		stateLayer = v10.container.stateLayer,
		ref = ref3
	})

	local createElement2 = React.createElement
	local v14 = {
		LayoutOrder = 1,
		tag = v10.header.tag,
		AutomaticSize = 0,
		onActivated = 0,
		testId = 0
	}
	local automaticSize

	if sizefull then
		automaticSize = Enum.AutomaticSize.Y
	end

	v14.AutomaticSize = automaticSize
	v14.onActivated = onActivated
	v14.testId = `{v2.testId}--header`
	local icon

	if v12 then
		local createElement3 = React.createElement

		local name = if type(v12) == "table" then v12.name else v12
		local variant

		if type(v12) == "table" then
			variant = v12.variant
		end

		icon = createElement3(Icon2, {
			LayoutOrder = layoutOrder,
			name = name,
			variant = variant,
			style = v10.icon.style,
			size = v10.icon.size,
			testId = `{v2.testId}--leading-icon`
		})
	end

	local title

	if not sizefull then
		title = element
	end

	local textContainer

	if sizefull then
		textContainer = React.createElement(
			View,
			{ LayoutOrder = 2, tag = v10.textContainer.tag, testId = `{v2.testId}--text-container` },
			{
				Title = element,
				Description = React.createElement(Text, {
					LayoutOrder = 3,
					Text = v2.description,
					TextWrapped = false,
					TextTruncate = Enum.TextTruncate.AtEnd,
					tag = v10.description.tag,
					testId = `{v2.testId}--description`
				})
			}
		)
	end

	local v15 = {
		Header = createElement2(View, v14, {
			Icon = icon,
			Title = title,
			TextContainer = textContainer,
			CollapseIcon = React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = v11 and 1 or 3,
				testId = `{v2.testId}--collapse-icon-container`
			}, {
				Icon = React.createElement(Icon2, {
					name = Icon.ChevronLargeDown,
					Rotation = rotation,
					style = v10.icon.style,
					size = v10.icon.size,
					testId = `{v2.testId}--collapse-icon`
				})
			})
		}),
		Content = 0,
		Divider = 0
	}
	local content

	if state then
		local createElement3 = React.createElement
		local v16 = {
			tag = "col",
			LayoutOrder = 2,
			testId = `{v2.testId}--content`,
			Size = 0,
			ClipsDescendants = true
		}
		local size

		if v6 then
			size = v6:map(function(p2)
				return UDim2.new(1, 0, 0, p2)
			end)
		end

		v16.Size = size
		content = createElement3(View, v16, {
			AnimatedContainer = React.createElement(View, {
				tag = v10.content.tag,
				ref = ref2,
				onAbsoluteSizeChanged = onAbsoluteSizeChanged,
				flexItem = { FlexMode = Enum.UIFlexMode.None },
				testId = `{v2.testId}--animated-content`
			}, { v2.children })
		})
	end

	v15.Content = content
	local divider

	if v2.hasDivider then
		divider = React.createElement(Divider, { LayoutOrder = 3, testId = `{v2.testId}--divider` })
	end

	v15.Divider = divider
	return createElement(View, v13, v15)
end

return React.memo(React.forwardRef(AccordionItem))
