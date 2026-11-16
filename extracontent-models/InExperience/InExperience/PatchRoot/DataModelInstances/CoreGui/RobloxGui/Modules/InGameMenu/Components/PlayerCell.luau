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
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local LoadableImage = UIBlox.App.Loading.LoadableImage
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local Images = UIBlox.App.ImageSet.Images
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local udim = UDim.new(0, 24)

local extended = Roact.PureComponent:extend("PlayerCell")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { Visible = true, UserInputService = UserInputService }

function extended:init()
	function self.onActivated()
		if self.props.onActivated and self.props.userId then
			self.props.onActivated(self.props.userId)
		end
	end
end

function extended:renderButtons()
	local v2 = self.props[Roact.Children] or {}
	return (Cryo.Dictionary.join(v2, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5)
		})
	}))
end

function extended:renderWithSelectionCursor(_)
	local props = self.props
	local displayName = props.displayName ~= "" and props.displayName or props.username

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundContrast = {
					Color = p.Color.Surface.Surface_100.Color3,
					Transparency = p.Color.Surface.Surface_100.Transparency
				},
				BackgroundOnHover = {
					Color = p.Color.State.Hover.Color3,
					Transparency = p.Color.State.Hover.Transparency
				},
				OnlineStatus = {
					Color = p.Color.System.Success.Color3,
					Transparency = p.Color.System.Success.Transparency
				}
			}
		}
	end, function(p)
		local v2 = p.Theme.BackgroundContrast
		local v3

		if self.props.isSelected then
			v2 = p.Theme.BackgroundOnHover
			v3 = 0.23
		else
			v3 = 1.1
		end

		local color = v2.Color

		local v4 = {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 3) }),
			Border = Roact.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.new(color.R * v3, color.G * v3, color.B * v3),
				Transparency = 0,
				Thickness = 2
			})
		}

		local v5 = {
			BorderRadius = Roact.createElement("UICorner", { CornerRadius = udim }),
			PlayerIcon = Roact.createElement(LoadableImage, {
				loadingStrategy = self.props.loadingStrategy,
				Size = UDim2.fromScale(1, 1),
				ImageColor3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
				BackgroundTransparency = 1,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or "",
				ZIndex = 2,
				LayoutOrder = 1,
				useShimmerAnimationWhileLoading = true,
				renderOnFailed = function()
					if FFlagCoreUiMigrateUIBloxToFoundation then
						return Roact.createElement(Image, {
							Size = UDim2.fromScale(1, 1),
							Image = "icons/common/user",
							ZIndex = 2,
							LayoutOrder = 1,
							cornerRadius = udim
						})
					end

					return Roact.createElement(ImageSetLabel, {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Image = Images["icons/common/user"],
						ZIndex = 2,
						LayoutOrder = 1
					}, {
						Corner = Roact.createElement("UICorner", { CornerRadius = udim })
					})
				end,
				cornerRadius = udim
			}),
			OnlineIndicator = 0
		}
		local onlineIndicator

		if self.props.isOnline then
			local v6

			if FFlagCoreUiMigrateUIBloxToFoundation then
				v6 = Roact.createElement(Image, {
					AnchorPoint = Vector2.new(1, 1),
					Image = Assets.Images.Circle,
					imageStyle = {
						Color3 = props.isOnline and p.Theme.OnlineStatus.Color or nil,
						Transparency = 0
					},
					Position = UDim2.new(1, -3, 1, -3),
					Size = UDim2.new(0, 6, 0, 6),
					ZIndex = 3
				}, v4)
			else
				v6 = Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(1, 1),
					Image = Assets.Images.Circle,
					ImageColor3 = props.isOnline and p.Theme.OnlineStatus.Color or nil,
					Position = UDim2.new(1, -3, 1, -3),
					Size = UDim2.new(0, 6, 0, 6),
					ZIndex = 3
				}, v4)
			end

			onlineIndicator = v6 or nil
		end

		v5.OnlineIndicator = onlineIndicator

		local createElement = Roact.createElement
		local children = {
			background = self.props.isSelected and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = color,
				BackgroundTransparency = v2.Transparency
			}) or nil,
			onActivated = self.onActivated,
			[Roact.Change.AbsolutePosition] = self.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = self.props.forwardRef or nil,
			layoutOrder = props.LayoutOrder,
			size = UDim2.new(1, 0, 0, 72)
		}
		local createElement2 = Roact.createElement
		local v6 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(1, -20, 0, 72),
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local v7 = {
			HeadListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			AvatarBackground = 0,
			NameContainer = 0
		}
		local avatarBackground

		if FFlagCoreUiMigrateUIBloxToFoundation then
			avatarBackground = Roact.createElement(
				Image,
				{ Image = "component_assets/userBG_dark", Size = UDim2.new(0, 48, 0, 48) },
				v5
			)
		else
			avatarBackground = Roact.createElement(
				ImageSetLabel,
				{
					BackgroundTransparency = 1,
					Image = Images["component_assets/userBG_dark"],
					Size = UDim2.new(0, 48, 0, 48)
				},
				v5
			)
		end

		v7.AvatarBackground = avatarBackground

		local createElement3 = Roact.createElement
		local v8 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -68, 0, 72),
			Position = UDim2.fromOffset(48, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			LayoutOrder = 2
		}

		local children2 = {
			NameListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			NamePadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 6) }),
			DisplayNameLabel = 0,
			UsernameLabel = 0
		}

		local createElement4 = Roact.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v9 = {
			emoji = not props.hasVerifiedBadge and "" or VerifiedBadges.emoji.verified,
			automaticSize = Enum.AutomaticSize.None,
			size = UDim2.new(1, -40, 0, 20)
		}

		local createElement5 = Roact.createElement
		local v10 = {
			fontKey = "CaptionHeader",
			themeKey = "TextEmphasis",
			BackgroundTransparency = 1,
			Text = displayName or props.username,
			Size = UDim2.new(1, 0, 0, 20),
			AutomaticSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0,
			LayoutOrder = 1
		}
		local automaticSize

		if props.hasVerifiedBadge then
			automaticSize = Enum.AutomaticSize.XY
		else
			automaticSize = Enum.AutomaticSize.None
		end

		v10.AutomaticSize = automaticSize

		v10.TextXAlignment = Enum.TextXAlignment.Left
		v10.TextTruncate = Enum.TextTruncate.AtEnd
		children2.DisplayNameLabel = createElement4(emojiWrapper, v9, {
			DisplayNameLabel = createElement5(ThemedTextLabel, v10)
		})

		children2.UsernameLabel = Roact.createElement(ThemedTextLabel, {
			fontKey = "Footer",
			themeKey = "TextDefault",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, 0, 0, 14),
			Text = "@" .. props.username,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 2
		})
		v7.NameContainer = createElement3("Frame", v8, children2)
		children.head = createElement2("Frame", v6, v7)

		children.tail = Roact.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			},
			self:renderButtons()
		)
		return createElement(Cell, children)
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return React.memo(extended, function(data, data2): boolean
	return data.isSelected == data2.isSelected
		and data.isOnline == data2.isOnline
		and data[Roact.Change.AbsolutePosition] == data2[Roact.Change.AbsolutePosition]
		and data.forwardRef == data2.forwardRef
		and data.memoKey == data2.memoKey
		and data.loadingStrategy == data2.loadingStrategy
end)
