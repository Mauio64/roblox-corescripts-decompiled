local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ScreenTime = require(CorePackages.Workspace.Packages.ScreenTime)
local HttpRequests = ScreenTime.HttpRequests
local Constants = ScreenTime.Constants
local GetFFlagScreenTimeSignalR = ScreenTime.GetFFlagScreenTimeSignalR
local Utils = ScreenTime.Utils
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Modules = CoreGui.RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local AntiAddictionPrompt = require(Modules.LuaApp.Components.AntiAddictionPrompt)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local Toast = require(CorePackages.Packages.UIBlox).App.Dialog.Toast
local Constants2 = require(Modules.LuaApp.Constants)
local withLocalization = require(Modules.LuaApp.withLocalization)
local v27 = Roact.Component:extend("ScreenTimeEventReceiver")
local _ = {
	Normal = 1,
	LockedOut = 2,
	OpenWebView = 3
}
local _ = {
	Default = 0,
	LogoutOnClose = 1,
	Toast = 2
}
local _ = {
	FullScreen = "fullScreen"
}

function v27.showScreenTimeHeartbeatConsecutiveFailurePrompt(p1) -- line: 52
	p1:setState({
		heartbeatConsecutiveFailure = true
	})
end
function v27.init(p2) -- line: 58
	-- upvalues: HttpRequests (copy), HttpService (copy), Utils (copy), MemStorageService (copy), RunService (copy), Logging (copy), GetFFlagScreenTimeSignalR (copy), Constants (copy), RbxAnalyticsService (copy), NotificationType (copy)
	local RobloxEventReceiver = p2.props.RobloxEventReceiver

	p2:setState({
		promptsCount = 0,
		promptsIndex = 0,
		heartbeatConsecutiveFailure = false,
		prompts = {}
	})

	function p2.setScreenTimePrompts(p3) -- line: 68
		-- upvalues: p2 (copy)
		local t1 = {}

		for _, v in ipairs(p3) do
			table.insert(t1, {
				type = v.type,
				instructionName = v.instructionName,
				id = v.serialId,
				title = v.title,
				text = v.message,
				url = v.url,
				modalType = v.modalType
			})
		end

		local v52 = #t1

		p2:setState({
			promptsIndex = 1,
			promptsCount = v52,
			prompts = t1
		})
	end

	p2.screenTimeHttpRequests = HttpRequests:new(HttpService)
	p2.screenTimeUtils = Utils:new({
		globalGetter = function(p4) -- line: 96
			-- upvalues: MemStorageService (copy)
			return MemStorageService:GetItem(p4)
		end,
		globalSetter = function(p5, p6) -- line: 99
			-- upvalues: MemStorageService (copy)
			MemStorageService:SetItem(p5, p6)
		end
	})

	function p2.processInstructions(p7) -- line: 104
		-- upvalues: p2 (copy), RunService (copy)
		local t2 = {}

		for _, v in ipairs(p7) do
			if v.type == 2 then
				p2.screenTimeUtils:setLockedOut()
			end

			if v.type ~= 1 or RunService:IsRunning() then
				table.insert(t2, v)
			end
		end

		p2.setScreenTimePrompts(t2)
	end
	function p2.requestInstructions() -- line: 120
		-- upvalues: p2 (copy), Logging (copy)
		p2.screenTimeHttpRequests:getInstructions(function(p8, p9, p10) -- line: 121
			-- upvalues: p2 (copy), Logging (copy)
			if p8 then
				p2.processInstructions(p10)

				return
			end

			if p9 then
				Logging.warn("ScreenTimeEventReceiver requestInstructions failed: unauthorized")
				p2.props.doLogout(p2.props.networking, p2.props.guiService)

				return
			end

			Logging.warn("ScreenTimeEventReceiver requestInstructions failed: error")
		end)
	end

	p2.tokens = {}

	if GetFFlagScreenTimeSignalR() then
		local v35 = RobloxEventReceiver:observeEvent(Constants.SIGNALR_NAMESPACE, function(_, p12) -- line: 138
			-- upvalues: Constants (copy), p2 (copy)
			if p12 == Constants.SIGNALR_TYPE_NEW_INSTRUCTION then
				p2.requestInstructions()
			end
		end)

		table.insert(p2.tokens, v35)
	else
		local v36 = RobloxEventReceiver:observeEvent(Constants.HEARTBEAT_NOTIFICATIONS_NAMESPACE, function(p13, p14) -- line: 148
			-- upvalues: Constants (copy), p2 (copy), Logging (copy)
			if p14 == Constants.HEARTBEAT_CONSECUTIVE_FAILURE then
				p2:showScreenTimeHeartbeatConsecutiveFailurePrompt()

				return
			end

			if p13.notifications == nil then
				Logging.warn("ScreenTimeEventReceiver empty heartbeat notifications")

				return
			end

			for _, v in ipairs(p13.notifications) do
				if v.type == Constants.HEARTBEAT_NOTIFICATION_TYPE_NEW_INSTRUCTION then
					p2.requestInstructions()
				end
			end
		end)

		table.insert(p2.tokens, v36)
	end

	function p2.ok() -- line: 168
		-- upvalues: p2 (copy)
		local promptsIndex = p2.state.promptsIndex
		local v67 = p2.state.prompts[promptsIndex]

		p2.screenTimeHttpRequests:reportExecution(v67.instructionName, v67.id)

		if v67.type == 2 then
			return
		end

		if v67.type == 3 then
			p2.openWebView(v67.url)
		end

		local v68 = promptsIndex + 1

		if v68 > p2.state.promptsCount then
			p2:setState({
				promptsIndex = 0,
				promptsCount = 0
			})

			return
		end

		p2:setState({
			promptsIndex = v68
		})
	end
	function p2.toastDismissed() -- line: 194
		-- upvalues: p2 (copy)
		local promptsIndex = p2.state.promptsIndex
		local v70 = p2.state.prompts[promptsIndex]

		p2.screenTimeHttpRequests:reportExecution(v70.instructionName, v70.id)

		local v71 = promptsIndex + 1

		if v71 > p2.state.promptsCount then
			p2:setState({
				promptsIndex = 0,
				promptsCount = 0
			})

			return
		end

		p2:setState({
			promptsIndex = v71
		})
	end
	function p2.heartbeatConsecutiveFailureLogoutCallback() -- line: 214
		-- upvalues: RbxAnalyticsService (copy)
		RbxAnalyticsService:ReportCounter("ScreenTime-LogoutAfterConsecutiveHeartbeatFailure-FromApp")
	end
	function p2.openWebView(p15) -- line: 218
		-- upvalues: p2 (copy), NotificationType (copy), HttpService (copy)
		local guiService = p2.props.guiService
		local SDK_OPEN_URL = NotificationType.SDK_OPEN_URL

		guiService:BroadcastNotification(HttpService:JSONEncode({
			encodeUrl = false,
			type = "fullScreen",
			url = p15
		}), SDK_OPEN_URL)
	end
end
function v27.render(p16) -- line: 238
	-- upvalues: Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), Constants2 (copy), Toast (copy), AntiAddictionPrompt (copy), withLocalization (copy)
	local v38 = nil

	if p16.state.promptsCount > 0 then
		local promptsIndex = p16.state.promptsIndex
		local v40 = p16.state.prompts[promptsIndex]
		local type = v40.type
		local v42 = v40.id or ""
		local text = v40.text

		v38 = if v40.modalType ~= 2 then Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			["prompt:" .. v42] = Roact.createElement(AntiAddictionPrompt, {
				okCallback = p16.ok,
				logoutCallback = p16.ok,
				message = text,
				lockOut = type == 2
			})
		}) else Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			["prompt:" .. v42] = Roact.createElement(ScreenGuiWithBlurControl, {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = Constants2.DisplayOrder.AntiAddictionPrompt
			}, {
				Toast = Roact.createElement(Toast, {
					duration = 5,
					toastContent = {
						toastTitle = text,
						onDismissed = p16.toastDismissed
					}
				})
			})
		})
	end

	if p16.state.heartbeatConsecutiveFailure then
		v38 = withLocalization({
			heartbeatConsecutiveFailureMessage = "Feature.Screentime.Description.HeartbeatConsecutiveFailure"
		})(function(p17) -- line: 281
			-- upvalues: Roact (copy), CoreGui (copy), AntiAddictionPrompt (copy), p16 (copy)
			local heartbeatConsecutiveFailureMessage = p17.heartbeatConsecutiveFailureMessage

			return Roact.createElement(Roact.Portal, {
				target = CoreGui
			}, {
				hearbeatFailurePrompt = Roact.createElement(AntiAddictionPrompt, {
					lockOut = true,
					logoutCallback = p16.heartbeatConsecutiveFailureLogoutCallback,
					message = heartbeatConsecutiveFailureMessage
				})
			})
		end)
	end

	return v38
end
function v27.willUnmount(p18) -- line: 297
	for _, v in pairs(p18.tokens) do
		v:disconnect()
	end
end

local v31 = RoactRodux.connect(nil, function(p19) -- line: 303
	-- upvalues: Logout (copy), luaLogoutReasonNames (copy)
	return {
		doLogout = function(p20, p21) -- line: 305
			-- upvalues: p19 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p19(Logout(p20, p21, luaLogoutReasonNames.ScreenTimeEvent))
		end
	}
end)(v27)

return RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService
})(v31)
