local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local clientReplicator = nil
local function getClientReplicator()
	local v = clientReplicator == nil and game:FindService("NetworkClient")

	if v then
		clientReplicator = v:FindFirstChildOfClass("ClientReplicator")
	end

	if clientReplicator and clientReplicator:IsDescendantOf(game) then
		return clientReplicator
	end

	return nil
end

return getClientReplicator
