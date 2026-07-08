local IsVRAppBuild = require(script.Parent.IsVRAppBuild)

return function() -- line: 3
	-- upvalues: IsVRAppBuild (copy)
	if IsVRAppBuild() then
		return Enum.QualityLevel.Level07
	end

	return Enum.QualityLevel.Automatic
end
