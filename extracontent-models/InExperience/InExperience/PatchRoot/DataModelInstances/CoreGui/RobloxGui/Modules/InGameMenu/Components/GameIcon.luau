local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images
local AssetImage = require(ParentParent.Components.AssetImage)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameIconRequestSize = require(ParentParent.Components.getGameIconRequestSize)
local v12 = Roact.PureComponent:extend("GameIcon")

v12.validateProps = t.strictInterface({
	gameId = t.number,
	iconSize = t.numberMin(0),
	layoutOrder = t.optional(t.number),
	cornerRadius = t.optional(t.UDim),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2)
})

function v12.render(p1) -- line: 33
	-- upvalues: getGameIconRequestSize (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), AssetImage (copy), ImageSetLabel (copy), Images (copy)
	local iconSize = p1.props.iconSize
	local v15 = getGameIconRequestSize(iconSize)
	local gameId = p1.props.gameId
	local cornerRadius = p1.props.cornerRadius
	local v18 = ("rbxthumb://type=GameIcon&id=%d&w=%d&h=%d"):format(gameId, v15, v15)

	if gameId == 0 then
		local n1 = 44

		if iconSize <= 44 then
			n1 = iconSize
		end

		return withFoundationOrUIBloxStyle(function(p2) -- line: 49
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
		end, function(p3) -- line: 56
			-- upvalues: Roact (copy), AssetImage (copy), iconSize (copy), p1 (copy), ImageSetLabel (copy), n1 (ref), Images (copy), cornerRadius (copy)
			return Roact.createElement(AssetImage.Label, {
				imageKey = "RoundedRect",
				Size = UDim2.fromOffset(iconSize, iconSize),
				ImageColor3 = p3.Theme.PlaceHolder.Color,
				ImageTransparency = p3.Theme.PlaceHolder.Transparency,
				LayoutOrder = p1.props.layoutOrder,
				Position = p1.props.Position,
				AnchorPoint = p1.props.AnchorPoint
			}, {
				PlaceholderIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(n1, n1),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = Images["icons/imageUnavailable"],
					ImageColor3 = p3.Theme.UIDefault.Color,
					ImageTransparency = p3.Theme.UIDefault.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					UICorner = cornerRadius and (cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
						CornerRadius = cornerRadius
					})) or nil
				})
			})
		end)
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = v18,
		Size = UDim2.fromOffset(iconSize, iconSize),
		LayoutOrder = p1.props.layoutOrder,
		Position = p1.props.Position,
		AnchorPoint = p1.props.AnchorPoint
	}, {
		UICorner = cornerRadius and (cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
			CornerRadius = cornerRadius
		})) or nil
	})
end

return v12
