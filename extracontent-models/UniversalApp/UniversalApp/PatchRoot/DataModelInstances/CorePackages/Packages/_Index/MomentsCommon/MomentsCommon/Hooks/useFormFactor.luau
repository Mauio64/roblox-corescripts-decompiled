local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local useScreenSize = require(MomentsCommon.Hooks.useScreenSize)
local FormFactor = require(MomentsCommon.Enums.FormFactor)

local function useFormFactor() -- line: 13
	-- upvalues: useScreenSize (copy), React (copy), FormFactor (copy)
	local v7 = useScreenSize()

	return (React.useMemo(function() -- line: 16
		-- upvalues: v7 (copy), FormFactor (copy)
		if v7.X < 600 then
			return FormFactor.MobilePortrait
		end

		if v7.Y < 480 then
			return FormFactor.MobileLandscape
		end

		return FormFactor.Wide
	end, { v7 }))
end

return useFormFactor
