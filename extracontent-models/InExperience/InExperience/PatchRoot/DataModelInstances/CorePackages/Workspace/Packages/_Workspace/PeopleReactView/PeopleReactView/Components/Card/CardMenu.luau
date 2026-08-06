local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Foundation = require(PeopleReactViewParent.Foundation)
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Menu = Foundation.Menu
local View = Foundation.View
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local CardMenuWithVoiceVolume = require(PeopleReactView.Components.Card.CardMenuWithVoiceVolume)
local useDismissWhenOutOfView = require(PeopleReactView.Hooks.useDismissWhenOutOfView)
local Constants = require(PeopleReactView.Constants)
local v17 = require(PeopleReactViewParent.PeopleService).getService("Flags")
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = v17.FFlagVoiceVolumeControlsPerUserPlayerGridMenu
local FFlagPeoplePageDismissCardMenuOnScrollOutOfView = v17.FFlagPeoplePageDismissCardMenuOnScrollOutOfView
local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = v17.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry

local function CardMenu(t1: {[any]: any}) -- line: 42
	-- upvalues: useLocalization (copy), Constants (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), useGetPeopleService (copy), PersonButtonConfigs (copy), SignalsReact (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), React (copy), FFlagPeoplePageDismissCardMenuOnScrollOutOfView (copy), useDismissWhenOutOfView (copy), IconName (copy), PersonButton (copy), View (copy), CardMenuWithVoiceVolume (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), Menu (copy), InputSize (copy)
	local v24 = useLocalization({
		unblock = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNBLOCK,
		block = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.BLOCK,
		unmute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNMUTE,
		mute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.MUTE,
		report = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.REPORT,
		voiceSectionTitle = if not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else Constants.PEOPLEPAGE.CARD_MENU.LOCALIZED_STRINGS.VOICE_SECTION_TITLE
	})
	local v25 = useGetPeopleService("PeopleBlockStatusStore")
	local v26 = useGetPeopleService("PeopleVoiceChatStore")
	local v27 = useGetPeopleService("PeopleAnalyticsManager")
	local v28 = useGetPeopleService("Constants")
	local v29 = PersonButtonConfigs(t1.person.UserId)
	local v30 = SignalsReact.useSignalState(v25.getPlayerBlockStatus(t1.person.UserId))
	local v31 = SignalsReact.useSignalState(v26.getPlayerIsLocalMuted(t1.person.UserId))
	local v32 = SignalsReact.useSignalState(v26.getPlayerIsTalking(t1.person.UserId))
	local v33 = not not FFlagVoiceVolumeControlsPerUserPlayerGridMenu and SignalsReact.useSignalState(v26.getShowVolumeControl)
	local v34 = not not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and (v33 and v29[v28.PERSON_BUTTONS.MUTE_PLAYER].shouldShow())
	local v35, v36 = React.useState(false)
	local v37 = React.useCallback(function(b1: boolean) -- line: 73
		-- upvalues: t1 (copy), v36 (copy)
		t1.onIsOpenChanged(b1)
		v36(b1)
	end, { t1.onIsOpenChanged })
	local v38 = React.useCallback(function() -- line: 78
		-- upvalues: v27 (copy), v37 (copy)
		v27:trackPersonCardMenuToggled(false)
		v37(false)
	end, { v37 })
	local v39 = React.useCallback(function() -- line: 84
		-- upvalues: v35 (copy), v27 (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), v34 (copy), v28 (copy), v37 (copy)
		local v48 = not v35

		v27:trackPersonCardMenuToggled(v48)

		if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and (v48 and v34) then
			v27:recordPerUserVoiceVolumeUiOpened(v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
		end

		v37(v48)
	end, {
		v35,
		v37,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else v34,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else v28
	})
	local v40 = nil

	if FFlagPeoplePageDismissCardMenuOnScrollOutOfView then
		v40 = React.useRef(nil)
		useDismissWhenOutOfView(v35, v38, v40)
	end

	local v41 = React.useMemo(function() -- line: 112
		-- upvalues: v29 (copy), v28 (copy)
		return v29[v28.PERSON_BUTTONS.MUTE_PLAYER].animatedIcon
	end, { v29 })
	local v42 = nil

	if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		local getPlayerIsLocalMuted = v26.getPlayerIsLocalMuted

		v42 = React.useCallback(function(n1: number) -- line: 119
			-- upvalues: getPlayerIsLocalMuted (copy)
			if n1 and getPlayerIsLocalMuted then
				return getPlayerIsLocalMuted(n1)(false)
			end

			return false
		end, { getPlayerIsLocalMuted })
	end

	local v44 = if not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then React.useMemo(function() -- line: 201
		-- upvalues: v29 (copy), v28 (copy), v31 (copy), v24 (copy), IconName (copy), v30 (copy), v37 (copy)
		local v57 = v29[v28.PERSON_BUTTONS.MUTE_PLAYER]
		local v58 = v29[v28.PERSON_BUTTONS.BLOCK_PLAYER]
		local v59 = v29[v28.PERSON_BUTTONS.REPORT_PLAYER]
		local t2 = {}

		if v57.shouldShow() then
			table.insert(t2, {
				id = "mute",
				text = if not v31 then v24.mute else v24.unmute,
				icon = if not v31 then IconName.Speaker else IconName.SpeakerSlash,
				onActivated = function() -- line: 213
					-- upvalues: v57 (copy), v28 (copy)
					v57.onActivated(v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
				end
			})
		end

		if v58.shouldShow() then
			table.insert(t2, {
				id = "block",
				text = if not v30 then v24.block else v24.unblock,
				icon = IconName.CircleSlash,
				onActivated = function() -- line: 223
					-- upvalues: v58 (copy), v28 (copy), v37 (copy)
					v58.onActivated(v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
					v37(false)
				end
			})
		end

		if v59.shouldShow() then
			table.insert(t2, {
				id = "report",
				text = v24.report,
				icon = IconName.Flag,
				onActivated = function() -- line: 234
					-- upvalues: v59 (copy), v28 (copy)
					v59.onActivated(v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
				end
			})
		end

		return t2
	end, {
		v30,
		v31,
		v37,
		v29,
		v24
	}) else React.useMemo(function() -- line: 130
		-- upvalues: v29 (copy), v28 (copy), v31 (copy), v24 (copy), IconName (copy), v33 (copy), v30 (copy), v37 (copy)
		local v50 = v29[v28.PERSON_BUTTONS.MUTE_PLAYER]
		local v51 = v29[v28.PERSON_BUTTONS.BLOCK_PLAYER]
		local v52 = v29[v28.PERSON_BUTTONS.REPORT_PLAYER]
		local PEOPLE_CARD = v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD
		local t3 = {}
		local t4 = {}
		local t5 = nil

		if v50.shouldShow() then
			t5 = {
				id = "mute",
				text = if not v31 then v24.mute else v24.unmute,
				icon = if not v31 then IconName.Speaker else IconName.SpeakerSlash,
				onActivated = function() -- line: 145
					-- upvalues: v50 (copy), PEOPLE_CARD (copy)
					v50.onActivated(PEOPLE_CARD)
				end
			}
		end

		if t5 and not v33 then
			table.insert(t4, t5)
		end

		if v51.shouldShow() then
			table.insert(t4, {
				id = "block",
				text = if not v30 then v24.block else v24.unblock,
				icon = IconName.CircleSlash,
				onActivated = function() -- line: 161
					-- upvalues: v51 (copy), PEOPLE_CARD (copy), v37 (copy)
					v51.onActivated(PEOPLE_CARD)
					v37(false)
				end
			})
		end

		if v52.shouldShow() then
			table.insert(t4, {
				id = "report",
				text = v24.report,
				icon = IconName.Flag,
				onActivated = function() -- line: 172
					-- upvalues: v52 (copy), PEOPLE_CARD (copy)
					v52.onActivated(PEOPLE_CARD)
				end
			})
		end

		if #t4 > 0 then
			table.insert(t3, {
				items = t4
			})
		end

		if t5 and v33 then
			table.insert(t3, {
				showVolumeSlider = true,
				title = v24.voiceSectionTitle,
				items = { t5 }
			})
		end

		return t3
	end, {
		v30,
		v31,
		v37,
		v29,
		v24,
		v33
	})
	local v45 = React.createElement(PersonButton, {
		isBackgroundTransparent = true,
		LayoutOrder = 1,
		icon = {
			on = if not v32 then IconName.ThreeDotsHorizontal else nil
		},
		animatedIcon = if not v32 then nil else v41,
		onActivated = v39,
		isBuilderIcon = not v32
	})
	local v46 = if not FFlagPeoplePageDismissCardMenuOnScrollOutOfView then nil else React.createElement(View, {
		LayoutOrder = 1,
		tag = "auto-xy",
		ref = v40
	}, {
		Button = v45
	})

	if next(v44) == nil then
		return nil
	end

	if FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		return React.createElement(CardMenuWithVoiceVolume, {
			isOpen = v35,
			menuGroups = v44,
			onPressedOutside = v38,
			userId = t1.person.UserId,
			voiceVolumeMin = v28.VOICE_CHAT.VOICE_VOLUME.MIN,
			voiceVolumeMax = v28.VOICE_CHAT.VOICE_VOLUME.MAX,
			getPlayerVoiceVolume = v26.getPlayerVoiceVolume,
			subscribePlayerVoiceVolume = v26.subscribePlayerVoiceVolume,
			setPlayerVoiceVolume = v26.setPlayerVoiceVolume,
			isMutedByLocalUser = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then nil else v31,
			getPlayerIsLocalMuted = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else v42,
			getVoiceSessionId = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else v26.getVoiceSessionId
		}, {
			MenuAnchor = v46 or v45
		})
	end

	return React.createElement(Menu, {
		isOpen = v35,
		items = v44,
		size = InputSize.Medium,
		onPressedOutside = v38
	}, {
		MenuAnchor = v46 or v45
	})
end

return React.memo(CardMenu)
