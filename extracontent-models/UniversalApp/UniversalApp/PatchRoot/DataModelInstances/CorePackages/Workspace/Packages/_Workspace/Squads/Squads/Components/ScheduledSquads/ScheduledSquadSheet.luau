local Parent = script:FindFirstAncestor("Squads").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SquadExternalContractProvider = require(Parent.SquadsCore.SquadExternalContractProvider)

require(Parent.SquadsCore.Types)

local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useStore = require(Parent.RoactUtils).Hooks.RoactRodux.useStore
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local createScheduledSquad = require(Parent.SquadsCore.Thunks).createScheduledSquad
local EventNames = require(Parent.SquadsCore.EventNames)
local SquadPromptResponse = require(Parent.SquadsCore.Enums).SquadPromptResponse
local SquadPromptType = require(Parent.SquadsCore.Enums).SquadPromptType
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local updateScheduledSquad = require(Parent.SquadsCore.NetworkRequests).updateScheduledSquad

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), SquadExternalContractContext (copy), useDispatch (copy), useLocalUserId (copy), useStore (copy), useLocalization (copy), SquadPromptType (copy), updateScheduledSquad (copy), EventNames (copy), SquadPromptResponse (copy), createScheduledSquad (copy), Sheet (copy), FoundationText (copy), Foundation (copy), View (copy)
	local v19 = React.useContext(SquadExternalContractContext)
	local v20 = useDispatch()
	local v21 = useLocalUserId()
	local v22 = useStore()
	local v23 = useLocalization({
		cancelText = "CommonUI.Controls.Action.Cancel",
		deleteText = "Feature.Chat.Action.Delete",
		fieldIsRequiredText = "Feature.Squads.Label.ThisFieldIsRequired",
		saveText = "Feature.Chat.Action.Save",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		scheduleAPartyText = "Feature.Squads.Action.ScheduleAParty",
		startTimeText = "Feature.Squads.Label.StartTime",
		titleText = "Feature.Squads.Description.Title"
	})
	local v24, v25 = React.useState(if not t1.scheduledSquad or not t1.scheduledSquad.startTime then nil else t1.scheduledSquad.startTime)
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(not t1.scheduledSquad and "" or t1.scheduledSquad.title)
	local v30, v31 = React.useState(false)

	if v30 then
		local _ = v23.fieldIsRequiredText
	end

	React.useEffect(function() -- line: 62
		-- upvalues: v25 (copy), t1 (copy), v27 (copy), v31 (copy)
		v25(if not t1.scheduledSquad or not t1.scheduledSquad.startTime then nil else t1.scheduledSquad.startTime)
		v27(false)
		v31(false)
	end, {
		t1.isOpen,
		t1.scheduledSquad and t1.scheduledSquad.startTime
	})

	local v33 = t1.scheduledSquad and tostring(t1.scheduledSquad.initiatorId) == tostring(v21)
	local dateTime = DateTime.now()
	local v35 = dateTime:ToLocalTime()
	local v36 = React.useCallback(function() -- line: 78
		-- upvalues: t1 (copy), v19 (copy), v22 (copy), SquadPromptType (copy)
		t1.onClose()
		v19.setSquadPrompt(v22, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error
		})
	end, {
		t1.onClose,
		v19.setSquadPrompt,
		v22
	})

	React.useCallback(function(p1) -- line: 86
		-- upvalues: v30 (copy), v31 (copy), v29 (copy)
		if v30 then
			v31(false)
		end

		v29(p1)
	end, {
		v30,
		v31,
		v29
	})

	local v37 = React.useCallback(function(n1: number, n2: number) -- line: 94
		if n1 == 2 and (n2 % 4 == 0 and n2 % 100 ~= 0 or n2 % 400 == 0) then
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
		})[n1]
	end, {})
	local v38 = React.useCallback(function(p2, _) -- line: 107
		-- upvalues: v26 (copy), v27 (copy), v25 (copy)
		if p2 and v26 then
			v27(false)
		end

		v25(if not p2 then nil else p2:ToIsoDate())
	end, {
		v27,
		v25,
		v26
	})
	local v39 = React.useCallback(function() -- line: 116
		-- upvalues: v24 (copy), v27 (copy), v33 (copy), t1 (copy), updateScheduledSquad (copy), v28 (copy), v36 (copy), v19 (copy), EventNames (copy), SquadPromptType (copy), SquadPromptResponse (copy), v20 (copy), createScheduledSquad (copy)
		local v47 = false

		if not v24 then
			v27(true)
			v47 = true
		else
			local dateTime2 = DateTime.fromIsoDate(v24)

			if dateTime2 and dateTime2.UnixTimestampMillis < DateTime.now().UnixTimestampMillis then
				v27(true)
				v47 = true
			end
		end

		if not v47 then
			if v33 and t1.scheduledSquad then
				updateScheduledSquad({
					scheduledGroupUpId = t1.scheduledSquad and t1.scheduledSquad.scheduledGroupUpId,
					title = v28,
					startTime = v24
				}, t1.onClose, v36)
				v19.fireSquadAnalytics(EventNames.SquadPromptResponded, {
					promptType = SquadPromptType.ScheduleSquad,
					scheduledSquadId = t1.scheduledSquad and t1.scheduledSquad.scheduledGroupUpId,
					squadLocation = v19.squadLocation,
					responseType = SquadPromptResponse.Update
				})

				return
			end

			t1.onClose()
			v20(createScheduledSquad({
				parentChannelId = t1.conversationId or "",
				title = v28,
				startTime = v24
			}, v19.setSquadPrompt))
			v19.fireSquadAnalytics(EventNames.SquadPromptResponded, {
				promptType = SquadPromptType.ScheduleSquad,
				squadLocation = v19.squadLocation,
				responseType = SquadPromptResponse.Create
			})
		end
	end, {
		v36,
		false,
		v33,
		t1.conversationId,
		t1.scheduledSquad,
		t1.onClose,
		v24,
		v27,
		v31,
		v30,
		v28,
		v19.setSquadPrompt,
		v19.fireSquadAnalytics,
		v19.squadLocation
	})
	local v40 = React.useCallback(function() -- line: 187
		-- upvalues: v35 (copy), v37 (copy)
		local Day = v35.Day
		local v50 = if not (v35.Month + 6 > 12) then v35.Month + 6 else (v35.Month + 6) % 12
		local v51 = if not (v35.Month + 6 > 12) then v35.Year else v35.Year + 1
		local v52 = v37(v50, v51)

		if v52 < Day then
			return DateTime.fromLocalTime(v51, v50, v52)
		end

		return DateTime.fromLocalTime(v51, v50, Day)
	end, {
		v35,
		v37
	})
	local v41 = React.useCallback(function() -- line: 204
		-- upvalues: t1 (copy), v19 (copy), EventNames (copy), SquadPromptType (copy), SquadPromptResponse (copy)
		t1.onClose()
		v19.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = SquadPromptType.ScheduleSquad,
			scheduledSquadId = t1.scheduledSquad and t1.scheduledSquad.scheduledGroupUpId,
			squadLocation = v19.squadLocation,
			responseType = SquadPromptResponse.Cancel
		})
	end, {
		t1.scheduledSquad and t1.scheduledSquad.scheduledGroupUpId,
		v19.fireSquadAnalytics,
		t1.onClose,
		v19.squadLocation
	})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t1.onClose,
		isOpen = t1.isOpen
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				Text = v23.scheduleAPartyText
			})
		}),
		Content = React.createElement(Sheet.Content, {}, {
			TitleInput = nil,
			DateTimePicker = React.createElement(Foundation.DateTimePicker, {
				LayoutOrder = 2,
				isRequired = true,
				defaultDates = if not v33 or not t1.scheduledSquad then nil else DateTime.fromIsoDate(t1.scheduledSquad.startTime),
				hasError = v26,
				label = v23.startTimeText,
				onChanged = v38,
				selectableDateRange = {
					endDate = v40(),
					startDate = dateTime
				},
				variant = Foundation.Enums.DateTimePickerVariant.SingleWithTime,
				width = UDim.new(1, 0)
			})
		}),
		Action = React.createElement(Sheet.Actions, {}, {
			ActionList = React.createElement(View, {
				tag = "col auto-y gap-small size-full-0"
			}, {
				ConfirmButton = React.createElement(Foundation.Button, {
					LayoutOrder = 1,
					isDisabled = not not v33 and (not not t1.scheduledSquad and (v24 == t1.scheduledSquad.startTime and v28 == t1.scheduledSquad.title)),
					onActivated = v39,
					text = v23.saveText,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					width = UDim.new(1, 0)
				}),
				CancelButton = React.createElement(Foundation.Button, {
					LayoutOrder = 2,
					onActivated = v41,
					text = v23.cancelText,
					variant = Foundation.Enums.ButtonVariant.Standard,
					width = UDim.new(1, 0)
				})
			})
		})
	})
end
