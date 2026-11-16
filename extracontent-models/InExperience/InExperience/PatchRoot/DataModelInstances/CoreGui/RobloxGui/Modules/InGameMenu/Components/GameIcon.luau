local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local parent = script.Parent.Parent

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images
local AssetImage = require(parent.Components.AssetImage)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local getGameIconRequestSize = require(parent.Components.getGameIconRequestSize)

local extended = Roact.PureComponent:extend("GameIcon")

extended.validateProps = t.strictInterface({
	gameId = t.number,
	iconSize = t.numberMin(0),
	layoutOrder = t.optional(t.number),
	cornerRadius = t.optional(t.UDim),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2)
})

function extended.render(p)
	local iconSize = p.props.iconSize
	local gameIconRequestSize = getGameIconRequestSize(iconSize)
	local gameId = p.props.gameId
	local cornerRadius = p.props.cornerRadius

	local formatted = ("rbxthumb://type=GameIcon&id=%d&w=%d&h=%d"):format(
		gameId,
		gameIconRequestSize,
		gameIconRequestSize
	)

	if gameId == 0 then
		local v = not (iconSize <= 44) and 44 or iconSize

		return withFoundationOrUIBloxStyle(function(p2)
			return {
				Theme = {
					PlaceHolder = {
						Color = p2.Color.Common.Shimmer.Color3,
						Transparency = p2.Color.Common.Shimmer.Transparency
					},
					UIDefault = {
						Color = p2.Color.Shift.Shift_200.Color3,
						Transparency = p2.Color.Shift.Shift_200.Transparency
					}
				}
			}
		end, function(p2)
			local createElement = Roact.createElement
			local label = AssetImage.Label
			local v2 = {
				imageKey = "RoundedRect",
				Size = UDim2.fromOffset(iconSize, iconSize),
				ImageColor3 = p2.Theme.PlaceHolder.Color,
				ImageTransparency = p2.Theme.PlaceHolder.Transparency,
				LayoutOrder = p.props.layoutOrder,
				Position = p.props.Position,
				AnchorPoint = p.props.AnchorPoint
			}
			local placeholderIcon

			if FFlagCoreUiMigrateUIBloxToFoundation then
				placeholderIcon = Roact.createElement(Image, {
					Size = UDim2.fromOffset(v, v),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = "icons/imageUnavailable",
					imageStyle = {
						Color3 = p2.Theme.UIDefault.Color,
						Transparency = p2.Theme.UIDefault.Transparency
					},
					AnchorPoint = Vector2.new(0.5, 0.5),
					cornerRadius = cornerRadius
				})
			else
				local createElement2 = Roact.createElement
				local v3 = {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v, v),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = Images["icons/imageUnavailable"],
					ImageColor3 = p2.Theme.UIDefault.Color,
					ImageTransparency = p2.Theme.UIDefault.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5)
				}
				local uiCorner

				if cornerRadius and cornerRadius ~= UDim.new(0, 0) then
					uiCorner = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
				end

				placeholderIcon = createElement2(ImageSetLabel, v3, { UICorner = uiCorner })
			end

			return createElement(label, v2, { PlaceholderIcon = placeholderIcon })
		end)
	end

	local createElement = Roact.createElement
	local v = {
		Image = formatted,
		Size = UDim2.fromOffset(iconSize, iconSize),
		BackgroundTransparency = 1,
		LayoutOrder = p.props.layoutOrder,
		Position = p.props.Position,
		AnchorPoint = p.props.AnchorPoint
	}
	local uiCorner

	if cornerRadius and cornerRadius ~= UDim.new(0, 0) then
		uiCorner = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
	end

	return createElement("ImageLabel", v, { UICorner = uiCorner })
end

return extended
