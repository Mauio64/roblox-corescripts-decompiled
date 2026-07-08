game:GetService("CoreGui"):WaitForChild("RobloxGui")

local ClientReplicator = nil

local function getClientReplicator() -- line: 4
	-- upvalues: ClientReplicator (ref)
	if ClientReplicator == nil then
		local Service = game:FindService("NetworkClient")

		if Service then
			ClientReplicator = Service:FindFirstChildOfClass("ClientReplicator")
		end
	end

	if ClientReplicator and ClientReplicator:IsDescendantOf(game) then
		return ClientReplicator
	end

	return nil
end

return getClientReplicator
