local TelemetryService = game:GetService("TelemetryService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PeopleService = script:FindFirstAncestor("PeopleService")
local PeopleServiceParent = PeopleService.Parent
local GameInvite = require(PeopleServiceParent.GameInvite)
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
local t1 = {
	ButtonName = {
		SettingsHub = "settingsHub"
	},
	EventName = {
		GameInviteEntryPoint = "inputShareGameEntryPoint",
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
		PerUserVoiceVolumeUnmutedViaSlider = "PerUserVoiceVolumeUnmutedViaSlider",
		GameInviteEntryPointCounter = settings():GetFVariable("LuaShareGameSettingsHubEntryCounter")
	}
}
local t2 = {
	GameInviteEntryPoint = {
		eventConfig = {
			description = "Event to track game invite entry point from people tab.",
			eventName = t1.EventName.GameInviteEntryPoint,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntGameInviteEntryPointThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				6,
				25
			}
		},
		counterConfig = {
			description = "Counter to track game invite entry point clicks from people tab.",
			eventName = t1.EventName.GameInviteEntryPointCounter,
			backends = { "RobloxTelemetryCounter" },
			throttlingPercentage = GetFIntGameInviteEntryPointThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				6,
				25
			}
		}
	},
	InspectButton = {
		eventConfig = {
			description = "Event to track inspect button click from people tab.",
			eventName = t1.EventName.InspectButton,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntInspectButtonThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				14
			}
		}
	},
	MuteAll = {
		eventConfig = {
			description = "Event to track mute all button click.",
			eventName = t1.EventName.MuteAll,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMuteAllThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				6,
				26
			}
		}
	},
	UnmuteAll = {
		eventConfig = {
			description = "Event to track unmute all button click.",
			eventName = t1.EventName.UnmuteAll,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmuteAllThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				6,
				26
			}
		}
	},
	MutePlayer = {
		eventConfig = {
			description = "Event to track individual player mute button click.",
			eventName = t1.EventName.MutePlayer,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMutePlayerThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				9
			}
		}
	},
	UnmutePlayer = {
		eventConfig = {
			description = "Event to track individual player unmute button click.",
			eventName = t1.EventName.UnmutePlayer,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmutePlayerThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				9
			}
		}
	},
	MuteSelf = {
		eventConfig = {
			description = "Event to track mute self button click.",
			eventName = t1.EventName.MuteSelf,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntMuteSelfThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				23
			}
		}
	},
	UnmuteSelf = {
		eventConfig = {
			description = "Event to track unmute self button click.",
			eventName = t1.EventName.UnmuteSelf,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnmuteSelfThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				23
			}
		}
	},
	RequestFriendship = {
		eventConfig = {
			description = "Event to track players menu actions.",
			eventName = if not GetFFlagAddPeoplePageCardLayout() then t1.EventName.PlayersMenu else t1.EventName.RequestFriendship,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntRequestFriendshipThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				9
			}
		},
		counterConfig = {
			description = "Counter to track players menu actions.",
			eventName = t1.EventName.PlayersMenu,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2025,
				7,
				9
			}
		}
	},
	BlockUserButtonClick = {
		eventConfig = {
			description = "Event to track block user button clicks from people tab.",
			eventName = t1.EventName.BlockUserButtonClick,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntBlockUserButtonClickThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				22
			}
		}
	},
	BlockUser = {
		eventConfig = {
			description = "Event to track successful user blocking from people tab.",
			eventName = t1.EventName.BlockUser,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntBlockUserThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				22
			}
		}
	},
	UnblockUser = {
		eventConfig = {
			description = "Event to track user unblocking from people tab.",
			eventName = t1.EventName.UnblockUser,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntUnblockUserThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				7,
				22
			}
		}
	},
	PeoplePageLayoutChanged = {
		eventConfig = {
			description = "Event to track people page layout change.",
			eventName = t1.EventName.PeoplePageLayoutChanged,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntPeoplePageLayoutChangedThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				9,
				2
			}
		}
	},
	PersonCardMenuToggled = {
		eventConfig = {
			description = "Event to track person card menu toggle.",
			eventName = t1.EventName.PersonCardMenuToggled,
			backends = { "EventIngest" },
			throttlingPercentage = GetFIntPersonCardMenuToggledThrottleHundredthsPercent(),
			lastUpdated = {
				2025,
				9,
				2
			}
		}
	},
	PerUserVoiceVolumeChanged = {
		eventConfig = {
			description = "Per-user voice volume slider drag on People List / People Cards.",
			links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/per_user_voice_volume_changed.proto",
			eventName = t1.EventName.PerUserVoiceVolumeChanged,
			backends = { "EventIngest" },
			throttlingPercentage = FIntPerUserVoiceVolumeChangedThrottleHundredthsPercent,
			lastUpdated = {
				2026,
				7,
				27
			}
		}
	},
	PerUserVoiceVolumeSession = {
		eventConfig = {
			description = "Session info for per-user voice volume UI open/change on People List / People Cards.",
			links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/per_user_voice_volume_session.proto",
			eventName = t1.EventName.PerUserVoiceVolumeSession,
			backends = { "EventIngest" },
			throttlingPercentage = FIntPerUserVoiceVolumeSessionThrottleHundredthsPercent,
			lastUpdated = {
				2026,
				7,
				27
			}
		}
	},
	PerUserVoiceVolumeSliderTouch = {
		counterConfig = {
			description = "Counter for per-user voice volume slider drag starts.",
			eventName = t1.EventName.PerUserVoiceVolumeSliderTouch,
			backends = { "RobloxTelemetryCounter" },
			throttlingPercentage = FIntPerUserVoiceVolumeSliderTouchThrottleHundredthsPercent,
			lastUpdated = {
				2026,
				7,
				27
			}
		}
	},
	PerUserVoiceVolumeMutedViaSlider = {
		counterConfig = {
			description = "Counter for muting a player by dragging per-user volume to MIN.",
			eventName = t1.EventName.PerUserVoiceVolumeMutedViaSlider,
			backends = { "RobloxTelemetryCounter" },
			throttlingPercentage = FIntPerUserVoiceVolumeMutedViaSliderThrottleHundredthsPercent,
			lastUpdated = {
				2026,
				7,
				27
			}
		}
	},
	PerUserVoiceVolumeUnmutedViaSlider = {
		counterConfig = {
			description = "Counter for unmuting a player by raising per-user volume above MIN.",
			eventName = t1.EventName.PerUserVoiceVolumeUnmutedViaSlider,
			backends = { "RobloxTelemetryCounter" },
			throttlingPercentage = FIntPerUserVoiceVolumeUnmutedViaSliderThrottleHundredthsPercent,
			lastUpdated = {
				2026,
				7,
				27
			}
		}
	}
}

t1.TelemetryConfigs = t2

local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

function t1.trackGameInviteEntryPoint(_) -- line: 286
	-- upvalues: t1 (copy), t2 (copy), TelemetryService (copy), GameInviteAnalyticsManager (copy)
	local t3 = {
		btn = t1.ButtonName.SettingsHub,
		placeId = tostring(game.PlaceId),
		gameId = tostring(game.GameId)
	}
	local GameInviteEntryPoint = t2.GameInviteEntryPoint

	TelemetryService:LogEvent(GameInviteEntryPoint.eventConfig, {
		customFields = t3
	})
	TelemetryService:LogCounter(GameInviteEntryPoint.counterConfig, {}, 1)
	GameInviteAnalyticsManager:withButtonName(t1.ButtonName.SettingsHub)
end
function t1.trackToggleMuteSelf(_: {[any]: any}, b1: boolean) -- line: 300
	-- upvalues: TelemetryService (copy), t2 (copy)
	if b1 then
		TelemetryService:LogEvent(t2.UnmuteSelf.eventConfig, {})

		return
	end

	TelemetryService:LogEvent(t2.MuteSelf.eventConfig, {})
end
function t1.trackInspectButton(_: {[any]: any}, n1: number?, s1: string?, s2: string?) -- line: 308
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), t2 (copy), TelemetryService (copy)
	local t6 = {
		playsessionid = s1,
		universeid = tostring(n1)
	}

	if GetFFlagAddPeoplePageCardLayout() then
		t6.entrypoint = s2
	end

	local InspectButton = t2.InspectButton

	TelemetryService:LogEvent(InspectButton.eventConfig, {
		eventContext = if not GetFFlagAddPeoplePageCardLayout() then nil else "examine_avatar",
		customFields = t6
	})
end
function t1.trackToggleMuteAll(_: {[any]: any}, b2: boolean) -- line: 324
	-- upvalues: TelemetryService (copy), t2 (copy)
	if b2 then
		TelemetryService:LogEvent(t2.UnmuteAll.eventConfig, {})

		return
	end

	TelemetryService:LogEvent(t2.MuteAll.eventConfig, {})
end
function t1.trackToggleMutePlayer(_: {[any]: any}, n2: number, b3: boolean, s3: string?) -- line: 332
	-- upvalues: TelemetryService (copy), t2 (copy), GetFFlagAddPeoplePageCardLayout (copy)
	if b3 then
		TelemetryService:LogEvent(t2.UnmutePlayer.eventConfig, {
			customFields = {
				mutedUserId = n2,
				entryPoint = if not GetFFlagAddPeoplePageCardLayout() then nil else s3
			}
		})

		return
	end

	TelemetryService:LogEvent(t2.MutePlayer.eventConfig, {
		customFields = {
			mutedUserId = n2,
			entryPoint = if not GetFFlagAddPeoplePageCardLayout() then nil else s3
		}
	})
end
function t1.trackRequestFriendship(_: {[any]: any}, s4: string?) -- line: 350
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), t2 (copy), TelemetryService (copy)
	local t10 = {
		selectedItem = "RequestFriendship",
		category = "Game",
		entryPoint = if not GetFFlagAddPeoplePageCardLayout() then nil else s4
	}
	local RequestFriendship = t2.RequestFriendship

	TelemetryService:LogEvent(RequestFriendship.eventConfig, {
		eventContext = if not GetFFlagAddPeoplePageCardLayout() then nil else "PlayersMenu",
		customFields = t10
	})
	TelemetryService:LogCounter(RequestFriendship.counterConfig, {
		customFields = {
			selectedItem = "RequestFriendship"
		}
	}, 1)
end
function t1.trackBlockUserButtonClick(_: {[any]: any}, n3: number, n4: number, s5: string?) -- line: 365
	-- upvalues: t2 (copy), TelemetryService (copy)
	local t12 = {
		blockeeUserId = n3,
		blockerUserId = n4,
		source = s5
	}
	local BlockUserButtonClick = t2.BlockUserButtonClick

	TelemetryService:LogEvent(BlockUserButtonClick.eventConfig, {
		customFields = t12
	})
end
function t1.trackBlockUser(_: {[any]: any}, n5: number, n6: number, s6: string?) -- line: 376
	-- upvalues: t2 (copy), TelemetryService (copy)
	local t14 = {
		blockeeUserId = n5,
		blockerUserId = n6,
		source = s6
	}
	local BlockUser = t2.BlockUser

	TelemetryService:LogEvent(BlockUser.eventConfig, {
		customFields = t14
	})
end
function t1.trackUnblockUser(_: {[any]: any}, n7: number, n8: number, s7: string?) -- line: 387
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), t2 (copy), TelemetryService (copy)
	local t16 = {
		blockeeUserId = n7,
		blockerUserId = n8,
		entryPoint = if not GetFFlagAddPeoplePageCardLayout() then nil else s7
	}
	local UnblockUser = t2.UnblockUser

	TelemetryService:LogEvent(UnblockUser.eventConfig, {
		customFields = t16
	})
end

if GetFFlagAddPeoplePageCardLayout() then
	function t1.trackPeoplePageLayoutChanged(_, p3) -- line: 399
		-- upvalues: t2 (copy), TelemetryService (copy)
		local t17 = {
			layout = p3.Name
		}
		local PeoplePageLayoutChanged = t2.PeoplePageLayoutChanged

		TelemetryService:LogEvent(PeoplePageLayoutChanged.eventConfig, {
			customFields = t17,
			standardizedFields = {
				"addPlaceId",
				"addUniverseId",
				"addPlaySessionId",
				"addSessionInfo"
			}
		})
	end
	function t1.trackPersonCardMenuToggled(_: {[any]: any}, b4: boolean) -- line: 411
		-- upvalues: t2 (copy), TelemetryService (copy)
		local t19 = {
			is_toggled_on = tostring(b4)
		}
		local PersonCardMenuToggled = t2.PersonCardMenuToggled

		TelemetryService:LogEvent(PersonCardMenuToggled.eventConfig, {
			customFields = t19,
			standardizedFields = {
				"addPlaceId",
				"addUniverseId",
				"addPlaySessionId",
				"addSessionInfo"
			}
		})
	end
end

local t20 = {
	openedVolumeUiList = false,
	openedVolumeUiCard = false,
	changedPerUserVolume = false,
	reported = false
}

local function getPerUserVoiceVolumeUxVariant() -- line: 442
	-- upvalues: FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), UX_VARIANT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy)
	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		return UX_VARIANT.DISABLE_WHEN_MUTED
	end

	if FFlagVoiceChatVolumePerUserMuteVolumeSync then
		return UX_VARIANT.SYNC
	end

	return UX_VARIANT.INDEPENDENT
end
local function resetPerUserVoiceVolumeSessionState() -- line: 452
	-- upvalues: t20 (copy)
	t20.openedVolumeUiList = false
	t20.openedVolumeUiCard = false
	t20.changedPerUserVolume = false
	t20.reported = false
end

function t1.getPerUserVoiceVolumeUxVariant() -- line: 459
	-- upvalues: FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), UX_VARIANT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy)
	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		return UX_VARIANT.DISABLE_WHEN_MUTED
	end

	if FFlagVoiceChatVolumePerUserMuteVolumeSync then
		return UX_VARIANT.SYNC
	end

	return UX_VARIANT.INDEPENDENT
end
function t1.recordPerUserVoiceVolumeUiOpened(_: {[any]: any}, s8: string) -- line: 463
	-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), ENTRY_POINT (copy), t20 (copy)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	if s8 == ENTRY_POINT.PEOPLE_LIST then
		t20.openedVolumeUiList = true

		return
	end

	if s8 == ENTRY_POINT.PEOPLE_CARD then
		t20.openedVolumeUiCard = true
	end
end
function t1.trackPerUserVoiceVolumeSliderTouch(_: {[any]: any}, s9: string) -- line: 475
	-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), UX_VARIANT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), TelemetryService (copy), t2 (copy)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	local v93 = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then if not FFlagVoiceChatVolumePerUserMuteVolumeSync then UX_VARIANT.INDEPENDENT else UX_VARIANT.SYNC else UX_VARIANT.DISABLE_WHEN_MUTED

	TelemetryService:LogCounter(t2.PerUserVoiceVolumeSliderTouch.counterConfig, {
		customFields = {
			entryPoint = s9,
			uxVariant = v93
		}
	}, 1)
end
function t1.trackPerUserVoiceVolumeChanged(_: {[any]: any}, t24: {[any]: any}) -- line: 490
	-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), UX_VARIANT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), VOICE_VOLUME (copy), UserGameSettings (copy), TelemetryService (copy), t2 (copy), t20 (copy)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	if t24.newVolume == t24.oldVolume then
		return
	end

	local v96 = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then if not FFlagVoiceChatVolumePerUserMuteVolumeSync then UX_VARIANT.INDEPENDENT else UX_VARIANT.SYNC else UX_VARIANT.DISABLE_WHEN_MUTED
	local wasMutedAtStart = t24.wasMutedAtStart
	local v98 = if v96 ~= UX_VARIANT.SYNC then nil else wasMutedAtStart == false and t24.newVolume == VOICE_VOLUME.MIN
	local v99 = if v96 ~= UX_VARIANT.SYNC then nil else wasMutedAtStart == true and t24.newVolume > VOICE_VOLUME.MIN
	local v100 = if v96 ~= UX_VARIANT.DISABLE_WHEN_MUTED then wasMutedAtStart else nil
	local t25 = {
		playSessionId = t24.playSessionId,
		voiceSessionId = t24.voiceSessionId,
		entryPoint = t24.entryPoint,
		targetUserId = t24.targetUserId,
		oldVolume = t24.oldVolume,
		newVolume = t24.newVolume,
		wasMutedAtStart = v100,
		mutedViaSlider = v98,
		unmutedViaSlider = v99,
		uxVariant = v96,
		masterVolume = UserGameSettings.MasterVolume,
		voiceChatVolume = UserGameSettings.VoiceChatVolume,
		dragDurationMs = t24.dragDurationMs
	}

	TelemetryService:LogEvent(t2.PerUserVoiceVolumeChanged.eventConfig, {
		customFields = t25,
		standardizedFields = {
			"addPlaceId",
			"addUniverseId"
		}
	})
	t20.changedPerUserVolume = true

	if v98 then
		TelemetryService:LogCounter(t2.PerUserVoiceVolumeMutedViaSlider.counterConfig, {
			customFields = {
				entryPoint = t24.entryPoint,
				uxVariant = v96
			}
		}, 1)
	end

	if v99 then
		TelemetryService:LogCounter(t2.PerUserVoiceVolumeUnmutedViaSlider.counterConfig, {
			customFields = {
				entryPoint = t24.entryPoint,
				uxVariant = v96
			}
		}, 1)
	end
end
function t1.flushPerUserVoiceVolumeSession(_: {[any]: any}, s10: string?, s11: string?) -- line: 552
	-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), t20 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), UX_VARIANT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), TelemetryService (copy), t2 (copy)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	if t20.reported then
		return
	end

	t20.reported = true

	local v105 = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else t20.openedVolumeUiList
	local v106 = if not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else t20.openedVolumeUiCard
	local v107 = v105 == true or v106 == true
	local v108 = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then if not FFlagVoiceChatVolumePerUserMuteVolumeSync then UX_VARIANT.INDEPENDENT else UX_VARIANT.SYNC else UX_VARIANT.DISABLE_WHEN_MUTED

	TelemetryService:LogEvent(t2.PerUserVoiceVolumeSession.eventConfig, {
		customFields = {
			playSessionId = s10,
			voiceSessionId = s11,
			openedVolumeUi = v107,
			openedVolumeUiList = v105,
			openedVolumeUiCard = v106,
			changedPerUserVolume = t20.changedPerUserVolume,
			uxVariant = v108
		},
		standardizedFields = {
			"addPlaceId",
			"addUniverseId"
		}
	})
	t20.openedVolumeUiList = false
	t20.openedVolumeUiCard = false
	t20.changedPerUserVolume = false
end
function t1.resetPerUserVoiceVolumeSession(_) -- line: 590
	-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), t20 (copy)
	if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		return
	end

	t20.openedVolumeUiList = false
	t20.openedVolumeUiCard = false
	t20.changedPerUserVolume = false
	t20.reported = false
end

return t1
