local v = {
	["grinning-face"] = "😀",
	["waving-hand"] = "👋",
	["thumbs-up"] = "👍",
	["party-popper"] = "🎉"
}

return {
	names = { "grinning-face", "waving-hand", "thumbs-up", "party-popper" },
	unicodeOf = function(p: string)
		return v[p]
	end
}
