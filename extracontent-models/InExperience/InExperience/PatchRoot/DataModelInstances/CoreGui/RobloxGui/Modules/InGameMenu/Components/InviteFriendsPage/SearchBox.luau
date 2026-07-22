local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v9 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local v17 = Roact.PureComponent:extend("SearchBox")

v17.validateProps = t.strictInterface({
	Size = t.UDim2,
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	searchUpdated = t.callback,
	searchCleared = t.callback,
	itemRef = t.optional(t.table)
})

function v17.init(p1) -- line: 50
	p1.state = {
		searchText = ""
	}
end
function v17.renderWithSelectionCursor(p2, p3) -- line: 56
	-- upvalues: withLocalization (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), v10 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
	return withLocalization({
		searchPlaceholder = "CoreScripts.InGameMenu.InviteFriends.Search"
	})(function(p4) -- line: 59
		-- upvalues: withFoundationOrUIBloxStyle (copy), p2 (copy), Roact (copy), p3 (copy), v10 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
		return withFoundationOrUIBloxStyle(function(p5) -- line: 60
			return {
				Theme = {
					TextEmphasis = {
						Color = p5.Color.Content.Emphasis.Color3,
						Transparency = p5.Color.Content.Emphasis.Transparency
					},
					IconEmphasis = {
						Color = p5.Color.Content.Emphasis.Color3,
						Transparency = p5.Color.Content.Emphasis.Transparency
					},
					BackgroundUIContrast = {
						Color = p5.Color.OverMedia.OverMedia_0.Color3,
						Transparency = p5.Color.OverMedia.OverMedia_0.Transparency
					},
					Divider = {
						Color = p5.Color.Stroke.Emphasis.Color3,
						Transparency = p5.Color.Stroke.Emphasis.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					Body = {
						Font = p5.Typography.BodyLarge.Font,
						RelativeSize = p5.Typography.BodyLarge.FontSize
					}
				}
			}
		end, function(p6) -- line: 73
			-- upvalues: p2 (copy), Roact (copy), p3 (copy), v10 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), p4 (copy)
			local TextEmphasis = p6.Theme.TextEmphasis
			local Body = p6.Font.Body
			local v28 = p2.state.searchText ~= ""
			local n1 = 49

			if v28 then
				n1 += 46
			end

			local v30 = Roact.createElement("TextButton", {
				Size = UDim2.fromOffset(32, 32),
				Position = UDim2.new(1, -7, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Visible = v28,
				SelectionImageObject = p3(v10.SmallPill),
				Selectable = true,
				[Roact.Event.Activated] = function() -- line: 94
					-- upvalues: p2 (copy)
					p2:setState({
						searchText = ""
					})
					p2.props.searchCleared()
				end
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
					PaddingBottom = UDim.new(0, 7)
				}),
				ClearImage = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Selectable = false,
					Size = UDim2.fromScale(1, 1),
					Image = Assets.Images.ClearIcon,
					ImageColor3 = p6.Theme.IconEmphasis.Color
				}) else Roact.createElement(FoundationImage, {
					Size = UDim2.fromScale(1, 1),
					Image = Assets.Images.ClearIcon.Image,
					imageRect = {
						offset = Assets.Images.ClearIcon.ImageRectOffset,
						size = Assets.Images.ClearIcon.ImageRectSize
					},
					imageStyle = {
						Transparency = 0,
						Color3 = p6.Theme.IconEmphasis.Color
					}
				})
			})

			return Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = p2.props.Size,
				Position = p2.props.Position,
				AnchorPoint = p2.props.AnchorPoint,
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p6.Theme.BackgroundUIContrast.Color,
				ImageTransparency = p6.Theme.BackgroundUIContrast.Transparency,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}, {
				Border = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Image = Assets.Images.RoundedRectBorder.Image,
					SliceCenter = Assets.Images.RoundedRectBorder.SliceCenter,
					ScaleType = Assets.Images.RoundedRectBorder.ScaleType,
					ImageColor3 = p6.Theme.Divider.Color,
					ImageTransparency = p6.Theme.Divider.Transparency
				}),
				SearchIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.SearchIcon,
					ImageColor3 = p6.Theme.IconEmphasis.Color
				}) else Roact.createElement(FoundationImage, {
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.SearchIcon.Image,
					imageRect = {
						offset = Assets.Images.SearchIcon.ImageRectOffset,
						size = Assets.Images.SearchIcon.ImageRectSize
					},
					imageStyle = {
						Transparency = 0,
						Color3 = p6.Theme.IconEmphasis.Color
					}
				}),
				TextBox = Roact.createElement("TextBox", {
					Size = UDim2.new(1, -n1, 1, 0),
					Position = UDim2.new(0, 44, 0, 0),
					PlaceholderText = "",
					Text = p2.state.searchText,
					ClearTextOnFocus = false,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = TextEmphasis.Color,
					TextTransparency = TextEmphasis.Transparency,
					Font = Body.Font,
					TextSize = Body.RelativeSize * p6.Font.BaseSize,
					TextWrapped = false,
					SelectionImageObject = p3(v10.InputFields),
					[Roact.Change.Text] = function(p7) -- line: 181
						-- upvalues: p2 (copy)
						if p2.state.searchText ~= p7.Text then
							p2:setState({
								searchText = p7.Text
							})
							p2.props.searchUpdated(p7.Text)
						end
					end,
					[Roact.Ref] = p2.props.itemRef
				}),
				PlaceholderText = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextEmphasis",
					fontKey = "Body",
					TextTransparency = 0.5,
					ZIndex = 2,
					Text = p4.searchPlaceholder,
					Size = UDim2.new(1, -44, 1, 0),
					Position = UDim2.new(0, 44, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					Visible = p2.state.searchText == ""
				}),
				ClearButton = v30
			})
		end)
	end)
end
function v17.render(p8) -- line: 211
	-- upvalues: v9 (copy)
	return v9(function(p9) -- line: 212
		-- upvalues: p8 (copy)
		return p8:renderWithSelectionCursor(p9)
	end)
end

return v17
