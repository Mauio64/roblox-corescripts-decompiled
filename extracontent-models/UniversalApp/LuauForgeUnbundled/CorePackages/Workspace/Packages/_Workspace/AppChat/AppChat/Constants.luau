local v5 = {
	Color = {
		GRAY3 = Color3.fromRGB(184, 184, 184),
		WHITE = Color3.fromRGB(255, 255, 255),
		BLUE_PRIMARY = Color3.fromRGB(0, 162, 255)
	},
	Font = { FONT_SIZE_14 = 17 },
	PresenceIndicatorSize = {
		Size6x6 = "Size6x6",
		Size8x8 = "Size8x8",
		Size10x10 = "Size10x10",
		Size12x12 = "Size12x12",
		Size14x14 = "Size14x14",
		DEFAULT = "DEFAULT"
	},
	ServerState = { NONE = "NONE", CREATING = "CREATING", CREATED = "CREATED" },
	ConversationLoadingState = { NONE = "NONE", LOADING = "LOADING", DONE = "DONE" },
	PresenceIndicatorImagesBySize = {
		Size6x6 = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online-6x6.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame-6x6.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio-6x6.png"
		},
		Size8x8 = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online-8x8.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame-8x8.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio-8x8.png"
		},
		Size10x10 = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online-10x10.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame-10x10.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio-10x10.png"
		},
		Size12x12 = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online-12x12.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame-12x12.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio-12x12.png"
		},
		Size14x14 = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online-14x14.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame-14x14.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio-14x14.png"
		},
		DEFAULT = {
			NONE = nil,
			ONLINE = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-online.png",
			IN_GAME = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-ingame.png",
			IN_STUDIO = "rbxasset://textures/ui/LuaChat/graphic/gr-indicator-instudio.png"
		}
	},
	MAX_PARTICIPANT_COUNT = 5,
	MIN_PARTICIPANT_COUNT = 1,
	NAV_BAR_WITH_FACEPILE_SIZE = 56,
	PerformanceMeasurement = {
		LUA_CHAT_SEND_MESSAGE = "LuaChatSendMessage",
		LUA_CHAT_RECEIVE_MESSAGE = "LuaChatReceiveMessage"
	},
	GameCard = { THUMBNAIL_WIDTH = 256, THUMBNAIL_HEIGHT = 144, FOOTER_HEIGHT = 64 },
	AssetCard = { WIDTH = 256 },
	NavProps = { WIDE_MODE = "wideMode", TOP_BAR_HEIGHT = "topBarHeight" },
	OptInVariant = {
		OsaContextCard = "OsaContextCard",
		ChatOptInInfoCard = "ChatOptInInfoCard"
	},
	ModalAction = { Accept = "record_has_accepted", Decline = "record_dont_show_again" },
	ModalSequence = { ConversationListOverlay = "conversation_list_overlay" }
}

function v5:GetPresenceIndicatorSizeKey(p3)
	if p3 == 6 then
		return self.PresenceIndicatorSize.Size6x6
	elseif p3 == 8 then
		return self.PresenceIndicatorSize.Size8x8
	elseif p3 == 10 then
		return self.PresenceIndicatorSize.Size10x10
	elseif p3 == 12 then
		return self.PresenceIndicatorSize.Size12x12
	elseif p3 == 14 then
		return self.PresenceIndicatorSize.Size14x14
	end

	return self.PresenceIndicatorSize.DEFAULT
end

function v5:GetIconButtonWidth(p3): number
	if p3 then
		return 44
	end

	return 34
end

return v5
