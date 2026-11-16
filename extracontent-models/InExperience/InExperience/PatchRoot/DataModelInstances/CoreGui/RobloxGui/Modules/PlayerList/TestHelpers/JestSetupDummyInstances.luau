local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

if not RobloxGui:FindFirstChild("SendNotificationInfo") then
	local sendNotificationInfo = Instance.new("BindableEvent")
	sendNotificationInfo.Name = "SendNotificationInfo"
	sendNotificationInfo.Parent = RobloxGui
end
