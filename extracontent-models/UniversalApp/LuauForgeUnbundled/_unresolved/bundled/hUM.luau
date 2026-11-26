return require("@luauforge/bundled/dFr").makeActionCreator("UpdateAccountPinUnlockTimeout", function(p2)
	assert(
		p2 == nil or typeof(p2) == "DateTime",
		"Expected the passed unlock time must be a valid `DateTime` or nil"
	)

	return { accountPinUnlockedUntil = p2 }
end)
