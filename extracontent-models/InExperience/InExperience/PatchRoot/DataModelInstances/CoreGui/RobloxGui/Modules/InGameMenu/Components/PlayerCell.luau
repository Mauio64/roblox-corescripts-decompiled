local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local Cell = UIBlox.App.Table.Cell
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = UIBlox.App.Loading.LoadableImage
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local uDim = UDim.new(0, 24)
local v21 = Roact.PureComponent:extend("PlayerCell")

v21.validateProps = t.strictInterface({
	userId = t.number,
	username = t.string,
	displayName = t.optional(t.string),
	hasVerifiedBadge = t.optional(t.boolean),
	isOnline = t.optional(t.boolean),
	isSelected = t.optional(t.boolean),
	LayoutOrder = t.union(t.integer, t.table),
	Visible = t.optional(t.boolean),
	loadingStrategy = t.optional(LoadingStrategy.isEnumValue),
	onActivated = t.optional(t.callback),
	memoKey = t.optional(t.number),
	[Roact.Children] = t.optional(t.table),
	[Roact.Change.AbsolutePosition] = t.optional(t.callback),
	forwardRef = t.optional(t.union(t.callback, t.table)),
	UserInputService = t.optional(t.union(t.Instance, t.table))
})
v21.defaultProps = {
	Visible = true,
	UserInputService = UserInputService
}

function v21.init(p1) -- line: 63
	function p1.onActivated() -- line: 64
		-- upvalues: p1 (copy)
		if p1.props.onActivated and p1.props.userId then
			p1.props.onActivated(p1.props.userId)
		end
	end
end
function v21.renderButtons(p2) -- line: 71
	-- upvalues: Roact (copy), Cryo (copy)
	local v24 = p2.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v24, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5)
		})
	}))
end
function v21.renderWithSelectionCursor(p3, _) -- line: 86
	-- upvalues: withStyle (copy), Roact (copy), Cell (copy), ImageSetLabel (copy), Images (copy), uDim (copy), LoadableImage (copy), Assets (copy), VerifiedBadges (copy), ThemedTextLabel (copy)
	local props = p3.props
	local v28 = props.displayName ~= "" and props.displayName or props.username

	return withStyle(function(p5) -- line: 96
		-- upvalues: p3 (copy), Roact (copy), Cell (copy), props (copy), ImageSetLabel (copy), Images (copy), uDim (copy), LoadableImage (copy), Assets (copy), VerifiedBadges (copy), ThemedTextLabel (copy), v28 (copy)
		local BackgroundContrast = p5.Theme.BackgroundContrast
		local n1 = 1.1

		if p3.props.isSelected then
			BackgroundContrast = p5.Theme.BackgroundOnHover
			n1 = 0.23
		end

		local BackgroundContrastColor = BackgroundContrast.Color

		return Roact.createElement(Cell, {
			background = p3.props.isSelected and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = BackgroundContrastColor,
				BackgroundTransparency = BackgroundContrast.Transparency
			}) or nil,
			onActivated = p3.onActivated,
			[Roact.Change.AbsolutePosition] = p3.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = p3.props.forwardRef or nil,
			layoutOrder = props.LayoutOrder,
			size = UDim2.new(1, 0, 0, 72),
			head = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(1, -20, 0, 72),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				HeadListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				AvatarBackground = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Images["component_assets/userBG_dark"],
					Size = UDim2.new(0, 48, 0, 48)
				}, {
					BorderRadius = Roact.createElement("UICorner", {
						CornerRadius = uDim
					}),
					PlayerIcon = Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						ZIndex = 2,
						LayoutOrder = 1,
						useShimmerAnimationWhileLoading = true,
						loadingStrategy = p3.props.loadingStrategy,
						Size = UDim2.fromScale(1, 1),
						ImageColor3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
						Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or "",
						renderOnFailed = function() -- line: 149
							-- upvalues: Roact (copy), ImageSetLabel (copy), Images (copy), uDim (copy)
							return Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								ZIndex = 2,
								LayoutOrder = 1,
								Size = UDim2.fromScale(1, 1),
								Image = Images["icons/common/user"]
							}, {
								Corner = Roact.createElement("UICorner", {
									CornerRadius = uDim
								})
							})
						end,
						cornerRadius = uDim
					}),
					OnlineIndicator = p3.props.isOnline and Roact.createElement(ImageSetLabel, {
						ZIndex = 3,
						AnchorPoint = Vector2.new(1, 1),
						Image = Assets.Images.Circle,
						ImageColor3 = props.isOnline and p5.Theme.OnlineStatus.Color or nil,
						Position = UDim2.new(1, -3, 1, -3),
						Size = UDim2.new(0, 6, 0, 6)
					}, {
						Corner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 3)
						}),
						Border = Roact.createElement("UIStroke", {
							Transparency = 0,
							Thickness = 2,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.new(BackgroundContrastColor.R * n1, BackgroundContrastColor.G * n1, BackgroundContrastColor.B * n1)
						})
					}) or nil
				}),
				NameContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, -68, 0, 72),
					Position = UDim2.fromOffset(48, 0),
					AnchorPoint = Vector2.new(0, 0.5)
				}, {
					NameListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					NamePadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 6)
					}),
					DisplayNameLabel = Roact.createElement(VerifiedBadges.EmojiWrapper, {
						emoji = not props.hasVerifiedBadge and "" or VerifiedBadges.emoji.verified,
						automaticSize = Enum.AutomaticSize.None,
						size = UDim2.new(1, -40, 0, 20)
					}, {
						DisplayNameLabel = Roact.createElement(ThemedTextLabel, {
							fontKey = "CaptionHeader",
							themeKey = "TextEmphasis",
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Text = v28 or props.username,
							Size = UDim2.new(1, 0, 0, 20),
							AutomaticSize = if not props.hasVerifiedBadge then Enum.AutomaticSize.None else Enum.AutomaticSize.XY,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd
						})
					}),
					UsernameLabel = Roact.createElement(ThemedTextLabel, {
						fontKey = "Footer",
						themeKey = "TextDefault",
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(1, 0, 0, 14),
						Text = "@" .. props.username,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				})
			}),
			tail = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			}, p3:renderButtons())
		})
	end)
end
function v21.render(p6) -- line: 245
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p7) -- line: 246
		-- upvalues: p6 (copy)
		return p6:renderWithSelectionCursor(p7)
	end)
end

return React.memo(v21, function(p8, p9) -- line: 251
	-- upvalues: Roact (copy)
	return p8.isSelected == p9.isSelected and (p8.isOnline == p9.isOnline and (p8[Roact.Change.AbsolutePosition] == p9[Roact.Change.AbsolutePosition] and (p8.forwardRef == p9.forwardRef and (p8.memoKey == p9.memoKey and p8.loadingStrategy == p9.loadingStrategy))))
end)
