local ReplicatedFirst = game:GetService("ReplicatedFirst")

return {
	isRemoved = function()
		return ReplicatedFirst:IsDefaultLoadingGuiRemoved()
	end,
	subscribeRemoved = function(onDefaultLoadingGuiRemoved)
		local defaultLoadingGuiRemovedConnection = ReplicatedFirst.DefaultLoadingGuiRemoved:Connect(onDefaultLoadingGuiRemoved)
		return function()
			defaultLoadingGuiRemovedConnection:Disconnect()
		end
	end
}
