local function defaultHasJoinConnected(): boolean
	return game:FindService("NetworkClient") ~= nil
end

return function(p2, p3)
	if (p3 or defaultHasJoinConnected)() then
		return
	end

	local ReplicatedFirst = game:GetService("ReplicatedFirst")
	local v5 = p2 or ReplicatedFirst

	if v5:IsDefaultLoadingGuiRemoved() then
		return
	end

	v5:SetDefaultLoadingGuiRemoved()
end
