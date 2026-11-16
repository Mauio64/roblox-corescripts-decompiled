local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local t = require(CorePackages.Packages.t)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)

local tuple = t.tuple(t.string, t.string)

return makeActionCreator(script.Name, function(messageId, newText)
	maybeAssert(tuple(messageId, newText))

	ExpChat.Events.LegacyBubbleTextUpdated(messageId, newText)

	return { messageId = messageId, newText = newText }
end)
