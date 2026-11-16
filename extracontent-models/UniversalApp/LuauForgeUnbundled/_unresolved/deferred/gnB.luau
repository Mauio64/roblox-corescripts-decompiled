local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/deferred/gnA")

local extended = Roact.PureComponent:extend("AvailableToSellLimitedUniqueRow")

function extended.render(p2)
	local userAssetInfo = p2.props.userAssetInfo

	if not userAssetInfo or userAssetInfo and not userAssetInfo.serialNumber then
		return
	end

	local v5 = "# " .. userAssetInfo.serialNumber

	local forwardRef = p2.props.forwardRef

	return Roact.createElement(module, {
		LayoutOrder = p2.props.LayoutOrder,
		onActivated = p2.props.onActivated,
		horizontalPadding = p2.props.horizontalPadding,
		Position = p2.props.Position,
		Size = p2.props.Size,
		Text = v5,
		NextSelectionLeft = p2.props.NextSelectionLeft,
		NextSelectionRight = p2.props.NextSelectionRight,
		NextSelectionUp = p2.props.NextSelectionUp,
		NextSelectionDown = p2.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	})
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { userAssetInfo = p2.AvatarExperience.Catalog.UserAssets[p3.userAssetId] }
end)(extended)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
