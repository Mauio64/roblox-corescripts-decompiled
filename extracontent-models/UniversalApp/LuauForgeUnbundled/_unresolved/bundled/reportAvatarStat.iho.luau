local UserInputService = game:GetService("UserInputService")

local function reportAvatarStat(p2, p3, p4)
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		p3 = "Android" .. p3
	elseif platform == Enum.Platform.IOS then
		p3 = "IOS" .. p3
	elseif platform == Enum.Platform.Windows then
		p3 = "Windows" .. p3
	elseif platform == Enum.Platform.OSX then
		p3 = "OSX" .. p3
	elseif platform == Enum.Platform.XBoxOne then
		p3 = "Xbox" .. p3
	end

	p2.Diag:reportStats(p3, p4)
end

return reportAvatarStat
