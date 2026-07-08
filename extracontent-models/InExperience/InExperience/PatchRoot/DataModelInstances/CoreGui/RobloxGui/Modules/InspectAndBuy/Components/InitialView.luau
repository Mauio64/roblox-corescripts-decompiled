local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerNameLabel = require(ParentParent.Components.PlayerNameLabel)
local AvatarHeadShot = require(ParentParent.Components.AvatarHeadShot)
local AssetList = require(ParentParent.Components.AssetList)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local v9 = Roact.PureComponent:extend("InitialView")

function v9.render(p1) -- line: 13
	-- upvalues: Roact (copy), InspectAndBuyContext (copy), AvatarHeadShot (copy), PlayerNameLabel (copy), AssetList (copy)
	local view = p1.props.view
	local detailsInformation = p1.props.detailsInformation

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2) -- line: 18
			-- upvalues: view (copy), Roact (copy), detailsInformation (copy), AvatarHeadShot (copy), PlayerNameLabel (copy), AssetList (copy)
			local v16 = p2[view]

			return Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Selectable = false,
				Position = UDim2.new(0, v16.BorderPaddingSize, 0, 10),
				Size = UDim2.new(1, -(2 * v16.BorderPaddingSize), 1, -36),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = not detailsInformation.viewingDetails
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 15),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Top = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v16.TopSizeY)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					AvatarHeadShot = Roact.createElement(AvatarHeadShot),
					PlayerNameLabel = Roact.createElement(PlayerNameLabel)
				}),
				AssetList = Roact.createElement(AssetList)
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 53
	return {
		view = p3.view,
		detailsInformation = p3.detailsInformation
	}
end)(v9)
