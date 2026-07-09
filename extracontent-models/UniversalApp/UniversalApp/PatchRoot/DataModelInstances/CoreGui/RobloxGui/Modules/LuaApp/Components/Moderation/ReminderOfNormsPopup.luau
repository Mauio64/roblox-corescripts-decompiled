local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local CloseReminderOfNormsPopup = require(Modules.LuaApp.Thunks.Moderation.CloseReminderOfNormsPopup)
local ReminderOfNormsAnalytics = require(Modules.LuaApp.Components.Moderation.ReminderOfNormsAnalytics)
local EventIngestService = game:GetService("EventIngestService")
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local _ = {
	LocalizationKeyPrefix = "Feature.Home"
}

function getReminderVariantBodyKey(p1) -- line: 24
	local s1 = ""

	if p1 == "positive" then
		return "Feature.Home.Experiment.Reminders.BodyPositiveVariant"
	end

	if p1 == "warning" then
		s1 = "Feature.Home.Experiment.Reminders.BodyWarningVariant"
	end

	return s1
end

local function ReminderOfNormsPopup(t1: {[any]: any}) -- line: 43
	-- upvalues: useDispatch (copy), useScreenSize (copy), useStyle (copy), React (copy), useSelector (copy), CloseReminderOfNormsPopup (copy), EventIngest (copy), EventIngestService (copy), ReminderOfNormsAnalytics (copy), useLocalization (copy), InteractiveAlert (copy), ButtonType (copy)
	local v21 = useDispatch()
	local v22 = useScreenSize()
	local Theme = useStyle().Theme
	local v24 = React.useRef(DateTime.now().UnixTimestampMillis)
	local v25 = useSelector(function(p2) -- line: 50
		return p2.LocalUserId
	end)
	local v26 = React.useCallback(function() -- line: 54
		-- upvalues: v21 (copy), CloseReminderOfNormsPopup (copy)
		v21(CloseReminderOfNormsPopup())
	end, { v21 })
	local v27 = t1.eventIngest or EventIngest.new(EventIngestService)
	local v28 = React.useCallback(function(p3) -- line: 59
		-- upvalues: v25 (copy), t1 (copy), v24 (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		return {
			user_id = v25,
			source_intervention_id = t1.interventionId,
			reminder_number = t1.reminderNumber,
			experiment_variant = t1.experimentVariant,
			timestamp_milliseconds = UnixTimestampMillis,
			time_to_interact_seconds = (UnixTimestampMillis - v24.current) / 1000,
			interaction = p3
		}
	end, {
		v25,
		t1.interventionId,
		t1.reminderNumber,
		t1.experimentVariant
	})
	local v29 = React.useCallback(function() -- line: 72
		-- upvalues: v28 (copy), ReminderOfNormsAnalytics (copy), v27 (copy), v26 (copy)
		local v36 = v28(ReminderOfNormsAnalytics.Constants.EventTypes.Dimissed)

		ReminderOfNormsAnalytics.sendEvent(v27, v36)
		v26()
	end, { v28 })
	local v30 = React.useCallback(function() -- line: 78
		-- upvalues: v28 (copy), ReminderOfNormsAnalytics (copy), v27 (copy), v26 (copy)
		local v37 = v28(ReminderOfNormsAnalytics.Constants.EventTypes.CtaClicked)

		ReminderOfNormsAnalytics.sendEvent(v27, v37)
		v26()
	end, { v28 })
	local v31 = useLocalization({
		policyViolation = `Feature.Home.{ t1.policyViolation }`
	})
	local v32 = useLocalization({
		reminderTitle = "Feature.Home.Experiment.Reminders.Title",
		buttonText = "Feature.Home.Experiment.Reminders.Button",
		sharedBody = {
			"Feature.Home.Experiment.Reminders.BodyShared",
			policy_violation = v31.policyViolation
		},
		variantBody = getReminderVariantBodyKey(t1.contentVariant)
	})

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BackgroundColor = Theme.BackgroundTransparency,
		[React.Event.Activated] = v29
	}, {
		Popup = React.createElement(InteractiveAlert, {
			title = v32.reminderTitle,
			bodyText = `{ v32.sharedBody } \n\n { v32.variantBody }`,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v30,
						text = v32.buttonText
					}
				}}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v22
		})
	})
end

return ReminderOfNormsPopup
