local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local selfViewVisibilityUpdatedSignal = require(Modules.SelfView.selfViewVisibilityUpdatedSignal)

local selfViewIsOpenAndVisible = false
local PublicApi = {}

function PublicApi.getSelfViewIsOpenAndVisible()
	return selfViewIsOpenAndVisible
end

function PublicApi.setSelfViewIsOpenAndVisible(p)
	selfViewIsOpenAndVisible = p
	selfViewVisibilityUpdatedSignal:fire()
end

return PublicApi
