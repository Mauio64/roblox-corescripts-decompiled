local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FilteredConversationList = require(script.Parent.FilteredConversationList)
local GameBanner = require(script.Parent.GameBanner)
local v6 = Roact.PureComponent:extend("ShareTargetGame")

v6.defaultProps = {
	byBuilderText = "By (placeholder)",
	gameName = "Placeholder Game",
	gameThumbnail = "rbxasset://textures/grid2.png",
	shouldShowCreatorName = true,
	offlinePresence = nil,
	onlinePresence = nil,
	filterBoxPlaceHolderText = nil,
	sendText = nil,
	sentText = nil,
	sendingText = nil,
	failedText = nil,
	onSendButtonActivated = nil,
	conversationListScrollTouchedBottom = nil,
	LayoutOrder = nil,
	isLoading = false,
	conversations = {
		{
			title = "PlaceholderName1"
		},
		{
			title = "PlaceholderName2"
		},
		{
			title = "PlaceholderName3"
		}
	},
	conversationSendingStatus = {}
}

function v6.render(p1) -- line: 49
	-- upvalues: UIBlox (copy), Roact (copy), GameBanner (copy), FilteredConversationList (copy)
	return UIBlox.Style.withStyle(function(_) -- line: 50
		-- upvalues: Roact (copy), p1 (copy), GameBanner (copy), FilteredConversationList (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -72),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			gameBanner = Roact.createElement(GameBanner, {
				LayoutOrder = 1,
				creator = p1.props.byBuilderText,
				shouldShowCreatorName = p1.props.shouldShowCreatorName,
				name = p1.props.gameName,
				thumbnail = p1.props.gameThumbnail,
				isLoading = p1.props.isLoading
			}),
			conversationListContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, -88)
			}, {
				conversationList = Roact.createElement(FilteredConversationList, {
					entryHeight = 52,
					conversations = p1.props.formattedConversations,
					conversationSendingStatuses = p1.props.conversationSendingStatuses,
					touchedBottomCallback = p1.props.conversationListScrollTouchedBottom,
					filterBoxPlaceHolderText = p1.props.filterBoxPlaceHolderText,
					onSendButtonActivated = p1.props.onSendButtonActivated,
					sendText = p1.props.sendText,
					sentText = p1.props.sentText,
					sendingText = p1.props.sendingText,
					failedText = p1.props.failedText,
					isLoading = p1.props.isLoading,
					offlinePresence = p1.props.offlinePresence,
					onlinePresence = p1.props.onlinePresence
				})
			})
		})
	end)
end

return v6
