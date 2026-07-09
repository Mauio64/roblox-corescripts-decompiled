local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local Mock = dependencies.Mock
local Badge = UIBlox.App.Indicator.Badge
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local withStyle = UIBlox.Style.withStyle
local LocalizedKeys = require(SocialTab.Enums.LocalizedKeys)
local withLocalization = dependencies.withLocalization
local v14 = Roact.PureComponent:extend("UserCarouselHeader")

v14.defaultProps = {
	friendCount = 0,
	hasFriendRequests = false,
	layoutOrder = 0,
	goToFriendRequestsPage = function() -- line: 30
	end,
	goToFriendsPage = function() -- line: 31
	end
}
v14.validateProps = t.interface({
	friendCount = t.number,
	hasFriendRequests = t.boolean,
	layoutOrder = t.optional(t.number),
	goToFriendRequestsPage = t.union(t.callback, Mock.MagicMock.is),
	goToFriendsPage = t.union(t.callback, Mock.MagicMock.is)
})

function v14.init(p1) -- line: 42
	function p1.goToFriendRequestsPage(...) -- line: 43
		-- upvalues: p1 (copy)
		return p1.props.goToFriendRequestsPage(...)
	end
end
function v14.render(p2) -- line: 48
	-- upvalues: LocalizedKeys (copy), withLocalization (copy), withStyle (copy), Roact (copy), Badge (copy), BadgeStates (copy), IconButton (copy), Images (copy)
	local v17 = p2.props.friendCount ~= 0 and {
		LocalizedKeys.FriendsHeaderWithCount.rawValue(),
		friendCount = p2.props.friendCount
	} or LocalizedKeys.FriendsHeader.rawValue()

	return withLocalization({
		headerText = v17
	})(function(p3) -- line: 58
		-- upvalues: withStyle (copy), Roact (copy), Badge (copy), BadgeStates (copy), p2 (copy), IconButton (copy), Images (copy)
		return withStyle(function(p4) -- line: 59
			-- upvalues: Roact (copy), Badge (copy), BadgeStates (copy), p2 (copy), p3 (copy), IconButton (copy), Images (copy)
			local v20 = Roact.createElement(Badge, {
				position = UDim2.new(0.6, 2, 0, 6),
				anchorPoint = Vector2.new(0, 0.5),
				value = BadgeStates.isEmpty
			}) or Roact.createElement(Badge, {
				value = "",
				position = UDim2.new(0.6, 0, 0, 0),
				anchorPoint = Vector2.new(0, 0.5)
			})

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p2.props.layoutOrder,
				Size = UDim2.new(1, 0, 0, 50)
			}, {
				Title = Roact.createElement("TextButton", {
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Font = p4.Font.Header1.Font,
					Size = UDim2.new(0, 0, 0, 50),
					Text = p3.headerText,
					TextColor3 = p4.Theme.TextEmphasis.Color,
					TextSize = p4.Font.Header1.RelativeSize * p4.Font.BaseSize,
					TextTransparency = p4.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					[Roact.Event.Activated] = p2.props.goToFriendsPage
				}),
				FriendRequests = Roact.createElement(IconButton, {
					size = UDim2.fromOffset(28, 28),
					icon = Images["icons/actions/friends/friendAdd"],
					position = UDim2.new(1, 0, 0.5, 0),
					anchorPoint = Vector2.new(1, 0.5),
					onActivated = p2.goToFriendRequestsPage
				}, {
					FriendRequestsBadge = p2.props.hasFriendRequests and v20 or nil
				})
			})
		end)
	end)
end

return v14
