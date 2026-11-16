local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local List = Foundation.List

local function hasContent(items): boolean
	if typeof(items) == "table" and not React.isValidElement(items) then
		for _, item in items do
			if item ~= false then
				return true
			end
		end

		return false
	end

	return items ~= nil and items ~= false
end

local function partId(p: string?, p2: string)
	if p then
		return `{p}--{p2}`
	end

	return nil
end

local function SduiExpandableListItem(props)
	local v = Foundation.Hooks.useTokens()
	local testId = props.testId

	local children = props.children
	local v2

	if typeof(children) == "table" and not React.isValidElement(children) then
		local flag = true

		for _, child in children do
			if child ~= false then
				v2 = true
				flag = false
				break
			end
		end

		if flag then
			v2 = false
		end
	elseif children == nil then
		v2 = false
	else
		v2 = children ~= false
	end

	local trailing = props.trailing
	local v3

	if typeof(trailing) == "table" and not React.isValidElement(trailing) then
		local flag = true

		for _, v4 in trailing do
			if v4 ~= false then
				v3 = true
				flag = false
				break
			end
		end

		if flag then
			v3 = false
		end
	elseif trailing == nil then
		v3 = false
	else
		v3 = trailing ~= false
	end

	local state, setState = React.useState(props.initiallyExpanded == true)
	local v4 = props.isExpanded ~= nil

	if v4 then
		state = props.isExpanded == true
	end

	local ref = React.useRef(state)
	ref.current = state
	local function toggle()
		local current = not ref.current
		ref.current = current

		if not v4 then
			setState(current)
		end

		if props.onExpandedChanged then
			props.onExpandedChanged(current)
		end
	end

	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local rotation, v5 = ReactOtter.useAnimatedBinding(state and -180 or 0)
	React.useEffect(function()
		local v6 = state and -180 or 0
		local v7

		if reducedMotion then
			v7 = ReactOtter.instant(v6)
		else
			v7 = ReactOtter.ease(v6, {
				easingStyle = v.Ease.StandardOut,
				duration = v.Time.Time_300
			})
		end

		v5(v7)
	end, { state, reducedMotion, v })

	local leading = React.useMemo(function()
		local leadingIcon = props.leadingIcon

		if leadingIcon == nil then
			return nil
		end

		return IconName[leadingIcon] or { iconName = leadingIcon }
	end, { props.leadingIcon })

	local createElement = React.createElement
	local view = Foundation.View
	local actions

	if v3 then
		actions = React.createElement(
			Foundation.View,
			{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 1 },
			props.trailing
		)
	end

	local toggle2

	if v2 then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local testId2

		if testId then
			testId2 = `{testId}--toggle`
		end

		local createElement3 = React.createElement
		local icon = Foundation.Icon
		local v6 = {
			name = IconName.ChevronSmallDown,
			size = IconSize.Large,
			Rotation = rotation,
			testId = 0
		}
		local testId3

		if testId then
			testId3 = `{testId}--chevron`
		end

		v6.testId = testId3
		toggle2 = createElement2(
			view2,
			{
				tag = "size-600-600 radius-small",
				onActivated = toggle,
				testId = testId2,
				LayoutOrder = 2
			},
			{ Chevron = createElement3(icon, v6) }
		)
	else
		toggle2 = React.createElement(Foundation.View, { tag = "size-600-600", LayoutOrder = 2 })
	end

	local element = createElement(view, { tag = "row align-y-center gap-xsmall auto-xy" }, {
		Actions = actions,
		Toggle = toggle2
	})

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v6 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			[props.tag or ""] = props.tag ~= nil
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local testId2

	if testId then
		testId2 = `{testId}--row`
	end

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v7 = {
		tag = {
			["radius-medium expandable-list-item-highlight"] = true,
			["bg-shift-200"] = props.isSelected == true
		},
		Position = UDim2.fromOffset(-v.Padding.Small, v.Padding.XSmall),
		Size = UDim2.new(1, v.Padding.Small * 2, 1, -v.Padding.XSmall * 2),
		ZIndex = 0,
		testId = 0
	}
	local testId3

	if testId then
		testId3 = `{testId}--highlight`
	end

	v7.testId = testId3
	local children2 = { Highlight = createElement4(view4, v7), Item = 0 }

	local createElement5 = React.createElement
	local item = List.Item
	local v8 = {
		title = props.title or "",
		description = props.description,
		leading = leading,
		trailing = element,
		input = Foundation.Enums.ListItemInputType.None,
		onActivated = 0,
		LayoutOrder = 1,
		testId = 0
	}

	local onActivated = props.onActivated

	if not onActivated then
		onActivated = if v2 then toggle else nil
	end

	v8.onActivated = onActivated

	v8.testId = testId
	children2.Item = createElement5(item, v8)
	local v9 = {
		Row = createElement3(
			view3,
			{
				tag = "size-full-0 auto-y expandable-list-item-row",
				testId = testId2,
				LayoutOrder = 1
			},
			children2
		),
		Content = 0
	}
	local content

	if v2 and state then
		local createElement6 = React.createElement
		local view5 = Foundation.View
		local v10 = {
			tag = "size-full-0 auto-y",
			padding = { left = UDim.new(0, v.Size.Size_300) },
			LayoutOrder = 2
		}

		local createElement7 = React.createElement
		local root = List.Root
		local v11 = {
			size = props.size or Foundation.Enums.InputSize.Medium,
			hasDivider = false,
			isContained = { isContained = false, hasMargin = false },
			testId = 0
		}
		local testId4

		if testId then
			testId4 = `{testId}--content`
		end

		v11.testId = testId4
		content = createElement6(view5, v10, {
			List = createElement7(root, v11, props.children)
		})
	end

	v9.Content = content
	return createElement2(view2, v6, v9)
end

return React.memo(SduiExpandableListItem)
