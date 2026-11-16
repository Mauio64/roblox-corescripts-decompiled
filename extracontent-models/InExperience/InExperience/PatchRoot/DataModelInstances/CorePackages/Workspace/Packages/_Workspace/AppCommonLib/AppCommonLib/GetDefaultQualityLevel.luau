local IsVRAppBuild = require(script.Parent.IsVRAppBuild)

return function()
	if IsVRAppBuild() then
		return Enum.QualityLevel.Level07
	end

	return Enum.QualityLevel.Automatic
end
