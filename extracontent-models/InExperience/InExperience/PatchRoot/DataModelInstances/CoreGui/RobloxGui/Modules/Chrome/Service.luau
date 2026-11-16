local CorePackages = game:GetService("CorePackages")
local Chrome = script:FindFirstAncestor("Chrome")

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
assert(Chrome2.Enabled(), "Chrome.Service should not be initialized when Chrome is not enabled")

local Service = require(Chrome.ChromeShared.Service)
return Service
