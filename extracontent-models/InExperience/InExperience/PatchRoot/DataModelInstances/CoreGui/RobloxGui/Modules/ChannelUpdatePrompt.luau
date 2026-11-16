local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local AppUpdateService = game:GetService("AppUpdateService")

local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function translateOrFallback(p, p2, p3) -- 2 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return RobloxTranslator:FormatByKey(p, p3)
	end)
	return success and result or p2
end

local function performUpdate()
	AppUpdateService:PerformManagedUpdate()
end

local function resolveUpdateName(updateType, jsonDecode) -- 1 equivalent call inferred from this helper
	if updateType == "BetaProgram" then
		return jsonDecode.betaProgramName
	elseif updateType == "BoundChannel" then
		return jsonDecode.channelName
	end

	return nil
end

return {
	init = function()
		local default = ErrorPrompt.new("Default", {
			MessageTextScaled = true,
			HideErrorCode = true,
			MenuIsOpenKey = "ChannelUpdatePrompt"
		})
		default:setParent(RobloxGui)

		local function showUpdatePrompt(p, value)
			local v = value or ""
			local v2

			if p == "BetaProgram" then
				v2 = "An update is required for the Beta Program you are in: \"" .. v .. "\"."
				v2 = translateOrFallback("InGame.ChannelUpdatePrompt.Message.BetaProgram", v2, { -- inferred equivalent call
					RBX_NAME = v
				})
			else
				if p ~= "BoundChannel" then
					warn("ChannelUpdatePrompt: unknown updateType '" .. tostring(p) .. "', skipping prompt")
					return
				end

				v2 = "An update is required for the channel you are bound to: \"" .. v .. "\"."
				v2 = translateOrFallback("InGame.ChannelUpdatePrompt.Message.BoundChannel", v2, { -- inferred equivalent call
					RBX_NAME = v
				})
			end

			default:_open(v2)
		end

		default:updateButtons({
			{
				Text = "Restart Now",
				LocalizationKey = "InGame.CommonUI.Button.RestartNow",
				LayoutOrder = 1,
				Callback = performUpdate,
				Primary = true
			}
		})
		default:setErrorTitle("Update Required", "InGame.CommonUI.Title.UpdateRequired")

		local v = RobloxGui.AbsoluteSize.X
		local v2 = RobloxGui.AbsoluteSize.Y

		local function onScreenSizeChanged() -- 1 equivalent call inferred from this helper
			local x = RobloxGui.AbsoluteSize.X
			local y = RobloxGui.AbsoluteSize.Y

			if v ~= x or v2 ~= y then
				v = x
				v2 = y
				default:resizeWidthAndHeight(v, v2)
			end
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(onScreenSizeChanged)
		onScreenSizeChanged() -- inferred equivalent call
		NotificationService.RobloxEventReceived:Connect(function(p)
			if p.namespace == "ChannelUpdateRequired" then
				local jsonDecode = HttpService:JSONDecode(p.detail)
				local updateName = resolveUpdateName(jsonDecode.updateType, jsonDecode) -- inferred equivalent call
				showUpdatePrompt(jsonDecode.updateType, updateName)
			end
		end)

		local success, result = pcall(function()
			return AppUpdateService:GetProtocolLaunchUpdateType()
		end)

		local success2, result2 = pcall(function()
			return AppUpdateService:GetProtocolLaunchUpdateName()
		end)

		if success and result ~= "" then
			showUpdatePrompt(result, success2 and result2 or "")
		end
	end
}
