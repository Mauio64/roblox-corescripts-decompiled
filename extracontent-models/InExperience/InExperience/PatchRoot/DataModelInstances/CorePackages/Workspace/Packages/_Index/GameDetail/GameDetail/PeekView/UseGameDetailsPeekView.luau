local parent = script:FindFirstAncestor("GameDetail").Parent
local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local Players = game:GetService("Players")

return function(): boolean
	return not not Players.LocalPlayer and not isSubjectToDesktopPolicies()
end
