local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local module2 = require("@luauforge/bundled/egZ")
local t = require(CorePackages.Packages.t)

local images = UIBlox.App.ImageSet.Images
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local iconscommonrobux = images["icons/common/robux"]

local extended = Roact.PureComponent:extend("PassFooter")

extended.validateProps = t.strictInterface({
	price = t.number,
	userOwnsPass = t.boolean,
	onActivated = t.callback,
	localization = t.table
})

function extended.render(p2)
	local localization = p2.props.localization
	local price = p2.props.price
	local userOwnsPass = p2.props.userOwnsPass

	return module2({ owned = "Feature.Catalog.Label.Owned" })(function(p3)
		local v5

		if userOwnsPass then
			v5 = p3.owned
		else
			v5 = numberLocalization.abbreviate(price, localization:GetLocale())
		end

		return Roact.createElement(button, {
			buttonType = buttonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, 35),
			icon = if not userOwnsPass then iconscommonrobux else nil,
			text = v5,
			isDisabled = userOwnsPass,
			onActivated = p2.props.onActivated
		})
	end)
end

return (roactServices.connect({ localization = module })(extended))
