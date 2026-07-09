local Parent = script:FindFirstAncestor("GameDetail").Parent
local isSubjectToDesktopPolicies = require(Parent.SharedFlags).isSubjectToDesktopPolicies
local Players = game:GetService("Players")

return function() -- line: 6
	-- upvalues: Players (copy), isSubjectToDesktopPolicies (copy)
	if not Players.LocalPlayer then
		return false
	end

	if isSubjectToDesktopPolicies() then
		return false
	end

	return true
end
