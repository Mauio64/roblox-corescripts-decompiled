local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local v11 = Roact.PureComponent:extend("ConfirmSignOut")

function v11.render(p1) -- line: 18
	-- upvalues: Roact (copy), AlertWindow (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local theme = p1.props.theme
	local containerWidth = p1.props.containerWidth
	local closeAlert = p1.props.closeAlert
	local continueFunc = p1.props.continueFunc
	local localization = p1.props.localization

	local function v19(t1: {[any]: any}) -- line: 25
		-- upvalues: Roact (copy), AlertWindow (copy), theme (copy), containerWidth (copy), continueFunc (copy), closeAlert (copy)
		return Roact.createElement(AlertWindow, {
			isConfirming = false,
			hasCancelButton = true,
			theme = theme,
			containerWidth = containerWidth,
			titleText = t1.titleText,
			titleFont = theme.AlertWindow.Title.Font,
			messageText = t1.messageText,
			messageFont = theme.AlertWindow.Title.Font,
			buttonFont = theme.AlertWindow.Button.Font,
			confirmButtonText = t1.confirmButtonText,
			onConfirm = continueFunc,
			onCancel = closeAlert
		})
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			titleText = "Application.Logout.Title.Logout",
			messageText = "Application.Logout.Message.Confirmation",
			confirmButtonText = "Application.Logout.Action.Logout",
			cancelButtonText = "Feature.GamePage.LabelCancelField"
		})(v19)
	end

	return v19({
		titleText = localization:Format("Application.Logout.Title.Logout"),
		messageText = localization:Format("Application.Logout.Message.Confirmation"),
		confirmButtonText = localization:Format("Application.Logout.Action.Logout"),
		cancelButtonText = localization:Format("Feature.GamePage.LabelCancelField")
	})
end

local v12 = RoactRodux.connect(nil, function(p2) -- line: 59
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeAlert = function() -- line: 61
			-- upvalues: p2 (copy), CloseCentralOverlay (copy)
			return p2(CloseCentralOverlay())
		end
	}
end)(v11)

return (RoactServices.connect({
	localization = RoactLocalization
})(v12))
