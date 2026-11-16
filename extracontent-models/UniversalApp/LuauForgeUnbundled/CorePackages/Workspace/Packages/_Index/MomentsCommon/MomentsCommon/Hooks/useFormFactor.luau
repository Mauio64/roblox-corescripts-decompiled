local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useScreenSize")
local FormFactor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/FormFactor")

local function useFormFactor()
	local v5 = useScreenSize()

	return (React.useMemo(function()
		if v5.X < 600 then
			return FormFactor.MobilePortrait
		end

		if v5.Y < 480 then
			return FormFactor.MobileLandscape
		end

		return FormFactor.Wide
	end, { v5 }))
end

return useFormFactor
