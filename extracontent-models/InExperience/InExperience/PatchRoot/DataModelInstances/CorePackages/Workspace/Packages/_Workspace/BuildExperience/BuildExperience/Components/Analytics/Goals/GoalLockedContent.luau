local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

require(BuildExperience.Analytics.Goals.GoalLockedActionId)
require(BuildExperience.Analytics.Goals.GoalTypes)
local useGoalLockedTelemetry = require(script.Parent.useGoalLockedTelemetry)

local function GoalLockedContent(props)
	local testId = props.testId or "GoalLockedContent"
	local locked = props.locked
	local actions = locked.actions
	local goalId = props.goalId
	local universeId = props.universeId

	local function getEligibleHandler(p)
		if p == nil or props.actionHandlers == nil then
			return nil
		end

		local actionHandler = props.actionHandlers[p.id]

		if actionHandler == nil or not actionHandler.isEligible then
			return nil
		end

		return actionHandler
	end

	local v, v2, secondary, v3

	if actions == nil then
		v = nil
		v2 = nil
		secondary = nil
		v3 = nil
	else
		v = actions.primary
		local primary = actions.primary

		if primary == nil or props.actionHandlers == nil then
			v2 = nil
		else
			v2 = props.actionHandlers[primary.id]

			if v2 == nil or not v2.isEligible then
				v2 = nil
			end
		end

		secondary = actions.secondary
		local secondary2 = actions.secondary

		if secondary2 == nil or props.actionHandlers == nil then
			v3 = nil
		else
			v3 = props.actionHandlers[secondary2.id]

			if v3 == nil or not v3.isEligible then
				v3 = nil
			end
		end

		if v2 == nil then
			v2 = v3
			v = secondary
			secondary = nil
			v3 = nil
		end
	end

	local v4 = { message = locked.messageKey }

	local id = nil
	local id2

	if not (v == nil or v2 == nil) then
		v4.primary = v.textKey
		id2 = v.id
	end

	if secondary ~= nil and v3 ~= nil then
		v4.secondary = secondary.textKey
		id = secondary.id
	end

	local v5 = useLocalization(v4)
	local v6 = useGoalLockedTelemetry(universeId, goalId, id2, id)

	local children = {}

	if v ~= nil and v2 ~= nil then
		children.Primary = React.createElement(Button, {
			LayoutOrder = 1,
			text = v5.primary,
			size = InputSize.Small,
			variant = ButtonVariant.SoftEmphasis,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = function()
				v6("primary", v.id)
				v2.onActivate()
			end,
			testId = `{testId}.Primary`
		})

		if secondary ~= nil and v3 ~= nil then
			children.Secondary = React.createElement(Button, {
				LayoutOrder = 2,
				text = v5.secondary,
				size = InputSize.Small,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				width = UDim.new(1, 0),
				onActivated = function()
					v6("secondary", secondary.id)
					v3.onActivate()
				end,
				testId = `{testId}.Secondary`
			})
		end
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = testId
	}

	local v8 = {
		Message = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v5.message,
			tag = "size-full-0 auto-y text-body-medium text-align-x-center content-default",
			testId = `{testId}.Message`
		}),
		Actions = 0
	}
	local actions2

	if v2 ~= nil then
		actions2 = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row gap-small size-full-0 auto-y",
				testId = `{testId}.Actions`
			},
			children
		)
	end

	v8.Actions = actions2
	return createElement(View, v7, v8)
end

return GoalLockedContent
