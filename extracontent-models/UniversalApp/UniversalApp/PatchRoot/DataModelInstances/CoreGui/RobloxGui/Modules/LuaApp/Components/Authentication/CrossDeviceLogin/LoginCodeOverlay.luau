local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local GetFFlagBottomAnchorXDLCodeModal = require(Modules.LuaApp.Flags.GetFFlagBottomAnchorXDLCodeModal)

return function(p1) -- line: 12
	-- upvalues: useLocalization (copy), Roact (copy), PartialPageModal (copy), GetFFlagBottomAnchorXDLCodeModal (copy)
	local v9 = useLocalization({
		alertTitle = "Authentication.CrossDevice.Heading.QuickLogin"
	})

	return Roact.createElement(PartialPageModal, {
		title = v9.alertTitle,
		screenSize = p1.screenSize,
		onCloseClicked = p1.onCloseClicked,
		position = UDim2.new(0.5, 0, 0.5, 0),
		anchorPoint = if not GetFFlagBottomAnchorXDLCodeModal() then Vector2.new(0.5, 0.5) else Vector2.new(0.5, 0)
	}, {
		ViewContainer = p1.loginCode
	})
end
