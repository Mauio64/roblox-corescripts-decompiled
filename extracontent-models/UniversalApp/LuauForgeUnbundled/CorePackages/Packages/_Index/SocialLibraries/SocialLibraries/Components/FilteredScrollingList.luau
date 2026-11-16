local module = require("@luauforge/deferred/gce")
local roact = module.Roact
local socialLibraries = module.SocialLibraries
local uiBlox = module.UIBlox
local user = module.User

local filteredScrollingList = socialLibraries.Components.FilteredScrollingList

local module2 = require("@luauforge/deferred/gci")
local module3 = require("@luauforge/deferred/gcj")

local extended = roact.PureComponent:extend("FilteredConversationList")
extended.defaultProps = {
	searchFilterPredicate = function(value, p2): boolean
		local title = p2.title

		if value and value ~= "" then
			return string.find(string.lower(title), string.lower(value), 1, true) ~= nil
		end

		return true
	end,
	conversations = {},
	conversationSendingStatuses = {},
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
	onSendButtonActivated = function(p2) end
}

function extended:init()
	self.loadingEntries = table.create(3, { title = "" })

	function self.renderConversationCell(props)
		local v5

		if props.presence then
			if props.presence == user.PresenceType.ONLINE then
				v5 = self.props.onlinePresence
			elseif props.presence == user.PresenceType.OFFLINE then
				v5 = self.props.offlinePresence
			else
				v5 = props.lastLocation
			end
		else
			v5 = ""
		end

		return roact.createElement(module3, {
			conversation = props,
			sentStatus = self.props.conversationSendingStatuses[props.conversationId],
			subTitleText = v5,
			sendText = self.props.sendText,
			sentText = self.props.sentText,
			sendingText = self.props.sendingText,
			failedText = self.props.failedText,
			secondaryTitleText = props.alias,
			onSendButtonActivated = self.props.onSendButtonActivated,
			isLoading = self.props.isLoading
		})
	end
end

function extended.render(data)
	local loadingEntries = data.props.isLoading and data.loadingEntries or data.props.conversations

	return uiBlox.Style.withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		return roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			layout = roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			dividerTop = roact.createElement("Frame", {
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				LayoutOrder = 1
			}),
			filterBoxContainer = roact.createElement(filteredScrollingList, {
				searchBoxHeight = 48,
				searchBackgroundColor3 = theme.UIMuted.Color,
				searchBackgroundTransparency = theme.UIMuted.Transparency,
				searchIconCellWidth = 60,
				searchIconSize = 24,
				searchIconColor3 = theme.TextDefault.Color,
				searchIconTransparency = theme.TextDefault.Transparency,
				searchIconImage = "rbxasset://textures/ui/LuaChat/icons/ic-search.png",
				searchInputTextFont = font.Body.Font,
				searchInputTextColor3 = theme.TextDefault.Color,
				searchInputTextSize = font.BaseSize * font.Body.RelativeSize,
				searchInputTextTransparency = theme.TextDefault.Transparency,
				searchPlaceholderTextTransparency = theme.PlaceHolder.Transparency,
				searchPlaceholderTextColor3 = theme.TextDefault.Color,
				searchPlaceholderText = data.props.filterBoxPlaceHolderText,
				searchClearIconColor3 = theme.TextDefault.Color,
				searchClearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
				searchDividerColor3 = theme.Divider.Color,
				searchDividerTransparency = theme.Divider.Transparency,
				searchDividerHeight = 1,
				scrollBarImageTransparency = p2.Theme.UIDefault.Transparency,
				scrollBarImageColor3 = p2.Theme.UIDefault.Color,
				entries = loadingEntries,
				renderEntry = data.renderConversationCell,
				entryHeight = data.props.entryHeight,
				scrollTouchedBottomCallback = data.props.touchedBottomCallback,
				filterPredicate = data.props.searchFilterPredicate,
				sortComparator = module2,
				LayoutOrder = 2
			})
		})
	end)
end

return extended
