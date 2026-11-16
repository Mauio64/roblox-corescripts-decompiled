local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
require(parent.SquadsCore.Types)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore

local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local Thunks = require(parent.SquadsCore.Thunks)
local createScheduledSquad = Thunks.createScheduledSquad
local EventNames = require(parent.SquadsCore.EventNames)
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptResponse = Enums.SquadPromptResponse
local Enums2 = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums2.SquadPromptType
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local NetworkRequests = require(parent.SquadsCore.NetworkRequests)
local updateScheduledSquad = NetworkRequests.updateScheduledSquad

return function(props)
	local v = React.useContext(SquadExternalContractContext)
	local v2 = useDispatch()
	local v3 = useLocalUserId()
	local v4 = useStore()
	local v5 = useLocalization({
		cancelText = "CommonUI.Controls.Action.Cancel",
		deleteText = "Feature.Chat.Action.Delete",
		fieldIsRequiredText = "Feature.Squads.Label.ThisFieldIsRequired",
		saveText = "Feature.Chat.Action.Save",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		scheduleAPartyText = "Feature.Squads.Action.ScheduleAParty",
		startTimeText = "Feature.Squads.Label.StartTime",
		titleText = "Feature.Squads.Description.Title"
	})

	local useState = React.useState
	local v6

	if props.scheduledSquad and props.scheduledSquad.startTime then
		v6 = props.scheduledSquad.startTime
	end

	local state, setState = useState(v6)

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(not props.scheduledSquad and "" or props.scheduledSquad.title)
	local state4, setState4 = React.useState(false)

	if state4 then
		local _fieldIsRequiredText = v5.fieldIsRequiredText
	end

	React.useEffect(function()
		local v7

		if props.scheduledSquad and props.scheduledSquad.startTime then
			v7 = props.scheduledSquad.startTime
		end

		setState(v7)

		setState2(false)
		setState4(false)
	end, { props.isOpen, props.scheduledSquad and props.scheduledSquad.startTime })

	local v7 = props.scheduledSquad and tostring(props.scheduledSquad.initiatorId) == tostring(v3)

	local now = DateTime.now()
	local localTime = now:ToLocalTime()

	local v8 = React.useCallback(function()
		props.onClose()
		v.setSquadPrompt(v4, { hideCancelButton = true, promptType = SquadPromptType.Error })
	end, { props.onClose, v.setSquadPrompt, v4 })

	React.useCallback(function(p)
		if state4 then
			setState4(false)
		end

		setState3(p)
	end, { state4, setState4, setState3 })

	local v9 = React.useCallback(function(p: number, p2: number)
		if p == 2 and (p2 % 4 == 0 and p2 % 100 ~= 0 or p2 % 400 == 0) then
			return 29
		end

		return ({
			31,
			28,
			31,
			30,
			31,
			30,
			31,
			31,
			30,
			31,
			30,
			31
		})[p]
	end, {})

	local onChanged = React.useCallback(function(object, _)
		if object and state2 then
			setState2(false)
		end

		local v10

		if object then
			v10 = object:ToIsoDate()
		end

		setState(v10)
	end, { setState2, setState, state2 })

	local onActivated = React.useCallback(function()
		local v10 = false

		if state then
			local dateTime = DateTime.fromIsoDate(state)

			if dateTime and dateTime.UnixTimestampMillis < DateTime.now().UnixTimestampMillis then
				setState2(true)
				v10 = true
			end
		else
			setState2(true)
			v10 = true
		end

		if not v10 then
			if v7 and props.scheduledSquad then
				updateScheduledSquad({
					scheduledGroupUpId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
					title = state3,
					startTime = state
				}, props.onClose, v8)

				v.fireSquadAnalytics(EventNames.SquadPromptResponded, {
					promptType = SquadPromptType.ScheduleSquad,
					scheduledSquadId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
					squadLocation = v.squadLocation,
					responseType = SquadPromptResponse.Update
				})
			else
				props.onClose()
				v2(createScheduledSquad({
					parentChannelId = props.conversationId or "",
					title = state3,
					startTime = state
				}, v.setSquadPrompt))

				v.fireSquadAnalytics(EventNames.SquadPromptResponded, {
					promptType = SquadPromptType.ScheduleSquad,
					squadLocation = v.squadLocation,
					responseType = SquadPromptResponse.Create
				})
			end
		end
	end, {
		v8,
		false,
		v7,
		props.conversationId,
		props.scheduledSquad,
		props.onClose,
		state,
		setState2,
		setState4,
		state4,
		state3,
		v.setSquadPrompt,
		v.fireSquadAnalytics,
		v.squadLocation
	})

	local v10 = React.useCallback(function()
		local day = localTime.Day
		local v10

		if localTime.Month + 6 > 12 then
			v10 = (localTime.Month + 6) % 12
		else
			v10 = localTime.Month + 6
		end

		local v11

		if localTime.Month + 6 > 12 then
			v11 = localTime.Year + 1
		else
			v11 = localTime.Year
		end

		local v12 = v9(v10, v11)

		if v12 < day then
			return DateTime.fromLocalTime(v11, v10, v12)
		end

		return DateTime.fromLocalTime(v11, v10, day)
	end, { localTime, v9 })

	local onActivated2 = React.useCallback(function()
		props.onClose()

		v.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = SquadPromptType.ScheduleSquad,
			scheduledSquadId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
			squadLocation = v.squadLocation,
			responseType = SquadPromptResponse.Cancel
		})
	end, {
		props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
		v.fireSquadAnalytics,
		props.onClose,
		v.squadLocation
	})

	local createElement = React.createElement
	local root = Sheet.Root
	local v11 = {
		onClose = props.onClose,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet" or nil
	}

	local children = {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v5.scheduleAPartyText,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--title" or nil
			})
		}),
		Content = 0,
		Action = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content

	local createElement3 = React.createElement
	local dateTimePicker = Foundation.DateTimePicker
	local defaultDates

	if v7 and props.scheduledSquad then
		defaultDates = DateTime.fromIsoDate(props.scheduledSquad.startTime)
	end

	children.Content = createElement2(content, {}, {
		TitleInput = nil,
		DateTimePicker = createElement3(dateTimePicker, {
			defaultDates = defaultDates,
			hasError = state2,
			LayoutOrder = 2,
			isRequired = true,
			label = v5.startTimeText,
			onChanged = onChanged,
			selectableDateRange = { endDate = v10(), startDate = now },
			variant = Foundation.Enums.DateTimePickerVariant.SingleWithTime,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--start-time-picker" or nil
		})
	})

	local createElement4 = React.createElement
	local actions = Sheet.Actions
	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local button = Foundation.Button
	local isDisabled

	if v7 and props.scheduledSquad and props.scheduledSquad.startTime == state then
		isDisabled = props.scheduledSquad.title == state3
	else
		isDisabled = false
	end

	children.Action = createElement4(actions, {}, {
		ActionList = createElement5(View, { tag = "col auto-y gap-small size-full-0" }, {
			ConfirmButton = createElement6(button, {
				LayoutOrder = 1,
				isDisabled = isDisabled,
				onActivated = onActivated,
				text = v5.saveText,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--save-button" or nil
			}),
			CancelButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = onActivated2,
				text = v5.cancelText,
				variant = Foundation.Enums.ButtonVariant.Standard,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--cancel-button" or nil
			})
		})
	})
	return createElement(root, v11, children)
end
