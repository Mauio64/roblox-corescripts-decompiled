local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Skeleton = dependencies.Foundation.Skeleton
local withStyle = UIBlox.Style.withStyle
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local Mock = dependencies.Mock
local t = dependencies.t
local Images = UIBlox.App.ImageSet.Images
local StyledImageSetLabel = require(SocialTab.Components.StyledImageSetLabel)
local User = require(SocialTab.User)
local StyledTextLabel = require(SocialTab.Components.StyledTextLabel)
local getSocialTabUserProfileApiEnabled = require(SocialTab.Flags.getSocialTabUserProfileApiEnabled)
local calculateTextSize = require(SocialTab.utils.calculateTextSize)
local isSocialTabAutoSizedCarouselAndTileEnabled2 = require(SocialTab.Flags.isSocialTabAutoSizedCarouselAndTileEnabled2)

local function getLastLocationText(p1) -- line: 34
	return p1 and p1:gsub("^Playing%s*", "") or ""
end

local v18 = Roact.PureComponent:extend("UserTile")

v18.defaultProps = {
	enableDisplayNamePolicy = false,
	height = 120,
	layoutOrder = 0,
	thumbnailSize = 96,
	absolutePosition = 1,
	onActivated = function() -- line: 43
	end
}
v18.validateProps = t.interface({
	enableDisplayNamePolicy = t.optional(t.boolean),
	height = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	onActivated = t.optional(t.union(t.callback, Mock.MagicMock.is)),
	thumbnailSize = t.optional(t.number),
	user = User.validateUser,
	absolutePosition = t.optional(t.number),
	shouldShimmerName = t.optional(t.boolean),
	combinedName = t.optional(t.string)
})

function v18.init(p2) -- line: 60
	-- upvalues: Roact (copy), calculateTextSize (copy)
	p2.userTileRef = Roact.createRef()

	function p2.onActivated() -- line: 63
		-- upvalues: p2 (copy)
		local user = p2.props.user

		if user and p2.userTileRef.current then
			p2.props.onActivated({
				source = "SocialTab",
				user = user,
				positionIndex = p2.props.layoutOrder,
				absolutePosition = p2.props.absolutePosition,
				anchorSpaceSize = p2.userTileRef.current.AbsoluteSize,
				anchorSpacePosition = p2.userTileRef.current.AbsolutePosition
			})
		end
	end

	p2.calculateTextBounds = calculateTextSize()
end
function v18.render(p3) -- line: 82
	-- upvalues: getSocialTabUserProfileApiEnabled (copy), PresenceType (copy), withStyle (copy), Roact (copy), isSocialTabAutoSizedCarouselAndTileEnabled2 (copy), StyledImageSetLabel (copy), Images (copy), StyledTextLabel (copy), Skeleton (copy)
	local user = p3.props.user
	local u23 = not getSocialTabUserProfileApiEnabled() and (not not p3.props.enableDisplayNamePolicy and user.displayName) or user.username

	if getSocialTabUserProfileApiEnabled() and p3.props.combinedName then
		u23 = p3.props.combinedName
	end

	local v24 = user.userPresenceType ~= PresenceType.Offline
	local lastLocation = user.lastLocation
	local v26 = lastLocation and lastLocation:gsub("^Playing%s*", "") or ""
	local v27 = (user.userPresenceType == PresenceType.InGame or user.userPresenceType == PresenceType.InStudio) and v26

	return withStyle(function(p4) -- line: 97
		-- upvalues: p3 (copy), v26 (copy), u23 (ref), Roact (copy), isSocialTabAutoSizedCarouselAndTileEnabled2 (copy), StyledImageSetLabel (copy), v24 (copy), Images (copy), StyledTextLabel (copy), Skeleton (copy), v27 (copy)
		local CaptionHeader = p4.Font.CaptionHeader
		local v31 = CaptionHeader.RelativeSize * p4.Font.BaseSize
		local CaptionSubHeader = p4.Font.CaptionSubHeader
		local v33 = p3.calculateTextBounds(v26 .. "...", CaptionSubHeader, p4.Font.BaseSize)
		local v34 = p3.calculateTextBounds(u23, CaptionHeader, p4.Font.BaseSize)
		local v35 = math.min(p3.props.thumbnailSize - 12 - 4, v34.X)

		return Roact.createElement("TextButton", {
			AutomaticSize = isSocialTabAutoSizedCarouselAndTileEnabled2() and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
			Size = UDim2.new(0, p3.props.thumbnailSize, 0, p3.props.height + v33.Y),
			BackgroundTransparency = 1,
			Text = "",
			LayoutOrder = p3.props.layoutOrder,
			[Roact.Ref] = p3.userTileRef,
			[Roact.Event.Activated] = p3.onActivated
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			Thumbnail = Roact.createElement(StyledImageSetLabel, {
				LayoutOrder = 1,
				BackgroundStyle = p4.Theme.PlaceHolder,
				Image = p3.props.user.thumbnail,
				Size = UDim2.new(0, p3.props.thumbnailSize, 0, p3.props.thumbnailSize)
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			}),
			UserInfo = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = isSocialTabAutoSizedCarouselAndTileEnabled2() and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
				Size = UDim2.new(1, 0, 0, p3.props.height - p3.props.thumbnailSize)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				UsernameFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v31)
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					PresenceIcon = v24 and Roact.createElement(StyledImageSetLabel, {
						LayoutOrder = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = Images["component_assets/circle_25"],
						ImageStyle = p4.Theme.OnlineStatus,
						Position = UDim2.fromScale(0.5, 0.5),
						ScaleType = Enum.ScaleType.Slice,
						Size = UDim2.new(0, 12, 0, 12),
						SliceCenter = Rect.new(12, 12, 13, 13)
					}) or nil,
					Username = if p3.props.shouldShimmerName then nil else Roact.createElement(StyledTextLabel, {
						LayoutOrder = 2,
						FontStyle = CaptionHeader,
						Size = UDim2.new(0, v35, 0, v34.Y),
						TextStyle = p4.Theme.TextEmphasis,
						Text = u23,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					ShimmerName = if not p3.props.shouldShimmerName then nil else Roact.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(0.8, 0.8)
					})
				}),
				InGameOrStudioTitle = Roact.createElement(StyledTextLabel, {
					LayoutOrder = 2,
					FontStyle = CaptionSubHeader,
					Size = UDim2.new(1, 0, 0, v33.Y),
					TextStyle = p4.Theme.TextMuted,
					Text = v27 and v26 or "",
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Center
				})
			})
		})
	end)
end

return v18
