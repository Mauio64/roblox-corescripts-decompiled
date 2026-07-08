local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

return require(FriendsLanding.dependencies).enumerate(script.Name, {
	StudioPresenceTextGlobal = "Roblox Studio",
	StudioPresenceTextLuobu = "LuoBu Studio"
})
