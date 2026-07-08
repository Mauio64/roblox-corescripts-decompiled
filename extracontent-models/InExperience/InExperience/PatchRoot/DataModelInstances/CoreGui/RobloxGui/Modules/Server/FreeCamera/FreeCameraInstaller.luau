local v1 = game:DefineFastFlag("AllowLuobuFreecamGroup", false)
local v2 = game:DefineFastFlag("UseGetCanManageAsync", false) and game:GetEngineFeature("LuaGetCanManageAsync")
local v3 = game:DefineFastFlag("FreeCameraToIAS", false) and game:GetEngineFeature("PlayerScriptStatusProperty")
local t1 = { 4358041 }
local t2 = { 7842878 }
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)
local FFlagUserPresenceTokenRccCheckPermissionsLua = require(RobloxGui.Modules.Common.Flags.FFlagUserPresenceTokenRccCheckPermissionsLua)

local function Install() -- line: 35
	-- upvalues: v3 (copy), StarterPlayer (copy), ServerUtil (copy), RunService (copy), v2 (copy), Url (copy), HttpService (copy), FFlagUserPresenceTokenRccCheckPermissionsLua (copy), HttpRbxApiService (copy), t1 (copy), v1 (copy), PolicyService (copy), t2 (copy), Players (copy)
	local function WaitForChildOfClass(p1, p2) -- line: 36
		local p2_2 = p1:FindFirstChildOfClass(p2)

		while not p2_2 or p2 ~= p2_2.ClassName do
			p2_2 = p1.ChildAdded:Wait()
		end

		return p2_2
	end
	local function AddFreeCamera(p3) -- line: 44
		-- upvalues: WaitForChildOfClass (copy), v3 (copy), StarterPlayer (copy), ServerUtil (copy)
		local v28 = WaitForChildOfClass(p3, "PlayerGui")
		local v31

		if v3 then
			local PlayerModuleStatus = StarterPlayer.PlayerModuleStatus
			local v30 = not (PlayerModuleStatus == 1 or PlayerModuleStatus == 2) and "FreeCamera" or "FreeCameraIAS"

			v31 = script.Parent:WaitForChild(v30)
		else
			v31 = script.Parent:WaitForChild("FreeCamera")
		end

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "Freecam"
		ScreenGui.ResetOnSpawn = false

		local LocalScript = Instance.new("LocalScript")

		LocalScript.Name = "FreecamScript"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			LocalScript.Source = ServerUtil.getSourceForServerScript(v31)
		else
			LocalScript.Source = v31.Source
		end

		LocalScript.Parent = ScreenGui
		ScreenGui.Parent = v28
	end
	local function ShouldAddFreeCam(p4) -- line: 73
		-- upvalues: RunService (copy), v2 (copy), Url (copy), HttpService (copy), FFlagUserPresenceTokenRccCheckPermissionsLua (copy), HttpRbxApiService (copy), t1 (copy), v1 (copy), PolicyService (copy), t2 (copy)
		if RunService:IsStudio() then
			return true
		end

		if p4.UserId <= 0 then
			return false
		end

		if v2 then
			local ok, result = pcall(p4.GetCanManageAsync, p4)

			if ok and result then
				return true
			end
		else
			local ok, result = pcall(function() -- line: 88
				-- upvalues: Url (copy), HttpService (copy), p4 (copy), FFlagUserPresenceTokenRccCheckPermissionsLua (copy), HttpRbxApiService (copy)
				local v49 = string.format(Url.APIS_URL .. "asset-permissions-api/v1/rcc/assets/check-permissions")
				local json = HttpService:JSONEncode({
					requests = {{
						action = "Edit",
						subject = {
							subjectType = "User",
							subjectId = p4.UserId
						},
						assetId = game.PlaceId
					}}
				})
				local v51 = if not FFlagUserPresenceTokenRccCheckPermissionsLua then HttpRbxApiService:PostAsyncFullUrl(v49, json) else HttpRbxApiService:PostAsyncFullUrlForPlayer(v49, json, p4)

				return HttpService:JSONDecode(v51)
			end)

			if ok then
				local v39 = result.results[1]

				if v39.value and v39.value.status == "HasPermission" then
					return true
				end
			end
		end

		for _, v in ipairs(t1) do
			local ok, result = pcall(p4.IsInGroup, p4, v)

			if ok and result then
				return true
			end
		end

		if v1 and game:GetEngineFeature("LuobuModerationStatus") and PolicyService.IsLuobuServer == Enum.TriStateBoolean.True then
			for _, v in ipairs(t2) do
				local ok, result = pcall(p4.IsInGroup, p4, v)

				if ok and result then
					return true
				end
			end
		end

		return false
	end
	local function PlayerAdded(p5) -- line: 144
		-- upvalues: ShouldAddFreeCam (copy), AddFreeCamera (copy)
		if ShouldAddFreeCam(p5) then
			AddFreeCamera(p5)
		end
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerAdded)(player)
	end
end

return Install
