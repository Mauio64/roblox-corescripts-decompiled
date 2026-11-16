local v5 = {
	Unknown = "unknown",
	Profile = "profile",
	Chat = "chat",
	BuyRobux = "buyRobux",
	InExperience = "inExperience"
}

v5.toEnumInteger = {
	[v5.Unknown] = 0,
	[v5.Profile] = 1,
	[v5.Chat] = 2,
	[v5.BuyRobux] = 3,
	[v5.InExperience] = 4
}

return v5
