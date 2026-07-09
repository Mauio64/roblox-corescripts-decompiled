local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withStyle = UIBlox.Style.withStyle
local t = dependencies.t
local Mock = dependencies.Mock
local Images = UIBlox.App.ImageSet.Images
local StyledImageSetLabel = require(SocialTab.Components.StyledImageSetLabel)
local StyledTextLabel = require(SocialTab.Components.StyledTextLabel)
local calculateTextSize = require(SocialTab.utils.calculateTextSize)
local withLocalization = dependencies.withLocalization
local LocalizedKeys = require(SocialTab.Enums.LocalizedKeys)
local v14 = Roact.PureComponent:extend("AddFriendsTile")

v14.defaultProps = {
	accountProviderName = "",
	layoutOrder = 0,
	shouldInviteFromAccountProvider = false,
	thumbnailSize = 96,
	totalHeight = 96,
	onActivated = function() -- line: 25
	end
}
v14.validateProps = t.interface({
	accountProviderName = t.optional(t.string),
	layoutOrder = t.optional(t.number),
	onActivated = t.optional(t.union(t.callback, Mock.MagicMock.is)),
	shouldInviteFromAccountProvider = t.optional(t.boolean),
	thumbnailSize = t.number,
	totalHeight = t.number
})

function v14.init(p1) -- line: 40
	-- upvalues: calculateTextSize (copy)
	p1.calculateTextSize = calculateTextSize()
end
function v14.render(p2) -- line: 44
	-- upvalues: LocalizedKeys (copy), withLocalization (copy), withStyle (copy), Roact (copy), StyledImageSetLabel (copy), Images (copy), StyledTextLabel (copy)
	local v17 = LocalizedKeys.AddFriend.rawValue()

	if p2.props.shouldInviteFromAccountProvider and p2.props.accountProviderName ~= "" then
		v17 = {
			LocalizedKeys.InviteFriend.rawValue(),
			provider = p2.props.accountProviderName
		}
	end

	return withLocalization({
		addFriendText = v17
	})(function(p3) -- line: 56
		-- upvalues: withStyle (copy), Roact (copy), p2 (copy), StyledImageSetLabel (copy), Images (copy), StyledTextLabel (copy)
		return withStyle(function(p4) -- line: 57
			-- upvalues: Roact (copy), p2 (copy), StyledImageSetLabel (copy), Images (copy), StyledTextLabel (copy), p3 (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p2.props.thumbnailSize, 0, p2.props.totalHeight),
				LayoutOrder = p2.props.layoutOrder
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8)
				}),
				AddFriendButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, p2.props.thumbnailSize, 0, p2.props.thumbnailSize),
					BackgroundColor3 = p4.Theme.UIEmphasis.Color,
					Text = "",
					BackgroundTransparency = p4.Theme.UIEmphasis.Transparency,
					[Roact.Event.Activated] = p2.props.onActivated
				}, {
					AddFriendButtonBorder = Roact.createElement(StyledImageSetLabel, {
						Image = Images["component_assets/circle_68_stroke_2"],
						ImageStyle = p4.Theme.SecondaryDefault,
						Size = UDim2.new(0, p2.props.thumbnailSize, 0, p2.props.thumbnailSize)
					}, {
						AddIcon = Roact.createElement(StyledImageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Image = Images["icons/actions/friends/friendAdd"],
							ImageStyle = p4.Theme.IconEmphasis,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0.45, 0, 0.45, 0)
						})
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					})
				}),
				AddFriendsLabel = Roact.createElement(StyledTextLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					FontStyle = p4.Font.CaptionHeader,
					Size = UDim2.new(0, p2.props.thumbnailSize, 0, p2.calculateTextSize(p3.addFriendText .. "...", p4.Font.CaptionHeader, p4.Font.BaseSize).Y),
					TextStyle = p4.Theme.TextEmphasis,
					Text = p3.addFriendText,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Center
				})
			})
		end)
	end)
end

return v14
