local CoreGui = game:GetService("CoreGui")

local function getVRSurfaceGui() -- line: 7
	-- upvalues: CoreGui (copy)
	local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")
	local v4 = if not LuaAppScreenGui then nil else LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")

	if v4 and v4:IsA("SurfaceGui") then
		return v4
	end

	return nil
end

return getVRSurfaceGui
