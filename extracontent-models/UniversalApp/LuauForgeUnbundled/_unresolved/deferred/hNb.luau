local CorePackages = game:GetService("CorePackages")

local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {}

v5.Enum = enumerate("AccountPinError", {
	Default = -1,
	NoAccountPin = 1,
	AccountLocked = 2,
	Flooded = 3,
	IncorrectPin = 4
})

v5.valueToLocalizationKey = {
	[v5.Enum.Default] = "Feature.AccountSecurityPrompt.Message.Error.Pin.Default",
	[v5.Enum.NoAccountPin] = "Feature.AccountSecurityPrompt.Message.Error.Pin.NoAccountPin",
	[v5.Enum.AccountLocked] = "Feature.AccountSecurityPrompt.Message.Error.Pin.AccountLocked",
	[v5.Enum.Flooded] = "Feature.AccountSecurityPrompt.Message.Error.Pin.Flooded",
	[v5.Enum.IncorrectPin] = "Feature.AccountSecurityPrompt.Message.Error.Pin.IncorrectPin"
}

v5.localizationKeys = {}

for k, v7 in pairs(v5.valueToLocalizationKey) do
	v5.localizationKeys[v7] = v7
end

function v5.toString(p2, p3)
	return p2[v5.valueToLocalizationKey[p3] or v5.valueToLocalizationKey[v5.Enum.Default]]
end

return v5
