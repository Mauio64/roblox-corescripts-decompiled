local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createCommentSessionFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentSessionFiltersStore/createCommentSessionFiltersStore")

return Signals.createComputed(function(p2)
	return createCommentSessionFiltersStore()
end)
