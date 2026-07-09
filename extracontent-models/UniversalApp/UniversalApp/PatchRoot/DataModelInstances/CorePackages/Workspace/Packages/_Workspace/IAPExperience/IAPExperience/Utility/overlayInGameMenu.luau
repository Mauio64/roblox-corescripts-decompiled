local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local GuiService = game:GetService("GuiService")
local AppCommonLib = require(ParentParent.AppCommonLib)

return function(p1) -- line: 7
	-- upvalues: AppCommonLib (copy), GuiService (copy), React (copy)
	if AppCommonLib.IsVRAppBuild() or GuiService:IsTenFootInterface() then
		return p1
	end

	return React.createElement("ScreenGui", {
		Enabled = true,
		DisplayOrder = 10,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	}, {
		Component = p1
	})
end
