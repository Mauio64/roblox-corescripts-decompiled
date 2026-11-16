local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local selfViewVisibilityUpdatedSignal = require(RobloxGui.Modules.SelfView.selfViewVisibilityUpdatedSignal)
local publicApi = require(RobloxGui.Modules.SelfView.publicApi)

return {
	selfViewVisibilityUpdatedSignal = selfViewVisibilityUpdatedSignal,
	getSelfViewVisibility = publicApi.getSelfViewIsOpenAndVisible
}
