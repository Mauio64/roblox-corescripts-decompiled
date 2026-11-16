local TransferOrigination = {
	Unknown = "unknown",
	Profile = "profile",
	Chat = "chat",
	BuyRobux = "buyRobux",
	InExperience = "inExperience"
}

TransferOrigination.toEnumInteger = {
	[TransferOrigination.Unknown] = 0,
	[TransferOrigination.Profile] = 1,
	[TransferOrigination.Chat] = 2,
	[TransferOrigination.BuyRobux] = 3,
	[TransferOrigination.InExperience] = 4
}

return TransferOrigination
