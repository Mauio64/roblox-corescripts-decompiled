local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Interactable = UIBlox.Core.Control.Interactable
local useStyle = UIBlox.Core.Style.useStyle

local function ItemTileDetailButton(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), useLocalization (copy), Roact (copy), Interactable (copy)
	local v9 = useStyle()
	local Theme = v9.Theme
	local Font = v9.Font
	local v12 = not t1.itemsCount and "Feature.Avatar.Label.DetailsButton" or {
		"Feature.Avatar.Label.Details",
		quantity = t1.itemsCount
	}
	local v13 = useLocalization({
		detail = v12
	})

	return Roact.createElement(Interactable, {
		Size = UDim2.new(1, 0, 0, 28),
		Position = UDim2.new(0, 0, 1, -28),
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		[Roact.Event.Activated] = t1.activateButton,
		ZIndex = 10,
		BackgroundTransparency = 1
	}, {
		BoundingFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Theme.SystemPrimaryDefault.Color
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10)
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Font = Font.CaptionHeader.Font,
				TextSize = Font.CaptionHeader.RelativeSize * Font.BaseSize,
				Text = v13.detail,
				TextColor3 = Theme.SystemPrimaryContent.Color
			})
		})
	})
end

return ItemTileDetailButton
