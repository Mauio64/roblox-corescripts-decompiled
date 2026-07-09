local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday

return function(p1) -- line: 8
	-- upvalues: ArgCheck (copy), Birthday (copy), SetCentralOverlay (copy), OverlayType (copy)
	return function(p2) -- line: 9
		-- upvalues: ArgCheck (copy), p1 (copy), Birthday (copy), SetCentralOverlay (copy), OverlayType (copy)
		ArgCheck.isType(p1.onClose, "function", "props.onClose passed down to OpenCentralOverlayForSignUpBirthdayPicker")

		if p1.initialBirthday then
			ArgCheck.assert(Birthday.is(p1.initialBirthday), "props.initialBirthday passed down to OpenCentralOverlayForSignUpBirthdayPicker")
		end

		p2:dispatch(SetCentralOverlay(OverlayType.SignUpBirthdayPickerOverlay, p1))
	end
end
