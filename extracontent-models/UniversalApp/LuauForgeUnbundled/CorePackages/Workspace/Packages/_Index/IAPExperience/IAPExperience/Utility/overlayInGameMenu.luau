local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/AppCommonLib")

return function(p2)
	if AppCommonLib.IsVRAppBuild() or AppCommonLib.isTenFootInterface() then
		return p2
	end

	return React.createElement(
		"ScreenGui",
		{
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			DisplayOrder = 10,
			IgnoreGuiInset = true
		},
		{ Component = p2 }
	)
end
