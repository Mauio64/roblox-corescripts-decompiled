local v5 = {}

function v5.new()
	return {}
end

function v5.mockDiscord()
	local v6 = v5.new()
	v6.url = "https://discord.gg/f2vDJse"
	v6.title = "Join the discord, to chat with players, and receive updates!"
	v6.type = "Discord"
	return v6
end

function v5.mockRobloxGroup()
	local v6 = v5.new()
	v6.url = "https://www.roblox.com/groups/2757866"
	v6.title = "Join Flamin' Studios to instantly unlock pushups in-game!"
	v6.type = "RobloxGroup"
	return v6
end

function v5.mockTwitter()
	local v6 = v5.new()
	v6.url = "https://twitter.com/HiddoYT"
	v6.title = "Follow Hiddo on Twitter for Codes!"
	v6.type = "Twitter"
	return v6
end

function v5.mockAmazon()
	local v6 = v5.new()
	v6.url = "https://amazon.com/roblox"
	v6.title = "Check out official Roblox merch!"
	v6.type = "Amazon"
	return v6
end

function v5.fromJsonData(data)
	local v6 = v5.new()
	v6.url = data.url
	v6.title = data.title
	v6.type = data.type
	return v6
end

return v5
