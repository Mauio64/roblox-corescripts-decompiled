local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local FilteredScrollingList = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/FilteredScrollingList")
local module2 = require("@luauforge/deferred/gcX")

local extended = Roact.PureComponent:extend("ShareTargetGame")
extended.defaultProps = {
	byBuilderText = "By (placeholder)",
	gameName = "Placeholder Game",
	gameThumbnail = "rbxasset://textures/grid2.png",
	shouldShowCreatorName = true,
	conversations = {
		{ title = "PlaceholderName1" },
		{ title = "PlaceholderName2" },
		{ title = "PlaceholderName3" }
	},
	conversationSendingStatus = {},
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
	isLoading = false
}

function extended.render(p2)
	return UIBlox.Style.withStyle(function(p3)
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, -72),
				BackgroundTransparency = 1,
				LayoutOrder = p2.props.LayoutOrder
			},
			{
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				gameBanner = Roact.createElement(module2, {
					creator = p2.props.byBuilderText,
					shouldShowCreatorName = p2.props.shouldShowCreatorName,
					name = p2.props.gameName,
					thumbnail = p2.props.gameThumbnail,
					isLoading = p2.props.isLoading,
					LayoutOrder = 1
				}),
				conversationListContainer = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, -88),
						BackgroundTransparency = 1,
						LayoutOrder = 2
					},
					{
						conversationList = Roact.createElement(FilteredScrollingList, {
							conversations = p2.props.formattedConversations,
							conversationSendingStatuses = p2.props.conversationSendingStatuses,
							touchedBottomCallback = p2.props.conversationListScrollTouchedBottom,
							filterBoxPlaceHolderText = p2.props.filterBoxPlaceHolderText,
							onSendButtonActivated = p2.props.onSendButtonActivated,
							sendText = p2.props.sendText,
							sentText = p2.props.sentText,
							sendingText = p2.props.sendingText,
							failedText = p2.props.failedText,
							isLoading = p2.props.isLoading,
							entryHeight = 52,
							offlinePresence = p2.props.offlinePresence,
							onlinePresence = p2.props.onlinePresence
						})
					}
				)
			}
		)
	end)
end

return extended
