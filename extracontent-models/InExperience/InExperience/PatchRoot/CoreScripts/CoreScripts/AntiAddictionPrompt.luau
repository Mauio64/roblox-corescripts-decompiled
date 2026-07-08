game:GetService("RunService")

local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url

local function leaveGame() -- line: 18
	-- upvalues: GuiService (copy)
	GuiService.SelectedCoreObject = nil
	game:Shutdown()
end

local t1 = {
	Warning = 1,
	Lockout = 2
}

local function parseResponse(p1) -- line: 28
	local type = p1.response.state.type
	local messages = p1.response.state.messages

	return {
		State = type,
		Messages = messages
	}
end
local function markRead(p2) -- line: 37
	-- upvalues: Url (copy), HttpRbxApiService (copy)
	local v31 = "mesasgeId=" .. p2
	local v32 = Url.RCS_URL .. "screen-time-api/v1/messages/mark-read" .. "?" .. v31
	local _, _ = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v32)
end

local t3 = {
	displaying = nil,
	displayMessageCallback = nil,
	pendingResolveMessage = {},
	resolvedMessage = {},
	update = function(p3, p4) -- line: 57
		for _, v in pairs(p4) do
			local t2 = {
				id = v.id,
				message = v.text
			}

			table.insert(p3.pendingResolveMessage, t2)
		end

		p3:processNext()
	end,
	processNext = function(p5) -- line: 68
		-- upvalues: Url (copy), HttpRbxApiService (copy)
		if p5.displaying then
			return
		end

		local v41 = table.remove(p5.pendingResolveMessage, 1)

		if not v41 then
			return
		end

		if p5.resolvedMessage[v41.id] then
			p5:processNext()

			return
		end

		p5.displaying = v41

		if p5.displayMessageCallback then
			p5.displayMessageCallback(v41.message)
		end

		spawn(function() -- line: 88
			-- upvalues: v41 (copy), Url (copy), HttpRbxApiService (copy)
			local v55 = "mesasgeId=" .. v41.id
			local v56 = Url.RCS_URL .. "screen-time-api/v1/messages/mark-read" .. "?" .. v55
			local _, _ = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v56)
		end)
	end,
	resolve = function(p6) -- line: 94
		p6.resolvedMessage[p6.displaying.id] = p6.displaying.message
		p6.displaying = nil
		p6:processNext()
	end
}
local t4 = {
	MessageTextScaled = true,
	HideErrorCode = true,
	MenuIsOpenKey = "AnitAddictionPrompt"
}
local v16 = ErrorPrompt.new("Default", t4)

v16:setParent(RobloxGui)

local function displayMessage(p7) -- line: 110
	-- upvalues: v16 (copy)
	v16:_open(p7)
end
local function resolveMessage() -- line: 114
	-- upvalues: v16 (copy), t3 (copy)
	v16:_close()
	t3:resolve()
end

local t5 = {{
	Text = "OK",
	LocalizationKey = "InGame.CommonUI.Button.Ok",
	LayoutOrder = 1,
	Primary = true,
	Callback = resolveMessage
}}

t3.displayMessageCallback = displayMessage
v16:updateButtons(t5)
v16:setErrorTitle("Warning", "InGame.CommonUI.Title.Warning")

local AbsoluteSizeX = RobloxGui.AbsoluteSize.X
local AbsoluteSizeY = RobloxGui.AbsoluteSize.Y

local function onScreenSizeChanged() -- line: 136
	-- upvalues: v16 (copy), RobloxGui (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref)
	if not v16 then
		return
	end

	local AbsoluteSizeX2 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY2 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX2 ~= AbsoluteSizeX or AbsoluteSizeY2 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX2
		AbsoluteSizeY = AbsoluteSizeY2
		v16:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end
end

RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(onScreenSizeChanged)

if v16 then
	local AbsoluteSizeX3 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY3 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX3 ~= AbsoluteSizeX or AbsoluteSizeY3 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX3
		AbsoluteSizeY = AbsoluteSizeY3
		v16:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end
end

local connection = nil

local function antiAddictionStatesUpdated(p8) -- line: 154
	-- upvalues: connection (ref), GuiService (copy), t3 (copy)
	local type = p8.response.state.type
	local messages = p8.response.state.messages
	local t6 = {
		State = type,
		Messages = messages
	}

	if t6.State == 2 then
		if connection then
			connection:Disconnect()
		end

		GuiService.SelectedCoreObject = nil
		game:Shutdown()
	end

	t3:update(t6.Messages)
end

connection = NotificationService.RobloxEventReceived:Connect(function(p9) -- line: 168
	-- upvalues: HttpService (copy), t1 (copy), connection (ref), GuiService (copy), t3 (copy)
	if p9.namespace == "AntiAddictionNotifications" then
		local data = HttpService:JSONDecode(p9.detail)
		local type = data.response.state.type
		local messages = data.response.state.messages
		local t7 = {
			State = type,
			Messages = messages
		}

		if t7.State == t1.Lockout then
			if connection then
				connection:Disconnect()
			end

			GuiService.SelectedCoreObject = nil
			game:Shutdown()
		end

		t3:update(t7.Messages)
	end
end)
