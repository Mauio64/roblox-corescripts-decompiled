local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local Context = require(script.Parent.Context)

local function ChatPagePaddingProvider(p)
	return React.createElement(Context.Provider, {
		value = Cryo.Dictionary.join({ top = 0, right = 12, bottom = 0, left = 12 }, p.value)
	}, p.children)
end

return ChatPagePaddingProvider
