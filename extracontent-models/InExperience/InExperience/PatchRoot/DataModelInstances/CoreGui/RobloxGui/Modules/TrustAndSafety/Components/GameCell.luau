local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cell = UIBlox.App.Table.Cell
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local GameIcon = require(Dependencies.GameIcon)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)
local v12 = Roact.PureComponent:extend("GameCell")

v12.validateProps = t.strictInterface({
	gameId = t.number,
	layoutOrder = t.optional(t.union(t.integer, t.table)),
	onActivated = t.optional(t.callback)
})

function v12.renderWithSelectionCursor(p1, _) -- line: 27
	-- upvalues: withLocalization (copy), Roact (copy), Cell (copy), GameIcon (copy), ThemedTextLabel (copy)
	local props = p1.props

	return withLocalization({
		labelText = "CoreScripts.InGameMenu.Report.ReportExperience"
	})(function(p3) -- line: 31
		-- upvalues: Roact (copy), Cell (copy), props (copy), GameIcon (copy), ThemedTextLabel (copy)
		return Roact.createElement(Cell, {
			onActivated = props.onActivated,
			layoutOrder = props.layoutOrder,
			size = UDim2.new(1, 0, 0, 72),
			head = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 72)
			}, {
				GameIcon = Roact.createElement(GameIcon, {
					iconSize = 48,
					gameId = props.gameId,
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
					Text = p3.labelText,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 54, 0.5, 0)
				})
			}),
			tail = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			})
		})
	end)
end
function v12.render(p4) -- line: 69
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p5) -- line: 70
		-- upvalues: p4 (copy)
		return p4:renderWithSelectionCursor(p5)
	end)
end

return v12
