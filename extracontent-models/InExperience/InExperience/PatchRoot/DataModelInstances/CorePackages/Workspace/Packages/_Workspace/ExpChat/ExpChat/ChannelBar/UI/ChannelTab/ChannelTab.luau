local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Config = require(ExpChat.Config)
local React = require(parent.React)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local UIBlox = require(parent.UIBlox)
local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)
local ChannelTabDisplayLabel = ExpChatShared.ChannelTabDisplayLabel
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Interactable = UIBlox.Core.Control.Interactable
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local FFlagExpChatChannelTabSizingUpdate = require(ExpChat.Flags.FFlagExpChatChannelTabSizingUpdate)
local FFlagExpChatUseSharedChannelTabDisplayLabel = SharedFlags.FFlagExpChatUseSharedChannelTabDisplayLabel
local TextService

if FFlagExpChatChannelTabSizingUpdate then
	TextService = game:GetService("TextService")
else
	TextService = nil
end

local Localization = require(ExpChat.Localization)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local getUnreadIndicatorLayout = require(script.Parent.getUnreadIndicatorLayout)
local useTabImpression = require(script.Parent.useTabImpression)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local unreachable = ExpChatShared.TabTypes.unreachable
local v = FFlagExpChatChannelTabSizingUpdate and 12 or 20
local color = Color3.fromRGB(255, 255, 255)

local v2 = {
	channelName = "",
	hasUnreadMessages = false,
	isDividerVisible = false,
	isTabCollapsed = false,
	isTabSelected = false,
	tabIndex = 1,
	isTabVisibleToUser = true,
	isLayoutReady = true,
	onTabSelected = nil,
	setTransparency = nil
}

local function createUnreadDot(position: UDim2, backgroundTransparency: number)
	return React.createElement("Frame", {
		Size = UDim2.new(0, 8, 0, 8),
		Position = position,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.ChannelTabsSettings.UnreadDotColor3,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end

local function ChannelTab(p)
	local joined = dictionary.join(v2, p)
	local v3 = {
		enabled = joined.isLayoutReady,
		name = joined.channelName,
		tabType = joined.tabType,
		index = joined.tabIndex,
		inOverflow = joined.isTabCollapsed,
		visible = joined.isTabVisibleToUser,
		hasUnreadMessages = joined.hasUnreadMessages,
		isSelected = 0
	}
	local isSelected

	if FFlagExpChatGlobalTabDefault then
		isSelected = joined.isTabSelected
	end

	v3.isSelected = isSelected
	useTabImpression(v3)

	local v4 = Localization.useLocalization(not FFlagExpChatUseSharedChannelTabDisplayLabel and {
		yourServer = "CoreScripts.TextChat.ChannelTabs.Here",
		moreServers = "CoreScripts.TextChat.ChannelTabs.Global2",
		friends = "CoreScripts.TextChat.ChannelTabs.Friends",
		system = "CoreScripts.TextChat.ChannelTabs.System",
		team = "CoreScripts.TextChat.ChannelTabs.Team"
	} or ChannelTabDisplayLabel.LocalizationKeys)

	local tabType = joined.tabType
	local text = joined.channelName

	if FFlagExpChatUseSharedChannelTabDisplayLabel then
		text = ChannelTabDisplayLabel.getDisplayLabel(
			tabType,
			joined.channelName,
			joined.textChannel,
			Players.LocalPlayer,
			v4
		)
	elseif tabType == "TextChat" then
		local channelName = joined.channelName

		if string.find(channelName, "RBXGeneral") then
			text = v4.yourServer
		elseif string.find(channelName, "RBXSystem") then
			text = v4.system
		elseif string.find(channelName, "^RBXTeam") then
			text = v4.team
		else
			text = string.find(channelName, "^RBXWhisper")
				and joined.textChannel
				and Players.LocalPlayer
				and getOtherDisplayNameInWhisperChannel(joined.textChannel, Players.LocalPlayer)
				or text
		end
	elseif tabType == "UniverseChat" then
		if string.find(joined.channelName, "RBXGlobal") then
			text = v4.moreServers
		end
	elseif tabType == "FriendsChat" then
		text = v4.friends
	else
		unreachable(tabType)
	end

	local state, setState = React.useState(joined.channelTabsSettings.BackgroundColor3)
	local selectionImageObject = useSelectionCursor(CursorKind.RoundedSlot)
	local v5 = FFlagExpChatChannelTabSizingUpdate and joined.hasUnreadMessages and not joined.isTabCollapsed

	local v6 = nil
	local position = nil
	local fn

	if FFlagExpChatChannelTabSizingUpdate then
		local naturalTextWidth, v7 = React.useBinding(nil)
		local tabWidth, v8 = React.useBinding(nil)
		fn = function(p2)
			v8(p2.AbsoluteSize.X)
		end

		React.useEffect(function()
			v7(nil)

			if joined.hasUnreadMessages and not joined.isTabCollapsed then
				local v9 = false
				task.spawn(function()
					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = text
					getTextBoundsParams.Font = joined.channelTabsSettings.FontFace
					getTextBoundsParams.Size = joined.channelTabsSettings.TextSize
					getTextBoundsParams.Width = 1e999

					local success, result = pcall(function()
						return TextService:GetTextBoundsAsync(getTextBoundsParams)
					end)

					if success and not v9 then
						v7((math.ceil(result.X)))
					end
				end)

				return function()
					v9 = true
				end
			end
		end, {
			joined.channelTabsSettings.FontFace,
			joined.channelTabsSettings.TextSize,
			joined.hasUnreadMessages,
			joined.isTabCollapsed,
			text
		})

		if v5 then
			local mapped = React.joinBindings({
				naturalTextWidth = naturalTextWidth,
				tabWidth = tabWidth
			}):map(function(p2)
				return getUnreadIndicatorLayout(
					joined.hasUnreadMessages,
					joined.isTabCollapsed,
					p2.tabWidth,
					p2.naturalTextWidth,
					v,
					8,
					8
				)
			end)

			v6 = mapped:map(function(p2)
				if p2 then
					return (UDim2.new(0, p2.textWidth, 1, 0))
				end

				return (UDim2.new(1, -(v * 2 + 8 + 8), 1, 0))
			end)

			position = mapped:map(function(p2)
				if p2 then
					return (UDim2.fromOffset(p2.textLeft, 0))
				end

				return (UDim2.fromOffset(v + 8 + 8, 0))
			end)
		end
	end

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = joined.isTabCollapsed and joined.setTransparency(joined.channelTabsSettings.BackgroundTransparency) or 1,
		BackgroundColor3 = joined.isTabCollapsed and state or joined.channelTabsSettings.BackgroundColor3,
		BorderSizePixel = 0,
		ref = joined.tabRef,
		SelectionImageObject = selectionImageObject,
		onStateChanged = function() end,
		[React.Change.AbsoluteSize] = fn,
		[React.Event.Activated] = joined.onTabSelected,
		[React.Event.MouseEnter] = function()
			if joined.isTabCollapsed then
				setState(joined.channelTabsSettings.HoverBackgroundColor3)
			end
		end,
		[React.Event.MouseLeave] = function()
			if joined.isTabCollapsed then
				setState(joined.channelTabsSettings.BackgroundColor3)
			end
		end
	}

	local createElement2 = React.createElement
	local v8 = {
		Size = v6 or UDim2.fromScale(1, 1),
		Position = position,
		BackgroundTransparency = 1,
		Text = text,
		FontFace = joined.channelTabsSettings.FontFace,
		TextSize = joined.channelTabsSettings.TextSize,
		TextColor3 = joined.isTabSelected and joined.channelTabsSettings.SelectedTabTextColor3 or joined.channelTabsSettings.TextColor3,
		TextTransparency = joined.setTransparency(0),
		TextStrokeColor3 = joined.channelTabsSettings.TextStrokeColor3,
		TextStrokeTransparency = joined.setTransparency(joined.channelTabsSettings.TextStrokeTransparency),
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextTruncate = 0,
		BorderSizePixel = 0
	}
	local textXAlignment

	if v5 then
		textXAlignment = Enum.TextXAlignment.Left
	elseif joined.isTabCollapsed then
		textXAlignment = Enum.TextXAlignment.Left
	else
		textXAlignment = Enum.TextXAlignment.Center
	end

	v8.TextXAlignment = textXAlignment

	v8.TextYAlignment = Enum.TextYAlignment.Center
	v8.TextTruncate = Enum.TextTruncate.AtEnd
	local uiPadding

	if not v5 then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v + (joined.isTabCollapsed and 4 or 0)),
			PaddingRight = UDim.new(0, v)
		})
	end

	return createElement(Interactable, v7, {
		TextLabel = createElement2("TextLabel", v8, {
			UIPadding = uiPadding,
			UnreadDot = v5 and createUnreadDot(UDim2.new(0, -8, 0.5, 0), joined.setTransparency(0))
		}),
		UnreadDot = joined.hasUnreadMessages and not v5 and createUnreadDot(
			UDim2.new(0, v - 2, 0.5, 0),
			joined.setTransparency(0)
		),
		Highlight = joined.isTabSelected and React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 4),
			Position = UDim2.new(0, 0, 1, -4),
			BackgroundColor3 = color,
			BackgroundTransparency = joined.setTransparency(0),
			BorderSizePixel = 0
		}),
		Divider = joined.isDividerVisible and React.createElement("Frame", {
			AnchorPoint = joined.isTabCollapsed and Vector2.new(0, 1) or Vector2.new(0, 0.5),
			Position = joined.isTabCollapsed and UDim2.fromScale(0, 1) or UDim2.fromScale(1, 0.5),
			Size = joined.isTabCollapsed and UDim2.new(1, 0, 0, Config.ChannelTabsSettings.DividerSize) or UDim2.new(0, Config.ChannelTabsSettings.DividerSize, 0.8, 0),
			BackgroundTransparency = joined.setTransparency(Config.ChannelTabsSettings.DividerTransparency),
			BackgroundColor3 = Config.ChannelTabsSettings.DividerColor3,
			BorderSizePixel = 0
		})
	})
end

return ChannelTab
