local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createCommentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetCommentReactionsStore/createCommentReactionsStore")

return Signals.createComputed(function()
	return createCommentReactionsStore()
end)
