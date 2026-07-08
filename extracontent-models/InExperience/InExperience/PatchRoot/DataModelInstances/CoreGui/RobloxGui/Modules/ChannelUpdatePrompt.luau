local RobloxGui = game:GetService("CoreGui").RobloxGui
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local AppUpdateService = game:GetService("AppUpdateService")
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function translateOrFallback(p1, p2, p3) -- line: 21
	-- upvalues: RobloxTranslator (copy)
	local ok, result = pcall(function() -- line: 22
		-- upvalues: RobloxTranslator (copy), p1 (copy), p3 (copy)
		return RobloxTranslator:FormatByKey(p1, p3)
	end)

	return ok and result or p2
end
local function performUpdate() -- line: 28
	-- upvalues: AppUpdateService (copy)
	AppUpdateService:PerformManagedUpdate()
end
local function resolveUpdateName(p4, p5) -- line: 32
	if p4 == "BetaProgram" then
		return p5.betaProgramName
	end

	if p4 == "BoundChannel" then
		return p5.channelName
	end

	return nil
end

return {
	init = function() -- line: 43
		-- upvalues: ErrorPrompt (copy), RobloxGui (copy), RobloxTranslator (copy), performUpdate (copy), NotificationService (copy), HttpService (copy), AppUpdateService (copy)
		local t1 = {
			MessageTextScaled = true,
			HideErrorCode = true,
			MenuIsOpenKey = "ChannelUpdatePrompt"
		}
		local v19 = ErrorPrompt.new("Default", t1)

		v19:setParent(RobloxGui)

		local function showUpdatePrompt(p6, p7) -- line: 57
			-- upvalues: RobloxTranslator (copy), v19 (copy)
			local v32 = p7 or ""
			local v38

			if p6 == "BetaProgram" then
				local v33 = "An update is required for the Beta Program you are in: \"" .. v32 .. "\"."
				local t2 = {
					RBX_NAME = v32
				}
				local s1 = "InGame.ChannelUpdatePrompt.Message.BetaProgram"
				local ok, result = pcall(function() -- line: 22
					-- upvalues: RobloxTranslator (copy), s1 (copy), t2 (copy)
					return RobloxTranslator:FormatByKey(s1, t2)
				end)

				v38 = ok and result or v33
			else
				if p6 ~= "BoundChannel" then
					warn("ChannelUpdatePrompt: unknown updateType '" .. tostring(p6) .. "', skipping prompt")

					return
				end

				local v39 = "An update is required for the channel you are bound to: \"" .. v32 .. "\"."
				local t3 = {
					RBX_NAME = v32
				}
				local s2 = "InGame.ChannelUpdatePrompt.Message.BoundChannel"
				local ok, result = pcall(function() -- line: 22
					-- upvalues: RobloxTranslator (copy), s2 (copy), t3 (copy)
					return RobloxTranslator:FormatByKey(s2, t3)
				end)

				v38 = ok and result or v39
			end

			v19:_open(v38)
		end

		v19:updateButtons({{
			Text = "Restart Now",
			LocalizationKey = "InGame.CommonUI.Button.RestartNow",
			LayoutOrder = 1,
			Primary = true,
			Callback = performUpdate
		}})
		v19:setErrorTitle("Update Required", "InGame.CommonUI.Title.UpdateRequired")

		local AbsoluteSizeX = RobloxGui.AbsoluteSize.X
		local AbsoluteSizeY = RobloxGui.AbsoluteSize.Y

		local function onScreenSizeChanged() -- line: 95
			-- upvalues: RobloxGui (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref), v19 (copy)
			local AbsoluteSizeX2 = RobloxGui.AbsoluteSize.X
			local AbsoluteSizeY2 = RobloxGui.AbsoluteSize.Y

			if AbsoluteSizeX2 ~= AbsoluteSizeX or AbsoluteSizeY2 ~= AbsoluteSizeY then
				AbsoluteSizeX = AbsoluteSizeX2
				AbsoluteSizeY = AbsoluteSizeY2
				v19:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
			end
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(onScreenSizeChanged)

		local AbsoluteSizeX3 = RobloxGui.AbsoluteSize.X
		local AbsoluteSizeY3 = RobloxGui.AbsoluteSize.Y

		if AbsoluteSizeX3 ~= AbsoluteSizeX or AbsoluteSizeY3 ~= AbsoluteSizeY then
			AbsoluteSizeX = AbsoluteSizeX3
			AbsoluteSizeY = AbsoluteSizeY3
			v19:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
		end

		NotificationService.RobloxEventReceived:Connect(function(p8) -- line: 108
			-- upvalues: HttpService (copy), showUpdatePrompt (copy)
			if p8.namespace == "ChannelUpdateRequired" then
				local data = HttpService:JSONDecode(p8.detail)
				local updateType = data.updateType
				local v49 = if updateType ~= "BetaProgram" then if updateType ~= "BoundChannel" then nil else data.channelName else data.betaProgramName

				showUpdatePrompt(data.updateType, v49)
			end
		end)

		local ok, result = pcall(function() -- line: 117
			-- upvalues: AppUpdateService (copy)
			return AppUpdateService:GetProtocolLaunchUpdateType()
		end)
		local ok2, result2 = pcall(function() -- line: 120
			-- upvalues: AppUpdateService (copy)
			return AppUpdateService:GetProtocolLaunchUpdateName()
		end)

		if ok and result ~= "" then
			showUpdatePrompt(result, ok2 and result2 or "")
		end
	end
}
