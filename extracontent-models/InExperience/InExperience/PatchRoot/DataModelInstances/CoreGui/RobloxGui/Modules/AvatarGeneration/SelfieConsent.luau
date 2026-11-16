local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SelfieConsent = require(CorePackages.Workspace.Packages.SelfieConsent)
local dialog = SelfieConsent.SelfieConsentDialog.createDialog()

dialog.mountCoreUI(RobloxGui)

return dialog
