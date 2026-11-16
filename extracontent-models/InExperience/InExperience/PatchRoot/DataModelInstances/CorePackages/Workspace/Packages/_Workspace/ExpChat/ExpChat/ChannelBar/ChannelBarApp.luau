local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local ExpChatShared = require(parent.ExpChatShared)

local Analytics = ExpChatShared.Analytics
local Config = require(ExpChat.Config)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatLogGlobalChatTabClicked = require(ExpChat.Flags.FFlagExpChatLogGlobalChatTabClicked)
local FFlagGlobalTextChatAddPlaySessionField = require(ExpChat.Flags.FFlagGlobalTextChatAddPlaySessionField)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)

local selectTabByType = require(ExpChat.TabNavigation.selectTabByType)

local FFlagDebugFriendsChat = require(parent.FriendsChat.FFlagDebugFriendsChat)
local LocalTextChannelParticipantAdded = require(ExpChat.Actions.LocalTextChannelParticipantAdded)
local ChannelTabsConfigurationEnabled = require(ExpChat.Actions.ChannelTabsConfigurationEnabled)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

local ChannelBar = require(script.Parent.UI.ChannelBar)

local extended = Roact.Component:extend("ChannelBarApp")

if FFlagExpChatUseChatConfigStore then
	function extended:init()
		self.chatConfigStore = GetChatConfigurationStore(false)
		self.state = {
			channelTabsSettings = self.chatConfigStore.getChannelTabsSettings(false)
		}
	end
end

function extended:didMount()
	if FFlagExpChatUseChatConfigStore then
		self.updateChannelTabsSettingsEffect = createEffect(function(p)
			self:setState({
				channelTabsSettings = self.chatConfigStore.getChannelTabsSettings(p)
			})
		end)
	end

	if FFlagDebugFriendsChat then
		self.debugAddTabsConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if
				input.KeyCode == Enum.KeyCode.J
				and input:IsModifierKeyDown(Enum.ModifierKey.Ctrl)
				and self.props.debugAddFakeTabs
			then
				self.props.debugAddFakeTabs(3)
			end
		end)
	end
end

function extended:willUnmount()
	if self.updateChannelTabsSettingsEffect then
		self.updateChannelTabsSettingsEffect()
		self.updateChannelTabsSettingsEffect = nil
	end

	if self.debugAddTabsConnection then
		self.debugAddTabsConnection:Disconnect()
		self.debugAddTabsConnection = nil
	end
end

function extended.render(p)
	local channelTabsSettings

	if FFlagExpChatUseChatConfigStore then
		channelTabsSettings = p.state.channelTabsSettings
	else
		channelTabsSettings = p.props.channelTabsSettings
	end

	return React.createElement(ChannelBar, {
		channelTabsSettings = channelTabsSettings,
		chatWindowSettings = p.props.chatWindowSettings,
		allChannelTabs = p.props.allChannelTabs,
		allTextChannels = p.props.allTextChannels,
		selectedTabName = p.props.selectedTabName,
		onTabSelected = function(p2, p3, channelName, p4)
			if
				p4 == "UniverseChat"
				and FFlagExpChatLogGlobalChatTabClicked
				and channelName ~= p.props.selectedTabName
			then
				local clone = table.clone(Analytics.DefaultStandardizedFields)
				table.insert(clone, "addPlaceInstanceId")

				if FFlagGlobalTextChatAddPlaySessionField then
					table.insert(clone, "addPlaySessionId")
				end

				Analytics:TelemetryLogEvent(
					Analytics.ExpChatGlobalChatTabClickedConfig,
					{ channelName = channelName },
					clone
				)
			end

			p.props.onTabSelected(p2, p3, channelName, p4)
		end,
		onHovered = p.props.onHovered,
		onUnhovered = p.props.onUnhovered,
		visible = p.props.visible,
		transparencyValue = p.props.transparencyValue,
		topBorderRef = p.props.topBorderRef
	})
end

local v = RoactRodux.connect(function(data)
	return {
		channelTabsSettings = not FFlagExpChatUseChatConfigStore and (data.ChatLayout.ChannelTabsSettings or {
			BackgroundTransparency = Config.ChannelTabsSettings.BackgroundTransparency,
			BackgroundColor3 = Config.ChannelTabsSettings.BackgroundColor3,
			HoverBackgroundColor3 = Config.ChannelTabsSettings.HoverBackgroundColor3,
			FontFace = Config.ChannelTabsSettings.FontFace,
			TextSize = Config.ChannelTabsSettings.TextSize,
			TextColor3 = Config.ChannelTabsSettings.TextColor3,
			SelectedTabTextColor3 = Config.ChannelTabsSettings.SelectedTabTextColor3,
			TextStrokeColor3 = Config.ChannelTabsSettings.TextStrokeColor3,
			TextStrokeTransparency = Config.ChannelTabsSettings.TextStrokeTransparency
		}) or nil,
		allChannelTabs = not FFlagExpChatUseChannelTabsStore and (data.ChannelTabs.allChannelTabs or {}) or nil,
		selectedTabName = not FFlagExpChatUseChannelTabsStore and (data.ChannelTabs.selectedTabName or "") or nil,
		allTextChannels = data.TextChannels.allTextChannels
	}
end, function(callback)
	return {
		onTabSelected = function(textChannel, shouldReorderTabs, channelName, tabType)
			selectTabByType(callback, {
				channelName = channelName,
				tabType = tabType,
				shouldReorderTabs = shouldReorderTabs,
				textChannel = textChannel
			})
		end,
		debugAddFakeTabs = FFlagDebugFriendsChat and function(p: number)
			callback(ChannelTabsConfigurationEnabled(true))
			local channelTabsStore = GetChannelTabsStore(false)
			channelTabsStore.setChannelTabsConfigurationEnabled(true)

			for i = 1, p do
				local name = "D" .. tostring(i)
				local textChannel = Instance.new("TextChannel")
				textChannel.Name = name

				textChannel.Parent = TextChatService:FindFirstChild("TextChannels") or TextChatService
				callback(LocalTextChannelParticipantAdded(textChannel))
				channelTabsStore.addChannelTab({ type = "TextChat", name = name }, nil)
			end
		end or nil
	}
end)(extended)

local function areChannelTabsEqual(allChannelTabs, allChannelTabs2): boolean
	if allChannelTabs == allChannelTabs2 then
		return true
	end

	for k, item in allChannelTabs do
		local item2 = allChannelTabs2[k]

		if
			item2 == nil
			or item2.tabIndex ~= item.tabIndex
			or item2.type ~= item.type
			or item2.HasUnreadMessages ~= item.HasUnreadMessages
		then
			return false
		end
	end

	for k in allChannelTabs2 do
		if allChannelTabs[k] == nil then
			return false
		end
	end

	return true
end

local function ChannelBarAppWithSignals(p)
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(p2)

			return {
				allChannelTabs = channelTabsState.allChannelTabs,
				selectedTabName = channelTabsState.selectedTabName or ""
			}
		end, function(p2, p3)
			return p2.selectedTabName == p3.selectedTabName
				and areChannelTabsEqual(p2.allChannelTabs, p3.allChannelTabs)
		end)
	end, {})
	local v3 = SignalsReact.useSignalState(v2)

	return React.createElement(v, Cryo.Dictionary.union(p, v3))
end

if FFlagExpChatUseChannelTabsStore then
	return React.memo(ChannelBarAppWithSignals)
end

return v
