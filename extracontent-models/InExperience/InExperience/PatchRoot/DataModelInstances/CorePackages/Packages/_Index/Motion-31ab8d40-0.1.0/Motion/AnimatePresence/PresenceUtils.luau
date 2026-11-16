local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local PresenceContext = require(script.Parent.PresenceContext)

local function isPresent(p) -- 1 equivalent call inferred from this helper
	return p == nil or p.isPresent
end

return {
	useIsPresent = function()
		return isPresent(React.useContext(PresenceContext)) -- inferred equivalent call
	end,
	isPresent = isPresent
}
