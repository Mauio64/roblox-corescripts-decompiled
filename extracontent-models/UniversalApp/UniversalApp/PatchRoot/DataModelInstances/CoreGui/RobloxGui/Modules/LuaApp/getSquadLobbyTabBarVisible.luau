local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local SystemBarVisibility = require(Modules.LuaApp.Enum.SystemBarVisibility)

return function(p1) -- line: 8
	-- upvalues: UserInputService (copy), FormFactor (copy), SystemBarVisibility (copy)
	local None = Enum.Platform.None

	pcall(function() -- line: 10
		-- upvalues: None (ref), UserInputService (copy)
		None = UserInputService:GetPlatform()
	end)

	if None == Enum.Platform.IOS or None == Enum.Platform.Android then
		if p1.FormFactor == FormFactor.WIDE then
			return SystemBarVisibility.Visible
		end

		return SystemBarVisibility.Hidden
	end

	return SystemBarVisibility.PolicyDependent
end
