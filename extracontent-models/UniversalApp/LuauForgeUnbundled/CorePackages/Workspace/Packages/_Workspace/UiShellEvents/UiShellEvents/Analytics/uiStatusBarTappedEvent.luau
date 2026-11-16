local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/t")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Logger")

local strictInterface = t.strictInterface({ page = t.string })

return function(object, p2, p3)
	local v5, v6 = strictInterface(p3)

	if not v5 then
		Logger:error(v6)
	end

	object:sendEventDeferred(p2, "uiShellStatusBarTapped", p3)
end
