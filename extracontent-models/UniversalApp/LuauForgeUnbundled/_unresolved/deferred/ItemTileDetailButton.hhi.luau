local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local interactable = UIBlox.Core.Control.Interactable

local useStyle = UIBlox.Core.Style.useStyle

local function ItemTileDetailButton(p2)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font
	local v7 = useLocalization({
		detail = p2.itemsCount and {
			"Feature.Avatar.Label.Details",
			quantity = p2.itemsCount
		} or "Feature.Avatar.Label.DetailsButton"
	})

	return Roact.createElement(interactable, {
		Size = UDim2.new(1, 0, 0, 28),
		Position = UDim2.new(0, 0, 1, -28),
		BackgroundColor3 = theme.BackgroundUIDefault.Color,
		[Roact.Event.Activated] = p2.activateButton,
		ZIndex = 10,
		BackgroundTransparency = 1
	}, {
		BoundingFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.SystemPrimaryDefault.Color
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10)
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
				TextSize = font.CaptionHeader.RelativeSize * font.BaseSize,
				Text = v7.detail,
				TextColor3 = theme.SystemPrimaryContent.Color
			})
		})
	})
end

return ItemTileDetailButton
