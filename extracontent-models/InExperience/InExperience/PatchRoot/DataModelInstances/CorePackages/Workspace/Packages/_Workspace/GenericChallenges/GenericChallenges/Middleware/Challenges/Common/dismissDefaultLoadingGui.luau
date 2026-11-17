local function defaultHasJoinConnected(): boolean
	return game:FindService("NetworkClient") ~= nil
end

return function(p, callback)
	if (callback or defaultHasJoinConnected)() then
		return
	end

	local ReplicatedFirst = game:GetService("ReplicatedFirst")
	local v = p or ReplicatedFirst

	if v:IsDefaultLoadingGuiRemoved() then
		return
	end

	v:SetDefaultLoadingGuiRemoved()
end
