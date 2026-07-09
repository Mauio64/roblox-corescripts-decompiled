local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvailableToSellRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.AvailableToSellRow)
local v7 = Roact.PureComponent:extend("AvailableToSellLimitedUniqueRow")

function v7.render(p1) -- line: 22
	-- upvalues: Roact (copy), AvailableToSellRow (copy)
	local userAssetInfo = p1.props.userAssetInfo

	if not userAssetInfo or userAssetInfo and not userAssetInfo.serialNumber then
		return
	end

	local v11 = "# " .. userAssetInfo.serialNumber
	local forwardRef = p1.props.forwardRef

	return Roact.createElement(AvailableToSellRow, {
		LayoutOrder = p1.props.LayoutOrder,
		onActivated = p1.props.onActivated,
		horizontalPadding = p1.props.horizontalPadding,
		Position = p1.props.Position,
		Size = p1.props.Size,
		Text = v11,
		NextSelectionLeft = p1.props.NextSelectionLeft,
		NextSelectionRight = p1.props.NextSelectionRight,
		NextSelectionUp = p1.props.NextSelectionUp,
		NextSelectionDown = p1.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	})
end

local u8 = RoactRodux.connect(function(p2, p3) -- line: 48
	return {
		userAssetInfo = p2.AvatarExperience.Catalog.UserAssets[p3.userAssetId]
	}
end)(v7)

return Roact.forwardRef(function(p4, p5) -- line: 55
	-- upvalues: Roact (copy), u8 (ref), Cryo (copy)
	return Roact.createElement(u8, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
