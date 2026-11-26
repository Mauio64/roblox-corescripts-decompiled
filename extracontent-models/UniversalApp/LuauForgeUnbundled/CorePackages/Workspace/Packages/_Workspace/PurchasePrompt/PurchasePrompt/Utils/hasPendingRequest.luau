local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

return function(p2): boolean
	return p2.promptRequest.requestType ~= RequestType.None
end
