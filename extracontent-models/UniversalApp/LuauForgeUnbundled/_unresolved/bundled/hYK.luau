local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")

local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local useRef = React.useRef

local eventIngest = require("@luauforge/bundled/bZt").AnalyticsReporters.EventIngest
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/hYL")
local module2 = require("@luauforge/bundled/hQO")
local module3 = require("@luauforge/bundled/hYM")
local module4 = require("@luauforge/deferred/hYN")
local module5 = require("@luauforge/bundled/hYQ")

local function HomepageReminderWrapper(props)
	local v5 = useRef(DateTime.now().UnixTimestampMillis)
	local v6 = useDispatch()

	local v7 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v8 = useAppPolicy(function(p2)
		local getAccountType = p2.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end) == "Kids"

	local v9 = props.nudgeType == module2.NudgeType.TextFilterEducation
	local v10

	if v9 then
		v10 = module3.Constants.ExperimentVariants[props.experimentVariant]
			or module3.Constants.ExperimentVariants.Invalid
	else
		v10 = props.experimentVariant
	end

	local eventIngest2 = props.eventIngest or eventIngest.new(EventIngestService)
	local v11 = useCallback(function(interaction)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v12 = {
			user_id = v7,
			source_intervention_id = props.interventionId,
			reminder_number = props.reminderNumber,
			experiment_variant = v10,
			content_variant = 0,
			is_kids_variant = 0,
			timestamp_milliseconds = 0,
			time_to_interact_seconds = 0,
			interaction = 0
		}

		local v13 = if v9 then props.contentVariant else nil
		v12.content_variant = v13
		v12.is_kids_variant = if v9 then v8 else nil
		v12.timestamp_milliseconds = unixTimestampMillis
		v12.time_to_interact_seconds = (unixTimestampMillis - v5.current) / 1000
		v12.interaction = interaction
		return v12
	end, {
		v7,
		props.interventionId,
		props.reminderNumber,
		v10,
		props.contentVariant,
		v9,
		v8
	})

	local v12 = useCallback(function()
		v6(module())
	end, { v6 })

	local v13 = useCallback(function()
		local v14 = v11(module3.Constants.EventTypes.Dimissed)
		module3.sendEvent(eventIngest2, v14)
		v12()
	end, { v11, eventIngest2, v12 })

	local v14 = useCallback(function()
		local v15 = v11(module3.Constants.EventTypes.CtaClicked)
		module3.sendEvent(eventIngest2, v15)
		v12()
	end, { v11, eventIngest2, v12 })

	if v9 then
		return React.createElement(module5, {
			contentVariant = props.contentVariant,
			experimentVariant = props.experimentVariant,
			isKids = v8,
			onClose = v14
		})
	end

	return React.createElement(module4, {
		contentVariant = props.contentVariant,
		policyViolation = props.policyViolation,
		onDismiss = v13,
		onClose = v14
	})
end

return React.memo(HomepageReminderWrapper)
