local roactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").RoactRodux

local function connectToStore(p2, p3)
	return function(unconnected)
		local v5 = roactRodux.UNSTABLE_connect2(p2, p3)(unconnected)

		function v5.getUnconnected()
			return unconnected
		end

		return v5
	end
end

return connectToStore
