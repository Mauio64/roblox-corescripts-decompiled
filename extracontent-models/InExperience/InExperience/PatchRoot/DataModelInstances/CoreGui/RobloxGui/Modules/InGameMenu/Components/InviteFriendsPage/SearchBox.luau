local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v14 = Roact.PureComponent:extend("SearchBox")

v14.validateProps = t.strictInterface({
	Size = t.UDim2,
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	searchUpdated = t.callback,
	searchCleared = t.callback,
	itemRef = t.optional(t.table)
})

function v14.init(p1) -- line: 41
	p1.state = {
		searchText = ""
	}
end
function v14.renderWithSelectionCursor(p2, p3) -- line: 47
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), CursorKind (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy)
	return withLocalization({
		searchPlaceholder = "CoreScripts.InGameMenu.InviteFriends.Search"
	})(function(p4) -- line: 50
		-- upvalues: withStyle (copy), p2 (copy), Roact (copy), p3 (copy), CursorKind (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy)
		return withStyle(function(p5) -- line: 51
			-- upvalues: p2 (copy), Roact (copy), p3 (copy), CursorKind (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), p4 (copy)
			local TextEmphasis = p5.Theme.TextEmphasis
			local Body = p5.Font.Body
			local v24 = p2.state.searchText ~= ""
			local n1 = 49

			if v24 then
				n1 += 46
			end

			local v26 = Roact.createElement("TextButton", {
				Size = UDim2.fromOffset(32, 32),
				Position = UDim2.new(1, -7, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Visible = v24,
				SelectionImageObject = p3(CursorKind.SmallPill),
				Selectable = true,
				[Roact.Event.Activated] = function() -- line: 72
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
				ClearImage = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Selectable = false,
					Size = UDim2.fromScale(1, 1),
					Image = Assets.Images.ClearIcon,
					ImageColor3 = p5.Theme.IconEmphasis.Color
				})
			})

			return Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = p2.props.Size,
				Position = p2.props.Position,
				AnchorPoint = p2.props.AnchorPoint,
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p5.Theme.BackgroundUIContrast.Color,
				ImageTransparency = p5.Theme.BackgroundUIContrast.Transparency,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}, {
				Border = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Image = Assets.Images.RoundedRectBorder.Image,
					SliceCenter = Assets.Images.RoundedRectBorder.SliceCenter,
					ScaleType = Assets.Images.RoundedRectBorder.ScaleType,
					ImageColor3 = p5.Theme.Divider.Color,
					ImageTransparency = p5.Theme.Divider.Transparency
				}),
				SearchIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.SearchIcon,
					ImageColor3 = p5.Theme.IconEmphasis.Color
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
					TextSize = Body.RelativeSize * p5.Font.BaseSize,
					TextWrapped = false,
					SelectionImageObject = p3(CursorKind.InputFields),
					[Roact.Change.Text] = function(p6) -- line: 143
						-- upvalues: p2 (copy)
						if p2.state.searchText ~= p6.Text then
							p2:setState({
								searchText = p6.Text
							})
							p2.props.searchUpdated(p6.Text)
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
				ClearButton = v26
			})
		end)
	end)
end
function v14.render(p7) -- line: 173
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p8) -- line: 174
		-- upvalues: p7 (copy)
		return p7:renderWithSelectionCursor(p8)
	end)
end

return v14
