local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local AppCommonLib = require(ExpChat.Parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
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
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local isGlobalTabFirst = require(ExpChat.isGlobalTabFirst)

local getFFlagExpChatFixChannelTabsMidExperienceToggle = require(ExpChat.Flags.getFFlagExpChatFixChannelTabsMidExperienceToggle)

local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

local parent = ExpChat.Parent
local ExpChatShared2 = require(parent.ExpChatShared)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared2.Flags.GetFFlagTextChatEnableUniverseChatTabs
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatStickyTabs = SharedFlags.FFlagExpChatStickyTabs
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatTabShortcutNav = SharedFlags.FFlagExpChatTabShortcutNav

local v = nil

local function isKeyboardKeyCodeSanitized(p): boolean -- 2 equivalent calls inferred from this helper
	local stringForKeyCode = UserInputService:GetStringForKeyCode(p)

	if stringForKeyCode ~= nil and stringForKeyCode ~= "" and p ~= Enum.KeyCode.None then
		return true
	end

	warn("ChatInputBarConfiguration.KeyboardKeyCode has an unsupported keycode for rendering UI:" .. tostring(p))

	return false
end

local function shouldReorderTabs(items, targetTextChannel): boolean
	local v2

	if targetTextChannel then
		v2 = items[targetTextChannel.Name]
	end

	if v2 == nil then
		return false
	end

	local v3 = 0

	for _ in pairs(items) do
		v3 += 1
	end

	local channelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")

	if not channelTabsConfiguration then
		return false
	end

	local x = channelTabsConfiguration.AbsoluteSize.X

	if x < v3 * Config.ChannelTabsSettings.MinTabWidth or not v3 then
		v3 = math.floor((x - Config.ChannelTabsSettings.DropdownIconContainerWidth) / Config.ChannelTabsSettings.MinTabWidth)
	end

	local v4

	if FFlagExpChatUseChannelTabsStore then
		v4 = v2.tabIndex
	else
		v4 = v2.TabIndex
	end

	return v3 < v4
end

return function(object, p)
	if p.analytics then
		Analytics.with(p.analytics)
	end

	local function fn(p2: string, p3: string, value)
		local v2

		if type(value) == "number" or type(value) == "boolean" or typeof(value) == "EnumItem" then
			v2 = tostring(value)
		elseif typeof(value) == "Color3" then
			v2 = value:ToHex()
		elseif typeof(value) == "Font" then
			v2 = tostring((string.gsub(value.Family, "rbxasset://fonts/families/", ""))) .. " " .. tostring(value.Weight) .. " " .. tostring(value.Style)
		else
			return
		end

		assert(v2, "should exist")
		Analytics.FireClientAnalyticsWithEventName(p2, { [p3] = v2 })
	end

	local v2 = false

	local function fn2()
		local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
		local result = {}

		if not chatInputBarConfiguration then
			return {}
		end

		local transparencyStore = GetTransparencyStore(false)
		object:dispatch(ChatInputBarConfigurationEnabled(chatInputBarConfiguration.Enabled))

		if chatInputBarConfiguration.Enabled then
			transparencyStore.resetAllTransparency()
		end

		chatInputBarConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function()
			object:dispatch(ChatInputBarConfigurationEnabled(chatInputBarConfiguration.Enabled))

			if chatInputBarConfiguration.Enabled then
				transparencyStore.resetAllTransparency()
			end
		end)

		chatInputBarConfiguration:GetPropertyChangedSignal("TargetTextChannel"):Connect(function()
			local targetTextChannel = chatInputBarConfiguration.TargetTextChannel
			local v3

			if FFlagExpChatUseChannelTabsStore then
				v3 = GetChannelTabsStore(false).getChannelTabsState(false).allChannelTabs
			else
				v3 = object:getState().ChannelTabs.allChannelTabs
			end

			local v4 = shouldReorderTabs(v3, targetTextChannel)

			if FFlagExpChatTabShortcutNav and v4 and targetTextChannel ~= nil then
				local v5

				if FFlagExpChatUseChannelTabsStore then
					v5 = GetChannelTabsStore(false).getChannelTabsState(false).selectedTabName
				else
					v5 = object:getState().ChannelTabs.selectedTabName
				end

				if v5 == targetTextChannel.Name then
					v4 = false
				end
			end

			local v5

			if FFlagExpChatStickyTabs then
				v5 = v2
			else
				v5 = FFlagExpChatGlobalTabDefault and v2 and isGlobalTabFirst()
			end

			if v5 then
				v2 = false
				local v6, selectedTabName

				if FFlagExpChatUseChannelTabsStore then
					local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(false)
					v6 = channelTabsState.hasUserSelectedTab
					selectedTabName = channelTabsState.selectedTabName
				else
					local channelTabs = object:getState().ChannelTabs

					if channelTabs == nil then
						v6 = false
					else
						v6 = channelTabs.hasUserSelectedTab
					end

					if channelTabs ~= nil then
						selectedTabName = channelTabs.selectedTabName
					end
				end

				local v7

				if FFlagExpChatStickyTabs then
					v7 = v6 or FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and selectedTabName == "RBXGlobal"
				else
					v7 = not v6 and selectedTabName == "RBXGlobal"
				end

				if v7 then
					if not FFlagExpChatStickyTabs then
						return
					end

					local targetTextChannel2

					if selectedTabName then
						targetTextChannel2 = object:getState().TextChannels.allTextChannels[selectedTabName]
					end

					chatInputBarConfiguration.TargetTextChannel = targetTextChannel2

					return
				end
			end

			object:dispatch(TargetTextChannelPropertyChanged(targetTextChannel, v4))

			if FFlagExpChatUseChannelTabsStore then
				GetChannelTabsStore(false).setTargetChannel(targetTextChannel and targetTextChannel.Name, v4)
			end
		end)

		if p.defaultTargetTextChannel then
			chatInputBarConfiguration.TargetTextChannel = p.defaultTargetTextChannel
		elseif TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
			local Chat = game:GetService("Chat")
			Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(function()
				local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

				if rbxGeneral and rbxGeneral:IsA("TextChannel") then
					if FFlagExpChatStickyTabs then
						v2 = chatInputBarConfiguration.TargetTextChannel ~= rbxGeneral
					elseif FFlagExpChatGlobalTabDefault then
						v2 = true
					end

					chatInputBarConfiguration.TargetTextChannel = rbxGeneral
				end
			end)
		end

		object:dispatch(DevTextBoxEnabledChanged(chatInputBarConfiguration.TextBox ~= nil))
		chatInputBarConfiguration:GetPropertyChangedSignal("TextBox"):Connect(function()
			object:dispatch(DevTextBoxEnabledChanged(chatInputBarConfiguration.TextBox ~= nil))
		end)

		object.changed:connect(function(p2, p3)
			if
				p2.TextChannels ~= p3.TextChannels
				and p2.TextChannels.targetTextChannel ~= p3.TextChannels.targetTextChannel
			then
				chatInputBarConfiguration.TargetTextChannel = p2.TextChannels.targetTextChannel
			end
		end)

		local v3 = {
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

		if
			getEnableChatInputBarConfigurationAutocompleteEnabled()
			and chatInputBarConfiguration.AutocompleteEnabled ~= nil
		then
			table.insert(v3, "AutocompleteEnabled")
		end

		for _, v4 in ipairs(v3) do
			if not chatInputBarConfiguration[v4] then
				continue
			end

			local v5 = chatInputBarConfiguration[v4]

			if v4 == "KeyboardKeyCode" and not isKeyboardKeyCodeSanitized(v5) then -- inferred equivalent call
				chatInputBarConfiguration.KeyboardKeyCode = Enum.KeyCode.Slash
				result.KeyboardKeyCode = Enum.KeyCode.Slash
				continue
			end

			result[v4] = v5
			fn("ChatInputBarConfigurationLoaded", v4, v5)
		end

		if isTenFootInterface() then
			result.TextSize = math.floor(0.5 + result.TextSize * 1.5)
		end

		chatInputBarConfiguration.Changed:Connect(function(p2)
			local v4 = chatInputBarConfiguration[p2]

			if p2 == "KeyboardKeyCode" and not isKeyboardKeyCodeSanitized(v4) then -- inferred equivalent call
				chatInputBarConfiguration.KeyboardKeyCode = object:getState().ChatLayout.ChatInputBarSettings.KeyboardKeyCode
				return
			end

			if FFlagExpChatUseChatConfigStore then
				GetChatConfigurationStore(false).setChatInputBarProperty(p2, v4)
			else
				object:dispatch(ChatInputBarSettingsChanged(p2, v4))
			end

			fn("ChatInputBarConfigurationChanged", p2, v4)
		end)

		return result
	end

	local function fn3()
		local bubbleChatConfiguration = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")
		local result = {}

		if not bubbleChatConfiguration then
			return {}
		end

		for _, v3 in ipairs({
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
			if bubbleChatConfiguration[v3] == nil then
				continue
			end

			local v4 = bubbleChatConfiguration[v3]
			result[v3] = v4

			fn("BubbleChatConfigurationLoaded", v3, v4)
		end

		if isTenFootInterface() then
			result.TextSize = math.floor(0.5 + result.TextSize * 1.5)
		end

		bubbleChatConfiguration.Changed:Connect(function(p2)
			local v3 = bubbleChatConfiguration[p2]

			if FFlagExpChatUseChatConfigStore then
				GetChatConfigurationStore(false).setBubbleChatProperty(p2, v3)
			else
				object:dispatch(BubbleChatSettingsChanged(p2, v3))
			end

			fn("BubbleChatConfigurationChanged", p2, v3)
		end)

		local v3 = setUpBubbleChatConfigurationChildren(object)

		for k, v4 in pairs(v3) do
			if v4 then
				result[k] = v3[k]
			end
		end

		return result
	end

	local function fn4()
		local localPlayer = Players.LocalPlayer

		if not localPlayer then
			return
		end

		for _, textSource in TextChatService:GetDescendants() do
			if not (textSource:IsA("TextSource") and textSource.UserId == localPlayer.UserId) then
				continue
			end

			local parent2 = textSource.Parent

			if not (parent2 and parent2:IsA("TextChannel")) then
				continue
			end

			if FFlagExpChatUseChannelTabsStore then
				GetChannelTabsStore(false).handleLocalTextChannelParticipantAdded(parent2)
			else
				object:dispatch(LocalTextChannelParticipantAdded(parent2))
			end
		end
	end

	local function fn5()
		local channelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
		local result = {}

		if v then
			v()
		end

		v = syncFriendsTabVisibility(object)

		if not channelTabsConfiguration then
			return {}
		end

		object:dispatch(ChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled))
		local v3 = GetFFlagTextChatEnableUniverseChatTabs() and GetMessagesStore(false)

		if v3 then
			v3.setChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled)
		end

		if FFlagExpChatUseChannelTabsStore then
			GetChannelTabsStore(false).setChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled)
		end

		channelTabsConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function()
			object:dispatch(ChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled))
			local v4 = GetFFlagTextChatEnableUniverseChatTabs() and GetMessagesStore(false)

			if v4 then
				v4.setChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled)
			end

			if FFlagExpChatUseChannelTabsStore then
				GetChannelTabsStore(false).setChannelTabsConfigurationEnabled(channelTabsConfiguration.Enabled)
			end

			if
				getFFlagExpChatFixChannelTabsMidExperienceToggle()
				and GetFFlagTextChatEnableUniverseChatTabs()
				and channelTabsConfiguration.Enabled
			then
				fn4()
			end
		end)

		for _, v4 in ipairs({
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
			if not channelTabsConfiguration[v4] then
				continue
			end

			local v5 = channelTabsConfiguration[v4]
			result[v4] = v5

			fn("ChannelTabsConfigurationLoaded", v4, v5)
		end

		if isTenFootInterface() then
			result.TextSize = math.floor(0.5 + result.TextSize * 1.5)
		end

		channelTabsConfiguration.Changed:Connect(function(p2)
			local v4 = channelTabsConfiguration[p2]

			if FFlagExpChatUseChatConfigStore then
				GetChatConfigurationStore(false).setChannelTabsProperty(p2, v4)
			else
				object:dispatch(ChannelTabsSettingsChanged(p2, v4))
			end

			fn("ChannelTabsConfigurationChanged", p2, v4)
		end)

		return result
	end

	local chatWindowSettings = (function()
		local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
		local result = {}

		if not chatWindowConfiguration then
			return {}
		end

		object:dispatch(ChatWindowConfigurationEnabled(chatWindowConfiguration.Enabled))
		chatWindowConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function()
			object:dispatch(ChatWindowConfigurationEnabled(chatWindowConfiguration.Enabled))
		end)

		object:dispatch(ChatLayoutHorizontalAlignmentChanged(chatWindowConfiguration.HorizontalAlignment))
		chatWindowConfiguration:GetPropertyChangedSignal("HorizontalAlignment"):Connect(function()
			object:dispatch(ChatLayoutHorizontalAlignmentChanged(chatWindowConfiguration.HorizontalAlignment))
		end)

		object:dispatch(ChatLayoutVerticalAlignmentChanged(chatWindowConfiguration.VerticalAlignment))
		chatWindowConfiguration:GetPropertyChangedSignal("VerticalAlignment"):Connect(function()
			object:dispatch(ChatLayoutVerticalAlignmentChanged(chatWindowConfiguration.VerticalAlignment))
		end)

		for _, v3 in ipairs({
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
			if not chatWindowConfiguration[v3] then
				continue
			end

			local v4 = chatWindowConfiguration[v3]
			result[v3] = v4

			fn("ChatWindowConfigurationLoaded", v3, v4)
		end

		if isTenFootInterface() then
			result.TextSize = math.floor(0.5 + result.TextSize * 1.5)
		end

		chatWindowConfiguration.Changed:Connect(function(p2)
			local v3 = chatWindowConfiguration[p2]

			if FFlagExpChatUseChatConfigStore then
				GetChatConfigurationStore(false).setChatWindowProperty(p2, v3)
			else
				object:dispatch(ChatWindowSettingsChanged(p2, v3))
			end

			fn("ChatWindowConfigurationChanged", p2, v3)
		end)

		return result
	end)()
	local bubbleChatSettings = fn3()
	local chatInputBarSettings = fn2()
	local channelTabsSettings = fn5()

	if FFlagExpChatUseChatConfigStore then
		local chatConfigurationStore = GetChatConfigurationStore(false)

		chatConfigurationStore.mergeBubbleChatSettings(bubbleChatSettings)
		chatConfigurationStore.mergeChatWindowSettings(chatWindowSettings)
		chatConfigurationStore.mergeChatInputBarSettings(chatInputBarSettings)
		chatConfigurationStore.mergeChannelTabsSettings(channelTabsSettings)
	else
		object:dispatch(ConfigurationObjectsLoaded({
			bubbleChatSettings = bubbleChatSettings,
			chatWindowSettings = chatWindowSettings,
			chatInputBarSettings = chatInputBarSettings,
			channelTabsSettings = channelTabsSettings
		}))
	end
end
