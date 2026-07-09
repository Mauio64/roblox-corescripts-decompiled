local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild

local function getHasBackgroundMusic() -- line: 6
	-- upvalues: IsVRAppBuild (copy), GuiService (copy)
	return IsVRAppBuild() or GuiService:IsTenFootInterface()
end

return getHasBackgroundMusic
