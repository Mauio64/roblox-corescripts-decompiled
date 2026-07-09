local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local withLocalization = require(Modules.LuaApp.withLocalization)
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v13 = Images["icons/common/robux"]
local v14 = Roact.PureComponent:extend("PassFooter")

v14.validateProps = t.strictInterface({
	price = t.number,
	userOwnsPass = t.boolean,
	onActivated = t.callback,
	localization = t.table
})

function v14.render(p1) -- line: 31
	-- upvalues: withLocalization (copy), NumberLocalization (copy), Roact (copy), Button (copy), ButtonType (copy), v13 (copy)
	local localization = p1.props.localization
	local price = p1.props.price
	local userOwnsPass = p1.props.userOwnsPass

	return withLocalization({
		owned = "Feature.Catalog.Label.Owned"
	})(function(p2) -- line: 38
		-- upvalues: userOwnsPass (copy), NumberLocalization (copy), price (copy), localization (copy), Roact (copy), Button (copy), ButtonType (copy), v13 (copy), p1 (copy)
		local v20 = if not userOwnsPass then NumberLocalization.abbreviate(price, localization:GetLocale()) else p2.owned

		return Roact.createElement(Button, {
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, 35),
			icon = if userOwnsPass then nil else v13,
			text = v20,
			isDisabled = userOwnsPass,
			onActivated = p1.props.onActivated
		})
	end)
end

return (RoactServices.connect({
	localization = RoactLocalization
})(v14))
