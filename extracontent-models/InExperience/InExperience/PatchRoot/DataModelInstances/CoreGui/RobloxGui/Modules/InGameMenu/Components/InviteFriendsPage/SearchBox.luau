local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent.Parent

local Assets = require(parent.Resources.Assets)
local withLocalization = require(parent.Localization.withLocalization)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = Foundation.Image

local extended = Roact.PureComponent:extend("SearchBox")

extended.validateProps = t.strictInterface({
	Size = t.UDim2,
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	searchUpdated = t.callback,
	searchCleared = t.callback,
	itemRef = t.optional(t.table)
})

function extended:init()
	self.state = { searchText = "" }
end

function extended:renderWithSelectionCursor(callback)
	return withLocalization({ searchPlaceholder = "CoreScripts.InGameMenu.InviteFriends.Search" })(function(p)
		return withFoundationOrUIBloxStyle(function(tokens)
			return {
				Tokens = tokens,
				Theme = {
					TextEmphasis = {
						Color = tokens.Color.Content.Emphasis.Color3,
						Transparency = tokens.Color.Content.Emphasis.Transparency
					},
					IconEmphasis = {
						Color = tokens.Color.Content.Emphasis.Color3,
						Transparency = tokens.Color.Content.Emphasis.Transparency
					},
					BackgroundUIContrast = {
						Color = tokens.Color.OverMedia.OverMedia_0.Color3,
						Transparency = tokens.Color.OverMedia.OverMedia_0.Transparency
					},
					Divider = {
						Color = tokens.Color.Stroke.Emphasis.Color3,
						Transparency = tokens.Color.Stroke.Emphasis.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					Body = {
						Font = tokens.Typography.BodyLarge.Font,
						RelativeSize = tokens.Typography.BodyLarge.FontSize
					}
				}
			}
		end, function(props)
			local textEmphasis = props.Theme.TextEmphasis
			local body = props.Font.Body

			local visible = self.state.searchText ~= ""
			local total = 49

			if visible then
				total += 46
			end

			local createElement = Roact.createElement
			local v3 = {
				Size = UDim2.fromOffset(32, 32),
				Position = UDim2.new(1, -7, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Visible = visible,
				SelectionImageObject = callback(v2.SmallPill),
				Selectable = true,
				[Roact.Event.Activated] = function()
					self:setState({ searchText = "" })

					self.props.searchCleared()
				end
			}
			local v4 = {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
					PaddingBottom = UDim.new(0, 7)
				}),
				ClearImage = 0
			}
			local clearImage

			if FFlagCoreUiMigrateUIBloxToFoundation then
				clearImage = Roact.createElement(Image, {
					Size = UDim2.fromScale(1, 1),
					Image = Assets.Images.ClearIcon.Image,
					imageRect = {
						offset = Assets.Images.ClearIcon.ImageRectOffset,
						size = Assets.Images.ClearIcon.ImageRectSize
					},
					imageStyle = { Color3 = props.Theme.IconEmphasis.Color, Transparency = 0 }
				})
			else
				clearImage = Roact.createElement(ImageSetLabel, {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Image = Assets.Images.ClearIcon,
					ImageColor3 = props.Theme.IconEmphasis.Color,
					Selectable = false
				})
			end

			v4.ClearImage = clearImage
			local element = createElement("TextButton", v3, v4)

			local createElement2 = Roact.createElement
			local v5 = {
				BackgroundTransparency = 1,
				Size = self.props.Size,
				Position = self.props.Position,
				AnchorPoint = self.props.AnchorPoint,
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = props.Theme.BackgroundUIContrast.Color,
				ImageTransparency = props.Theme.BackgroundUIContrast.Transparency,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}
			local children = {
				Border = Roact.createElement(ImageSetLabel, {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = Assets.Images.RoundedRectBorder.Image,
					SliceCenter = Assets.Images.RoundedRectBorder.SliceCenter,
					ScaleType = Assets.Images.RoundedRectBorder.ScaleType,
					ImageColor3 = props.Theme.Divider.Color,
					ImageTransparency = props.Theme.Divider.Transparency
				}),
				SearchIcon = 0,
				TextBox = 0,
				PlaceholderText = 0,
				ClearButton = 0
			}
			local searchIcon

			if FFlagCoreUiMigrateUIBloxToFoundation then
				searchIcon = Roact.createElement(Image, {
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.SearchIcon.Image,
					imageRect = {
						offset = Assets.Images.SearchIcon.ImageRectOffset,
						size = Assets.Images.SearchIcon.ImageRectSize
					},
					imageStyle = { Color3 = props.Theme.IconEmphasis.Color, Transparency = 0 }
				})
			else
				searchIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.SearchIcon,
					ImageColor3 = props.Theme.IconEmphasis.Color
				})
			end

			children.SearchIcon = searchIcon

			children.TextBox = Roact.createElement("TextBox", {
				Size = UDim2.new(1, -total, 1, 0),
				Position = UDim2.new(0, 44, 0, 0),
				PlaceholderText = "",
				Text = self.state.searchText,
				ClearTextOnFocus = false,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = textEmphasis.Color,
				TextTransparency = textEmphasis.Transparency,
				FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
				TextSize = body.RelativeSize * props.Font.BaseSize,
				TextWrapped = false,
				SelectionImageObject = callback(v2.InputFields),
				[Roact.Change.Text] = function(p2)
					if self.state.searchText ~= p2.Text then
						self:setState({ searchText = p2.Text })

						self.props.searchUpdated(p2.Text)
					end
				end,
				[Roact.Ref] = self.props.itemRef
			})

			children.PlaceholderText = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextEmphasis",
				fontKey = "Body",
				Text = p.searchPlaceholder,
				Size = UDim2.new(1, -44, 1, 0),
				Position = UDim2.new(0, 44, 0, 0),
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				Visible = self.state.searchText == ""
			})

			children.ClearButton = element
			return createElement2(ImageSetLabel, v5, children)
		end)
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
