local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Context = require(script.Parent.Context)

local function ChatPagePaddingProvider(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Context (copy), Cryo (copy)
	return React.createElement(Context.Provider, {
		value = Cryo.Dictionary.join({
			top = 0,
			right = 12,
			bottom = 0,
			left = 12
		}, t1.value)
	}, t1.children)
end

return ChatPagePaddingProvider
