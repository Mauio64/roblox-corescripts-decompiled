local UserInputService = game:GetService("UserInputService")

local function reportAvatarStat(p1, p2, p3) -- line: 3
	-- upvalues: UserInputService (copy)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Android then
		p2 = "Android" .. p2
	elseif Platform == Enum.Platform.IOS then
		p2 = "IOS" .. p2
	elseif Platform == Enum.Platform.Windows then
		p2 = "Windows" .. p2
	elseif Platform == Enum.Platform.OSX then
		p2 = "OSX" .. p2
	elseif Platform == Enum.Platform.XBoxOne then
		p2 = "Xbox" .. p2
	end

	p1.Diag:reportStats(p2, p3)
end

return reportAvatarStat
