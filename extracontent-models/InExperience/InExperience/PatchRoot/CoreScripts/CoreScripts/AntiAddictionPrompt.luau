game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local function leaveGame() -- 2 equivalent calls inferred from this helper
	GuiService.SelectedCoreObject = nil
	game:Shutdown()
end

local v = { Warning = 1, Lockout = 2 }

local function parseResponse(p) -- 2 equivalent calls inferred from this helper
	return { State = p.response.state.type, Messages = p.response.state.messages }
end

local function markRead(id) -- 1 equivalent call inferred from this helper
	local v2 = "mesasgeId=" .. id
	local v3 = Url.RCS_URL .. "screen-time-api/v1/messages/mark-read" .. "?" .. v2
	local _, _ = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v3)
end

local v2 = {
	pendingResolveMessage = {},
	displaying = nil,
	resolvedMessage = {},
	displayMessageCallback = nil,
	update = function(self, items)
		for _, item in pairs(items) do
			local v2 = { id = item.id, message = item.text }

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

		spawn(function()
			markRead(displaying.id) -- inferred equivalent call
		end)
	end,
	resolve = function(self)
		self.resolvedMessage[self.displaying.id] = self.displaying.message
		self.displaying = nil
		self:processNext()
	end
}

local default = ErrorPrompt.new("Default", {
	MessageTextScaled = true,
	HideErrorCode = true,
	MenuIsOpenKey = "AnitAddictionPrompt"
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
local robloxEventReceivedConnection = nil
local function antiAddictionStatesUpdated(p)
	local response = parseResponse(p) -- inferred equivalent call

	if response.State == 2 then
		if robloxEventReceivedConnection then
			robloxEventReceivedConnection:Disconnect()
		end

		leaveGame() -- inferred equivalent call
	end

	v2:update(response.Messages)
end

robloxEventReceivedConnection = NotificationService.RobloxEventReceived:Connect(function(p)
	if p.namespace == "AntiAddictionNotifications" then
		local response = parseResponse(HttpService:JSONDecode(p.detail)) -- inferred equivalent call

		if response.State == v.Lockout then
			if robloxEventReceivedConnection then
				robloxEventReceivedConnection:Disconnect()
			end

			leaveGame() -- inferred equivalent call
		end

		v2:update(response.Messages)
	end
end)
