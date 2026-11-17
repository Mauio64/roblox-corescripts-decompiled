local ReplicatedFirst = game:GetService("ReplicatedFirst")
local DefaultLoadingScreen = {}

function DefaultLoadingScreen.isRemoved()
	return ReplicatedFirst:IsDefaultLoadingGuiRemoved()
end

function DefaultLoadingScreen.subscribeRemoved(onDefaultLoadingGuiRemoved)
	local defaultLoadingGuiRemovedConnection = ReplicatedFirst.DefaultLoadingGuiRemoved:Connect(onDefaultLoadingGuiRemoved)
	return function()
		defaultLoadingGuiRemovedConnection:Disconnect()
	end
end

return DefaultLoadingScreen
