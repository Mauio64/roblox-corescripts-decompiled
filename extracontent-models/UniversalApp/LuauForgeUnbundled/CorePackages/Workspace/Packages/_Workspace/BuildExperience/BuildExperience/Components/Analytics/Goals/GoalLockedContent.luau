local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
local useGoalLockedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalLockedTelemetry")

local function GoalLockedContent(props)
	local testId = props.testId or "GoalLockedContent"
	local locked = props.locked
	local actions = locked.actions
	local goalId = props.goalId
	local universeId = props.universeId

	local function getEligibleHandler(p2)
		if p2 == nil or props.actionHandlers == nil then
			return nil
		end

		local actionHandler = props.actionHandlers[p2.id]

		if actionHandler == nil or not actionHandler.isEligible then
			return nil
		end

		return actionHandler
	end

	local v5, v6, secondary, v7

	if actions == nil then
		v5 = nil
		v6 = nil
		secondary = nil
		v7 = nil
	else
		v5 = actions.primary
		local primary = actions.primary

		if primary == nil or props.actionHandlers == nil then
			v6 = nil
		else
			v6 = props.actionHandlers[primary.id]

			if v6 == nil or not v6.isEligible then
				v6 = nil
			end
		end

		secondary = actions.secondary
		local secondary2 = actions.secondary

		if secondary2 == nil or props.actionHandlers == nil then
			v7 = nil
		else
			v7 = props.actionHandlers[secondary2.id]

			if v7 == nil or not v7.isEligible then
				v7 = nil
			end
		end

		if v6 == nil then
			v6 = v7
			v5 = secondary
			secondary = nil
			v7 = nil
		end
	end

	local v8 = { message = locked.messageKey }

	local id = nil
	local id2

	if not (v5 == nil or v6 == nil) then
		v8.primary = v5.textKey
		id2 = v5.id
	end

	if secondary ~= nil and v7 ~= nil then
		v8.secondary = secondary.textKey
		id = secondary.id
	end

	local v9 = useLocalization(v8)
	local v10 = useGoalLockedTelemetry(universeId, goalId, id2, id)

	local children = {}

	if v5 ~= nil and v6 ~= nil then
		children.Primary = React.createElement(button, {
			LayoutOrder = 1,
			text = v9.primary,
			size = inputSize.Small,
			variant = buttonVariant.SoftEmphasis,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = function()
				v10("primary", v5.id)
				v6.onActivate()
			end,
			testId = `{testId}.Primary`
		})

		if secondary ~= nil and v7 ~= nil then
			children.Secondary = React.createElement(button, {
				LayoutOrder = 2,
				text = v9.secondary,
				size = inputSize.Small,
				variant = buttonVariant.Standard,
				fillBehavior = fillBehavior.Fill,
				width = UDim.new(1, 0),
				onActivated = function()
					v10("secondary", secondary.id)
					v7.onActivate()
				end,
				testId = `{testId}.Secondary`
			})
		end
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = testId
	}

	local v13 = {
		Message = React.createElement(text, {
			LayoutOrder = 1,
			Text = v9.message,
			tag = "size-full-0 auto-y text-body-medium text-align-x-center content-default",
			testId = `{testId}.Message`
		}),
		Actions = 0
	}

	local v14 = if v6 ~= nil then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "row gap-small size-full-0 auto-y",
			testId = `{testId}.Actions`
		},
		children
	) else nil
	v13.Actions = v14
	return createElement(view, v12, v13)
end

return GoalLockedContent
