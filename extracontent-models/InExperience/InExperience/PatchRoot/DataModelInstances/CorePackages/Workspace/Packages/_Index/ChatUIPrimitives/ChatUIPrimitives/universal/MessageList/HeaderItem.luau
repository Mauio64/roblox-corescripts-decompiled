local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)

local Sizing = require(script.Parent.Parent.Sizing)
require(script.Parent.groupMessages)

local context = React.createContext(nil)

local function HeaderItem(_)
	local header = React.useContext(context)
	local v = Sizing.useSizing()
	local tag = Foundation.Hooks.useDefaultTags(v.row.tag, "size-full-0 auto-y")
	return React.createElement(Foundation.View, { tag = tag, testId = "message-list-header" }, {
		Header = header
	})
end

return { Context = context, Component = HeaderItem }
