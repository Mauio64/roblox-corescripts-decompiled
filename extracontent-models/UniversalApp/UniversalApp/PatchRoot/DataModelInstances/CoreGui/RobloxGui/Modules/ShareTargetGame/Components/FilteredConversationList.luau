local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local dependencies = require(ShareTargetGame.dependencies)
local Roact = dependencies.Roact
local SocialLibraries = dependencies.SocialLibraries
local UIBlox = dependencies.UIBlox
local User = dependencies.User
local FilteredScrollingList = SocialLibraries.Components.FilteredScrollingList
local conversationSortComparator = require(ShareTargetGame.Utils.conversationSortComparator)
local ConversationCellWithSendButton = require(script.Parent.ConversationCellWithSendButton)
local v10 = Roact.PureComponent:extend("FilteredConversationList")

v10.defaultProps = {
	touchedBottomCallback = nil,
	filterBoxPlaceHolderText = nil,
	offlinePresence = nil,
	onlinePresence = nil,
	sendText = "Send",
	sentText = "Sent",
	sendingText = "Sending",
	failedText = "Failed",
	entryHeight = nil,
	isLoading = false,
	searchFilterPredicate = function(p1, p2) -- line: 17
		local title = p2.title

		if not p1 or p1 == "" then
			return true
		end

		return string.find(string.lower(title), string.lower(p1), 1, true) ~= nil
	end,
	conversations = {},
	conversationSendingStatuses = {},
	onSendButtonActivated = function(_) -- line: 42
	end
}

function v10.init(p4) -- line: 45
	-- upvalues: User (copy), Roact (copy), ConversationCellWithSendButton (copy)
	local t1 = {
		title = ""
	}

	p4.loadingEntries = table.create(3, t1)

	function p4.renderConversationCell(p5) -- line: 50
		-- upvalues: User (copy), p4 (copy), Roact (copy), ConversationCellWithSendButton (copy)
		local v20 = not p5.presence and "" or if p5.presence ~= User.PresenceType.ONLINE then if p5.presence ~= User.PresenceType.OFFLINE then p5.lastLocation else p4.props.offlinePresence else p4.props.onlinePresence

		return Roact.createElement(ConversationCellWithSendButton, {
			conversation = p5,
			sentStatus = p4.props.conversationSendingStatuses[p5.conversationId],
			subTitleText = v20,
			sendText = p4.props.sendText,
			sentText = p4.props.sentText,
			sendingText = p4.props.sendingText,
			failedText = p4.props.failedText,
			secondaryTitleText = p5.alias,
			onSendButtonActivated = p4.props.onSendButtonActivated,
			isLoading = p4.props.isLoading
		})
	end
end
function v10.render(p6) -- line: 79
	-- upvalues: UIBlox (copy), Roact (copy), FilteredScrollingList (copy), conversationSortComparator (copy)
	local v18 = p6.props.isLoading and p6.loadingEntries or p6.props.conversations

	return UIBlox.Style.withStyle(function(p7) -- line: 82
		-- upvalues: Roact (copy), FilteredScrollingList (copy), p6 (copy), v18 (copy), conversationSortComparator (copy)
		local Theme = p7.Theme
		local p7Font = p7.Font

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			dividerTop = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			filterBoxContainer = Roact.createElement(FilteredScrollingList, {
				searchBoxHeight = 48,
				searchIconCellWidth = 60,
				searchIconSize = 24,
				searchIconImage = "rbxasset://textures/ui/LuaChat/icons/ic-search.png",
				searchClearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
				searchDividerHeight = 1,
				LayoutOrder = 2,
				searchBackgroundColor3 = Theme.UIMuted.Color,
				searchBackgroundTransparency = Theme.UIMuted.Transparency,
				searchIconColor3 = Theme.TextDefault.Color,
				searchIconTransparency = Theme.TextDefault.Transparency,
				searchInputTextFont = p7Font.Body.Font,
				searchInputTextColor3 = Theme.TextDefault.Color,
				searchInputTextSize = p7Font.BaseSize * p7Font.Body.RelativeSize,
				searchInputTextTransparency = Theme.TextDefault.Transparency,
				searchPlaceholderTextTransparency = Theme.PlaceHolder.Transparency,
				searchPlaceholderTextColor3 = Theme.TextDefault.Color,
				searchPlaceholderText = p6.props.filterBoxPlaceHolderText,
				searchClearIconColor3 = Theme.TextDefault.Color,
				searchDividerColor3 = Theme.Divider.Color,
				searchDividerTransparency = Theme.Divider.Transparency,
				scrollBarImageTransparency = p7.Theme.UIDefault.Transparency,
				scrollBarImageColor3 = p7.Theme.UIDefault.Color,
				entries = v18,
				renderEntry = p6.renderConversationCell,
				entryHeight = p6.props.entryHeight,
				scrollTouchedBottomCallback = p6.props.touchedBottomCallback,
				filterPredicate = p6.props.searchFilterPredicate,
				sortComparator = conversationSortComparator
			})
		})
	end)
end

return v10
