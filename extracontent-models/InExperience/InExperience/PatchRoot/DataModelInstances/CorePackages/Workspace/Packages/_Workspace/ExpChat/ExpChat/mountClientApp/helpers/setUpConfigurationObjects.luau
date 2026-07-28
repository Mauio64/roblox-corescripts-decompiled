local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatShared = require(ExpChat.Parent.ExpChatShared)
local Analytics = ExpChatShared.Analytics
local Config = require(ExpChat.Config)
local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChatInputBarConfigurationEnabled = require(Actions.ChatInputBarConfigurationEnabled)
local ChatWindowConfigurationEnabled = require(Actions.ChatWindowConfigurationEnabled)
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local LocalTextChannelParticipantAdded = require(Actions.LocalTextChannelParticipantAdded)
local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local BubbleChatSettingsChanged = require(Actions.BubbleChatSettingsChanged)
local ChatLayoutVerticalAlignmentChanged = require(Actions.ChatLayoutVerticalAlignmentChanged)
local ChatLayoutHorizontalAlignmentChanged = require(Actions.ChatLayoutHorizontalAlignmentChanged)
local ChatWindowSettingsChanged = require(Actions.ChatWindowSettingsChanged)
local ChatInputBarSettingsChanged = require(Actions.ChatInputBarSettingsChanged)
local ChannelTabsSettingsChanged = require(Actions.ChannelTabsSettingsChanged)
local DevTextBoxEnabledChanged = require(Actions.DevTextBoxEnabledChanged)
local setUpBubbleChatConfigurationChildren = require(script.Parent.setUpBubbleChatConfigurationChildren)
local syncFriendsTabVisibility = require(script.Parent.syncFriendsTabVisibility)
local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local getFFlagExpChatFixChannelTabsMidExperienceToggle = require(ExpChat.Flags.getFFlagExpChatFixChannelTabsMidExperienceToggle)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local ExpChatParent = ExpChat.Parent
local GetFFlagTextChatEnableUniverseChatTabs = require(ExpChatParent.ExpChatShared).Flags.GetFFlagTextChatEnableUniverseChatTabs
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local u39 = nil

local function isKeyboardKeyCodeSanitized(p1) -- line: 52
	-- upvalues: UserInputService (copy)
	local StringForKeyCode = UserInputService:GetStringForKeyCode(p1)

	if StringForKeyCode == nil or (StringForKeyCode == "" or p1 == Enum.KeyCode.None) then
		warn("ChatInputBarConfiguration.KeyboardKeyCode has an unsupported keycode for rendering UI:" .. tostring(p1))

		return false
	end

	return true
end
local function shouldReorderTabs(t1: {[any]: any}, p2) -- line: 65
	-- upvalues: TextChatService (copy), Config (copy)
	if p2 == nil or t1[p2.Name] == nil then
		return false
	end

	local n1 = 0

	for _ in pairs(t1) do
		n1 += 1
	end

	local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")

	if not ChannelTabsConfiguration then
		return false
	end

	local AbsoluteSizeX = ChannelTabsConfiguration.AbsoluteSize.X

	return (not (AbsoluteSizeX < n1 * Config.ChannelTabsSettings.MinTabWidth) and n1 or math.floor((AbsoluteSizeX - Config.ChannelTabsSettings.DropdownIconContainerWidth) / Config.ChannelTabsSettings.MinTabWidth)) < t1[p2.Name].TabIndex
end

return function(p3, p4) -- line: 91
	-- upvalues: Analytics (copy), TextChatService (copy), GetTransparencyStore (copy), ChatInputBarConfigurationEnabled (copy), getFFlagExpChatEnableChannelTabsUI (copy), shouldReorderTabs (copy), TargetTextChannelPropertyChanged (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), DevTextBoxEnabledChanged (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), UserInputService (copy), GuiService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ChatInputBarSettingsChanged (copy), ChatWindowConfigurationEnabled (copy), ChatLayoutHorizontalAlignmentChanged (copy), ChatLayoutVerticalAlignmentChanged (copy), ChatWindowSettingsChanged (copy), BubbleChatSettingsChanged (copy), setUpBubbleChatConfigurationChildren (copy), Players (copy), LocalTextChannelParticipantAdded (copy), FFlagExpChatEnableFriendsTab (copy), u39 (ref), syncFriendsTabVisibility (copy), ChannelTabsConfigurationEnabled (copy), FFlagExpChatUseMessagesStore (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), GetMessagesStore (copy), getFFlagExpChatFixChannelTabsMidExperienceToggle (copy), ChannelTabsSettingsChanged (copy), ConfigurationObjectsLoaded (copy)
	if p4.analytics then
		Analytics.with(p4.analytics)
	end

	local function v52(s1: string, s2: string, p5) -- line: 96
		-- upvalues: Analytics (copy)
		local str

		if type(p5) == "number" or (type(p5) == "boolean" or typeof(p5) == "EnumItem") then
			str = tostring(p5)
		elseif typeof(p5) == "Color3" then
			str = p5:ToHex()
		else
			if typeof(p5) ~= "Font" then
				return
			end

			str = tostring((string.gsub(p5.Family, "rbxasset://fonts/families/", ""))) .. " " .. tostring(p5.Weight) .. " " .. tostring(p5.Style)
		end

		assert(str, "should exist")
		Analytics.FireClientAnalyticsWithEventName(s1, {
			[s2] = str
		})
	end
	local function v53() -- line: 376
		-- upvalues: Players (copy), TextChatService (copy), p3 (copy), LocalTextChannelParticipantAdded (copy)
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		for _, descendant in TextChatService:GetDescendants() do
			if descendant:IsA("TextSource") and descendant.UserId == LocalPlayer.UserId then
				local descendantParent = descendant.Parent

				if descendantParent and descendantParent:IsA("TextChannel") then
					p3:dispatch(LocalTextChannelParticipantAdded(descendantParent))
				end
			end
		end
	end

	local v54 = (function() -- line: 239
		-- upvalues: TextChatService (copy), p3 (copy), ChatWindowConfigurationEnabled (copy), ChatLayoutHorizontalAlignmentChanged (copy), ChatLayoutVerticalAlignmentChanged (copy), v52 (copy), GuiService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ChatWindowSettingsChanged (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
		local t2 = {}

		if ChatWindowConfiguration then
			p3:dispatch(ChatWindowConfigurationEnabled(ChatWindowConfiguration.Enabled))
			ChatWindowConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 245
				-- upvalues: p3 (copy), ChatWindowConfigurationEnabled (copy), ChatWindowConfiguration (copy)
				p3:dispatch(ChatWindowConfigurationEnabled(ChatWindowConfiguration.Enabled))
			end)
			p3:dispatch(ChatLayoutHorizontalAlignmentChanged(ChatWindowConfiguration.HorizontalAlignment))
			ChatWindowConfiguration:GetPropertyChangedSignal("HorizontalAlignment"):Connect(function() -- line: 250
				-- upvalues: p3 (copy), ChatLayoutHorizontalAlignmentChanged (copy), ChatWindowConfiguration (copy)
				p3:dispatch(ChatLayoutHorizontalAlignmentChanged(ChatWindowConfiguration.HorizontalAlignment))
			end)
			p3:dispatch(ChatLayoutVerticalAlignmentChanged(ChatWindowConfiguration.VerticalAlignment))
			ChatWindowConfiguration:GetPropertyChangedSignal("VerticalAlignment"):Connect(function() -- line: 255
				-- upvalues: p3 (copy), ChatLayoutVerticalAlignmentChanged (copy), ChatWindowConfiguration (copy)
				p3:dispatch(ChatLayoutVerticalAlignmentChanged(ChatWindowConfiguration.VerticalAlignment))
			end)

			for _, v in ipairs({
				"BackgroundColor3",
				"BackgroundTransparency",
				"FontFace",
				"TextColor3",
				"TextSize",
				"TextStrokeColor3",
				"TextStrokeTransparency",
				"HeightScale",
				"WidthScale",
				"HorizontalAlignment",
				"VerticalAlignment"
			}) do
				if ChatWindowConfiguration[v] then
					local v76 = ChatWindowConfiguration[v]

					t2[v] = v76
					v52("ChatWindowConfigurationLoaded", v, v76)
				end
			end

			if GuiService:IsTenFootInterface() then
				t2.TextSize = math.floor(0.5 + t2.TextSize * 1.5)
			end

			ChatWindowConfiguration.Changed:Connect(function(property) -- line: 292
				-- upvalues: ChatWindowConfiguration (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), p3 (copy), ChatWindowSettingsChanged (copy), v52 (copy)
				local v105 = ChatWindowConfiguration[property]

				if FFlagExpChatUseChatConfigStore then
					GetChatConfigurationStore(false).setChatWindowProperty(property, v105)
				else
					p3:dispatch(ChatWindowSettingsChanged(property, v105))
				end

				v52("ChatWindowConfigurationChanged", property, v105)
			end)

			return t2
		end

		return {}
	end)()
	local v55 = (function() -- line: 310
		-- upvalues: TextChatService (copy), v52 (copy), GuiService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), p3 (copy), BubbleChatSettingsChanged (copy), setUpBubbleChatConfigurationChildren (copy)
		local BubbleChatConfiguration = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")
		local t3 = {}

		if BubbleChatConfiguration then
			for _, v in ipairs({
				"Enabled",
				"AdorneeName",
				"BubbleDuration",
				"BubblesSpacing",
				"VerticalStudsOffset",
				"LocalPlayerStudsOffset",
				"MinimizeDistance",
				"MaxDistance",
				"BackgroundColor3",
				"TextColor3",
				"TextSize",
				"FontFace",
				"MaxBubbles",
				"TailVisible",
				"BackgroundTransparency"
			}) do
				if BubbleChatConfiguration[v] ~= nil then
					local v81 = BubbleChatConfiguration[v]

					t3[v] = v81
					v52("BubbleChatConfigurationLoaded", v, v81)
				end
			end

			if GuiService:IsTenFootInterface() then
				t3.TextSize = math.floor(0.5 + t3.TextSize * 1.5)
			end

			BubbleChatConfiguration.Changed:Connect(function(property) -- line: 351
				-- upvalues: BubbleChatConfiguration (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), p3 (copy), BubbleChatSettingsChanged (copy), v52 (copy)
				local v107 = BubbleChatConfiguration[property]

				if FFlagExpChatUseChatConfigStore then
					GetChatConfigurationStore(false).setBubbleChatProperty(property, v107)
				else
					p3:dispatch(BubbleChatSettingsChanged(property, v107))
				end

				v52("BubbleChatConfigurationChanged", property, v107)
			end)

			local v82 = setUpBubbleChatConfigurationChildren(p3)

			for k, v in pairs(v82) do
				if v then
					t3[k] = v82[k]
				end
			end

			return t3
		end

		return {}
	end)()
	local v56 = (function() -- line: 115
		-- upvalues: TextChatService (copy), GetTransparencyStore (copy), p3 (copy), ChatInputBarConfigurationEnabled (copy), getFFlagExpChatEnableChannelTabsUI (copy), shouldReorderTabs (copy), TargetTextChannelPropertyChanged (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), p4 (copy), DevTextBoxEnabledChanged (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), UserInputService (copy), v52 (copy), GuiService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ChatInputBarSettingsChanged (copy)
		local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
		local t4 = {}

		if ChatInputBarConfiguration then
			local v65 = GetTransparencyStore(false)

			p3:dispatch(ChatInputBarConfigurationEnabled(ChatInputBarConfiguration.Enabled))

			if ChatInputBarConfiguration.Enabled then
				v65.resetAllTransparency()
			end

			ChatInputBarConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 124
				-- upvalues: p3 (copy), ChatInputBarConfigurationEnabled (copy), ChatInputBarConfiguration (copy), v65 (copy)
				p3:dispatch(ChatInputBarConfigurationEnabled(ChatInputBarConfiguration.Enabled))

				if ChatInputBarConfiguration.Enabled then
					v65.resetAllTransparency()
				end
			end)
			ChatInputBarConfiguration:GetPropertyChangedSignal("TargetTextChannel"):Connect(function() -- line: 131
				-- upvalues: ChatInputBarConfiguration (copy), getFFlagExpChatEnableChannelTabsUI (copy), shouldReorderTabs (copy), p3 (copy), TargetTextChannelPropertyChanged (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy)
				local TargetTextChannel = ChatInputBarConfiguration.TargetTextChannel
				local v96 = not not getFFlagExpChatEnableChannelTabsUI() and shouldReorderTabs(p3:getState().ChannelTabs.allChannelTabs, TargetTextChannel)

				p3:dispatch(TargetTextChannelPropertyChanged(TargetTextChannel, v96))

				if FFlagExpChatUseChannelTabsStore then
					GetChannelTabsStore(false).setTargetChannel(TargetTextChannel and TargetTextChannel.Name, v96)
				end
			end)

			if p4.defaultTargetTextChannel then
				ChatInputBarConfiguration.TargetTextChannel = p4.defaultTargetTextChannel
			elseif TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
				game:GetService("Chat"):GetPropertyChangedSignal("IsAutoMigrated"):Once(function() -- line: 148
					-- upvalues: TextChatService (copy), ChatInputBarConfiguration (copy)
					local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

					if RBXGeneral and RBXGeneral:IsA("TextChannel") then
						ChatInputBarConfiguration.TargetTextChannel = RBXGeneral
					end
				end)
			end

			p3:dispatch(DevTextBoxEnabledChanged(ChatInputBarConfiguration.TextBox ~= nil))
			ChatInputBarConfiguration:GetPropertyChangedSignal("TextBox"):Connect(function() -- line: 157
				-- upvalues: p3 (copy), DevTextBoxEnabledChanged (copy), ChatInputBarConfiguration (copy)
				p3:dispatch(DevTextBoxEnabledChanged(ChatInputBarConfiguration.TextBox ~= nil))
			end)
			p3.changed:connect(function(p6, p7) -- line: 162
				-- upvalues: ChatInputBarConfiguration (copy)
				if p6.TextChannels ~= p7.TextChannels and p6.TextChannels.targetTextChannel ~= p7.TextChannels.targetTextChannel then
					ChatInputBarConfiguration.TargetTextChannel = p6.TextChannels.targetTextChannel
				end
			end)

			local t5 = {
				"BackgroundTransparency",
				"BackgroundColor3",
				"TextSize",
				"TextColor3",
				"TextStrokeColor3",
				"TextStrokeTransparency",
				"FontFace",
				"PlaceholderColor3",
				"KeyboardKeyCode"
			}

			if getEnableChatInputBarConfigurationAutocompleteEnabled() and ChatInputBarConfiguration.AutocompleteEnabled ~= nil then
				table.insert(t5, "AutocompleteEnabled")
			end

			for _, v in ipairs(t5) do
				if not ChatInputBarConfiguration[v] then
					continue
				end

				local v69 = ChatInputBarConfiguration[v]

				if v == "KeyboardKeyCode" then
					local StringForKeyCode = UserInputService:GetStringForKeyCode(v69)
					local v71

					if StringForKeyCode == nil or StringForKeyCode == "" or v69 == Enum.KeyCode.None then
						warn("ChatInputBarConfiguration.KeyboardKeyCode has an unsupported keycode for rendering UI:" .. tostring(v69))
						v71 = false
					else
						v71 = true
					end

					if not v71 then
						ChatInputBarConfiguration.KeyboardKeyCode = Enum.KeyCode.Slash
						t4[v] = Enum.KeyCode.Slash

						continue
					end
				end

				t4[v] = v69
				v52("ChatInputBarConfigurationLoaded", v, v69)
			end

			if GuiService:IsTenFootInterface() then
				t4.TextSize = math.floor(0.5 + t4.TextSize * 1.5)
			end

			ChatInputBarConfiguration.Changed:Connect(function(property) -- line: 214
				-- upvalues: ChatInputBarConfiguration (copy), UserInputService (copy), p3 (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ChatInputBarSettingsChanged (copy), v52 (copy)
				local v101 = ChatInputBarConfiguration[property]

				if property == "KeyboardKeyCode" then
					local StringForKeyCode = UserInputService:GetStringForKeyCode(v101)
					local v103

					if StringForKeyCode == nil or StringForKeyCode == "" or v101 == Enum.KeyCode.None then
						warn("ChatInputBarConfiguration.KeyboardKeyCode has an unsupported keycode for rendering UI:" .. tostring(v101))
						v103 = false
					else
						v103 = true
					end

					if not v103 then
						ChatInputBarConfiguration.KeyboardKeyCode = p3:getState().ChatLayout.ChatInputBarSettings.KeyboardKeyCode

						return
					end
				end

				if FFlagExpChatUseChatConfigStore then
					GetChatConfigurationStore(false).setChatInputBarProperty(property, v101)
				else
					p3:dispatch(ChatInputBarSettingsChanged(property, v101))
				end

				v52("ChatInputBarConfigurationChanged", property, v101)
			end)

			return t4
		end

		return {}
	end)()
	local v57 = if not getFFlagExpChatEnableChannelTabsUI() then {} else (function() -- line: 396
		-- upvalues: TextChatService (copy), FFlagExpChatEnableFriendsTab (copy), u39 (ref), syncFriendsTabVisibility (copy), p3 (copy), ChannelTabsConfigurationEnabled (copy), FFlagExpChatUseMessagesStore (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), GetMessagesStore (copy), getFFlagExpChatFixChannelTabsMidExperienceToggle (copy), v53 (copy), v52 (copy), GuiService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), ChannelTabsSettingsChanged (copy)
		local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
		local t6 = {}

		if FFlagExpChatEnableFriendsTab then
			if u39 then
				u39()
			end

			u39 = syncFriendsTabVisibility(p3)
		end

		if ChannelTabsConfiguration then
			p3:dispatch(ChannelTabsConfigurationEnabled(ChannelTabsConfiguration.Enabled))

			if FFlagExpChatUseMessagesStore and GetFFlagTextChatEnableUniverseChatTabs() then
				local v91 = GetMessagesStore(false)

				if v91 then
					v91.setChannelTabsConfigurationEnabled(ChannelTabsConfiguration.Enabled)
				end
			end

			ChannelTabsConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 415
				-- upvalues: p3 (copy), ChannelTabsConfigurationEnabled (copy), ChannelTabsConfiguration (copy), FFlagExpChatUseMessagesStore (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), GetMessagesStore (copy), getFFlagExpChatFixChannelTabsMidExperienceToggle (copy), v53 (copy)
				p3:dispatch(ChannelTabsConfigurationEnabled(ChannelTabsConfiguration.Enabled))

				if FFlagExpChatUseMessagesStore and GetFFlagTextChatEnableUniverseChatTabs() then
					local v108 = GetMessagesStore(false)

					if v108 then
						v108.setChannelTabsConfigurationEnabled(ChannelTabsConfiguration.Enabled)
					end
				end

				if getFFlagExpChatFixChannelTabsMidExperienceToggle() and GetFFlagTextChatEnableUniverseChatTabs() and ChannelTabsConfiguration.Enabled then
					v53()
				end
			end)

			for _, v in ipairs({
				"BackgroundTransparency",
				"BackgroundColor3",
				"HoverBackgroundColor3",
				"FontFace",
				"TextSize",
				"TextColor3",
				"SelectedTabTextColor3",
				"TextStrokeColor3",
				"TextStrokeTransparency"
			}) do
				if ChannelTabsConfiguration[v] then
					local v94 = ChannelTabsConfiguration[v]

					t6[v] = v94
					v52("ChannelTabsConfigurationLoaded", v, v94)
				end
			end

			if GuiService:IsTenFootInterface() then
				t6.TextSize = math.floor(0.5 + t6.TextSize * 1.5)
			end

			ChannelTabsConfiguration.Changed:Connect(function(property) -- line: 465
				-- upvalues: ChannelTabsConfiguration (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), p3 (copy), ChannelTabsSettingsChanged (copy), v52 (copy)
				local v110 = ChannelTabsConfiguration[property]

				if FFlagExpChatUseChatConfigStore then
					GetChatConfigurationStore(false).setChannelTabsProperty(property, v110)
				else
					p3:dispatch(ChannelTabsSettingsChanged(property, v110))
				end

				v52("ChannelTabsConfigurationChanged", property, v110)
			end)

			return t6
		end

		return {}
	end)()

	if FFlagExpChatUseChatConfigStore then
		local v58 = GetChatConfigurationStore(false)

		v58.mergeBubbleChatSettings(v55)
		v58.mergeChatWindowSettings(v54)
		v58.mergeChatInputBarSettings(v56)
		v58.mergeChannelTabsSettings(v57)

		return
	end

	p3:dispatch(ConfigurationObjectsLoaded({
		bubbleChatSettings = v55,
		chatWindowSettings = v54,
		chatInputBarSettings = v56,
		channelTabsSettings = v57
	}))
end
