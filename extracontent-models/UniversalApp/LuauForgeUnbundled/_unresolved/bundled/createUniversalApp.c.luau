local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
UIBlox.init(require("@luauforge/bundled/d"))

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local module = require("@luauforge/bundled/n")

local function createUniversalApp()
	local folder = Instance.new("Folder")
	folder.Parent = game:GetService("CoreGui")

	local root = ReactRoblox.createRoot(folder)
	root:render(React.createElement(module))

	return function()
		root:unmount()
	end
end

return createUniversalApp
