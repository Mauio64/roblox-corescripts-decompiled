local Modules = game:GetService("CoreGui").RobloxGui.Modules
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagEnableCrossDeviceEnterCodeAuthButtonClickSchematization = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceEnterCodeAuthButtonClickSchematization)

return function(p1, s1: string) -- line: 9
	-- upvalues: GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), GetFFlagEnableCrossDeviceEnterCodeAuthButtonClickSchematization (copy), EventStreamConstants (copy)
	if GetFFlagEnableCrossDeviceLoginUsingQRCodes() then
		if GetFFlagEnableCrossDeviceEnterCodeAuthButtonClickSchematization() then
			p1.reportAuthButtonClick(EventStreamConstants.Context.QuickLogin, EventStreamConstants.Button.EnterDeviceCode, nil, nil, nil, nil, s1)

			return
		end

		p1.reportButtonClickedWithCType(EventStreamConstants.Context.QuickLogin, EventStreamConstants.Button.EnterDeviceCode, s1)

		return
	end

	p1.reportButtonClicked(EventStreamConstants.Context.QuickLogin, EventStreamConstants.Button.EnterDeviceCode)
end
