local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameHelpToControls = SharedFlags.FFlagRenameHelpToControls

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local pageOpenSignal = InGameMenuIntegrationUtils.createPageOpenSignal("HelpPage")

local v = {
	initialAvailability = Service.AvailabilitySignal.Available,
	id = "help",
	label = FFlagRenameHelpToControls and "CoreScripts.InGameMenu.Controls.ControlsPage" or "CoreScripts.Feedback.Help.MainHeader",
	sideSheetPlacement = 0,
	activated = 0,
	isActivated = 0,
	components = 0
}
local sideSheetPlacement

if isPioneerLaunch() then
	sideSheetPlacement = SideSheetPlacement.AboveFold
else
	sideSheetPlacement = SideSheetPlacement.BelowFold
end

v.sideSheetPlacement = sideSheetPlacement
function v.activated(_)
	InGameMenuIntegrationUtils.toggleIGMPage("HelpPage", pageOpenSignal:get())
end
v.isActivated = pageOpenSignal
v.components = {
	Icon = function(_)
		return CommonIcon(FFlagRenameHelpToControls and "Controller" or "CircleQuestion", nil, pageOpenSignal)
	end
}
return Service:register(v)
