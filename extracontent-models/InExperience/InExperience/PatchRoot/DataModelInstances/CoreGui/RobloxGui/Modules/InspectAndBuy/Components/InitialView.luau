local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerNameLabel = require(parent.Components.PlayerNameLabel)
local AvatarHeadShot = require(parent.Components.AvatarHeadShot)
local AssetList = require(parent.Components.AssetList)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local extended = Roact.PureComponent:extend("InitialView")

function extended.render(p)
	local view = p.props.view
	local detailsInformation = p.props.detailsInformation

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2)
			local v = p2[view]
			return Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, v.BorderPaddingSize, 0, 10),
				Size = UDim2.new(1, -(2 * v.BorderPaddingSize), 1, -36),
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = not detailsInformation.viewingDetails,
				Selectable = false
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 15),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Top = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, v.TopSizeY),
						BackgroundTransparency = 1,
						LayoutOrder = 2
					},
					{
						UIListLayout = Roact.createElement("UIListLayout", {
							Padding = UDim.new(0, 10),
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal
						}),
						AvatarHeadShot = Roact.createElement(AvatarHeadShot),
						PlayerNameLabel = Roact.createElement(PlayerNameLabel)
					}
				),
				AssetList = Roact.createElement(AssetList)
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { view = p.view, detailsInformation = p.detailsInformation }
end)(extended)
