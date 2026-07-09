local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local withLocalization = require(Modules.LuaApp.withLocalization)
local v9 = game:DefineFastFlag("AETwoFactorLogOutMessage", false)

local function TwoStepRequiredOverlay(t1: {[any]: any}) -- line: 22
	-- upvalues: withLocalization (copy), v9 (copy), Roact (copy), InteractiveAlert (copy), Images (copy), ButtonType (copy)
	local closePrompt = t1.closePrompt
	local navigateToSecuritySettings = t1.navigateToSecuritySettings

	return withLocalization({
		title = "Authentication.TwoStepVerification.Title.VerificationRequired",
		cancel = "Feature.Catalog.Action.Cancel",
		gotoSecurity = "Authentication.TwoStepVerification.Action.GoToSecurity",
		message = not v9 and "Authentication.TwoStepVerification.Label.TwoStepRequired" or "Authentication.TwoStepVerification.Label.TwoStepRequiredLogout"
	})(function(p1) -- line: 32
		-- upvalues: Roact (copy), InteractiveAlert (copy), Images (copy), closePrompt (copy), ButtonType (copy), navigateToSecuritySettings (copy), t1 (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p1.title,
			titleIcon = Images["icons/status/error_large"],
			bodyText = p1.message,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = closePrompt,
							text = p1.cancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = navigateToSecuritySettings,
							text = p1.gotoSecurity
						}
					}
				}
			},
			screenSize = t1.screenSize
		})
	end)
end

return TwoStepRequiredOverlay
