local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal

local SwitchServer = require(CorePackages.Workspace.Packages.SwitchServer)
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore
local constants = SwitchServer.Constants
local switchServerStore = GetSwitchServerStore(false)
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local SignalsUtils = require(CorePackages.Workspace.Packages.SignalsUtils)

local v = false
local v2 = Signal.new()
local isActivated = MappedSignal.new(v2, function()
	return v
end)

SignalsUtils.createDetachedEffect(function(p)
	local confirmationOpen = switchServerStore.isConfirmationOpen(p)

	if v ~= confirmationOpen then
		v = confirmationOpen
		v2:fire()
	end
end)

local v3 = {
	initialAvailability = Service.AvailabilitySignal.Unavailable,
	id = Constants.SWITCH_SERVER_ID,
	label = constants.BUTTON.LABEL,
	sideSheetPlacement = 0,
	activated = 0,
	isActivated = 0,
	components = 0
}
local sideSheetPlacement

if isPioneerLaunch() then
	sideSheetPlacement = SideSheetPlacement.SessionAction
else
	sideSheetPlacement = SideSheetPlacement.BelowFold
end

v3.sideSheetPlacement = sideSheetPlacement
function v3.activated()
	switchServerStore.setConfirmationOpen(true)
end
v3.isActivated = isActivated
v3.components = {
	Icon = function(_)
		return CommonIcon("TwoLocationPinsConnectingArrow", nil, isActivated)
	end
}
local v4 = Service:register(v3)

SignalsUtils.createDetachedEffect(function(p)
	if switchServerStore.shouldEnableSwitchServer(p) or isPioneerLaunch() then
		v4.availability:available()
	else
		v4.availability:unavailable()
	end
end)

return v4
