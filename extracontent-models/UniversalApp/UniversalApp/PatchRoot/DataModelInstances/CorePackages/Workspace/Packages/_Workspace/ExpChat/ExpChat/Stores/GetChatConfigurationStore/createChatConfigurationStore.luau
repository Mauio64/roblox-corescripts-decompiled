local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local tutils = require(ExpChatParent.tutils)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local DefaultSettings = require(ExpChat.installReducer.BubbleChat.DefaultSettings)

local function createChatConfigurationStore() -- line: 111
	-- upvalues: DefaultSettings (copy), ExpChat (copy), createSignal (copy), tutils (copy), createComputed (copy)
	local v9 = table.clone(DefaultSettings)
	local Config = require(ExpChat.Config)
	local t1 = {
		HeightScale = 1,
		WidthScale = 1,
		FontFace = Config.ChatWindowFont,
		TextColor3 = Config.ChatWindowTextColor3,
		TextSize = Config.ChatWindowTextSize,
		TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
		TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
		BackgroundColor3 = Config.ChatWindowBackgroundColor3,
		BackgroundTransparency = Config.ChatWindowBackgroundTransparency,
		SpatialPanelTextSize = Config.ChatWindowSpatialPanelTextSize
	}
	local t2 = {
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
	local t3 = {
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
	local v14, v15 = createSignal(v9, tutils.deepEqual)
	local v16, v17 = createSignal(t1, tutils.deepEqual)
	local v18, v19 = createSignal(t2, tutils.deepEqual)
	local v20, v21 = createSignal(t3, tutils.deepEqual)
	local v22 = createComputed(function(p1) -- line: 157
		-- upvalues: v14 (copy)
		return v14(p1).Enabled or false
	end)

	return {
		getBubbleChatSettings = v14,
		getChatWindowSettings = v16,
		getChatInputBarSettings = v18,
		getChannelTabsSettings = v20,
		setBubbleChatSettings = v15,
		setChatWindowSettings = v17,
		setChatInputBarSettings = v19,
		setChannelTabsSettings = v21,
		mergeBubbleChatSettings = function(t4: {[any]: any}) -- line: 163
			-- upvalues: v15 (copy)
			v15(function(p2) -- line: 164
				-- upvalues: t4 (copy)
				local v37 = table.clone(p2)

				for k, v in pairs(t4) do
					v37[k] = v
				end

				return v37
			end)
		end,
		mergeChatWindowSettings = function(t5: {[any]: any}) -- line: 173
			-- upvalues: v17 (copy)
			v17(function(p3) -- line: 174
				-- upvalues: t5 (copy)
				local v41 = table.clone(p3)

				for k, v in pairs(t5) do
					v41[k] = v
				end

				return v41
			end)
		end,
		mergeChatInputBarSettings = function(t6: {[any]: any}) -- line: 183
			-- upvalues: v19 (copy)
			v19(function(p4) -- line: 184
				-- upvalues: t6 (copy)
				local v45 = table.clone(p4)

				for k, v in pairs(t6) do
					v45[k] = v
				end

				return v45
			end)
		end,
		mergeChannelTabsSettings = function(t7: {[any]: any}) -- line: 193
			-- upvalues: v21 (copy)
			v21(function(p5) -- line: 194
				-- upvalues: t7 (copy)
				local v49 = table.clone(p5)

				for k, v in pairs(t7) do
					v49[k] = v
				end

				return v49
			end)
		end,
		setBubbleChatProperty = function(s1: string, p6) -- line: 203
			-- upvalues: v15 (copy)
			v15(function(p7) -- line: 204
				-- upvalues: s1 (copy), p6 (copy)
				local v53 = table.clone(p7)

				v53[s1] = p6

				return v53
			end)
		end,
		setChatWindowProperty = function(s2: string, p8) -- line: 211
			-- upvalues: v17 (copy)
			v17(function(p9) -- line: 212
				-- upvalues: s2 (copy), p8 (copy)
				local v55 = table.clone(p9)

				v55[s2] = p8

				return v55
			end)
		end,
		setChatInputBarProperty = function(s3: string, p10) -- line: 219
			-- upvalues: v19 (copy)
			v19(function(p11) -- line: 220
				-- upvalues: s3 (copy), p10 (copy)
				local v57 = table.clone(p11)

				v57[s3] = p10

				return v57
			end)
		end,
		setChannelTabsProperty = function(s4: string, p12) -- line: 227
			-- upvalues: v21 (copy)
			v21(function(p13) -- line: 228
				-- upvalues: s4 (copy), p12 (copy)
				local v59 = table.clone(p13)

				v59[s4] = p12

				return v59
			end)
		end,
		getIsBubbleChatEnabled = v22
	}
end

return createChatConfigurationStore
