local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Sizing = require(script.Parent.Parent.Parent.Sizing)
local getBubbleTone = require(script.Parent.getBubbleTone)

local context = React.createContext(nil)

local function createBubbleStyle(flag: boolean, p) -- 1 equivalent call inferred from this helper
	return { textStyle = getBubbleTone(flag, p).textStyle }
end

local function useBubbleStyle()
	local v = React.useContext(context)
	local v2 = Foundation.Hooks.useTokens()
	local v3 = React.useMemo(function()
		return createBubbleStyle(false, v2) -- inferred equivalent call
	end, { v2 })
	return if v == nil then v3 else v
end

return {
	Context = context,
	createBubbleStyle = createBubbleStyle,
	useBubbleStyle = useBubbleStyle,
	useBubbleFontStyle = function()
		return useBubbleStyle(), Sizing.useSizing().bubble.fontStyle
	end
}
