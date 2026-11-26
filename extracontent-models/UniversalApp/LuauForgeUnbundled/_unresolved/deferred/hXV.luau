local CorePackages = game:GetService("CorePackages")

local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {}

v5.Enum = enumerate("PasswordError", {
	Default = -1,
	Flooded = 2,
	InvalidPassword = 7,
	InvalidCurrentPassword = 8,
	PinLocked = 9
})

v5.valueToLocalizationKey = {
	[v5.Enum.Default] = "Feature.AccountSecurityPrompt.Message.Error.Password.Default",
	[v5.Enum.Flooded] = "Feature.AccountSecurityPrompt.Message.Error.Password.Flooded",
	[v5.Enum.InvalidPassword] = "Feature.AccountSecurityPrompt.Message.Error.Password.InvalidPassword",
	[v5.Enum.InvalidCurrentPassword] = "Feature.AccountSecurityPrompt.Message.Error.Password.InvalidCurrentPassword",
	[v5.Enum.PinLocked] = "Feature.AccountSecurityPrompt.Message.Error.Password.PinLocked"
}

v5.localizationKeys = {}

for k, v7 in pairs(v5.valueToLocalizationKey) do
	v5.localizationKeys[v7] = v7
end

function v5.toString(p2, p3)
	return p2[v5.valueToLocalizationKey[p3] or v5.valueToLocalizationKey[v5.Enum.Default]]
end

return v5
