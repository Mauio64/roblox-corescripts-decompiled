local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local t = require(CorePackages.Packages.t)

local images = UIBlox.App.ImageSet.Images
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local iconscommonrobux = images["icons/common/robux"]

local extended = Roact.PureComponent:extend("DeveloperProductFooter")

extended.validateProps = t.strictInterface({
	price = t.number,
	onActivated = t.callback,
	localization = t.table
})

function extended.render(p2)
	local localization = p2.props.localization
	local price = p2.props.price

	return Roact.createElement(button, {
		buttonType = buttonType.PrimarySystem,
		size = UDim2.new(1, 0, 0, 35),
		icon = iconscommonrobux,
		text = numberLocalization.abbreviate(price, localization:GetLocale()),
		isDisabled = false,
		onActivated = p2.props.onActivated
	})
end

return (roactServices.connect({ localization = module })(extended))
