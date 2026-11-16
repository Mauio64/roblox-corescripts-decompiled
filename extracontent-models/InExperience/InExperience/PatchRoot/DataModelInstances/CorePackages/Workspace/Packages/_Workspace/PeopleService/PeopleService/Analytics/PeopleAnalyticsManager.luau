local TelemetryService = game:GetService("TelemetryService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local PeopleService = script:FindFirstAncestor("PeopleService")
local parent = PeopleService.Parent

local GameInvite = require(parent.GameInvite)

local Flags = require(PeopleService.Flags)
local Constants = require(PeopleService.Constants)

local GetFIntInspectButtonThrottleHundredthsPercent = Flags.GetFIntInspectButtonThrottleHundredthsPercent

local GetFIntGameInviteEntryPointThrottleHundredthsPercent = Flags.GetFIntGameInviteEntryPointThrottleHundredthsPercent
local GetFIntMuteAllThrottleHundredthsPercent = Flags.GetFIntMuteAllThrottleHundredthsPercent
local GetFIntUnmuteAllThrottleHundredthsPercent = Flags.GetFIntUnmuteAllThrottleHundredthsPercent
local GetFIntMutePlayerThrottleHundredthsPercent = Flags.GetFIntMutePlayerThrottleHundredthsPercent
local GetFIntUnmutePlayerThrottleHundredthsPercent = Flags.GetFIntUnmutePlayerThrottleHundredthsPercent
local GetFIntRequestFriendshipThrottleHundredthsPercent = Flags.GetFIntRequestFriendshipThrottleHundredthsPercent
local GetFIntMuteSelfThrottleHundredthsPercent = Flags.GetFIntMuteSelfThrottleHundredthsPercent
local GetFIntUnmuteSelfThrottleHundredthsPercent = Flags.GetFIntUnmuteSelfThrottleHundredthsPercent
local GetFIntBlockUserButtonClickThrottleHundredthsPercent = Flags.GetFIntBlockUserButtonClickThrottleHundredthsPercent
local GetFIntBlockUserThrottleHundredthsPercent = Flags.GetFIntBlockUserThrottleHundredthsPercent
local GetFIntUnblockUserThrottleHundredthsPercent = Flags.GetFIntUnblockUserThrottleHundredthsPercent

local GetFIntPeoplePageLayoutChangedThrottleHundredthsPercent = Flags.GetFIntPeoplePageLayoutChangedThrottleHundredthsPercent

local GetFIntPersonCardMenuToggledThrottleHundredthsPercent = Flags.GetFIntPersonCardMenuToggledThrottleHundredthsPercent
local GetFFlagAddPeoplePageCardLayout = Flags.GetFFlagAddPeoplePageCardLayout

local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = Flags.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local FFlagVoiceVolumeControlsPerUserPlayerListButton = Flags.FFlagVoiceVolumeControlsPerUserPlayerListButton
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = Flags.FFlagVoiceVolumeControlsPerUserPlayerGridMenu

local FIntPerUserVoiceVolumeChangedThrottleHundredthsPercent = Flags.FIntPerUserVoiceVolumeChangedThrottleHundredthsPercent

local FIntPerUserVoiceVolumeSessionThrottleHundredthsPercent = Flags.FIntPerUserVoiceVolumeSessionThrottleHundredthsPercent

local FIntPerUserVoiceVolumeSliderTouchThrottleHundredthsPercent = Flags.FIntPerUserVoiceVolumeSliderTouchThrottleHundredthsPercent

local FIntPerUserVoiceVolumeMutedViaSliderThrottleHundredthsPercent = Flags.FIntPerUserVoiceVolumeMutedViaSliderThrottleHundredthsPercent

local FIntPerUserVoiceVolumeUnmutedViaSliderThrottleHundredthsPercent = Flags.FIntPerUserVoiceVolumeUnmutedViaSliderThrottleHundredthsPercent
local FFlagVoiceChatVolumePerUserMuteVolumeSync = Flags.FFlagVoiceChatVolumePerUserMuteVolumeSync

local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted

local VOICE_VOLUME = Constants.VOICE_CHAT.VOICE_VOLUME
local ENTRY_POINT = Constants.ANALYTICS.ENTRY_POINT
local UX_VARIANT = Constants.ANALYTICS.UX_VARIANT

local PeopleAnalyticsManager = {}

PeopleAnalyticsManager.ButtonName = { SettingsHub = "settingsHub" }

PeopleAnalyticsManager.EventName = {
	GameInviteEntryPoint = "inputShareGameEntryPoint",
	GameInviteEntryPointCounter = settings():GetFVariable("LuaShareGameSettingsHubEntryCounter"),
	InspectButton = "ingame_menu_action",
	MuteAll = "mute_all",
	UnmuteAll = "unmute_all",
	MutePlayer = "mute_player",
	UnmutePlayer = "unmute_player",
	MuteSelf = "mute_self",
	UnmuteSelf = "unmute_self",
	PlayersMenu = "PlayersMenu",
	RequestFriendship = "RequestFriendship",
	BlockUserButtonClick = "blockUserButtonClick",
	BlockUser = "blockUser",
	UnblockUser = "unblockUser",
	PeoplePageLayoutChanged = "people_page_layout_changed",
	PersonCardMenuToggled = "person_card_menu_toggled",
	PerUserVoiceVolumeChanged = "PerUserVoiceVolumeChanged",
	PerUserVoiceVolumeSession = "PerUserVoiceVolumeSession",
	PerUserVoiceVolumeSliderTouch = "PerUserVoiceVolumeSliderTouch",
	PerUserVoiceVolumeMutedViaSlider = "PerUserVoiceVolumeMutedViaSlider",
	PerUserVoiceVolumeUnmutedViaSlider = "PerUserVoiceVolumeUnmutedViaSlider"
}

local telemetryConfigs = {
	GameInviteEntryPoint = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.GameInviteEntryPoint,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntGameInviteEntryPointThrottleHundredthsPercent(),
			lastUpdated = { 2025, 6, 25 },
			description = "Event to track game invite entry point from people tab."
		},
		counterConfig = {
			eventName = PeopleAnalyticsManager.EventName.GameInviteEntryPointCounter,
			backends = { "RobloxTelemetryCounter" },
			throttlingPercentage = GetFIntGameInviteEntryPointThrottleHundredthsPercent(),
			lastUpdated = { 2025, 6, 25 },
			description = "Counter to track game invite entry point clicks from people tab."
		}
	},
	InspectButton = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.InspectButton,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntInspectButtonThrottleHundredthsPercent(),
			lastUpdated = { 2025, 7, 14 },
			description = "Event to track inspect button click from people tab."
		}
	},
	MuteAll = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.MuteAll,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMuteAllThrottleHundredthsPercent(),
			lastUpdated = { 2025, 6, 26 },
			description = "Event to track mute all button click."
		}
	},
	UnmuteAll = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.UnmuteAll,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmuteAllThrottleHundredthsPercent(),
			lastUpdated = { 2025, 6, 26 },
			description = "Event to track unmute all button click."
		}
	},
	MutePlayer = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.MutePlayer,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMutePlayerThrottleHundredthsPercent(),
			lastUpdated = { 2025, 7, 9 },
			description = "Event to track individual player mute button click."
		}
	},
	UnmutePlayer = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.UnmutePlayer,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmutePlayerThrottleHundredthsPercent(),
			lastUpdated = { 2025, 7, 9 },
			description = "Event to track individual player unmute button click."
		}
	},
	MuteSelf = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.MuteSelf,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMuteSelfThrottleHundredthsPercent(),
			lastUpdated = { 2025, 7, 23 },
			description = "Event to track mute self button click."
		}
	},
	UnmuteSelf = {
		eventConfig = {
			eventName = PeopleAnalyticsManager.EventName.UnmuteSelf,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmuteSelfThrottleHundredthsPercent(),
			lastUpdated = { 2025, 7, 23 },
			description = "Event to track unmute self button click."
		}
	},
	RequestFriendship = 0,
	BlockUserButtonClick = 0,
	BlockUser = 0,
	UnblockUser = 0,
	PeoplePageLayoutChanged = 0,
	PersonCardMenuToggled = 0,
	PerUserVoiceVolumeChanged = 0,
	PerUserVoiceVolumeSession = 0,
	PerUserVoiceVolumeSliderTouch = 0,
	PerUserVoiceVolumeMutedViaSlider = 0,
	PerUserVoiceVolumeUnmutedViaSlider = 0
}
local eventName

if GetFFlagAddPeoplePageCardLayout() then
	eventName = PeopleAnalyticsManager.EventName.RequestFriendship
else
	eventName = PeopleAnalyticsManager.EventName.PlayersMenu
end

telemetryConfigs.RequestFriendship = {
	eventConfig = {
		eventName = eventName,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntRequestFriendshipThrottleHundredthsPercent(),
		lastUpdated = { 2025, 7, 9 },
		description = "Event to track players menu actions."
	},
	counterConfig = {
		eventName = PeopleAnalyticsManager.EventName.PlayersMenu,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2025, 7, 9 },
		description = "Counter to track players menu actions."
	}
}

telemetryConfigs.BlockUserButtonClick = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.BlockUserButtonClick,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntBlockUserButtonClickThrottleHundredthsPercent(),
		lastUpdated = { 2025, 7, 22 },
		description = "Event to track block user button clicks from people tab."
	}
}

telemetryConfigs.BlockUser = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.BlockUser,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntBlockUserThrottleHundredthsPercent(),
		lastUpdated = { 2025, 7, 22 },
		description = "Event to track successful user blocking from people tab."
	}
}

telemetryConfigs.UnblockUser = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.UnblockUser,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntUnblockUserThrottleHundredthsPercent(),
		lastUpdated = { 2025, 7, 22 },
		description = "Event to track user unblocking from people tab."
	}
}

telemetryConfigs.PeoplePageLayoutChanged = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.PeoplePageLayoutChanged,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntPeoplePageLayoutChangedThrottleHundredthsPercent(),
		lastUpdated = { 2025, 9, 2 },
		description = "Event to track people page layout change."
	}
}

telemetryConfigs.PersonCardMenuToggled = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.PersonCardMenuToggled,
		backends = { "EventIngest" },
		throttlingPercentage = GetFIntPersonCardMenuToggledThrottleHundredthsPercent(),
		lastUpdated = { 2025, 9, 2 },
		description = "Event to track person card menu toggle."
	}
}

telemetryConfigs.PerUserVoiceVolumeChanged = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.PerUserVoiceVolumeChanged,
		backends = { "EventIngest" },
		throttlingPercentage = FIntPerUserVoiceVolumeChangedThrottleHundredthsPercent,
		lastUpdated = { 2026, 7, 27 },
		description = "Per-user voice volume slider drag on People List / People Cards.",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/per_user_voice_volume_changed.proto"
	}
}

telemetryConfigs.PerUserVoiceVolumeSession = {
	eventConfig = {
		eventName = PeopleAnalyticsManager.EventName.PerUserVoiceVolumeSession,
		backends = { "EventIngest" },
		throttlingPercentage = FIntPerUserVoiceVolumeSessionThrottleHundredthsPercent,
		lastUpdated = { 2026, 7, 27 },
		description = "Session info for per-user voice volume UI open/change on People List / People Cards.",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/per_user_voice_volume_session.proto"
	}
}

telemetryConfigs.PerUserVoiceVolumeSliderTouch = {
	counterConfig = {
		eventName = PeopleAnalyticsManager.EventName.PerUserVoiceVolumeSliderTouch,
		backends = { "RobloxTelemetryCounter" },
		throttlingPercentage = FIntPerUserVoiceVolumeSliderTouchThrottleHundredthsPercent,
		lastUpdated = { 2026, 7, 27 },
		description = "Counter for per-user voice volume slider drag starts."
	}
}

telemetryConfigs.PerUserVoiceVolumeMutedViaSlider = {
	counterConfig = {
		eventName = PeopleAnalyticsManager.EventName.PerUserVoiceVolumeMutedViaSlider,
		backends = { "RobloxTelemetryCounter" },
		throttlingPercentage = FIntPerUserVoiceVolumeMutedViaSliderThrottleHundredthsPercent,
		lastUpdated = { 2026, 7, 27 },
		description = "Counter for muting a player by dragging per-user volume to MIN."
	}
}

telemetryConfigs.PerUserVoiceVolumeUnmutedViaSlider = {
	counterConfig = {
		eventName = PeopleAnalyticsManager.EventName.PerUserVoiceVolumeUnmutedViaSlider,
		backends = { "RobloxTelemetryCounter" },
		throttlingPercentage = FIntPerUserVoiceVolumeUnmutedViaSliderThrottleHundredthsPercent,
		lastUpdated = { 2026, 7, 27 },
		description = "Counter for unmuting a player by raising per-user volume above MIN."
	}
}

PeopleAnalyticsManager.TelemetryConfigs = telemetryConfigs

local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

function PeopleAnalyticsManager.trackGameInviteEntryPoint(_)
	local customFields = {
		btn = PeopleAnalyticsManager.ButtonName.SettingsHub,
		placeId = tostring(game.PlaceId),
		gameId = tostring(game.GameId)
	}

	local gameInviteEntryPoint = telemetryConfigs.GameInviteEntryPoint
	TelemetryService:LogEvent(gameInviteEntryPoint.eventConfig, { customFields = customFields })
	TelemetryService:LogCounter(gameInviteEntryPoint.counterConfig, {}, 1)

	GameInviteAnalyticsManager:withButtonName(PeopleAnalyticsManager.ButtonName.SettingsHub)
end

function PeopleAnalyticsManager.trackToggleMuteSelf(_, flag: boolean)
	if flag then
		TelemetryService:LogEvent(telemetryConfigs.UnmuteSelf.eventConfig, {})
	else
		TelemetryService:LogEvent(telemetryConfigs.MuteSelf.eventConfig, {})
	end
end

function PeopleAnalyticsManager.trackInspectButton(_, p: number?, playsessionid: string?, entrypoint: string?)
	local customFields = {}
	customFields.playsessionid = playsessionid
	customFields.universeid = tostring(p)

	if GetFFlagAddPeoplePageCardLayout() then
		customFields.entrypoint = entrypoint
	end

	TelemetryService:LogEvent(telemetryConfigs.InspectButton.eventConfig, {
		eventContext = GetFFlagAddPeoplePageCardLayout() and "examine_avatar" or nil,
		customFields = customFields
	})
end

function PeopleAnalyticsManager.trackToggleMuteAll(_, flag: boolean)
	if flag then
		TelemetryService:LogEvent(telemetryConfigs.UnmuteAll.eventConfig, {})
	else
		TelemetryService:LogEvent(telemetryConfigs.MuteAll.eventConfig, {})
	end
end

function PeopleAnalyticsManager.trackToggleMutePlayer(_, mutedUserId: number, flag: boolean, entryPoint: string?)
	if flag then
		local eventConfig = telemetryConfigs.UnmutePlayer.eventConfig

		if not GetFFlagAddPeoplePageCardLayout() then
			entryPoint = nil
		end

		TelemetryService:LogEvent(eventConfig, {
			customFields = { mutedUserId = mutedUserId, entryPoint = entryPoint }
		})
	else
		local eventConfig = telemetryConfigs.MutePlayer.eventConfig

		if not GetFFlagAddPeoplePageCardLayout() then
			entryPoint = nil
		end

		TelemetryService:LogEvent(eventConfig, {
			customFields = { mutedUserId = mutedUserId, entryPoint = entryPoint }
		})
	end
end

function PeopleAnalyticsManager.trackRequestFriendship(_, entryPoint: string?)
	if not GetFFlagAddPeoplePageCardLayout() then
		entryPoint = nil
	end

	local requestFriendship = telemetryConfigs.RequestFriendship
	TelemetryService:LogEvent(requestFriendship.eventConfig, {
		eventContext = GetFFlagAddPeoplePageCardLayout() and "PlayersMenu" or nil,
		customFields = {
			selectedItem = "RequestFriendship",
			category = "Game",
			entryPoint = entryPoint
		}
	})

	TelemetryService:LogCounter(requestFriendship.counterConfig, {
		customFields = { selectedItem = "RequestFriendship" }
	}, 1)
end

function PeopleAnalyticsManager.trackBlockUserButtonClick(_, blockeeUserId: number, blockerUserId: number, source: string?)
	TelemetryService:LogEvent(telemetryConfigs.BlockUserButtonClick.eventConfig, {
		customFields = {
			blockeeUserId = blockeeUserId,
			blockerUserId = blockerUserId,
			source = source
		}
	})
end

function PeopleAnalyticsManager.trackBlockUser(_, blockeeUserId: number, blockerUserId: number, source: string?)
	TelemetryService:LogEvent(telemetryConfigs.BlockUser.eventConfig, {
		customFields = {
			blockeeUserId = blockeeUserId,
			blockerUserId = blockerUserId,
			source = source
		}
	})
end

function PeopleAnalyticsManager.trackUnblockUser(_, blockeeUserId: number, blockerUserId: number, entryPoint: string?)
	if not GetFFlagAddPeoplePageCardLayout() then
		entryPoint = nil
	end

	TelemetryService:LogEvent(telemetryConfigs.UnblockUser.eventConfig, {
		customFields = {
			blockeeUserId = blockeeUserId,
			blockerUserId = blockerUserId,
			entryPoint = entryPoint
		}
	})
end

if GetFFlagAddPeoplePageCardLayout() then
	function PeopleAnalyticsManager.trackPeoplePageLayoutChanged(_, p)
		local customFields = { layout = p.Name }

		TelemetryService:LogEvent(telemetryConfigs.PeoplePageLayoutChanged.eventConfig, {
			customFields = customFields,
			standardizedFields = {
				"addPlaceId",
				"addUniverseId",
				"addPlaySessionId",
				"addSessionInfo"
			}
		})
	end

	function PeopleAnalyticsManager.trackPersonCardMenuToggled(_, flag: boolean)
		local customFields = { is_toggled_on = tostring(flag) }

		TelemetryService:LogEvent(telemetryConfigs.PersonCardMenuToggled.eventConfig, {
			customFields = customFields,
			standardizedFields = {
				"addPlaceId",
				"addUniverseId",
				"addPlaySessionId",
				"addSessionInfo"
			}
		})
	end
end

local v = {
	openedVolumeUiList = false,
	openedVolumeUiCard = false,
	changedPerUserVolume = false,
	reported = false
}

local function getPerUserVoiceVolumeUxVariant() -- 4 equivalent calls inferred from this helper
	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		return UX_VARIANT.DISABLE_WHEN_MUTED
	end

	if FFlagVoiceChatVolumePerUserMuteVolumeSync then
		return UX_VARIANT.SYNC
	end

	return UX_VARIANT.INDEPENDENT
end

local function resetPerUserVoiceVolumeSessionState() -- 1 equivalent call inferred from this helper
	v.openedVolumeUiList = false
	v.openedVolumeUiCard = false
	v.changedPerUserVolume = false
	v.reported = false
end

function PeopleAnalyticsManager.getPerUserVoiceVolumeUxVariant()
	return getPerUserVoiceVolumeUxVariant() -- inferred equivalent call
end

function PeopleAnalyticsManager.recordPerUserVoiceVolumeUiOpened(_, p: string)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	if p == ENTRY_POINT.PEOPLE_LIST then
		v.openedVolumeUiList = true
	elseif p == ENTRY_POINT.PEOPLE_CARD then
		v.openedVolumeUiCard = true
	end
end

function PeopleAnalyticsManager.trackPerUserVoiceVolumeSliderTouch(_, entryPoint: string)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	local perUserVoiceVolumeUxVariant = getPerUserVoiceVolumeUxVariant() -- inferred equivalent call
	TelemetryService:LogCounter(telemetryConfigs.PerUserVoiceVolumeSliderTouch.counterConfig, {
		customFields = { entryPoint = entryPoint, uxVariant = perUserVoiceVolumeUxVariant }
	}, 1)
end

function PeopleAnalyticsManager.trackPerUserVoiceVolumeChanged(_, data)
	if not (FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and data.newVolume ~= data.oldVolume) then
		return
	end

	local perUserVoiceVolumeUxVariant = getPerUserVoiceVolumeUxVariant() -- inferred equivalent call
	local wasMutedAtStart = data.wasMutedAtStart
	local mutedViaSlider

	if perUserVoiceVolumeUxVariant == UX_VARIANT.SYNC then
		if wasMutedAtStart == false then
			mutedViaSlider = data.newVolume == VOICE_VOLUME.MIN
		else
			mutedViaSlider = false
		end
	end

	local unmutedViaSlider

	if perUserVoiceVolumeUxVariant == UX_VARIANT.SYNC then
		if wasMutedAtStart == true then
			unmutedViaSlider = data.newVolume > VOICE_VOLUME.MIN
		else
			unmutedViaSlider = false
		end
	end

	if perUserVoiceVolumeUxVariant == UX_VARIANT.DISABLE_WHEN_MUTED then
		wasMutedAtStart = nil
	end

	local customFields = {
		playSessionId = data.playSessionId,
		voiceSessionId = data.voiceSessionId,
		entryPoint = data.entryPoint,
		targetUserId = data.targetUserId,
		oldVolume = data.oldVolume,
		newVolume = data.newVolume,
		wasMutedAtStart = wasMutedAtStart,
		mutedViaSlider = mutedViaSlider,
		unmutedViaSlider = unmutedViaSlider,
		uxVariant = perUserVoiceVolumeUxVariant,
		masterVolume = UserGameSettings.MasterVolume,
		voiceChatVolume = UserGameSettings.VoiceChatVolume,
		dragDurationMs = data.dragDurationMs
	}

	TelemetryService:LogEvent(telemetryConfigs.PerUserVoiceVolumeChanged.eventConfig, {
		customFields = customFields,
		standardizedFields = { "addPlaceId", "addUniverseId" }
	})

	v.changedPerUserVolume = true

	if mutedViaSlider then
		TelemetryService:LogCounter(telemetryConfigs.PerUserVoiceVolumeMutedViaSlider.counterConfig, {
			customFields = { entryPoint = data.entryPoint, uxVariant = perUserVoiceVolumeUxVariant }
		}, 1)
	end

	if unmutedViaSlider then
		TelemetryService:LogCounter(telemetryConfigs.PerUserVoiceVolumeUnmutedViaSlider.counterConfig, {
			customFields = { entryPoint = data.entryPoint, uxVariant = perUserVoiceVolumeUxVariant }
		}, 1)
	end
end

function PeopleAnalyticsManager.flushPerUserVoiceVolumeSession(_, playSessionId: string?, voiceSessionId: string?)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry or v.reported then
		return
	end

	v.reported = true
	local openedVolumeUiList

	if FFlagVoiceVolumeControlsPerUserPlayerListButton then
		openedVolumeUiList = v.openedVolumeUiList
	end

	local openedVolumeUiCard

	if FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		openedVolumeUiCard = v.openedVolumeUiCard
	end

	local openedVolumeUi = openedVolumeUiList == true or openedVolumeUiCard == true
	local perUserVoiceVolumeUxVariant = getPerUserVoiceVolumeUxVariant() -- inferred equivalent call
	TelemetryService:LogEvent(telemetryConfigs.PerUserVoiceVolumeSession.eventConfig, {
		customFields = {
			playSessionId = playSessionId,
			voiceSessionId = voiceSessionId,
			openedVolumeUi = openedVolumeUi,
			openedVolumeUiList = openedVolumeUiList,
			openedVolumeUiCard = openedVolumeUiCard,
			changedPerUserVolume = v.changedPerUserVolume,
			uxVariant = perUserVoiceVolumeUxVariant
		},
		standardizedFields = { "addPlaceId", "addUniverseId" }
	})

	v.openedVolumeUiList = false
	v.openedVolumeUiCard = false
	v.changedPerUserVolume = false
end

function PeopleAnalyticsManager.resetPerUserVoiceVolumeSession(_)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	resetPerUserVoiceVolumeSessionState() -- inferred equivalent call
end

return PeopleAnalyticsManager
