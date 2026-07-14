local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local Assets = require(ParentParent.Resources.Assets)
local React = require(CorePackages.Packages.React)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v15 = Roact.PureComponent:extend("GameLabel")

v15.validateProps = t.strictInterface({
	gameId = t.number,
	gameName = t.string,
	LayoutOrder = t.integer,
	onActivated = t.optional(t.callback),
	[Roact.Children] = t.optional(t.table),
	buttonRef = t.optional(t.table)
})

function v15.renderButtons(p1) -- line: 42
	-- upvalues: Roact (copy), Cryo (copy)
	local v17 = p1.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v17, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end
function v15.renderWithSelectionCursor(p2, p3) -- line: 57
	-- upvalues: Assets (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), React (copy), CursorKind (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
	local gameId = p2.props.gameId
	local PlaceholderGameIcon = Assets.Images.PlaceholderGameIcon

	if p2.props.gameId > 0 then
		PlaceholderGameIcon = "rbxthumb://type=GameIcon&id=" .. gameId .. "&w=150&h=150"
	end

	return withFoundationOrUIBloxStyle(function(_) -- line: 64
		return {}
	end, function(_) -- line: 66
		-- upvalues: Roact (copy), React (copy), p2 (copy), p3 (copy), CursorKind (copy), ImageSetLabel (copy), PlaceholderGameIcon (ref), ThemedTextLabel (copy)
		return Roact.createElement("TextButton", {
			[React.Tag] = "data-testid=experienceLabel",
			BackgroundTransparency = 1,
			LayoutOrder = p2.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 70),
			Text = "",
			AutoButtonColor = false,
			SelectionImageObject = p3(CursorKind.Square),
			[Roact.Ref] = p2.props.buttonRef,
			[Roact.Event.Activated] = p2.props.onActivated
		}, {
			GameIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 24, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				Image = PlaceholderGameIcon
			}),
			GameNameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = p2.props.gameName,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			ButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			}, p2:renderButtons())
		})
	end)
end
function v15.render(p6) -- line: 108
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p7) -- line: 109
		-- upvalues: p6 (copy)
		return p6:renderWithSelectionCursor(p7)
	end)
end

return Roact.forwardRef(function(p8, p9) -- line: 114
	-- upvalues: Roact (copy), v15 (copy), Cryo (copy)
	return Roact.createElement(v15, Cryo.Dictionary.join(p8, {
		buttonRef = p9
	}))
end)
