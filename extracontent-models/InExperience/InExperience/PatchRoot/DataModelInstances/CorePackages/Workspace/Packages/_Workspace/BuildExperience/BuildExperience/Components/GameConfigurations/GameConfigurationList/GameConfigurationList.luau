local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local List = Foundation.List
local Text = Foundation.Text
local View = Foundation.View

local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local function GameConfigurationListItem(props)
	local row = props.row
	local isDisabled = row.isDisabled == true
	local onActivated = row.onActivated
	local onActivated2 = React.useCallback(function()
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })
	local trailing

	if row.trailingIcon then
		trailing = React.createElement(Icon, {
			name = row.trailingIcon,
			size = IconSize.Large,
			tag = "auto-xy content-default",
			testId = `{props.testId}-trailing-icon`
		})
	end

	local createElement = React.createElement
	local item = List.Item
	local v = {
		LayoutOrder = props.LayoutOrder,
		title = row.title,
		description = row.description,
		trailing = trailing,
		onActivated = 0,
		testId = 0
	}

	if onActivated == nil or isDisabled then
		onActivated2 = nil
	end

	v.onActivated = onActivated2
	v.testId = props.testId
	local element = createElement(item, v)

	if isDisabled then
		return React.createElement("CanvasGroup", {
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 0.5
		}, { Item = element })
	end

	return element
end

local function GameConfigurationList(props)
	local testId = props.testId or "game-configuration-list"
	local v = React.useMemo(function()
		local children = {}

		for k, row in props.rows do
			children[row.id] = React.createElement(GameConfigurationListItem, {
				LayoutOrder = k,
				row = row,
				testId = `{testId}-row-{row.id}`
			})
		end

		return children
	end, { props.rows, testId })

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = testId
	}

	local createElement2 = React.createElement

	local v3 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
			testId = `{testId}-title`
		}),
		Body = 0
	}
	local body

	if props.body then
		body = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.body,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
			testId = `{testId}-body`
		})
	end

	v3.Body = body
	return createElement(View, v2, {
		Header = createElement2(View, { LayoutOrder = 1, tag = "col gap-xsmall size-full-0 auto-y" }, v3),
		Rows = React.createElement(List.Root, {
			LayoutOrder = 2,
			hasDivider = { hasDivider = true, isInset = false },
			isContained = true,
			size = InputSize.Medium
		}, v)
	})
end

return GameConfigurationList
