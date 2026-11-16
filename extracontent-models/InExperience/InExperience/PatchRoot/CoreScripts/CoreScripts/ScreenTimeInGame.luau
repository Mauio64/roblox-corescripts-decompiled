local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")

local ScreenTime = require(CorePackages.Workspace.Packages.ScreenTime)
local HttpRequests = ScreenTime.HttpRequests
local Constants = ScreenTime.Constants
local GetFFlagScreenTimeSignalR = ScreenTime.GetFFlagScreenTimeSignalR
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Logging = AppCommonLib.Logging
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)

local function leaveGame() -- 1 equivalent call inferred from this helper
	GuiService.SelectedCoreObject = nil
	game:Shutdown()
end

local _ = { Warning = 1, Lockout = 2, OpenWebView = 3 }

local v = HttpRequests:new(HttpService)
local robloxEventReceivedConnection = nil

local function disconnectAndLeaveGame() -- 2 equivalent calls inferred from this helper
	if robloxEventReceivedConnection then
		robloxEventReceivedConnection:Disconnect()
		robloxEventReceivedConnection = nil
	end

	leaveGame() -- inferred equivalent call
end

local v2 = {
	pendingResolveMessage = {},
	displaying = nil,
	resolvedMessage = {},
	displayMessageCallback = nil,
	update = function(self, items)
		for _, item in pairs(items) do
			local v2 = {
				id = item.serialId,
				instructionName = item.instructionName,
				message = item.message,
				type = item.type
			}

			table.insert(self.pendingResolveMessage, v2)
		end

		self:processNext()
	end,
	processNext = function(self)
		if self.displaying then
			return
		end

		local displaying = table.remove(self.pendingResolveMessage, 1)

		if not displaying then
			return
		end

		if self.resolvedMessage[displaying.id] then
			self:processNext()
			return
		end

		self.displaying = displaying

		if self.displayMessageCallback then
			self.displayMessageCallback(displaying.message)
		end
	end,
	resolve = function(self)
		self.resolvedMessage[self.displaying.id] = self.displaying.message

		v:reportExecution(self.displaying.instructionName, self.displaying.id)

		self.displaying = nil
		self:processNext()
	end
}

local default = ErrorPrompt.new("Default", {
	MessageTextScaled = true,
	HideErrorCode = true,
	MenuIsOpenKey = "ScreenTimePrompt"
})
default:setParent(RobloxGui)

local function displayMessage(p)
	default:_open(p)
end

local function resolveMessage()
	default:_close()
	v2:resolve()
end

v2.displayMessageCallback = displayMessage
default:updateButtons({
	{
		Text = "OK",
		LocalizationKey = "InGame.CommonUI.Button.Ok",
		LayoutOrder = 1,
		Callback = resolveMessage,
		Primary = true
	}
})
default:setErrorTitle("Warning", "InGame.CommonUI.Title.Warning")

local v3 = RobloxGui.AbsoluteSize.X
local v4 = RobloxGui.AbsoluteSize.Y

local function onScreenSizeChanged() -- 1 equivalent call inferred from this helper
	if not default then
		return
	end

	local x = RobloxGui.AbsoluteSize.X
	local y = RobloxGui.AbsoluteSize.Y

	if v3 ~= x or v4 ~= y then
		v3 = x
		v4 = y
		default:resizeWidthAndHeight(v3, v4)
	end
end

RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(onScreenSizeChanged)
onScreenSizeChanged() -- inferred equivalent call

local function screenTimeStatesUpdated(list)
	local v5 = {}

	for _, item in ipairs(list) do
		if item.type == 1 then
			table.insert(v5, item)
		elseif item.type == 2 then
			disconnectAndLeaveGame() -- inferred equivalent call
			return
		else
			local _ = item.type == 3
		end
	end

	v2:update(v5)
end

local function requestInstructions()
	v:getInstructions(function(p, p2, p3)
		if p then
			screenTimeStatesUpdated(p3)
		elseif p2 then
			Logging.warn("ScreenTimeInGame requestInstructions failed: unauthorized")
		else
			Logging.warn("ScreenTimeInGame requestInstructions failed: error")
		end
	end)
end

robloxEventReceivedConnection = NotificationService.RobloxEventReceived:Connect(function(data)
	local function fn(p, p2, p3)
		if p then
			screenTimeStatesUpdated(p3)
		elseif p2 then
			Logging.warn("ScreenTimeInGame requestInstructions failed: unauthorized")
		else
			Logging.warn("ScreenTimeInGame requestInstructions failed: error")
		end
	end

	if GetFFlagScreenTimeSignalR() then
		if
			data.namespace == Constants.SIGNALR_NAMESPACE
			and data.detailType == Constants.SIGNALR_TYPE_NEW_INSTRUCTION
		then
			v:getInstructions(fn)
		end
	elseif data.namespace == Constants.HEARTBEAT_NOTIFICATIONS_NAMESPACE then
		if data.detailType == Constants.HEARTBEAT_CONSECUTIVE_FAILURE then
			disconnectAndLeaveGame() -- inferred equivalent call
		else
			local success, result = pcall(function()
				return HttpService:JSONDecode(data.detail)
			end)

			if not success then
				Logging.warn("ScreenTimeInGame json decoding failed")
				return
			end

			if result.notifications == nil then
				Logging.warn("ScreenTimeInGame empty heartbeat notifications")
				return
			end

			for _, notification in ipairs(result.notifications) do
				if notification.type == Constants.HEARTBEAT_NOTIFICATION_TYPE_NEW_INSTRUCTION then
					v:getInstructions(fn)
				end
			end
		end
	end
end)
