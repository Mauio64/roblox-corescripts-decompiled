local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local Cell = UIBlox.App.Table.Cell
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)
local GameIcon = require(Dependencies.GameIcon)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)

local extended = Roact.PureComponent:extend("GameCell")

extended.validateProps = t.strictInterface({
	gameId = t.number,
	layoutOrder = t.optional(t.union(t.integer, t.table)),
	onActivated = t.optional(t.callback)
})

function extended:renderWithSelectionCursor(_)
	local props = self.props
	return withLocalization({ labelText = "CoreScripts.InGameMenu.Report.ReportExperience" })(function(p)
		return Roact.createElement(Cell, {
			onActivated = props.onActivated,
			layoutOrder = props.layoutOrder,
			size = UDim2.new(1, 0, 0, 72),
			head = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 72)
			}, {
				GameIcon = Roact.createElement(GameIcon, {
					gameId = props.gameId,
					iconSize = 48,
					cornerRadius = UDim.new(0, 8),
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5)
				}),
				Label = Roact.createElement(ThemedTextLabel, {
					fontKey = "Header2",
					themeKey = "TextEmphasis",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = p.labelText,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 54, 0.5, 0)
				})
			}),
			tail = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			})
		})
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
