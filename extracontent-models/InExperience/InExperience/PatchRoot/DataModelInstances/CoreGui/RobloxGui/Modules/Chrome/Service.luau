local CorePackages = game:GetService("CorePackages")
local Chrome = script:FindFirstAncestor("Chrome")

assert(require(CorePackages.Workspace.Packages.Chrome).Enabled(), "Chrome.Service should not be initialized when Chrome is not enabled")

return (require(Chrome.ChromeShared.Service))
