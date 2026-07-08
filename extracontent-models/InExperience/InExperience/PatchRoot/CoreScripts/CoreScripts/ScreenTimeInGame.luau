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
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)

local function leaveGame() -- line: 16
	-- upvalues: GuiService (copy)
	GuiService.SelectedCoreObject = nil
	game:Shutdown()
end

local _ = {
	Warning = 1,
	Lockout = 2,
	OpenWebView = 3
}
local v15 = HttpRequests:new(HttpService)
local u16 = nil

local function disconnectAndLeaveGame() -- line: 32
	-- upvalues: u16 (ref), GuiService (copy)
	if u16 then
		u16:Disconnect()
		u16 = nil
	end

	GuiService.SelectedCoreObject = nil
	game:Shutdown()
end

local t2 = {
	displaying = nil,
	displayMessageCallback = nil,
	pendingResolveMessage = {},
	resolvedMessage = {},
	update = function(p1, p2) -- line: 53
		for _, v in pairs(p2) do
			local t1 = {
				id = v.serialId,
				instructionName = v.instructionName,
				message = v.message,
				type = v.type
			}

			table.insert(p1.pendingResolveMessage, t1)
		end

		p1:processNext()
	end,
	processNext = function(p3) -- line: 66
		if p3.displaying then
			return
		end

		local v37 = table.remove(p3.pendingResolveMessage, 1)

		if not v37 then
			return
		end

		if p3.resolvedMessage[v37.id] then
			p3:processNext()

			return
		end

		p3.displaying = v37

		if p3.displayMessageCallback then
			p3.displayMessageCallback(v37.message)
		end
	end,
	resolve = function(p4) -- line: 88
		-- upvalues: v15 (copy)
		p4.resolvedMessage[p4.displaying.id] = p4.displaying.message
		v15:reportExecution(p4.displaying.instructionName, p4.displaying.id)
		p4.displaying = nil
		p4:processNext()
	end
}
local t3 = {
	MessageTextScaled = true,
	HideErrorCode = true,
	MenuIsOpenKey = "ScreenTimePrompt"
}
local v20 = ErrorPrompt.new("Default", t3)

v20:setParent(RobloxGui)

local function displayMessage(p5) -- line: 108
	-- upvalues: v20 (copy)
	v20:_open(p5)
end
local function resolveMessage() -- line: 112
	-- upvalues: v20 (copy), t2 (copy)
	v20:_close()
	t2:resolve()
end

local t4 = {{
	Text = "OK",
	LocalizationKey = "InGame.CommonUI.Button.Ok",
	LayoutOrder = 1,
	Primary = true,
	Callback = resolveMessage
}}

t2.displayMessageCallback = displayMessage
v20:updateButtons(t4)
v20:setErrorTitle("Warning", "InGame.CommonUI.Title.Warning")

local AbsoluteSizeX = RobloxGui.AbsoluteSize.X
local AbsoluteSizeY = RobloxGui.AbsoluteSize.Y

local function onScreenSizeChanged() -- line: 135
	-- upvalues: v20 (copy), RobloxGui (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref)
	if not v20 then
		return
	end

	local AbsoluteSizeX2 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY2 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX2 ~= AbsoluteSizeX or AbsoluteSizeY2 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX2
		AbsoluteSizeY = AbsoluteSizeY2
		v20:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end
end

RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(onScreenSizeChanged)

if v20 then
	local AbsoluteSizeX3 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY3 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX3 ~= AbsoluteSizeX or AbsoluteSizeY3 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX3
		AbsoluteSizeY = AbsoluteSizeY3
		v20:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end
end

local function screenTimeStatesUpdated(p6) -- line: 151
	-- upvalues: u16 (ref), GuiService (copy), t2 (copy)
	local t5 = {}

	for _, v in ipairs(p6) do
		if v.type ~= 1 then
			if v.type == 2 then
				if u16 then
					u16:Disconnect()
					u16 = nil
				end

				GuiService.SelectedCoreObject = nil
				game:Shutdown()

				return
			end

			if v.type ~= 3 then
			end

			continue
		end

		table.insert(t5, v)
	end

	t2:update(t5)
end
local function requestInstructions() -- line: 170
	-- upvalues: v15 (copy), screenTimeStatesUpdated (copy), Logging (copy)
	v15:getInstructions(function(p7, p8, p9) -- line: 171
		-- upvalues: screenTimeStatesUpdated (copy), Logging (copy)
		if p7 then
			screenTimeStatesUpdated(p9)

			return
		end

		if p8 then
			Logging.warn("ScreenTimeInGame requestInstructions failed: unauthorized")

			return
		end

		Logging.warn("ScreenTimeInGame requestInstructions failed: error")
	end)
end

u16 = NotificationService.RobloxEventReceived:Connect(function(p10) -- line: 183
	-- upvalues: GetFFlagScreenTimeSignalR (copy), Constants (copy), v15 (copy), screenTimeStatesUpdated (copy), Logging (copy), u16 (ref), GuiService (copy), HttpService (copy)
	if GetFFlagScreenTimeSignalR() then
		if p10.namespace == Constants.SIGNALR_NAMESPACE and p10.detailType == Constants.SIGNALR_TYPE_NEW_INSTRUCTION then
			v15:getInstructions(function(p11, p12, p13) -- line: 171
				-- upvalues: screenTimeStatesUpdated (copy), Logging (copy)
				if p11 then
					screenTimeStatesUpdated(p13)

					return
				end

				if p12 then
					Logging.warn("ScreenTimeInGame requestInstructions failed: unauthorized")

					return
				end

				Logging.warn("ScreenTimeInGame requestInstructions failed: error")
			end)

			return
		end
	elseif p10.namespace == Constants.HEARTBEAT_NOTIFICATIONS_NAMESPACE then
		if p10.detailType == Constants.HEARTBEAT_CONSECUTIVE_FAILURE then
			if u16 then
				u16:Disconnect()
				u16 = nil
			end

			GuiService.SelectedCoreObject = nil
			game:Shutdown()

			return
		end

		local ok, result = pcall(function() -- line: 198
			-- upvalues: HttpService (copy), p10 (copy)
			return HttpService:JSONDecode(p10.detail)
		end)

		if not ok then
			Logging.warn("ScreenTimeInGame json decoding failed")

			return
		end

		if result.notifications == nil then
			Logging.warn("ScreenTimeInGame empty heartbeat notifications")

			return
		end

		for _, v in ipairs(result.notifications) do
			if v.type == Constants.HEARTBEAT_NOTIFICATION_TYPE_NEW_INSTRUCTION then
				v15:getInstructions(function(p14, p15, p16) -- line: 171
					-- upvalues: screenTimeStatesUpdated (copy), Logging (copy)
					if p14 then
						screenTimeStatesUpdated(p16)

						return
					end

					if p15 then
						Logging.warn("ScreenTimeInGame requestInstructions failed: unauthorized")

						return
					end

					Logging.warn("ScreenTimeInGame requestInstructions failed: error")
				end)
			end
		end
	end
end)
