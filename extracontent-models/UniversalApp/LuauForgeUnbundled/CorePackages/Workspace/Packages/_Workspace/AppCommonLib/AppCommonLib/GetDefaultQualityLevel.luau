local IsVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/IsVRAppBuild")

return function()
	if IsVRAppBuild() then
		return Enum.QualityLevel.Level07
	end

	return Enum.QualityLevel.Automatic
end
