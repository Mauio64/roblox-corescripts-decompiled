local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Foundation = require(PeopleReactViewParent.Foundation)
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Menu = Foundation.Menu
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local Constants = require(PeopleReactView.Constants)

local function CardMenu(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), Constants (copy), useGetPeopleService (copy), PersonButtonConfigs (copy), SignalsReact (copy), React (copy), IconName (copy), Menu (copy), InputSize (copy), PersonButton (copy)
	local v16 = useLocalization({
		unblock = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNBLOCK,
		block = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.BLOCK,
		unmute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNMUTE,
		mute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.MUTE,
		report = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.REPORT
	})
	local v17 = useGetPeopleService("PeopleBlockStatusStore")
	local v18 = useGetPeopleService("PeopleVoiceChatStore")
	local v19 = useGetPeopleService("PeopleAnalyticsManager")
	local v20 = useGetPeopleService("Constants")
	local v21 = PersonButtonConfigs(t1.person.UserId)
	local v22 = SignalsReact.useSignalState(v17.getPlayerBlockStatus(t1.person.UserId))
	local v23 = SignalsReact.useSignalState(v18.getPlayerIsLocalMuted(t1.person.UserId))
	local v24 = SignalsReact.useSignalState(v18.getPlayerIsTalking(t1.person.UserId))
	local v25, v26 = React.useState(false)
	local v27 = React.useCallback(function(b1: boolean) -- line: 51
		-- upvalues: t1 (copy), v26 (copy)
		t1.onIsOpenChanged(b1)
		v26(b1)
	end, { t1.onIsOpenChanged })
	local v28 = React.useCallback(function() -- line: 56
		-- upvalues: v19 (copy), v27 (copy)
		v19:trackPersonCardMenuToggled(false)
		v27(false)
	end, { v27 })
	local v29 = React.useCallback(function() -- line: 61
		-- upvalues: v25 (copy), v19 (copy), v27 (copy)
		local v33 = not v25

		v19:trackPersonCardMenuToggled(v33)
		v27(v33)
	end, {
		v25,
		v27
	})
	local v30 = React.useMemo(function() -- line: 67
		-- upvalues: v21 (copy), v20 (copy)
		return v21[v20.PERSON_BUTTONS.MUTE_PLAYER].animatedIcon
	end, { v21 })
	local v31 = React.useMemo(function() -- line: 71
		-- upvalues: v21 (copy), v20 (copy), v23 (copy), v16 (copy), IconName (copy), v22 (copy), v27 (copy)
		local v34 = v21[v20.PERSON_BUTTONS.MUTE_PLAYER]
		local v35 = v21[v20.PERSON_BUTTONS.BLOCK_PLAYER]
		local v36 = v21[v20.PERSON_BUTTONS.REPORT_PLAYER]
		local t2 = {}

		if v34.shouldShow() then
			table.insert(t2, {
				id = "mute",
				text = if not v23 then v16.mute else v16.unmute,
				icon = if not v23 then IconName.Speaker else IconName.SpeakerSlash,
				onActivated = function() -- line: 83
					-- upvalues: v34 (copy), v20 (copy)
					v34.onActivated(v20.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
				end
			})
		end

		if v35.shouldShow() then
			table.insert(t2, {
				id = "block",
				text = if not v22 then v16.block else v16.unblock,
				icon = IconName.CircleSlash,
				onActivated = function() -- line: 93
					-- upvalues: v35 (copy), v20 (copy), v27 (copy)
					v35.onActivated(v20.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
					v27(false)
				end
			})
		end

		if v36.shouldShow() then
			table.insert(t2, {
				id = "report",
				text = v16.report,
				icon = IconName.Flag,
				onActivated = function() -- line: 104
					-- upvalues: v36 (copy), v20 (copy)
					v36.onActivated(v20.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
				end
			})
		end

		return t2
	end, {
		v22,
		v23,
		v27,
		v21,
		v16
	})

	if next(v31) == nil then
		return nil
	end

	return React.createElement(Menu, {
		isOpen = v25,
		items = v31,
		size = InputSize.Medium,
		onPressedOutside = v28
	}, {
		MenuAnchor = React.createElement(PersonButton, {
			isBackgroundTransparent = true,
			LayoutOrder = 1,
			icon = {
				on = if not v24 then IconName.ThreeDotsHorizontal else nil
			},
			animatedIcon = if not v24 then nil else v30,
			onActivated = v29,
			isBuilderIcon = not v24
		})
	})
end

return React.memo(CardMenu)
