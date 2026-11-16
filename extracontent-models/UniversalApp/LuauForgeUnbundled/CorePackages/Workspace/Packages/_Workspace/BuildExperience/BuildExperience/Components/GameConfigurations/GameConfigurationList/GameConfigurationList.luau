local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local icon = Foundation.Icon
local list = Foundation.List
local text = Foundation.Text
local view = Foundation.View

local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local function GameConfigurationListItem(props)
	local row = props.row
	local isDisabled = row.isDisabled == true
	local onActivated = row.onActivated
	local v5 = React.useCallback(function()
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })
	local v6

	if row.trailingIcon then
		v6 = React.createElement(icon, {
			name = row.trailingIcon,
			size = iconSize.Large,
			tag = "auto-xy content-default",
			testId = `{props.testId}-trailing-icon`
		})
	end

	local createElement = React.createElement
	local item = list.Item
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		title = row.title,
		description = row.description,
		trailing = v6,
		onActivated = 0,
		testId = 0
	}

	if onActivated == nil or isDisabled then
		v5 = nil
	end

	v7.onActivated = v5
	v7.testId = props.testId
	local element = createElement(item, v7)

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
	local v5 = React.useMemo(function()
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
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = testId
	}

	local createElement2 = React.createElement

	local v10 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
			testId = `{testId}-title`
		}),
		Body = 0
	}

	local v11 = if props.body then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.body,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
		testId = `{testId}-body`
	}) else nil
	v10.Body = v11
	return createElement(view, v7, {
		Header = createElement2(view, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, v10),
		Rows = React.createElement(list.Root, {
			LayoutOrder = 2,
			hasDivider = { hasDivider = true, isInset = false },
			isContained = true,
			size = inputSize.Medium
		}, v5)
	})
end

return GameConfigurationList
