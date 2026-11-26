local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUploadStore/createUploadStore")

return Signals.createComputed(function(p2)
	return createUploadStore()
end)
