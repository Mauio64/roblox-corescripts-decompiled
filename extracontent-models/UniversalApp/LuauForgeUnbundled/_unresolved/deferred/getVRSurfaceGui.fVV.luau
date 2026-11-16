local CoreGui = game:GetService("CoreGui")

local function getVRSurfaceGui()
	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")
	local mainAppScreen_SurfaceGui

	if luaAppScreenGui then
		mainAppScreen_SurfaceGui = luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
	end

	if mainAppScreen_SurfaceGui and mainAppScreen_SurfaceGui:IsA("SurfaceGui") then
		return mainAppScreen_SurfaceGui
	end

	return nil
end

return getVRSurfaceGui
