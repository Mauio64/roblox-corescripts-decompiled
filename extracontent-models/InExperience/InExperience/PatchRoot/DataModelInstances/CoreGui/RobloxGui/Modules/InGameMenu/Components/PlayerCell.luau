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
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local LoadableImage = UIBlox.App.Loading.LoadableImage
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local Images = UIBlox.App.ImageSet.Images
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local v19 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local uDim = UDim.new(0, 24)
local v24 = Roact.PureComponent:extend("PlayerCell")

v24.validateProps = t.strictInterface({
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
v24.defaultProps = {
	Visible = true,
	UserInputService = UserInputService
}

function v24.init(p1) -- line: 71
	function p1.onActivated() -- line: 72
		-- upvalues: p1 (copy)
		if p1.props.onActivated and p1.props.userId then
			p1.props.onActivated(p1.props.userId)
		end
	end
end
function v24.renderButtons(p2) -- line: 79
	-- upvalues: Roact (copy), Cryo (copy)
	local v27 = p2.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v27, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5)
		})
	}))
end
function v24.renderWithSelectionCursor(p3, _) -- line: 94
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), uDim (copy), LoadableImage (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), Assets (copy), Cell (copy), VerifiedBadges (copy), ThemedTextLabel (copy)
	local props = p3.props
	local v31 = props.displayName ~= "" and props.displayName or props.username

	return withFoundationOrUIBloxStyle(function(p5) -- line: 104
		return {
			Theme = {
				BackgroundContrast = {
					Color = p5.Color.Surface.Surface_100.Color3,
					Transparency = p5.Color.Surface.Surface_100.Transparency
				},
				BackgroundOnHover = {
					Color = p5.Color.State.Hover.Color3,
					Transparency = p5.Color.State.Hover.Transparency
				},
				OnlineStatus = {
					Color = p5.Color.System.Success.Color3,
					Transparency = p5.Color.System.Success.Transparency
				}
			}
		}
	end, function(p6) -- line: 112
		-- upvalues: p3 (copy), Roact (copy), uDim (copy), LoadableImage (copy), props (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), Assets (copy), Cell (copy), VerifiedBadges (copy), ThemedTextLabel (copy), v31 (copy)
		local BackgroundContrast = p6.Theme.BackgroundContrast
		local n1 = 1.1

		if p3.props.isSelected then
			BackgroundContrast = p6.Theme.BackgroundOnHover
			n1 = 0.23
		end

		local BackgroundContrastColor = BackgroundContrast.Color
		local t1 = {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 3)
			}),
			Border = Roact.createElement("UIStroke", {
				Transparency = 0,
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.new(BackgroundContrastColor.R * n1, BackgroundContrastColor.G * n1, BackgroundContrastColor.B * n1)
			})
		}
		local t2 = {
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
				renderOnFailed = function() -- line: 152
					-- upvalues: FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationImage (copy), uDim (copy), ImageSetLabel (copy), Images (copy)
					if FFlagCoreUiMigrateUIBloxToFoundation then
						return Roact.createElement(FoundationImage, {
							Image = "icons/common/user",
							ZIndex = 2,
							LayoutOrder = 1,
							Size = UDim2.fromScale(1, 1),
							cornerRadius = uDim
						})
					end

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
			OnlineIndicator = p3.props.isOnline and (if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				ZIndex = 3,
				AnchorPoint = Vector2.new(1, 1),
				Image = Assets.Images.Circle,
				ImageColor3 = props.isOnline and p6.Theme.OnlineStatus.Color or nil,
				Position = UDim2.new(1, -3, 1, -3),
				Size = UDim2.new(0, 6, 0, 6)
			}, t1) else Roact.createElement(FoundationImage, {
				ZIndex = 3,
				AnchorPoint = Vector2.new(1, 1),
				Image = Assets.Images.Circle,
				imageStyle = {
					Transparency = 0,
					Color3 = props.isOnline and p6.Theme.OnlineStatus.Color or nil
				},
				Position = UDim2.new(1, -3, 1, -3),
				Size = UDim2.new(0, 6, 0, 6)
			}, t1)) or nil
		}

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
				AvatarBackground = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Images["component_assets/userBG_dark"],
					Size = UDim2.new(0, 48, 0, 48)
				}, t2) else Roact.createElement(FoundationImage, {
					Image = "component_assets/userBG_dark",
					Size = UDim2.new(0, 48, 0, 48)
				}, t2),
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
							Text = v31 or props.username,
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
function v24.render(p7) -- line: 291
	-- upvalues: v19 (copy)
	return v19(function(p8) -- line: 292
		-- upvalues: p7 (copy)
		return p7:renderWithSelectionCursor(p8)
	end)
end

return React.memo(v24, function(p9, p10) -- line: 297
	-- upvalues: Roact (copy)
	return p9.isSelected == p10.isSelected and (p9.isOnline == p10.isOnline and (p9[Roact.Change.AbsolutePosition] == p10[Roact.Change.AbsolutePosition] and (p9.forwardRef == p10.forwardRef and (p9.memoKey == p10.memoKey and p9.loadingStrategy == p10.loadingStrategy))))
end)
