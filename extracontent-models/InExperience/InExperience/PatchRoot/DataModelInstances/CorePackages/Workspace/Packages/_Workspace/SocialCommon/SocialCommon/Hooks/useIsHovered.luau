local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local React = require(parent.React)

local InputUtilities = require(SocialCommon.Utils.InputUtilities)

return function()
	local state, setState = React.useState(false)

	return state, React.useCallback(function(_, p)
		if InputUtilities.isPointerInput(p) then
			setState(true)
		end
	end, { setState }), (React.useCallback(function(_, p)
		if InputUtilities.isPointerInput(p) then
			setState(false)
		end
	end, { setState }))
end
