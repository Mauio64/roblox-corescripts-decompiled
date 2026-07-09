local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Http)
require(CorePackages.Packages.LuauPolyfill)
require(Modules.LuaApp.DeepLinks.ShareLinks.LinkStatus)
require(Modules.LuaApp.DeepLinks.ShareLinks.ShareLinkTypes)

return {}
