local parent = script.Parent.Parent
local ExpChatShared = require(parent.ExpChatShared)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs

local function startDebug()
	local CoreGui = game:GetService("CoreGui")
	local TextChatService = game:GetService("TextChatService")
	local engineFeature = game:GetEngineFeature("ExpChatDebuggerIncomingMessageEvent")
	local defineFastFlag = game:DefineFastFlag("ExpChatDebugGlobalChat", false)

	local experienceChatDebug = Instance.new("ScreenGui")
	experienceChatDebug.Name = "ExperienceChatDebug"
	experienceChatDebug.ResetOnSpawn = false
	experienceChatDebug.DisplayOrder = -1
	experienceChatDebug.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local v = 7
	local v2 = {
		{ vertical = Enum.VerticalAlignment.Top, horizontal = Enum.HorizontalAlignment.Left },
		{ vertical = Enum.VerticalAlignment.Top, horizontal = Enum.HorizontalAlignment.Center },
		{ vertical = Enum.VerticalAlignment.Top, horizontal = Enum.HorizontalAlignment.Right },
		{ vertical = Enum.VerticalAlignment.Center, horizontal = Enum.HorizontalAlignment.Left },
		{ vertical = Enum.VerticalAlignment.Center, horizontal = Enum.HorizontalAlignment.Center },
		{ vertical = Enum.VerticalAlignment.Center, horizontal = Enum.HorizontalAlignment.Right },
		{ vertical = Enum.VerticalAlignment.Bottom, horizontal = Enum.HorizontalAlignment.Left },
		{ vertical = Enum.VerticalAlignment.Bottom, horizontal = Enum.HorizontalAlignment.Center },
		{ vertical = Enum.VerticalAlignment.Bottom, horizontal = Enum.HorizontalAlignment.Right }
	}

	local v3 = {}

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = experienceChatDebug

	local function updateContainerLayout() -- 2 equivalent calls inferred from this helper
		local v4 = v2[v]
		uiListLayout.VerticalAlignment = v4.vertical
		uiListLayout.HorizontalAlignment = v4.horizontal
	end

	updateContainerLayout() -- inferred equivalent call
	local imageButton = Instance.new("ImageButton")
	imageButton.AutomaticSize = Enum.AutomaticSize.XY
	imageButton.Size = UDim2.new(0, 200, 0, 20)
	imageButton.BackgroundTransparency = 0.3
	imageButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	imageButton.Parent = experienceChatDebug

	imageButton.Activated:Connect(function()
		v += 1

		if v > #v2 then
			v = 1
		end

		updateContainerLayout() -- inferred equivalent call
	end)

	local function clearEntries()
		for _, v4 in v3 do
			v4:Destroy()
		end

		v3 = {}
	end
	imageButton.MouseButton2Click:Connect(clearEntries)
	imageButton.TouchLongPress:Connect(clearEntries)

	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
	uiListLayout2.Parent = imageButton

	local function addEntryToContainer(text, color, backgroundTransparency)
		local v4 = #v3 > 10 and table.remove(v3, 1)

		if v4 then
			v4:Destroy()
		end

		local textLabel = Instance.new("TextLabel")
		textLabel.AutomaticSize = Enum.AutomaticSize.X
		textLabel.BackgroundTransparency = backgroundTransparency
		textLabel.BackgroundColor3 = color
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.Text = text
		textLabel.RichText = true
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextSize = 16
		textLabel.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		textLabel.Size = UDim2.new(0, 0, 0, 18)
		textLabel.Parent = imageButton

		table.insert(v3, textLabel)
	end

	local v4 = utf8.char(128227)
	local v5 = utf8.char(128229)

	local function formatEntry(data, p: string)
		local v6

		if data.Status == Enum.TextChatMessageStatus.Sending then
			v6 = `{v4} Sent`
		else
			v6 = `{v5} Rec.`
		end

		local v7 = p == "Global" and "RBXGlobal"
			or (not data.TextChannel or p ~= "Local") and "Unknown"
			or data.TextChannel.Name

		local v8 = data.Status ~= Enum.TextChatMessageStatus.Success
			and data.Status ~= Enum.TextChatMessageStatus.Sending

		local v9 = not v8 and "" or `({data.Status.Name})`
		local color

		if v8 then
			color = Color3.fromRGB(255, 0, 0)
		else
			color = Color3.fromRGB(32, 32, 32)
		end

		local v10 = data.TextChannel
			and data.TextChannel.DirectChatRequester
			and " <font color='#00E344'>(Direct)</font>"
			or ""
		local v11

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v11 = data.TextInternal
		else
			v11 = data.Text
		end

		addEntryToContainer(`{v6} [{v7}{v10}] {v11} {v9}`, color, v8 and 0.5 or 1)
	end

	if engineFeature then
		TextChatService.OnIncomingMessageEvent:Connect(function(p)
			formatEntry(p, "Local")
		end)
	else
		TextChatService.MessageReceived:Connect(function(p)
			formatEntry(p, "Local")
		end)
		TextChatService.SendingMessage:Connect(function(p)
			formatEntry(p, "Local")
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() and defineFastFlag then
		TextChatService.UniverseChatMessageReceived:Connect(function(p)
			formatEntry(p, "Global")
		end)
	end

	experienceChatDebug.Parent = CoreGui
end

return startDebug
