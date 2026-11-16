local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)

local useScreenSize = require(script.Parent.useScreenSize)
local FormFactor = require(MomentsCommon.Enums.FormFactor)

local function useFormFactor()
	local v = useScreenSize()

	return (React.useMemo(function()
		if v.X < 600 then
			return FormFactor.MobilePortrait
		end

		if v.Y < 480 then
			return FormFactor.MobileLandscape
		end

		return FormFactor.Wide
	end, { v }))
end

return useFormFactor
