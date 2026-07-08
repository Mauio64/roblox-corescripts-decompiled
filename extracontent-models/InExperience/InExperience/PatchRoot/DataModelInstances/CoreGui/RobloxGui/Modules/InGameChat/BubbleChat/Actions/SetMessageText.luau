local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local t = require(CorePackages.Packages.t)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local v6 = t.tuple(t.string, t.string)

return makeActionCreator(script.Name, function(p1, p2) -- line: 10
	-- upvalues: maybeAssert (copy), v6 (copy), ExpChat (copy)
	maybeAssert(v6(p1, p2))
	ExpChat.Events.LegacyBubbleTextUpdated(p1, p2)

	return {
		messageId = p1,
		newText = p2
	}
end)
