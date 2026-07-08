local ParentParent = script.Parent.Parent
local GetFFlagTextChatEnableUniverseChatTabs = require(ParentParent.ExpChatShared).Flags.GetFFlagTextChatEnableUniverseChatTabs
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs

local function startDebug() -- line: 6
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local CoreGui = game:GetService("CoreGui")
	local TextChatService = game:GetService("TextChatService")
	local EngineFeature = game:GetEngineFeature("ExpChatDebuggerIncomingMessageEvent")
	local v8 = game:DefineFastFlag("ExpChatDebugGlobalChat", false)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ExperienceChatDebug"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = -1
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local n1 = 7
	local t1 = {
		{
			vertical = Enum.VerticalAlignment.Top,
			horizontal = Enum.HorizontalAlignment.Left
		},
		{
			vertical = Enum.VerticalAlignment.Top,
			horizontal = Enum.HorizontalAlignment.Center
		},
		{
			vertical = Enum.VerticalAlignment.Top,
			horizontal = Enum.HorizontalAlignment.Right
		},
		{
			vertical = Enum.VerticalAlignment.Center,
			horizontal = Enum.HorizontalAlignment.Left
		},
		{
			vertical = Enum.VerticalAlignment.Center,
			horizontal = Enum.HorizontalAlignment.Center
		},
		{
			vertical = Enum.VerticalAlignment.Center,
			horizontal = Enum.HorizontalAlignment.Right
		},
		{
			vertical = Enum.VerticalAlignment.Bottom,
			horizontal = Enum.HorizontalAlignment.Left
		},
		{
			vertical = Enum.VerticalAlignment.Bottom,
			horizontal = Enum.HorizontalAlignment.Center
		},
		{
			vertical = Enum.VerticalAlignment.Bottom,
			horizontal = Enum.HorizontalAlignment.Right
		}
	}
	local t2 = {}
	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Parent = ScreenGui

	local function updateContainerLayout() -- line: 36
		-- upvalues: t1 (copy), n1 (ref), UIListLayout (copy)
		local v23 = t1[n1]

		UIListLayout.VerticalAlignment = v23.vertical
		UIListLayout.HorizontalAlignment = v23.horizontal
	end

	local v15 = t1[n1]

	UIListLayout.VerticalAlignment = v15.vertical
	UIListLayout.HorizontalAlignment = v15.horizontal

	local ImageButton = Instance.new("ImageButton")

	ImageButton.AutomaticSize = Enum.AutomaticSize.XY
	ImageButton.Size = UDim2.new(0, 200, 0, 20)
	ImageButton.BackgroundTransparency = 0.3
	ImageButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	ImageButton.Parent = ScreenGui
	ImageButton.Activated:Connect(function() -- line: 50
		-- upvalues: n1 (ref), t1 (copy), UIListLayout (copy)
		n1 += 1

		if n1 > #t1 then
			n1 = 1
		end

		local v24 = t1[n1]

		UIListLayout.VerticalAlignment = v24.vertical
		UIListLayout.HorizontalAlignment = v24.horizontal
	end)

	local function clearEntries() -- line: 59
		-- upvalues: t2 (ref)
		for _, v26 in t2 do
			v26:Destroy()
		end

		t2 = {}
	end

	ImageButton.MouseButton2Click:Connect(clearEntries)
	ImageButton.TouchLongPress:Connect(clearEntries)

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout2.Parent = ImageButton

	local function addEntryToContainer(p1, p2, p3) -- line: 72
		-- upvalues: t2 (ref), ImageButton (copy)
		if #t2 > 10 then
			local v30 = table.remove(t2, 1)

			if v30 then
				v30:Destroy()
			end
		end

		local TextLabel = Instance.new("TextLabel")

		TextLabel.AutomaticSize = Enum.AutomaticSize.X
		TextLabel.BackgroundTransparency = p3
		TextLabel.BackgroundColor3 = p2
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.Text = p1
		TextLabel.RichText = true
		TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
		TextLabel.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextSize = 16
		TextLabel.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		TextLabel.Size = UDim2.new(0, 0, 0, 18)
		TextLabel.Parent = ImageButton
		table.insert(t2, TextLabel)
	end

	local v20 = utf8.char(128227)
	local v21 = utf8.char(128229)

	local function formatEntry(p4, s1: string) -- line: 102
		-- upvalues: v20 (copy), v21 (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), addEntryToContainer (copy)
		local v34 = if p4.Status ~= Enum.TextChatMessageStatus.Sending then `{ v21 } Rec.` else `{ v20 } Sent`
		local v35 = if s1 ~= "Global" then (not p4.TextChannel or s1 ~= "Local") and "Unknown" or p4.TextChannel.Name else "RBXGlobal"
		local v36 = p4.Status ~= Enum.TextChatMessageStatus.Success and p4.Status ~= Enum.TextChatMessageStatus.Sending
		local v37 = not v36 and "" or `({ p4.Status.Name })`
		local v38 = if not v36 then Color3.fromRGB(32, 32, 32) else Color3.fromRGB(255, 0, 0)
		local v39 = not v36 and 1 or 0.5
		local v40 = (not p4.TextChannel or not p4.TextChannel.DirectChatRequester) and "" or " <font color='#00E344'>(Direct)</font>"
		local v41 = if not getFFlagExpChatProtectedChatInternalAPIs() then p4.Text else p4.TextInternal

		addEntryToContainer(`{ v34 } [{ v35 }{ v40 }] { v41 } { v37 }`, v38, v39)
	end

	if EngineFeature then
		TextChatService.OnIncomingMessageEvent:Connect(function(p5) -- line: 135
			-- upvalues: formatEntry (copy)
			formatEntry(p5, "Local")
		end)
	else
		TextChatService.MessageReceived:Connect(function(p6) -- line: 139
			-- upvalues: formatEntry (copy)
			formatEntry(p6, "Local")
		end)
		TextChatService.SendingMessage:Connect(function(message) -- line: 142
			-- upvalues: formatEntry (copy)
			formatEntry(message, "Local")
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() and v8 then
		TextChatService.UniverseChatMessageReceived:Connect(function(p7) -- line: 148
			-- upvalues: formatEntry (copy)
			formatEntry(p7, "Global")
		end)
	end

	ScreenGui.Parent = CoreGui
end

return startDebug
