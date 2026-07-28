local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Roact = require(ExpChatParent.Roact)
local RoactRodux = require(ExpChatParent.RoactRodux)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Analytics = ExpChatShared.Analytics
local Config = require(ExpChat.Config)
local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatLogGlobalChatTabClicked = require(ExpChat.Flags.FFlagExpChatLogGlobalChatTabClicked)
local v20 = game:DefineFastFlag("GlobalTextChatAddPlaySessionField", false)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local createEffect = require(ExpChatParent.Signals).createEffect
local ChannelBar = require(script.Parent.UI.ChannelBar)
local v25 = Roact.Component:extend("ChannelBarApp")

if FFlagExpChatUseChatConfigStore then
	function v25.init(p1) -- line: 34
		-- upvalues: GetChatConfigurationStore (copy)
		p1.chatConfigStore = GetChatConfigurationStore(false)
		p1.state = {
			channelTabsSettings = p1.chatConfigStore.getChannelTabsSettings(false)
		}
	end
	function v25.didMount(p2) -- line: 41
		-- upvalues: createEffect (copy)
		p2.updateChannelTabsSettingsEffect = createEffect(function(p3) -- line: 43
			-- upvalues: p2 (copy)
			local v34 = p2.chatConfigStore.getChannelTabsSettings(p3)

			p2:setState({
				channelTabsSettings = v34
			})
		end)
	end
	function v25.willUnmount(p4) -- line: 51
		p4.updateChannelTabsSettingsEffect()
		p4.updateChannelTabsSettingsEffect = nil
	end
end

function v25.render(p5) -- line: 57
	-- upvalues: FFlagExpChatUseChatConfigStore (copy), React (copy), ChannelBar (copy), FFlagExpChatChannelTabRefactor (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatLogGlobalChatTabClicked (copy), Analytics (copy), v20 (copy)
	local v30 = if not FFlagExpChatUseChatConfigStore then p5.props.channelTabsSettings else p5.state.channelTabsSettings

	return React.createElement(ChannelBar, {
		channelTabsSettings = v30,
		chatWindowSettings = p5.props.chatWindowSettings,
		allChannelTabs = p5.props.allChannelTabs,
		allTextChannels = p5.props.allTextChannels,
		selectedTabName = p5.props.selectedTabName,
		onTabSelected = function(p6, p7, p8, p9) -- line: 73
			-- upvalues: FFlagExpChatChannelTabRefactor (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatLogGlobalChatTabClicked (copy), p5 (copy), Analytics (copy), v20 (copy)
			if ((if not FFlagExpChatChannelTabRefactor then not not GetFFlagTextChatEnableUniverseChatTabs() and not p6 else p9 == "UniverseChat")) and (FFlagExpChatLogGlobalChatTabClicked and p8 ~= p5.props.selectedTabName) then
				local v39 = table.clone(Analytics.DefaultStandardizedFields)

				table.insert(v39, "addPlaceInstanceId")

				if v20 then
					table.insert(v39, "addPlaySessionId")
				end

				Analytics:TelemetryLogEvent(Analytics.ExpChatGlobalChatTabClickedConfig, {
					channelName = p8
				}, v39)
			end

			p5.props.onTabSelected(p6, p7, p8, p9)
		end,
		onHovered = p5.props.onHovered,
		onUnhovered = p5.props.onUnhovered,
		visible = p5.props.visible,
		transparencyValue = p5.props.transparencyValue,
		topBorderRef = p5.props.topBorderRef
	})
end

return RoactRodux.connect(function(p10) -- line: 104
	-- upvalues: FFlagExpChatUseChatConfigStore (copy), getFFlagExpChatEnableChannelTabsUI (copy), Config (copy)
	return {
		channelTabsSettings = if not FFlagExpChatUseChatConfigStore then getFFlagExpChatEnableChannelTabsUI() and p10.ChatLayout.ChannelTabsSettings or {
			BackgroundTransparency = Config.ChannelTabsSettings.BackgroundTransparency,
			BackgroundColor3 = Config.ChannelTabsSettings.BackgroundColor3,
			HoverBackgroundColor3 = Config.ChannelTabsSettings.HoverBackgroundColor3,
			FontFace = Config.ChannelTabsSettings.FontFace,
			TextSize = Config.ChannelTabsSettings.TextSize,
			TextColor3 = Config.ChannelTabsSettings.TextColor3,
			SelectedTabTextColor3 = Config.ChannelTabsSettings.SelectedTabTextColor3,
			TextStrokeColor3 = Config.ChannelTabsSettings.TextStrokeColor3,
			TextStrokeTransparency = Config.ChannelTabsSettings.TextStrokeTransparency
		} else nil,
		allChannelTabs = getFFlagExpChatEnableChannelTabsUI() and p10.ChannelTabs.allChannelTabs or {},
		selectedTabName = getFFlagExpChatEnableChannelTabsUI() and p10.ChannelTabs.selectedTabName or "",
		allTextChannels = p10.TextChannels.allTextChannels
	}
end, function(p11) -- line: 123
	-- upvalues: FFlagExpChatChannelTabRefactor (copy), UniverseChatChannelSelected (copy), FFlagExpChatEnableFriendsTab (copy), FriendsChatChannelSelected (copy), TargetTextChannelPropertyChanged (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), getFFlagExpChatEnableChannelTabsUI (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy)
	return {
		onTabSelected = function(p12, p13, p14, p15) -- line: 126
			-- upvalues: FFlagExpChatChannelTabRefactor (copy), p11 (copy), UniverseChatChannelSelected (copy), FFlagExpChatEnableFriendsTab (copy), FriendsChatChannelSelected (copy), TargetTextChannelPropertyChanged (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), getFFlagExpChatEnableChannelTabsUI (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy)
			if FFlagExpChatChannelTabRefactor then
				if p15 == "UniverseChat" then
					p11(UniverseChatChannelSelected(p14))
				elseif FFlagExpChatEnableFriendsTab and p15 == "FriendsChat" then
					p11(FriendsChatChannelSelected(p14))
				elseif p12 then
					p11(TargetTextChannelPropertyChanged(p12, p13))
				end
			elseif GetFFlagTextChatEnableUniverseChatTabs() then
				if p12 then
					p11(TargetTextChannelPropertyChanged(p12, p13))
				else
					p11(UniverseChatChannelSelected(p14))
				end
			elseif getFFlagExpChatEnableChannelTabsUI() then
				p11(TargetTextChannelPropertyChanged(p12, p13))
			end

			if FFlagExpChatUseChannelTabsStore then
				if FFlagExpChatChannelTabRefactor then
					GetChannelTabsStore(false).setTargetChannel(p14, p13)

					return
				end

				if GetFFlagTextChatEnableUniverseChatTabs() then
					local v44 = GetChannelTabsStore(false)
					local v45 = p14 or p12 and p12.Name

					v44.setTargetChannel(v45, p13)

					return
				end

				if getFFlagExpChatEnableChannelTabsUI() then
					GetChannelTabsStore(false).setTargetChannel(p12 and p12.Name, p13)
				end
			end
		end
	}
end)(v25)
