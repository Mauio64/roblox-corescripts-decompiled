local Parent = script:FindFirstAncestor("AppChat").Parent
local ArgCheck = require(Parent.ArgCheck)
local filterForLinks = require(script.Parent.filterForLinks)
local t1 = {
	"roblox.com",
	"sitetest%d%.robloxlabs.com",
	"gametest%d%.robloxlabs.com",
	"roblox.cn",
	"roblox.qq.com",
	"roblox%-cn.com"
}

return function(p1) -- line: 18
	-- upvalues: ArgCheck (copy), filterForLinks (copy), t1 (copy)
	ArgCheck.isType(p1, "table", "filterForLinks.text")

	return filterForLinks(p1, t1)
end
