local t1 = {
	new = function() -- line: 19
		return {}
	end
}

function t1.mockDiscord() -- line: 24
	-- upvalues: t1 (copy)
	local v2 = t1.new()

	v2.url = "https://discord.gg/f2vDJse"
	v2.title = "Join the discord, to chat with players, and receive updates!"
	v2.type = "Discord"

	return v2
end
function t1.mockRobloxGroup() -- line: 32
	-- upvalues: t1 (copy)
	local v3 = t1.new()

	v3.url = "https://www.roblox.com/groups/2757866"
	v3.title = "Join Flamin' Studios to instantly unlock pushups in-game!"
	v3.type = "RobloxGroup"

	return v3
end
function t1.mockTwitter() -- line: 40
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.url = "https://twitter.com/HiddoYT"
	v4.title = "Follow Hiddo on Twitter for Codes!"
	v4.type = "Twitter"

	return v4
end
function t1.mockAmazon() -- line: 48
	-- upvalues: t1 (copy)
	local v5 = t1.new()

	v5.url = "https://amazon.com/roblox"
	v5.title = "Check out official Roblox merch!"
	v5.type = "Amazon"

	return v5
end
function t1.fromJsonData(p1) -- line: 56
	-- upvalues: t1 (copy)
	local v7 = t1.new()

	v7.url = p1.url
	v7.title = p1.title
	v7.type = p1.type

	return v7
end

return t1
