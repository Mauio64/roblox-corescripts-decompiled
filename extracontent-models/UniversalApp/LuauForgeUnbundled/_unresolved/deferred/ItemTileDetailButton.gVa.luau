local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local interactable = UIBlox.Core.Control.Interactable

local useStyle = UIBlox.Core.Style.useStyle

local function ItemTileDetailButton(p2)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font
	local v6 = useLocalization({
		detail = p2.itemsCount and {
			"Feature.Avatar.Label.Details",
			quantity = p2.itemsCount
		} or "Feature.Avatar.Label.DetailsButton"
	})

	local createElement = Roact.createElement
	local activateButtonsByActivated = {
		Size = UDim2.new(1, 0, 0, 28),
		Position = UDim2.new(0, 0, 1, -28),
		BackgroundColor3 = theme.BackgroundUIDefault.Color,
		[Roact.Event.Activated] = p2.activateButton,
		ZIndex = 10,
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v10 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = theme.SystemPrimaryDefault.Color
	}
	local v11 = {
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
		Text = 0
	}

	local createElement3 = Roact.createElement
	local v13 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		Text = 0,
		TextColor3 = 0
	}
	local v14 = if not foundationFontFaceMigration then font.CaptionHeader.Font else nil
	v13.Font = v14

	local v15 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font) else nil
	v13.FontFace = v15

	v13.TextSize = font.CaptionHeader.RelativeSize * font.BaseSize
	v13.Text = v6.detail
	v13.TextColor3 = theme.SystemPrimaryContent.Color
	v11.Text = createElement3("TextLabel", v13)
	return createElement(interactable, activateButtonsByActivated, {
		BoundingFrame = createElement2("Frame", v10, v11)
	})
end

return ItemTileDetailButton
