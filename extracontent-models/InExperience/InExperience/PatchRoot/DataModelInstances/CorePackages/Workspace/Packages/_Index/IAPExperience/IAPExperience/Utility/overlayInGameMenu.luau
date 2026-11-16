local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)

return function(component)
	if AppCommonLib.IsVRAppBuild() or AppCommonLib.isTenFootInterface() then
		return component
	end

	return React.createElement(
		"ScreenGui",
		{
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			DisplayOrder = 10,
			IgnoreGuiInset = true
		},
		{ Component = component }
	)
end
