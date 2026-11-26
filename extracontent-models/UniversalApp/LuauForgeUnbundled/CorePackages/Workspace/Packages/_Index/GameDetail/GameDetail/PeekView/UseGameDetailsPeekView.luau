local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").isSubjectToDesktopPolicies
local Players = game:GetService("Players")

return function(): boolean
	if not Players.LocalPlayer or isSubjectToDesktopPolicies() then
		return false
	end

	return true
end
