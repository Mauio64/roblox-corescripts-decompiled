local ParentParent = script.Parent.Parent
local R15plusUtils = require(ParentParent.util.R15plusUtils)

return function(p1) -- line: 12
	-- upvalues: R15plusUtils (copy)
	if not R15plusUtils.checkFlagEnabledForAllowHrd() then
		return p1.CFrame
	end

	local p1CFrame = p1.CFrame
	local p1Parent = p1.Parent

	while p1Parent and p1Parent:IsA("Attachment") do
		p1CFrame = p1Parent.CFrame * p1CFrame
		p1Parent = p1Parent.Parent
	end

	return p1CFrame
end
