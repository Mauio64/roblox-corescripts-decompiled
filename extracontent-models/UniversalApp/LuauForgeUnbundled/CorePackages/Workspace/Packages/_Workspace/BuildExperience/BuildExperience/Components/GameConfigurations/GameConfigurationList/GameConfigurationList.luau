local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local FFlagBuildExperienceConfigurationRowTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceConfigurationRowTelemetry")

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
	local onRowActivated = if FFlagBuildExperienceConfigurationRowTelemetry then props.onRowActivated else nil
	local id = row.id

	local function fn()
		if FFlagBuildExperienceConfigurationRowTelemetry and onRowActivated ~= nil then
			onRowActivated(id)
		end

		if onActivated ~= nil then
			onActivated()
		end
	end

	local v7 = React.useCallback(fn, { onActivated, onRowActivated, if FFlagBuildExperienceConfigurationRowTelemetry then id else nil })
	local v8

	if row.trailingIcon then
		v8 = React.createElement(icon, {
			name = row.trailingIcon,
			size = iconSize.Large,
			tag = "auto-xy content-default",
			testId = `{props.testId}-trailing-icon`
		})
	end

	local createElement = React.createElement
	local item = list.Item
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		title = row.title,
		description = row.description,
		trailing = v8,
		onActivated = 0,
		testId = 0
	}

	if onActivated == nil or isDisabled then
		v7 = nil
	end

	v9.onActivated = v7
	v9.testId = props.testId
	local element = createElement(item, v9)

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
	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for k, row in props.rows do
			local id = row.id
			local createElement = React.createElement

			local v7 = if FFlagBuildExperienceConfigurationRowTelemetry then props.onRowActivated else nil
			children[id] = createElement(GameConfigurationListItem, {
				LayoutOrder = k,
				row = row,
				onRowActivated = v7,
				testId = `{testId}-row-{row.id}`
			})
		end

		return children
	end

	local rows = props.rows

	local v6 = if FFlagBuildExperienceConfigurationRowTelemetry then props.onRowActivated else nil
	local v7 = useMemo(fn, { rows, testId, v6 })

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = testId
	}

	local createElement2 = React.createElement

	local v12 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
			testId = `{testId}-title`
		}),
		Body = 0
	}

	local v13 = if props.body then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.body,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
		testId = `{testId}-body`
	}) else nil
	v12.Body = v13
	return createElement(view, v9, {
		Header = createElement2(view, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, v12),
		Rows = React.createElement(list.Root, {
			LayoutOrder = 2,
			hasDivider = { hasDivider = true, isInset = false },
			isContained = true,
			size = inputSize.Medium
		}, v7)
	})
end

return GameConfigurationList
