local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
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
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local Assets = require(parent.Resources.Assets)

local React = require(CorePackages.Packages.React)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = Foundation.Image

local extended = Roact.PureComponent:extend("GameLabel")

extended.validateProps = t.strictInterface({
	gameId = t.number,
	gameName = t.string,
	LayoutOrder = t.integer,
	onActivated = t.optional(t.callback),
	[Roact.Children] = t.optional(t.table),
	buttonRef = t.optional(t.table)
})

function extended:renderButtons()
	local v3 = self.props[Roact.Children] or {}
	return (Cryo.Dictionary.join(v3, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end

function extended:renderWithSelectionCursor(callback)
	local gameId = self.props.gameId
	local image = Assets.Images.PlaceholderGameIcon

	if self.props.gameId > 0 then
		image = "rbxthumb://type=GameIcon&id=" .. gameId .. "&w=150&h=150"
	end

	return withFoundationOrUIBloxStyle(function(_)
		return {}
	end, function(_)
		local createElement = Roact.createElement
		local v3 = {
			[React.Tag] = "data-testid=experienceLabel",
			BackgroundTransparency = 1,
			LayoutOrder = self.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 70),
			Text = "",
			AutoButtonColor = false,
			SelectionImageObject = callback(v2.Square),
			[Roact.Ref] = self.props.buttonRef,
			[Roact.Event.Activated] = self.props.onActivated
		}
		local gameIcon

		if FFlagCoreUiMigrateUIBloxToFoundation then
			gameIcon = Roact.createElement(Image, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 24, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				Image = image
			})
		else
			gameIcon = Roact.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 24, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				BackgroundTransparency = 1,
				Image = image
			})
		end

		return createElement("TextButton", v3, {
			GameIcon = gameIcon,
			GameNameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = self.props.gameName,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			ButtonContainer = Roact.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -24, 0, 0),
					Size = UDim2.new(0, 0, 1, 0)
				},
				self:renderButtons()
			)
		})
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return Roact.forwardRef(function(p, buttonRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { buttonRef = buttonRef }))
end)
