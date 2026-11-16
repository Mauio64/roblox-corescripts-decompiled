local parent = script:FindFirstAncestor("AppChat").Parent

local ArgCheck = require(parent.ArgCheck)

local filterForLinks = require(script.Parent.filterForLinks)

local v = {
	"roblox.com",
	"sitetest%d%.robloxlabs.com",
	"gametest%d%.robloxlabs.com",
	"roblox.cn",
	"roblox.qq.com",
	"roblox%-cn.com"
}

return function(p)
	ArgCheck.isType(p, "table", "filterForLinks.text")

	return filterForLinks(p, v)
end
