local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p1, _, p3, _) -- line: 14
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), CloseCentralOverlay (copy)
	local v10 = p1 and p1.actionParams or nil

	if v10 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.DismissDialog
		}, p3.appPage)

		return
	end

	assert(v10, "actionParams must exist")

	if v10.dialogType == "centralOverlay" then
		p3.dependencies.dispatch(CloseCentralOverlay())
	end
end
