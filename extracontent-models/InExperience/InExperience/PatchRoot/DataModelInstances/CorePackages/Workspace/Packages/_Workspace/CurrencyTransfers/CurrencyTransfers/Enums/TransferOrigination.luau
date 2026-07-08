local t1 = {
	Unknown = "unknown",
	Profile = "profile",
	Chat = "chat",
	BuyRobux = "buyRobux",
	InExperience = "inExperience"
}

t1.toEnumInteger = {
	[t1.Unknown] = 0,
	[t1.Profile] = 1,
	[t1.Chat] = 2,
	[t1.BuyRobux] = 3,
	[t1.InExperience] = 4
}

return t1
