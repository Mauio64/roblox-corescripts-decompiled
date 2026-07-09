local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.UIBlox).init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UniversalApp = require(Modules.LuaApp.Components.UniversalApp)

local function createUniversalApp() -- line: 12
	-- upvalues: ReactRoblox (copy), React (copy), UniversalApp (copy)
	local Folder = Instance.new("Folder")

	Folder.Parent = game:GetService("CoreGui")

	local v8 = ReactRoblox.createRoot(Folder)

	v8:render(React.createElement(UniversalApp))

	return function() -- line: 19
		-- upvalues: v8 (copy)
		v8:unmount()
	end
end

return createUniversalApp
