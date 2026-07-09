local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v12 = Images["icons/common/robux"]
local v13 = Roact.PureComponent:extend("DeveloperProductFooter")

v13.validateProps = t.strictInterface({
	price = t.number,
	onActivated = t.callback,
	localization = t.table
})

function v13.render(p1) -- line: 29
	-- upvalues: Roact (copy), Button (copy), ButtonType (copy), v12 (copy), NumberLocalization (copy)
	local localization = p1.props.localization
	local price = p1.props.price

	return Roact.createElement(Button, {
		isDisabled = false,
		buttonType = ButtonType.PrimarySystem,
		size = UDim2.new(1, 0, 0, 35),
		icon = v12,
		text = NumberLocalization.abbreviate(price, localization:GetLocale()),
		onActivated = p1.props.onActivated
	})
end

return (RoactServices.connect({
	localization = RoactLocalization
})(v13))
