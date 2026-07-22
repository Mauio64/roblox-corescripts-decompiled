local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v11 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local Assets = require(ParentParent.Resources.Assets)
local React = require(CorePackages.Packages.React)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local v18 = Roact.PureComponent:extend("GameLabel")

v18.validateProps = t.strictInterface({
	gameId = t.number,
	gameName = t.string,
	LayoutOrder = t.integer,
	onActivated = t.optional(t.callback),
	[Roact.Children] = t.optional(t.table),
	buttonRef = t.optional(t.table)
})

function v18.renderButtons(p1) -- line: 51
	-- upvalues: Roact (copy), Cryo (copy)
	local v20 = p1.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v20, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end
function v18.renderWithSelectionCursor(p2, p3) -- line: 66
	-- upvalues: Assets (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), React (copy), v11 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
	local gameId = p2.props.gameId
	local PlaceholderGameIcon = Assets.Images.PlaceholderGameIcon

	if p2.props.gameId > 0 then
		PlaceholderGameIcon = "rbxthumb://type=GameIcon&id=" .. gameId .. "&w=150&h=150"
	end

	return withFoundationOrUIBloxStyle(function(_) -- line: 73
		return {}
	end, function(_) -- line: 75
		-- upvalues: Roact (copy), React (copy), p2 (copy), p3 (copy), v11 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), PlaceholderGameIcon (ref), ImageSetLabel (copy), ThemedTextLabel (copy)
		return Roact.createElement("TextButton", {
			[React.Tag] = "data-testid=experienceLabel",
			BackgroundTransparency = 1,
			LayoutOrder = p2.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 70),
			Text = "",
			AutoButtonColor = false,
			SelectionImageObject = p3(v11.Square),
			[Roact.Ref] = p2.props.buttonRef,
			[Roact.Event.Activated] = p2.props.onActivated
		}, {
			GameIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 24, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				Image = PlaceholderGameIcon
			}) else Roact.createElement(FoundationImage, {
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
function v18.render(p6) -- line: 124
	-- upvalues: v10 (copy)
	return v10(function(p7) -- line: 125
		-- upvalues: p6 (copy)
		return p6:renderWithSelectionCursor(p7)
	end)
end

return Roact.forwardRef(function(p8, p9) -- line: 130
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p8, {
		buttonRef = p9
	}))
end)
