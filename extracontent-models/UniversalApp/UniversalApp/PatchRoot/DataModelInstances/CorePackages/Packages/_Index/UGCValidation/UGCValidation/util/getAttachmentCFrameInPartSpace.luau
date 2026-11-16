local parent = script.Parent.Parent
local R15plusUtils = require(parent.util.R15plusUtils)

return function(instance)
	if not R15plusUtils.checkFlagEnabledForAllowHrd() then
		return instance.CFrame
	end

	local cframe = instance.CFrame
	local parent2 = instance.Parent

	while parent2 and parent2:IsA("Attachment") do
		cframe = parent2.CFrame * cframe
		parent2 = parent2.Parent
	end

	return cframe
end
