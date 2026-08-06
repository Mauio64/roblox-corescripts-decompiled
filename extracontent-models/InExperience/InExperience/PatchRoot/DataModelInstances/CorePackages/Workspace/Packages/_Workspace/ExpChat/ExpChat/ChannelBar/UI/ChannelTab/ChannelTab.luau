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
local v17 = if not FFlagExpChatChannelTabSizingUpdate then nil else game:GetService("TextService")
local GameLocalization = require(ExpChat.GameLocalization)
local Localization = require(ExpChat.Localization)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local getUnreadIndicatorLayout = require(script.Parent.getUnreadIndicatorLayout)
local unreachable = ExpChatShared.TabTypes.unreachable
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetFFlagEnableExpChatUniverseChatTabNames = ExpChatShared.Flags.GetFFlagEnableExpChatUniverseChatTabNames
local v25 = not FFlagExpChatChannelTabSizingUpdate and 20 or 12
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

local function createUnreadDot(uDim2: UDim2, n1: number) -- line: 65
	-- upvalues: React (copy), Config (copy)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, 8, 0, 8),
		Position = uDim2,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.ChannelTabsSettings.UnreadDotColor3,
		BackgroundTransparency = n1
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end
local function ChannelTab(t2: {[any]: any}) -- line: 80
	-- upvalues: Dictionary (copy), t1 (copy), FFlagExpChatChannelTabRefactor (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), Localization (copy), Players (copy), getOtherDisplayNameInWhisperChannel (copy), FFlagExpChatEnableFriendsTab (copy), unreachable (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), React (copy), FFlagExpChatFocusChannelBarSupport (copy), useSelectionCursor (copy), CursorKind (copy), FFlagExpChatChannelTabSizingUpdate (copy), v17 (copy), getUnreadIndicatorLayout (copy), v25 (copy), Interactable (copy), createUnreadDot (copy), color3 (copy), Config (copy)
	local v33 = Dictionary.join(t1, t2)
	local channelName = v33.channelName

	if FFlagExpChatChannelTabRefactor or GetFFlagEnableExpChatUniverseChatTabNames() then
		local v35 = Localization.useLocalization({
			yourServer = "CoreScripts.TextChat.ChannelTabs.Here",
			moreServers = "CoreScripts.TextChat.ChannelTabs.Global2",
			friends = "CoreScripts.TextChat.ChannelTabs.Friends"
		})

		if FFlagExpChatChannelTabRefactor then
			local tabType = v33.tabType

			if tabType == "TextChat" then
				local channelName2 = v33.channelName

				if string.find(channelName2, "RBXGeneral") then
					channelName = v35.yourServer
				elseif string.find(channelName2, "RBXSystem") then
					channelName = "System"
				elseif string.find(channelName2, "^RBXTeam") then
					channelName = "Team"
				elseif string.find(channelName2, "^RBXWhisper") and v33.textChannel and Players.LocalPlayer then
					local v38 = getOtherDisplayNameInWhisperChannel(v33.textChannel, Players.LocalPlayer)

					if v38 then
						channelName = v38
					end
				end
			elseif tabType == "UniverseChat" then
				if string.find(v33.channelName, "RBXGlobal") then
					channelName = v35.moreServers
				end
			elseif FFlagExpChatEnableFriendsTab and tabType == "FriendsChat" then
				channelName = v35.friends
			else
				unreachable(tabType)
			end
		elseif GetFFlagEnableExpChatUniverseChatTabNames() then
			if string.find(v33.channelName, "RBXGeneral") then
				channelName = v35.yourServer
			elseif GetFFlagTextChatEnableUniverseChatTabs() and string.find(v33.channelName, "RBXGlobal") then
				channelName = v35.moreServers
			end
		end
	end

	local v39 = if not FFlagExpChatChannelTabRefactor and not GetFFlagEnableExpChatUniverseChatTabNames() then v33.channelName else channelName
	local v40, v41 = React.useState(v33.channelTabsSettings.BackgroundColor3)
	local v42 = if not FFlagExpChatFocusChannelBarSupport then nil else useSelectionCursor(CursorKind.RoundedSlot)
	local v43 = FFlagExpChatChannelTabSizingUpdate and (v33.hasUnreadMessages and not v33.isTabCollapsed)
	local v44 = nil
	local v45 = nil
	local v46 = nil

	if FFlagExpChatChannelTabSizingUpdate then
		local v47, v48 = React.useBinding(nil)
		local v49, v50 = React.useBinding(nil)

		function v44(p1) -- line: 146
			-- upvalues: v50 (copy)
			v50(p1.AbsoluteSize.X)
		end

		React.useEffect(function() -- line: 151
			-- upvalues: v48 (copy), v33 (copy), v39 (copy), v17 (copy)
			v48(nil)

			if not v33.hasUnreadMessages or v33.isTabCollapsed then
				return
			end

			local u56 = false

			task.spawn(function() -- line: 158
				-- upvalues: v39 (copy), v33 (copy), v17 (copy), u56 (ref), v48 (copy)
				local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

				GetTextBoundsParams.Text = v39
				GetTextBoundsParams.Font = v33.channelTabsSettings.FontFace
				GetTextBoundsParams.Size = v33.channelTabsSettings.TextSize
				GetTextBoundsParams.Width = 1e999

				local ok, result = pcall(function() -- line: 165
					-- upvalues: v17 (copy), GetTextBoundsParams (copy)
					return v17:GetTextBoundsAsync(GetTextBoundsParams)
				end)

				if ok and not u56 then
					v48((math.ceil(result.X)))
				end
			end)

			return function() -- line: 173
				-- upvalues: u56 (ref)
				u56 = true
			end
		end, {
			v33.channelTabsSettings.FontFace,
			v33.channelTabsSettings.TextSize,
			v33.hasUnreadMessages,
			v33.isTabCollapsed,
			v39
		})

		if v43 then
			local v51 = React.joinBindings({
				naturalTextWidth = v47,
				tabWidth = v49
			}):map(function(p2) -- line: 190
				-- upvalues: getUnreadIndicatorLayout (copy), v33 (copy), v25 (copy)
				return getUnreadIndicatorLayout(v33.hasUnreadMessages, v33.isTabCollapsed, p2.tabWidth, p2.naturalTextWidth, v25, 8, 8)
			end)

			v45 = v51:map(function(p3) -- line: 201
				-- upvalues: v25 (copy)
				if p3 then
					return (UDim2.new(0, p3.textWidth, 1, 0))
				end

				return (UDim2.new(1, -(v25 * 2 + 8 + 8), 1, 0))
			end)
			v46 = v51:map(function(p4) -- line: 206
				-- upvalues: v25 (copy)
				if p4 then
					return (UDim2.fromOffset(p4.textLeft, 0))
				end

				return (UDim2.fromOffset(v25 + 8 + 8, 0))
			end)
		end
	end

	return React.createElement(Interactable, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v33.isTabCollapsed and v33.setTransparency(v33.channelTabsSettings.BackgroundTransparency) or 1,
		BackgroundColor3 = v33.isTabCollapsed and v40 or v33.channelTabsSettings.BackgroundColor3,
		BorderSizePixel = 0,
		SelectionImageObject = v42,
		onStateChanged = function() -- line: 222
		end,
		[React.Change.AbsoluteSize] = v44,
		[React.Event.Activated] = v33.onTabSelected,
		[React.Event.MouseEnter] = function() -- line: 225
			-- upvalues: v33 (copy), v41 (copy)
			if v33.isTabCollapsed then
				v41(v33.channelTabsSettings.HoverBackgroundColor3)
			end
		end,
		[React.Event.MouseLeave] = function() -- line: 230
			-- upvalues: v33 (copy), v41 (copy)
			if v33.isTabCollapsed then
				v41(v33.channelTabsSettings.BackgroundColor3)
			end
		end
	}, {
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v45 or UDim2.fromScale(1, 1),
			Position = v46,
			Text = v39,
			FontFace = v33.channelTabsSettings.FontFace,
			TextSize = v33.channelTabsSettings.TextSize,
			TextColor3 = v33.isTabSelected and v33.channelTabsSettings.SelectedTabTextColor3 or v33.channelTabsSettings.TextColor3,
			TextTransparency = v33.setTransparency(0),
			TextStrokeColor3 = v33.channelTabsSettings.TextStrokeColor3,
			TextStrokeTransparency = v33.setTransparency(v33.channelTabsSettings.TextStrokeTransparency),
			TextXAlignment = if not v43 then if not v33.isTabCollapsed then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left else Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UIPadding = if not v43 then React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v25 + (not v33.isTabCollapsed and 0 or 4)),
				PaddingRight = UDim.new(0, v25)
			}) else nil,
			UnreadDot = v43 and createUnreadDot(UDim2.new(0, -8, 0.5, 0), v33.setTransparency(0))
		}),
		UnreadDot = v33.hasUnreadMessages and (not v43 and createUnreadDot(UDim2.new(0, v25 - 2, 0.5, 0), v33.setTransparency(0))),
		Highlight = v33.isTabSelected and React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 4),
			Position = UDim2.new(0, 0, 1, -4),
			BackgroundColor3 = color3,
			BackgroundTransparency = v33.setTransparency(0)
		}),
		Divider = v33.isDividerVisible and React.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = v33.isTabCollapsed and Vector2.new(0, 1) or Vector2.new(0, 0.5),
			Position = v33.isTabCollapsed and UDim2.fromScale(0, 1) or UDim2.fromScale(1, 0.5),
			Size = v33.isTabCollapsed and UDim2.new(1, 0, 0, Config.ChannelTabsSettings.DividerSize) or UDim2.new(0, Config.ChannelTabsSettings.DividerSize, 0.8, 0),
			BackgroundTransparency = v33.setTransparency(Config.ChannelTabsSettings.DividerTransparency),
			BackgroundColor3 = Config.ChannelTabsSettings.DividerColor3
		})
	})
end

return GameLocalization.connect(function(p5) -- line: 287
	-- upvalues: FFlagExpChatChannelTabRefactor (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), Players (copy), getOtherDisplayNameInWhisperChannel (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local channelName = p5.channelName

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
		if p5.textChannel and Players.LocalPlayer then
			local v54 = getOtherDisplayNameInWhisperChannel(p5.textChannel, Players.LocalPlayer)

			if v54 then
				channelName = v54
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
