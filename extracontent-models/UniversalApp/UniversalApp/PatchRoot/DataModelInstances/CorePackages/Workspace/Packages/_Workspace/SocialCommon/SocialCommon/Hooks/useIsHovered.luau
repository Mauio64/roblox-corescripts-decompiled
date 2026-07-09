local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local React = require(SocialCommonParent.React)
local InputUtilities = require(SocialCommon.Utils.InputUtilities)

return function() -- line: 8
	-- upvalues: React (copy), InputUtilities (copy)
	local v5, v6 = React.useState(false)

	return v5, React.useCallback(function(_, p2) -- line: 11
		-- upvalues: InputUtilities (copy), v6 (copy)
		if InputUtilities.isPointerInput(p2) then
			v6(true)
		end
	end, { v6 }), (React.useCallback(function(_, p4) -- line: 17
		-- upvalues: InputUtilities (copy), v6 (copy)
		if InputUtilities.isPointerInput(p4) then
			v6(false)
		end
	end, { v6 }))
end
