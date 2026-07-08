local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Config = require(ExpChat.Config)
local React = require(ExpChatParent.React)
local Dictionary = require(ExpChatParent.llama).Dictionary
local UIBlox = require(ExpChatParent.UIBlox)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Interactable = UIBlox.Core.Control.Interactable
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local FFlagExpChatFocusChannelBarSupport = require(ExpChat.Flags.FFlagExpChatFocusChannelBarSupport)
local FFlagExpChatChannelTabSizingUpdate = require(ExpChat.Flags.FFlagExpChatChannelTabSizingUpdate)
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local GameLocalization = require(ExpChat.GameLocalization)
local Localization = require(ExpChat.Localization)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local unreachable = ExpChatShared.TabTypes.unreachable
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetFFlagEnableExpChatUniverseChatTabNames = ExpChatShared.Flags.GetFFlagEnableExpChatUniverseChatTabNames
local v23 = not FFlagExpChatChannelTabSizingUpdate and 20 or 12
local color3 = Color3.fromRGB(255, 255, 255)
local t1 = {
	channelName = "",
	hasUnreadMessages = false,
	isDividerVisible = false,
	isTabCollapsed = false,
	isTabSelected = false,
	onTabSelected = nil,
	setTransparency = nil
}

local function ChannelTab(t2: {[any]: any}) -- line: 62
	-- upvalues: Dictionary (copy), t1 (copy), FFlagExpChatChannelTabRefactor (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), Localization (copy), Players (copy), getOtherDisplayNameInWhisperChannel (copy), FFlagExpChatEnableFriendsTab (copy), unreachable (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), React (copy), FFlagExpChatFocusChannelBarSupport (copy), useSelectionCursor (copy), CursorKind (copy), Interactable (copy), v23 (copy), Config (copy), color3 (copy)
	local v28 = Dictionary.join(t1, t2)
	local channelName = v28.channelName

	if FFlagExpChatChannelTabRefactor or GetFFlagEnableExpChatUniverseChatTabNames() then
		local v30 = Localization.useLocalization({
			yourServer = "CoreScripts.TextChat.ChannelTabs.Here",
			moreServers = "CoreScripts.TextChat.ChannelTabs.Global2"
		})

		if FFlagExpChatChannelTabRefactor then
			local tabType = v28.tabType

			if tabType == "TextChat" then
				local channelName2 = v28.channelName

				if string.find(channelName2, "RBXGeneral") then
					channelName = v30.yourServer
				elseif string.find(channelName2, "RBXSystem") then
					channelName = "System"
				elseif string.find(channelName2, "^RBXTeam") then
					channelName = "Team"
				elseif string.find(channelName2, "^RBXWhisper") and v28.textChannel and Players.LocalPlayer then
					local v33 = getOtherDisplayNameInWhisperChannel(v28.textChannel, Players.LocalPlayer)

					if v33 then
						channelName = v33
					end
				end
			elseif tabType == "UniverseChat" then
				if string.find(v28.channelName, "RBXGlobal") then
					channelName = v30.moreServers
				end
			elseif FFlagExpChatEnableFriendsTab and tabType == "FriendsChat" then
				channelName = "Friends"
			else
				unreachable(tabType)
			end
		elseif GetFFlagEnableExpChatUniverseChatTabNames() then
			if string.find(v28.channelName, "RBXGeneral") then
				channelName = v30.yourServer
			elseif GetFFlagTextChatEnableUniverseChatTabs() and string.find(v28.channelName, "RBXGlobal") then
				channelName = v30.moreServers
			end
		end
	end

	local v34, v35 = React.useState(v28.channelTabsSettings.BackgroundColor3)
	local v36 = if not FFlagExpChatFocusChannelBarSupport then nil else useSelectionCursor(CursorKind.RoundedSlot)

	return React.createElement(Interactable, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v28.isTabCollapsed and v28.setTransparency(v28.channelTabsSettings.BackgroundTransparency) or 1,
		BackgroundColor3 = v28.isTabCollapsed and v34 or v28.channelTabsSettings.BackgroundColor3,
		BorderSizePixel = 0,
		SelectionImageObject = v36,
		onStateChanged = function() -- line: 125
		end,
		[React.Event.Activated] = v28.onTabSelected,
		[React.Event.MouseEnter] = function() -- line: 127
			-- upvalues: v28 (copy), v35 (copy)
			if v28.isTabCollapsed then
				v35(v28.channelTabsSettings.HoverBackgroundColor3)
			end
		end,
		[React.Event.MouseLeave] = function() -- line: 132
			-- upvalues: v28 (copy), v35 (copy)
			if v28.isTabCollapsed then
				v35(v28.channelTabsSettings.BackgroundColor3)
			end
		end
	}, {
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Text = if not FFlagExpChatChannelTabRefactor and not GetFFlagEnableExpChatUniverseChatTabNames() then v28.channelName else channelName,
			FontFace = v28.channelTabsSettings.FontFace,
			TextSize = v28.channelTabsSettings.TextSize,
			TextColor3 = v28.isTabSelected and v28.channelTabsSettings.SelectedTabTextColor3 or v28.channelTabsSettings.TextColor3,
			TextTransparency = v28.setTransparency(0),
			TextStrokeColor3 = v28.channelTabsSettings.TextStrokeColor3,
			TextStrokeTransparency = v28.setTransparency(v28.channelTabsSettings.TextStrokeTransparency),
			TextXAlignment = v28.isTabCollapsed and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v23 + (not v28.isTabCollapsed and 0 or 4)),
				PaddingRight = UDim.new(0, v23)
			})
		}),
		UnreadDot = v28.hasUnreadMessages and React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(0, v23 - 2, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = Config.ChannelTabsSettings.UnreadDotColor3,
			BackgroundTransparency = v28.setTransparency(0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		Highlight = v28.isTabSelected and React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 4),
			Position = UDim2.new(0, 0, 1, -4),
			BackgroundColor3 = color3,
			BackgroundTransparency = v28.setTransparency(0)
		}),
		Divider = v28.isDividerVisible and React.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = v28.isTabCollapsed and Vector2.new(0, 1) or Vector2.new(0, 0.5),
			Position = v28.isTabCollapsed and UDim2.fromScale(0, 1) or UDim2.fromScale(1, 0.5),
			Size = v28.isTabCollapsed and UDim2.new(1, 0, 0, Config.ChannelTabsSettings.DividerSize) or UDim2.new(0, Config.ChannelTabsSettings.DividerSize, 0.8, 0),
			BackgroundTransparency = v28.setTransparency(Config.ChannelTabsSettings.DividerTransparency),
			BackgroundColor3 = Config.ChannelTabsSettings.DividerColor3
		})
	})
end

return GameLocalization.connect(function(p1) -- line: 192
	-- upvalues: FFlagExpChatChannelTabRefactor (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), Players (copy), getOtherDisplayNameInWhisperChannel (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local channelName = p1.channelName

	if FFlagExpChatChannelTabRefactor then
		return {}
	end

	if string.find(channelName, "RBXGeneral") then
		if GetFFlagEnableExpChatUniverseChatTabNames() then
			return {}
		end

		channelName = "General"
	elseif string.find(channelName, "RBXSystem") then
		channelName = "System"
	elseif string.find(channelName, "^RBXTeam") then
		channelName = "Team"
	elseif string.find(channelName, "^RBXWhisper") then
		if p1.textChannel and Players.LocalPlayer then
			local v39 = getOtherDisplayNameInWhisperChannel(p1.textChannel, Players.LocalPlayer)

			if v39 then
				channelName = v39
			end
		end
	elseif GetFFlagTextChatEnableUniverseChatTabs() and string.find(channelName, "RBXGlobal") then
		if GetFFlagEnableExpChatUniverseChatTabNames() then
			return {}
		end

		channelName = "Global"
	end

	return {
		channelName = channelName
	}
end)(ChannelTab)
