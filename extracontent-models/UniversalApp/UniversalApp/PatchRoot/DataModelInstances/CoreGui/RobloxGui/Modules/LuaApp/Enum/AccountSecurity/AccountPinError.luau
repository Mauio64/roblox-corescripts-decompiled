local CorePackages = game:GetService("CorePackages")
local t1 = {
	Enum = require(CorePackages.Packages.enumerate)(script.Name, {
		Default = -1,
		NoAccountPin = 1,
		AccountLocked = 2,
		Flooded = 3,
		IncorrectPin = 4
	})
}

t1.valueToLocalizationKey = {
	[t1.Enum.Default] = "Feature.AccountSecurityPrompt.Message.Error.Pin.Default",
	[t1.Enum.NoAccountPin] = "Feature.AccountSecurityPrompt.Message.Error.Pin.NoAccountPin",
	[t1.Enum.AccountLocked] = "Feature.AccountSecurityPrompt.Message.Error.Pin.AccountLocked",
	[t1.Enum.Flooded] = "Feature.AccountSecurityPrompt.Message.Error.Pin.Flooded",
	[t1.Enum.IncorrectPin] = "Feature.AccountSecurityPrompt.Message.Error.Pin.IncorrectPin"
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
