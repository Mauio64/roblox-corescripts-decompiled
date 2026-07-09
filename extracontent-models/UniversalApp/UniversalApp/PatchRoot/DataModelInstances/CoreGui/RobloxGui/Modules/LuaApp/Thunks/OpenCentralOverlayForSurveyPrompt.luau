local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function(p1, p2, p3, p4, p5, p6) -- line: 8
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p7) -- line: 9
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy)
		p7:dispatch(SetCentralOverlay(OverlayType.SurveyPrompt, {
			continueFunc = p1,
			closeFunc = p2,
			titleText = p3,
			bodyText = p4,
			cancelButtonText = p5,
			confirmButtonText = p6
		}))
	end
end
