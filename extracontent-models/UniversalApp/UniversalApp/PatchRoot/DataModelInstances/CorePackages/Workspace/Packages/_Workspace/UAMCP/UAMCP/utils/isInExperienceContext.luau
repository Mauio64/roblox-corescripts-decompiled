local function isInExperienceContext() -- line: 1
	local CoreGui = game:FindFirstChild("CoreGui")

	if not CoreGui then
		return false
	end

	local TopBarApp = CoreGui:FindFirstChild("TopBarApp")

	if not TopBarApp then
		return false
	end

	local TopBarApp2 = TopBarApp:FindFirstChild("TopBarApp")

	if TopBarApp2 and TopBarApp2:IsA("ScreenGui") then
		return not CoreGui:FindFirstChild("LuaAppScreenGui")
	end

	return false
end

return isInExperienceContext
