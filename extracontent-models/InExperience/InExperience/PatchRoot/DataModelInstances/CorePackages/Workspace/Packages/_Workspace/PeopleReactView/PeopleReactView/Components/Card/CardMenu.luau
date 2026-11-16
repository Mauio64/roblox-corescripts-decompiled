local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Menu = Foundation.Menu
local View = Foundation.View

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)

local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local CardMenuWithVoiceVolume = require(PeopleReactView.Components.Card.CardMenuWithVoiceVolume)
local useDismissWhenOutOfView = require(PeopleReactView.Hooks.useDismissWhenOutOfView)

local Constants = require(PeopleReactView.Constants)

local PeopleService = require(parent.PeopleService)
local service = PeopleService.getService("Flags")
local fFlagVoiceVolumeControlsPerUserPlayerGridMenu = service.FFlagVoiceVolumeControlsPerUserPlayerGridMenu
local fFlagPeoplePageDismissCardMenuOnScrollOutOfView = service.FFlagPeoplePageDismissCardMenuOnScrollOutOfView

local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)

local fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = service.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry

local function CardMenu(p)
	local v = {
		unblock = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNBLOCK,
		block = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.BLOCK,
		unmute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.UNMUTE,
		mute = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.MUTE,
		report = Constants.PEOPLEPAGE.PERSON_BUTTONS.LOCALIZED_STRINGS.REPORT,
		voiceSectionTitle = 0
	}
	local voiceSectionTitle

	if fFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		voiceSectionTitle = Constants.PEOPLEPAGE.CARD_MENU.LOCALIZED_STRINGS.VOICE_SECTION_TITLE
	end

	v.voiceSectionTitle = voiceSectionTitle
	local v2 = useLocalization(v)

	local v3 = useGetPeopleService("PeopleBlockStatusStore")
	local v4 = useGetPeopleService("PeopleVoiceChatStore")
	local v5 = useGetPeopleService("PeopleAnalyticsManager")
	local v6 = useGetPeopleService("Constants")

	local personButtonConfigs = PersonButtonConfigs(p.person.UserId)

	local v7 = SignalsReact.useSignalState(v3.getPlayerBlockStatus(p.person.UserId))
	local v8 = SignalsReact.useSignalState(v4.getPlayerIsLocalMuted(p.person.UserId))
	local v9 = SignalsReact.useSignalState(v4.getPlayerIsTalking(p.person.UserId))
	local v10

	if fFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		v10 = SignalsReact.useSignalState(v4.getShowVolumeControl)
	else
		v10 = false
	end

	local v11

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v11 = v10 and personButtonConfigs[v6.PERSON_BUTTONS.MUTE_PLAYER].shouldShow()
	else
		v11 = false
	end

	local state, setState = React.useState(false)

	local v12 = React.useCallback(function(flag: boolean)
		p.onIsOpenChanged(flag)
		setState(flag)
	end, { p.onIsOpenChanged })

	local onPressedOutside = React.useCallback(function()
		v5:trackPersonCardMenuToggled(false)
		v12(false)
	end, { v12 })

	local useCallback = React.useCallback
	local function fn()
		local v13 = not state
		v5:trackPersonCardMenuToggled(v13)

		if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and v13 and v11 then
			v5:recordPerUserVoiceVolumeUiOpened(v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
		end

		v12(v13)
	end

	local v13

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v13 = v11
	end

	local v14

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v14 = v6
	end

	local onActivated = useCallback(fn, { state, v12, v13, v14 })
	local ref

	if fFlagPeoplePageDismissCardMenuOnScrollOutOfView then
		ref = React.useRef(nil)
		useDismissWhenOutOfView(state, onPressedOutside, ref)
	end

	local animatedIcon = React.useMemo(function()
		return personButtonConfigs[v6.PERSON_BUTTONS.MUTE_PLAYER].animatedIcon
	end, { personButtonConfigs })
	local getPlayerIsLocalMuted2

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		local getPlayerIsLocalMuted = v4.getPlayerIsLocalMuted
		getPlayerIsLocalMuted2 = React.useCallback(function(p2: number)
			if p2 and getPlayerIsLocalMuted then
				return getPlayerIsLocalMuted(p2)(false)
			end

			return false
		end, { getPlayerIsLocalMuted })
	end

	local v15

	if fFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		v15 = React.useMemo(function()
			local v16 = personButtonConfigs[v6.PERSON_BUTTONS.MUTE_PLAYER]
			local v17 = personButtonConfigs[v6.PERSON_BUTTONS.BLOCK_PLAYER]
			local v18 = personButtonConfigs[v6.PERSON_BUTTONS.REPORT_PLAYER]
			local PEOPLE_CARD = v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD

			local v19 = {}
			local items = {}
			local v20

			if v16.shouldShow() then
				v20 = { id = "mute", text = 0, icon = 0, onActivated = 0 }

				local text = if v8 then v2.unmute else v2.mute
				v20.text = text
				local icon

				if v8 then
					icon = IconName.SpeakerSlash
				else
					icon = IconName.Speaker
				end

				v20.icon = icon
				function v20.onActivated()
					v16.onActivated(PEOPLE_CARD)
				end
			end

			if v20 and not v10 then
				table.insert(items, v20)
			end

			if v17.shouldShow() then
				local text = if v7 then v2.unblock else v2.block
				local v21 = {
					id = "block",
					text = text,
					icon = IconName.CircleSlash,
					onActivated = function()
						v17.onActivated(PEOPLE_CARD)
						v12(false)
					end
				}
				table.insert(items, v21)
			end

			if v18.shouldShow() then
				table.insert(items, {
					id = "report",
					text = v2.report,
					icon = IconName.Flag,
					onActivated = function()
						v18.onActivated(PEOPLE_CARD)
					end
				})
			end

			if #items > 0 then
				table.insert(v19, { items = items })
			end

			if v20 and v10 then
				table.insert(v19, {
					title = v2.voiceSectionTitle,
					showVolumeSlider = true,
					items = { v20 }
				})
			end

			return v19
		end, { v7, v8, v12, personButtonConfigs, v2, v10 })
	else
		v15 = React.useMemo(function()
			local v16 = personButtonConfigs[v6.PERSON_BUTTONS.MUTE_PLAYER]
			local v17 = personButtonConfigs[v6.PERSON_BUTTONS.BLOCK_PLAYER]
			local v18 = personButtonConfigs[v6.PERSON_BUTTONS.REPORT_PLAYER]

			local v19 = {}

			if v16.shouldShow() then
				local text = if v8 then v2.unmute else v2.mute
				local icon

				if v8 then
					icon = IconName.SpeakerSlash
				else
					icon = IconName.Speaker
				end

				table.insert(v19, {
					id = "mute",
					text = text,
					icon = icon,
					onActivated = function()
						v16.onActivated(v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
					end
				})
			end

			if v17.shouldShow() then
				local text = if v7 then v2.unblock else v2.block
				local v20 = {
					id = "block",
					text = text,
					icon = IconName.CircleSlash,
					onActivated = function()
						v17.onActivated(v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
						v12(false)
					end
				}
				table.insert(v19, v20)
			end

			if v18.shouldShow() then
				table.insert(v19, {
					id = "report",
					text = v2.report,
					icon = IconName.Flag,
					onActivated = function()
						v18.onActivated(v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
					end
				})
			end

			return v19
		end, { v7, v8, v12, personButtonConfigs, v2 })
	end

	local createElement = React.createElement
	local on

	if not v9 then
		on = IconName.ThreeDotsHorizontal
	end

	if not v9 then
		animatedIcon = nil
	end

	local element = createElement(PersonButton, {
		icon = { on = on },
		animatedIcon = animatedIcon,
		onActivated = onActivated,
		isBuilderIcon = not v9,
		isBackgroundTransparent = true,
		LayoutOrder = 1
	})
	local v16

	if fFlagPeoplePageDismissCardMenuOnScrollOutOfView then
		v16 = React.createElement(View, { ref = ref, LayoutOrder = 1, tag = "auto-xy" }, {
			Button = element
		})
	end

	if next(v15) == nil then
		return nil
	end

	if not fFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		return React.createElement(
			Menu,
			{
				isOpen = state,
				items = v15,
				size = InputSize.Medium,
				onPressedOutside = onPressedOutside
			},
			{
				MenuAnchor = v16 or element
			}
		)
	end

	local createElement2 = React.createElement
	local v17 = {
		isOpen = state,
		menuGroups = v15,
		onPressedOutside = onPressedOutside,
		userId = p.person.UserId,
		voiceVolumeMin = v6.VOICE_CHAT.VOICE_VOLUME.MIN,
		voiceVolumeMax = v6.VOICE_CHAT.VOICE_VOLUME.MAX,
		getPlayerVoiceVolume = v4.getPlayerVoiceVolume,
		subscribePlayerVoiceVolume = v4.subscribePlayerVoiceVolume,
		setPlayerVoiceVolume = v4.setPlayerVoiceVolume,
		isMutedByLocalUser = 0,
		getPlayerIsLocalMuted = 0,
		getVoiceSessionId = 0
	}
	local isMutedByLocalUser

	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		isMutedByLocalUser = v8
	end

	v17.isMutedByLocalUser = isMutedByLocalUser

	if not fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		getPlayerIsLocalMuted2 = nil
	end

	v17.getPlayerIsLocalMuted = getPlayerIsLocalMuted2
	local getVoiceSessionId

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		getVoiceSessionId = v4.getVoiceSessionId
	end

	v17.getVoiceSessionId = getVoiceSessionId
	return createElement2(CardMenuWithVoiceVolume, v17, {
		MenuAnchor = v16 or element
	})
end

return React.memo(CardMenu)
