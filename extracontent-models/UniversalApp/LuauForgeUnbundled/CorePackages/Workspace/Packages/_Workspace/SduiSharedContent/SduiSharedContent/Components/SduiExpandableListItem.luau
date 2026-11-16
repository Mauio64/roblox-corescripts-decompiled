local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ReactOtter")

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local list = Foundation.List

local function hasContent(items): boolean
	if typeof(items) == "table" and not React.isValidElement(items) then
		for k, item in items do
			if item ~= false then
				return true
			end
		end

		return false
	end

	return items ~= nil and items ~= false
end

local function partId(p2, p3)
	if p2 then
		return `{p2}--{p3}`
	end

	return nil
end

local function SduiExpandableListItem(props)
	local v5 = Foundation.Hooks.useTokens()
	local testId = props.testId

	local children = props.children
	local v6

	if typeof(children) == "table" and not React.isValidElement(children) then
		local flag = true

		for k, child in children do
			if child ~= false then
				v6 = true
				flag = false
				break
			end
		end

		if flag then
			v6 = false
		end
	else
		v6 = not (children == nil) and children ~= false
	end

	local trailing = props.trailing
	local v7

	if typeof(trailing) == "table" and not React.isValidElement(trailing) then
		local flag = true

		for k, v8 in trailing do
			if v8 ~= false then
				v7 = true
				flag = false
				break
			end
		end

		if flag then
			v7 = false
		end
	else
		v7 = not (trailing == nil) and trailing ~= false
	end

	local state, setState = React.useState(props.initiallyExpanded == true)
	local v8 = props.isExpanded ~= nil

	if v8 then
		state = props.isExpanded == true
	end

	local ref = React.useRef(state)
	ref.current = state
	local function toggle()
		local v9 = not ref.current
		ref.current = v9

		if not v8 then
			setState(v9)
		end

		if props.onExpandedChanged then
			props.onExpandedChanged(v9)
		end
	end

	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local v9, v10 = ReactOtter.useAnimatedBinding(state and -180 or 0)
	React.useEffect(function()
		local v11 = state and -180 or 0
		local v13 = if reducedMotion then ReactOtter.instant(v11) else ReactOtter.ease(v11, {
			easingStyle = v5.Ease.StandardOut,
			duration = v5.Time.Time_300
		})
		v10(v13)
	end, { state, reducedMotion, v5 })

	local v11 = React.useMemo(function()
		local leadingIcon = props.leadingIcon

		if leadingIcon == nil then
			return nil
		end

		return iconName[leadingIcon] or { iconName = leadingIcon }
	end, { props.leadingIcon })

	local createElement = React.createElement
	local view = Foundation.View

	local v14 = if v7 then React.createElement(
		Foundation.View,
		{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 1 },
		props.trailing
	) else nil
	local v15

	if v6 then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v17 = if testId then `{testId}--toggle` else nil

		local createElement3 = React.createElement
		local icon = Foundation.Icon
		local v19 = {
			name = iconName.ChevronSmallDown,
			size = iconSize.Large,
			Rotation = v9,
			testId = 0
		}
		local v20 = if testId then `{testId}--chevron` else nil

		v19.testId = v20
		v15 = createElement2(
			view2,
			{
				tag = "size-600-600 radius-small",
				onActivated = toggle,
				testId = v17,
				LayoutOrder = 2
			},
			{ Chevron = createElement3(icon, v19) }
		)
	else
		v15 = React.createElement(Foundation.View, {
			tag = "size-600-600",
			LayoutOrder = 2
		})
	end

	local element = createElement(view, {
		tag = "row align-y-center gap-xsmall auto-xy"
	}, {
		Actions = v14,
		Toggle = v15
	})

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v16 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			[props.tag or ""] = props.tag ~= nil
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v20 = if testId then `{testId}--row` else nil

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v21 = {
		tag = {
			["radius-medium expandable-list-item-highlight"] = true,
			["bg-shift-200"] = props.isSelected == true
		},
		Position = UDim2.fromOffset(-v5.Padding.Small, v5.Padding.XSmall),
		Size = UDim2.new(1, v5.Padding.Small * 2, 1, -v5.Padding.XSmall * 2),
		ZIndex = 0,
		testId = 0
	}
	local v22 = if testId then `{testId}--highlight` else nil

	v21.testId = v22
	local children2 = { Highlight = createElement4(view4, v21), Item = 0 }

	local createElement5 = React.createElement
	local item = list.Item
	local v23 = {
		title = props.title or "",
		description = props.description,
		leading = v11,
		trailing = element,
		input = Foundation.Enums.ListItemInputType.None,
		onActivated = 0,
		LayoutOrder = 1,
		testId = 0
	}

	local v24 = props.onActivated

	if not v24 then
		v24 = if v6 then toggle else nil
	end

	v23.onActivated = v24

	v23.testId = testId
	children2.Item = createElement5(item, v23)
	local v18 = {
		Row = createElement3(
			view3,
			{
				tag = "size-full-0 auto-y expandable-list-item-row",
				testId = v20,
				LayoutOrder = 1
			},
			children2
		),
		Content = 0
	}
	local v25

	if v6 and state then
		local createElement6 = React.createElement
		local view5 = Foundation.View
		local v26 = {
			tag = "size-full-0 auto-y",
			padding = { left = UDim.new(0, v5.Size.Size_300) },
			LayoutOrder = 2
		}

		local createElement7 = React.createElement
		local root = list.Root
		local v28 = {
			size = props.size or Foundation.Enums.InputSize.Medium,
			hasDivider = false,
			isContained = { isContained = false, hasMargin = false },
			testId = 0
		}
		local v29 = if testId then `{testId}--content` else nil

		v28.testId = v29
		v25 = createElement6(view5, v26, {
			List = createElement7(root, v28, props.children)
		})
	end

	v18.Content = v25
	return createElement2(view2, v16, v18)
end

return React.memo(SduiExpandableListItem)
