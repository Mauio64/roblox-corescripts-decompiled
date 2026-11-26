local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Types")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Localization").Hooks.useLocalization
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useStore

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local createScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").createScheduledSquad
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadPromptResponse = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptResponse
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local updateScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").updateScheduledSquad

return function(props)
	local v5 = React.useContext(squadExternalContractContext)
	local v6 = useDispatch()
	local v7 = useLocalUserId()
	local v8 = useStore()
	local v9 = useLocalization({
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
	local v10

	if props.scheduledSquad and props.scheduledSquad.startTime then
		v10 = props.scheduledSquad.startTime
	end

	local state, setState = useState(v10)

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(not props.scheduledSquad and "" or props.scheduledSquad.title)
	local state4, setState4 = React.useState(false)

	if state4 then
		local fieldIsRequiredText = v9.fieldIsRequiredText
	end

	React.useEffect(function()
		local v12 = if props.scheduledSquad and props.scheduledSquad.startTime then props.scheduledSquad.startTime else nil
		setState(v12)

		setState2(false)
		setState4(false)
	end, { props.isOpen, props.scheduledSquad and props.scheduledSquad.startTime })

	local v11 = props.scheduledSquad and tostring(props.scheduledSquad.initiatorId) == tostring(v7)

	local now = DateTime.now()
	local localTime = now:ToLocalTime()

	local v12 = React.useCallback(function()
		props.onClose()
		v5.setSquadPrompt(v8, {
			hideCancelButton = true,
			promptType = squadPromptType.Error
		})
	end, { props.onClose, v5.setSquadPrompt, v8 })

	React.useCallback(function(p2)
		if state4 then
			setState4(false)
		end

		setState3(p2)
	end, { state4, setState4, setState3 })

	local v13 = React.useCallback(function(p2, p3)
		if p2 == 2 and (p3 % 4 == 0 and p3 % 100 ~= 0 or p3 % 400 == 0) then
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
		})[p2]
	end, {})

	local v14 = React.useCallback(function(object, p2)
		if object and state2 then
			setState2(false)
		end

		local v16 = if object then object:ToIsoDate() else nil
		setState(v16)
	end, { setState2, setState, state2 })

	local v15 = React.useCallback(function()
		local v16 = false

		if state then
			local dateTime = DateTime.fromIsoDate(state)

			if dateTime and dateTime.UnixTimestampMillis < DateTime.now().UnixTimestampMillis then
				setState2(true)
				v16 = true
			end
		else
			setState2(true)
			v16 = true
		end

		if not v16 then
			if v11 and props.scheduledSquad then
				updateScheduledSquad({
					scheduledGroupUpId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
					title = state3,
					startTime = state
				}, props.onClose, v12)

				v5.fireSquadAnalytics(EventNames.SquadPromptResponded, {
					promptType = squadPromptType.ScheduleSquad,
					scheduledSquadId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
					squadLocation = v5.squadLocation,
					responseType = squadPromptResponse.Update
				})
			else
				props.onClose()
				v6(createScheduledSquad({
					parentChannelId = props.conversationId or "",
					title = state3,
					startTime = state
				}, v5.setSquadPrompt))

				v5.fireSquadAnalytics(EventNames.SquadPromptResponded, {
					promptType = squadPromptType.ScheduleSquad,
					squadLocation = v5.squadLocation,
					responseType = squadPromptResponse.Create
				})
			end
		end
	end, {
		v12,
		false,
		v11,
		props.conversationId,
		props.scheduledSquad,
		props.onClose,
		state,
		setState2,
		setState4,
		state4,
		state3,
		v5.setSquadPrompt,
		v5.fireSquadAnalytics,
		v5.squadLocation
	})

	local v16 = React.useCallback(function()
		local day = localTime.Day

		local v17 = if localTime.Month + 6 > 12 then (localTime.Month + 6) % 12 else localTime.Month + 6
		local v18 = if localTime.Month + 6 > 12 then localTime.Year + 1 else localTime.Year

		local v19 = v13(v17, v18)

		if v19 < day then
			return DateTime.fromLocalTime(v18, v17, v19)
		end

		return DateTime.fromLocalTime(v18, v17, day)
	end, { localTime, v13 })

	local v17 = React.useCallback(function()
		props.onClose()

		v5.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = squadPromptType.ScheduleSquad,
			scheduledSquadId = props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
			squadLocation = v5.squadLocation,
			responseType = squadPromptResponse.Cancel
		})
	end, {
		props.scheduledSquad and props.scheduledSquad.scheduledGroupUpId,
		v5.fireSquadAnalytics,
		props.onClose,
		v5.squadLocation
	})

	local createElement = React.createElement
	local root = sheet.Root
	local v18 = {
		onClose = props.onClose,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet" or nil
	}

	local children = {
		Header = React.createElement(sheet.Header, {}, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = v9.scheduleAPartyText,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--title" or nil
			})
		}),
		Content = 0,
		Action = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local createElement3 = React.createElement
	local dateTimePicker = Foundation.DateTimePicker
	local v22 = if v11 and props.scheduledSquad then DateTime.fromIsoDate(props.scheduledSquad.startTime) else nil
	children.Content = createElement2(content, {}, {
		TitleInput = nil,
		DateTimePicker = createElement3(dateTimePicker, {
			defaultDates = v22,
			hasError = state2,
			LayoutOrder = 2,
			isRequired = true,
			label = v9.startTimeText,
			onChanged = v14,
			selectableDateRange = { endDate = v16(), startDate = now },
			variant = Foundation.Enums.DateTimePickerVariant.SingleWithTime,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--start-time-picker" or nil
		})
	})

	local createElement4 = React.createElement
	local actions = sheet.Actions
	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local button = Foundation.Button

	local v28 = if v11 and props.scheduledSquad and props.scheduledSquad.startTime == state then props.scheduledSquad.title == state3 else false
	children.Action = createElement4(actions, {}, {
		ActionList = createElement5(view, { tag = "col auto-y gap-small size-full-0" }, {
			ConfirmButton = createElement6(button, {
				LayoutOrder = 1,
				isDisabled = v28,
				onActivated = v15,
				text = v9.saveText,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--save-button" or nil
			}),
			CancelButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v17,
				text = v9.cancelText,
				variant = Foundation.Enums.ButtonVariant.Standard,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-sheet--cancel-button" or nil
			})
		})
	})
	return createElement(root, v18, children)
end
