local CorePackages = game:GetService("CorePackages")
local t1 = {
	Enum = require(CorePackages.Packages.enumerate)(script.Name, {
		Default = -1,
		Flooded = 2,
		InvalidPassword = 7,
		InvalidCurrentPassword = 8,
		PinLocked = 9
	})
}

t1.valueToLocalizationKey = {
	[t1.Enum.Default] = "Feature.AccountSecurityPrompt.Message.Error.Password.Default",
	[t1.Enum.Flooded] = "Feature.AccountSecurityPrompt.Message.Error.Password.Flooded",
	[t1.Enum.InvalidPassword] = "Feature.AccountSecurityPrompt.Message.Error.Password.InvalidPassword",
	[t1.Enum.InvalidCurrentPassword] = "Feature.AccountSecurityPrompt.Message.Error.Password.InvalidCurrentPassword",
	[t1.Enum.PinLocked] = "Feature.AccountSecurityPrompt.Message.Error.Password.PinLocked"
}
t1.localizationKeys = {}

for _, v in pairs(t1.valueToLocalizationKey) do
	t1.localizationKeys[v] = v
end

function t1.toString(p1, p2) -- line: 31
	-- upvalues: t1 (copy)
	return p1[t1.valueToLocalizationKey[p2] or t1.valueToLocalizationKey[t1.Enum.Default]]
end

return t1
