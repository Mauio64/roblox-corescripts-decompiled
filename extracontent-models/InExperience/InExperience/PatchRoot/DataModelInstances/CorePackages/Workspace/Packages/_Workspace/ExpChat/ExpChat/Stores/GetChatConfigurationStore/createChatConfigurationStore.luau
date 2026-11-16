local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local tutils = require(parent.tutils)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local DefaultSettings = require(ExpChat.installReducer.BubbleChat.DefaultSettings)

local function createChatConfigurationStore()
	local clone = table.clone(DefaultSettings)

	local Config = require(ExpChat.Config)
	local v = {
		FontFace = Config.ChatWindowFont,
		TextColor3 = Config.ChatWindowTextColor3,
		TextSize = Config.ChatWindowTextSize,
		TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
		TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
		BackgroundColor3 = Config.ChatWindowBackgroundColor3,
		BackgroundTransparency = Config.ChatWindowBackgroundTransparency,
		HeightScale = 1,
		WidthScale = 1,
		SpatialPanelTextSize = Config.ChatWindowSpatialPanelTextSize
	}

	local v2 = {
		BackgroundTransparency = Config.ChatInputBarBackgroundTransparency,
		BackgroundColor3 = Config.ChatInputBarBackgroundColor,
		TextSize = Config.ChatInputBarTextSize,
		TextColor3 = Config.ChatInputBarTextColor3,
		SpatialPanelTextSize = Config.ChatInputBarSpatialPanelTextSize,
		TextStrokeColor3 = Config.ChatInputBarTextStrokeColor,
		TextStrokeTransparency = Config.ChatInputBarTextStrokeTransparency,
		FontFace = Config.ChatInputBarFontFace,
		PlaceholderColor3 = Config.ChatInputBarPlaceholderColor,
		KeyboardKeyCode = Config.ChatInputBarDefaultFocusKeyCode,
		AutocompleteEnabled = Config.ChatInputBarDefaultAutocompleteEnabled
	}

	local v3 = {
		BackgroundTransparency = Config.ChannelTabsSettings.BackgroundTransparency,
		BackgroundColor3 = Config.ChannelTabsSettings.BackgroundColor3,
		HoverBackgroundColor3 = Config.ChannelTabsSettings.HoverBackgroundColor3,
		FontFace = Config.ChannelTabsSettings.FontFace,
		TextSize = Config.ChannelTabsSettings.TextSize,
		TextColor3 = Config.ChannelTabsSettings.TextColor3,
		SelectedTabTextColor3 = Config.ChannelTabsSettings.SelectedTabTextColor3,
		TextStrokeColor3 = Config.ChannelTabsSettings.TextStrokeColor3,
		TextStrokeTransparency = Config.ChannelTabsSettings.TextStrokeTransparency
	}

	local signal, setBubbleChatSettings = createSignal(clone, tutils.deepEqual)
	local signal2, setChatWindowSettings = createSignal(v, tutils.deepEqual)
	local signal3, setChatInputBarSettings = createSignal(v2, tutils.deepEqual)
	local signal4, setChannelTabsSettings = createSignal(v3, tutils.deepEqual)

	return {
		getBubbleChatSettings = signal,
		getChatWindowSettings = signal2,
		getChatInputBarSettings = signal3,
		getChannelTabsSettings = signal4,
		setBubbleChatSettings = setBubbleChatSettings,
		setChatWindowSettings = setChatWindowSettings,
		setChatInputBarSettings = setChatInputBarSettings,
		setChannelTabsSettings = setChannelTabsSettings,
		mergeBubbleChatSettings = function(items)
			setBubbleChatSettings(function(p)
				local clone2 = table.clone(p)

				for k, item in pairs(items) do
					clone2[k] = item
				end

				return clone2
			end)
		end,
		mergeChatWindowSettings = function(items)
			setChatWindowSettings(function(p)
				local clone2 = table.clone(p)

				for k, item in pairs(items) do
					clone2[k] = item
				end

				return clone2
			end)
		end,
		mergeChatInputBarSettings = function(items)
			setChatInputBarSettings(function(p)
				local clone2 = table.clone(p)

				for k, item in pairs(items) do
					clone2[k] = item
				end

				return clone2
			end)
		end,
		mergeChannelTabsSettings = function(items)
			setChannelTabsSettings(function(p)
				local clone2 = table.clone(p)

				for k, item in pairs(items) do
					clone2[k] = item
				end

				return clone2
			end)
		end,
		setBubbleChatProperty = function(p: string, p2)
			setBubbleChatSettings(function(p3)
				local clone2 = table.clone(p3)
				clone2[p] = p2
				return clone2
			end)
		end,
		setChatWindowProperty = function(p: string, p2)
			setChatWindowSettings(function(p3)
				local clone2 = table.clone(p3)
				clone2[p] = p2
				return clone2
			end)
		end,
		setChatInputBarProperty = function(p: string, p2)
			setChatInputBarSettings(function(p3)
				local clone2 = table.clone(p3)
				clone2[p] = p2
				return clone2
			end)
		end,
		setChannelTabsProperty = function(p: string, p2)
			setChannelTabsSettings(function(p3)
				local clone2 = table.clone(p3)
				clone2[p] = p2
				return clone2
			end)
		end,
		getIsBubbleChatEnabled = createComputed(function(p)
			return signal(p).Enabled or false
		end)
	}
end

return createChatConfigurationStore
