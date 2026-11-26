local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local module = require("@luauforge/bundled/iim")
local httpRequests = module.HttpRequests
local constants = module.Constants
local getFFlagScreenTimeSignalR = module.GetFFlagScreenTimeSignalR
local utils = module.Utils
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module3 = require("@luauforge/bundled/fvN")
local module4 = require("@luauforge/bundled/ijv")
local module5 = require("@luauforge/bundled/ggi")
local module6 = require("@luauforge/bundled/ggp")
local module7 = require("@luauforge/bundled/gIF")
local UIBlox = require(CorePackages.Packages.UIBlox)
local toast = UIBlox.App.Dialog.Toast
local module8 = require("@luauforge/bundled/dzD")

local module9 = require("@luauforge/bundled/egZ")

local extended = Roact.Component:extend("ScreenTimeEventReceiver")

local v5 = { Normal = 1, LockedOut = 2, OpenWebView = 3 }

local v6 = { Default = 0, LogoutOnClose = 1, Toast = 2 }

local v7 = { FullScreen = "fullScreen" }

function extended:showScreenTimeHeartbeatConsecutiveFailurePrompt()
	self:setState({ heartbeatConsecutiveFailure = true })
end

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver

	self:setState({
		promptsCount = 0,
		promptsIndex = 0,
		prompts = {},
		heartbeatConsecutiveFailure = false
	})

	function self.setScreenTimePrompts(list)
		local v8 = {}

		for i, item in ipairs(list) do
			table.insert(v8, {
				type = item.type,
				instructionName = item.instructionName,
				id = item.serialId,
				title = item.title,
				text = item.message,
				url = item.url,
				modalType = item.modalType
			})
		end

		self:setState({
			promptsIndex = 1,
			promptsCount = #v8,
			prompts = v8
		})
	end

	self.screenTimeHttpRequests = httpRequests:new(HttpService)
	self.screenTimeUtils = utils:new({
		globalGetter = function(p2)
			return MemStorageService:GetItem(p2)
		end,
		globalSetter = function(p2, p3)
			MemStorageService:SetItem(p2, p3)
		end
	})

	function self.processInstructions(list)
		local v8 = {}

		for i, item in ipairs(list) do
			if item.type == 2 then
				self.screenTimeUtils:setLockedOut()
			end

			if item.type ~= 1 or RunService:IsRunning() then
				table.insert(v8, item)
			end
		end

		self.setScreenTimePrompts(v8)
	end

	function self.requestInstructions()
		self.screenTimeHttpRequests:getInstructions(function(p2, p3, p4)
			if p2 then
				self.processInstructions(p4)
				return
			end

			if not p3 then
				logging.warn("ScreenTimeEventReceiver requestInstructions failed: error")

				return
			end

			logging.warn("ScreenTimeEventReceiver requestInstructions failed: unauthorized")
			self.props.doLogout(self.props.networking, self.props.guiService)
		end)
	end

	self.tokens = {}

	if getFFlagScreenTimeSignalR() then
		local v8 = robloxEventReceiver:observeEvent(constants.SIGNALR_NAMESPACE, function(p2, p3)
			if p3 == constants.SIGNALR_TYPE_NEW_INSTRUCTION then
				self.requestInstructions()
			end
		end)

		table.insert(self.tokens, v8)
	else
		local v8 = robloxEventReceiver:observeEvent(
			constants.HEARTBEAT_NOTIFICATIONS_NAMESPACE,
			function(p2, p3)
				if p3 == constants.HEARTBEAT_CONSECUTIVE_FAILURE then
					self:showScreenTimeHeartbeatConsecutiveFailurePrompt()
					return
				end

				if p2.notifications == nil then
					logging.warn("ScreenTimeEventReceiver empty heartbeat notifications")
					return
				end

				for i, notification in ipairs(p2.notifications) do
					if notification.type == constants.HEARTBEAT_NOTIFICATION_TYPE_NEW_INSTRUCTION then
						self.requestInstructions()
					end
				end
			end
		)

		table.insert(self.tokens, v8)
	end

	function self.ok()
		local promptsIndex = self.state.promptsIndex
		local prompt = self.state.prompts[promptsIndex]

		self.screenTimeHttpRequests:reportExecution(prompt.instructionName, prompt.id)

		if prompt.type == 2 then
			return
		end

		if prompt.type == 3 then
			self.openWebView(prompt.url)
		end

		local v8 = promptsIndex + 1

		if self.state.promptsCount < v8 then
			self:setState({ promptsIndex = 0, promptsCount = 0 })
		else
			self:setState({ promptsIndex = v8 })
		end
	end

	function self.toastDismissed()
		local promptsIndex = self.state.promptsIndex
		local prompt = self.state.prompts[promptsIndex]

		self.screenTimeHttpRequests:reportExecution(prompt.instructionName, prompt.id)
		local v8 = promptsIndex + 1

		if self.state.promptsCount < v8 then
			self:setState({ promptsIndex = 0, promptsCount = 0 })
		else
			self:setState({ promptsIndex = v8 })
		end
	end

	function self.heartbeatConsecutiveFailureLogoutCallback()
		RbxAnalyticsService:ReportCounter("ScreenTime-LogoutAfterConsecutiveHeartbeatFailure-FromApp")
	end

	function self.openWebView(p2)
		local guiService = self.props.guiService
		local SDK_OPEN_URL = module3.SDK_OPEN_URL

		guiService:BroadcastNotification(
			HttpService:JSONEncode({ url = p2, encodeUrl = false, type = "fullScreen" }),
			SDK_OPEN_URL
		)
	end
end

function extended.render(props)
	local v8

	if props.state.promptsCount > 0 then
		local promptsIndex = props.state.promptsIndex
		local prompt = props.state.prompts[promptsIndex]
		local kind = prompt.type
		local id = prompt.id or ""
		local text = prompt.text

		if prompt.modalType == 2 then
			v8 = Roact.createElement(Roact.Portal, { target = CoreGui }, {
				["prompt:" .. id] = Roact.createElement(
					module7,
					{
						ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
						DisplayOrder = module8.DisplayOrder.AntiAddictionPrompt
					},
					{
						Toast = Roact.createElement(toast, {
							toastContent = {
								toastTitle = text,
								onDismissed = props.toastDismissed
							},
							duration = 5
						})
					}
				)
			})
		else
			v8 = Roact.createElement(Roact.Portal, { target = CoreGui }, {
				["prompt:" .. id] = Roact.createElement(module4, {
					okCallback = props.ok,
					logoutCallback = props.ok,
					message = text,
					lockOut = kind == 2
				})
			})
		end
	end

	if props.state.heartbeatConsecutiveFailure then
		v8 = module9({
			heartbeatConsecutiveFailureMessage = "Feature.Screentime.Description.HeartbeatConsecutiveFailure"
		})(function(p2)
			local heartbeatConsecutiveFailureMessage = p2.heartbeatConsecutiveFailureMessage
			return Roact.createElement(Roact.Portal, { target = CoreGui }, {
				hearbeatFailurePrompt = Roact.createElement(module4, {
					logoutCallback = props.heartbeatConsecutiveFailureLogoutCallback,
					message = heartbeatConsecutiveFailureMessage,
					lockOut = true
				})
			})
		end)
	end

	return v8
end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

local v8 = RoactRodux.connect(nil, function(callback)
	return {
		doLogout = function(p2, p3)
			callback(module5(p2, p3, module6.ScreenTimeEvent))
		end
	}
end)(extended)

return roactServices.connect({ networking = module2, guiService = appGuiService })(v8)
