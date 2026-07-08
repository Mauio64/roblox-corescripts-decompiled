local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local PresenceContext = require(script.Parent.PresenceContext)

return {
	useIsPresent = function() -- line: 39
		-- upvalues: React (copy), PresenceContext (copy)
		local v5 = React.useContext(PresenceContext)

		if v5 == nil then
			return true
		end

		return v5.isPresent
	end,
	isPresent = function(p1) -- line: 27
		if p1 == nil then
			return true
		end

		return p1.isPresent
	end
}
