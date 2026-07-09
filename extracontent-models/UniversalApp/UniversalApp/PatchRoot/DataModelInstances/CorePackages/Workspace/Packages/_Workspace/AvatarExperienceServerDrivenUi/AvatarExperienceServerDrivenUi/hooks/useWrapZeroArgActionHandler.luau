local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local React = require(AvatarExperienceServerDrivenUiParent.React)
local wrapZeroArgAction = require(AvatarExperienceServerDrivenUi.Utils.wrapZeroArgAction)

local function useWrapZeroArgActionHandler(p1) -- line: 9
	-- upvalues: React (copy), wrapZeroArgAction (copy)
	return React.useMemo(function() -- line: 10
		-- upvalues: wrapZeroArgAction (copy), p1 (copy)
		return wrapZeroArgAction(p1)
	end, { p1 })
end

return useWrapZeroArgActionHandler
