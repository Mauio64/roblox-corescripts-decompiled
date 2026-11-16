local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local GetCommentSessionFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentSessionFiltersStore")
local createCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/createCommentCollectionStore")

return Signals.createComputed(function(p2)
	return createCommentCollectionStore({ sessionFilters = GetCommentSessionFiltersStore(false) })
end)
