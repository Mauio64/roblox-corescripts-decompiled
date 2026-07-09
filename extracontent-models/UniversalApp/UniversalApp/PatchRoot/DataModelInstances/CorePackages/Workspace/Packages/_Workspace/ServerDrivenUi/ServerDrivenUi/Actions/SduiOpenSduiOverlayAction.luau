local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

local function SduiOpenSduiOverlayAction(p1, _, p3) -- line: 14
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenSduiOverlay
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local configKey = v11.configKey
	local identifier = v11.identifier

	if not configKey then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing configKey in action params",
			name = SduiActionType.OpenSduiOverlay
		}, p3.appPage)

		return
	end

	if not identifier then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing identifier in action params",
			name = SduiActionType.OpenSduiOverlay
		}, p3.appPage)

		return
	end

	p3.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.SduiOverlay, {
		configKey = configKey,
		identifier = identifier,
		appPage = p3.appPage
	}))
end

return SduiOpenSduiOverlayAction
