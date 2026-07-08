local ok, result = pcall(function() -- line: 7
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)
local u3 = ok and result
local ok2, result2 = pcall(function() -- line: 15
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u6 = ok2 and result2
local t1 = {
	ScrollBarThickness = 4
}
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local MessageLabelCreator = require(scriptParent:WaitForChild("MessageLabelCreator"))
local CurveUtil = require(scriptParent:WaitForChild("CurveUtil"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local v13 = MessageLabelCreator.new()
local t2 = {}

t2.__index = t2

local function CreateGuiObjects() -- line: 42
	-- upvalues: ChatSettings (copy), t1 (copy)
	local Frame = Instance.new("Frame")

	Frame.Selectable = false
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Selectable = ChatSettings.GamepadNavigationEnabled
	ScrollingFrame.Name = "Scroller"
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 3)
	ScrollingFrame.Size = UDim2.new(1, -4, 1, -6)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ScrollBarThickness = t1.ScrollBarThickness
	ScrollingFrame.Active = true
	ScrollingFrame.Parent = Frame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollingFrame

	return Frame, ScrollingFrame, UIListLayout
end

function t2.Destroy(p1) -- line: 67
	p1.GuiObject:Destroy()
	p1.Destroyed = true
end
function t2.SetActive(p2, p3) -- line: 72
	p2.GuiObject.Visible = p3
end
function t2.UpdateMessageFiltered(p4, p5) -- line: 76
	-- upvalues: u3 (ref)
	local v24 = nil
	local n1 = 1
	local MessageObjectLog = p4.MessageObjectLog

	while n1 <= #MessageObjectLog do
		local v27 = MessageObjectLog[n1]

		if v27.ID == p5.ID then
			v24 = v27

			break
		end

		n1 += 1
	end

	if v24 then
		if u3 then
			if p5.Message == "" then
				p4:RemoveMessageAtIndex(n1)

				return
			end

			v24.UpdateTextFunction(p5)
			p4:PositionMessageLabelInWindow(v24, n1)

			return
		end

		v24.UpdateTextFunction(p5)
		p4:PositionMessageLabelInWindow(v24, n1)
	end
end
function t2.RefreshMessagePlacement(p6, p7) -- line: 107
	local v30 = nil
	local n2 = 1
	local MessageObjectLog = p6.MessageObjectLog

	while n2 <= #MessageObjectLog do
		local v33 = MessageObjectLog[n2]

		if v33.ID == p7.ID then
			v30 = v33

			break
		end

		n2 += 1
	end

	if v30 then
		p6:PositionMessageLabelInWindow(v30, n2)
	end
end
function t2.AddMessage(p8, p9) -- line: 129
	-- upvalues: u6 (ref), v13 (copy)
	p8:WaitUntilParentedCorrectly()

	local v36 = if not u6 then v13:CreateMessageLabel(p9, p8.CurrentChannelName) else v13:CreateMessageLabel_Chat(p9, p8.CurrentChannelName, function() -- line: 134
		-- upvalues: p8 (copy), p9 (copy)
		p8:RefreshMessagePlacement(p9)
	end)

	if v36 == nil then
		return
	end

	table.insert(p8.MessageObjectLog, v36)
	p8:PositionMessageLabelInWindow(v36, #p8.MessageObjectLog)
end
function t2.RemoveMessageAtIndex(p10, p11) -- line: 151
	p10:WaitUntilParentedCorrectly()

	local v39 = p10.MessageObjectLog[p11]

	if v39 then
		v39:Destroy()
		table.remove(p10.MessageObjectLog, p11)
	end
end
function t2.AddMessageAtIndex(p12, p13, p14) -- line: 162
	-- upvalues: u6 (ref), v13 (copy)
	local v43 = if not u6 then v13:CreateMessageLabel(p13, p12.CurrentChannelName) else v13:CreateMessageLabel_Chat(p13, p12.CurrentChannelName, function() -- line: 165
		-- upvalues: p12 (copy), p13 (copy)
		p12:RefreshMessagePlacement(p13)
	end)

	if v43 == nil then
		return
	end

	table.insert(p12.MessageObjectLog, p14, v43)
	p12:PositionMessageLabelInWindow(v43, p14)
end
function t2.RemoveLastMessage(p15) -- line: 183
	p15:WaitUntilParentedCorrectly()
	p15.MessageObjectLog[1]:Destroy()
	table.remove(p15.MessageObjectLog, 1)
end
function t2.IsScrolledDown(p16) -- line: 192
	local YOffset = p16.Scroller.CanvasSize.Y.Offset
	local AbsoluteWindowSizeY = p16.Scroller.AbsoluteWindowSize.Y
	local CanvasPositionY = p16.Scroller.CanvasPosition.Y

	return YOffset < AbsoluteWindowSizeY or YOffset - CanvasPositionY <= AbsoluteWindowSizeY + 5
end
function t2.UpdateMessageTextHeight(p17, p18) -- line: 201
	local BaseFrame = p18.BaseFrame

	for i = 1, 10 do
		if p18.BaseMessage.TextFits then
			return
		end

		local v53 = p17.Scroller.AbsoluteSize.X - i

		BaseFrame.Size = UDim2.new(1, 0, 0, p18.GetHeightFunction(v53))
	end
end
function t2.PositionMessageLabelInWindow(p19, p20, p21) -- line: 213
	p19:WaitUntilParentedCorrectly()

	local v57 = p19:IsScrolledDown()
	local BaseFrame = p20.BaseFrame
	local n3 = 1

	if p19.MessageObjectLog[p21 - 1] then
		n3 = if p21 ~= #p19.MessageObjectLog then p19.MessageObjectLog[p21 - 1].BaseFrame.LayoutOrder else p19.MessageObjectLog[p21 - 1].BaseFrame.LayoutOrder + 1
	end

	BaseFrame.LayoutOrder = n3
	BaseFrame.Size = UDim2.new(1, 0, 0, p20.GetHeightFunction(p19.Scroller.AbsoluteSize.X))
	BaseFrame.Parent = p19.Scroller

	if p20.BaseMessage then
		p19:UpdateMessageTextHeight(p20)
	end

	if v57 then
		p19.Scroller.CanvasPosition = Vector2.new(0, (math.max(0, p19.Scroller.CanvasSize.Y.Offset - p19.Scroller.AbsoluteSize.Y)))
	end
end
function t2.ReorderAllMessages(p22) -- line: 243
	p22:WaitUntilParentedCorrectly()

	if p22.GuiObject.AbsoluteSize.Y < 1 then
		return
	end

	local CanvasPosition = p22.Scroller.CanvasPosition
	local v62 = p22:IsScrolledDown()

	for _, v in pairs(p22.MessageObjectLog) do
		p22:UpdateMessageTextHeight(v)
	end

	if not v62 then
		p22.Scroller.CanvasPosition = CanvasPosition

		return
	end

	p22.Scroller.CanvasPosition = Vector2.new(0, (math.max(0, p22.Scroller.CanvasSize.Y.Offset - p22.Scroller.AbsoluteSize.Y)))
end
function t2.Clear(p23) -- line: 265
	for _, v in pairs(p23.MessageObjectLog) do
		v:Destroy()
	end

	p23.MessageObjectLog = {}
end
function t2.SetCurrentChannelName(p24, p25) -- line: 272
	p24.CurrentChannelName = p25
end
function t2.FadeOutBackground(_, _) -- line: 276
end
function t2.FadeInBackground(_, _) -- line: 280
end
function t2.FadeOutText(p30, p31) -- line: 284
	-- upvalues: CurveUtil (copy)
	for i = 1, #p30.MessageObjectLog do
		if p30.MessageObjectLog[i].FadeOutFunction then
			p30.MessageObjectLog[i].FadeOutFunction(p31, CurveUtil)
		end
	end
end
function t2.FadeInText(p32, p33) -- line: 292
	-- upvalues: CurveUtil (copy)
	for i = 1, #p32.MessageObjectLog do
		if p32.MessageObjectLog[i].FadeInFunction then
			p32.MessageObjectLog[i].FadeInFunction(p33, CurveUtil)
		end
	end
end
function t2.Update(p34, p35) -- line: 300
	-- upvalues: CurveUtil (copy)
	for i = 1, #p34.MessageObjectLog do
		if p34.MessageObjectLog[i].UpdateAnimFunction then
			p34.MessageObjectLog[i].UpdateAnimFunction(p35, CurveUtil)
		end
	end
end
function t2.WaitUntilParentedCorrectly(p36) -- line: 309
	while not p36.GuiObject:IsDescendantOf(game:GetService("Players").LocalPlayer) do
		p36.GuiObject.AncestryChanged:wait()
	end
end
function t1.new() -- line: 318
	-- upvalues: t2 (copy), CreateGuiObjects (copy)
	local self = setmetatable({}, t2)

	self.Destroyed = false

	local v85, v86, v87 = CreateGuiObjects()

	self.GuiObject = v85
	self.Scroller = v86
	self.Layout = v87
	self.MessageObjectLog = {}
	self.Name = "MessageLogDisplay"
	self.GuiObject.Name = "Frame_" .. self.Name
	self.CurrentChannelName = ""
	self.GuiObject:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 334
		-- upvalues: self (copy)
		spawn(function() -- line: 335
			-- upvalues: self (copy)
			self:ReorderAllMessages()
		end)
	end)

	local u88 = true

	self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 340
		-- upvalues: self (copy), u88 (ref)
		local AbsoluteContentSize = self.Layout.AbsoluteContentSize

		self.Scroller.CanvasSize = UDim2.new(0, 0, 0, AbsoluteContentSize.Y)

		if u88 then
			local AbsoluteWindowSize = self.Scroller.AbsoluteWindowSize

			self.Scroller.CanvasPosition = Vector2.new(0, AbsoluteContentSize.Y - AbsoluteWindowSize.Y)
		end
	end)
	self.Scroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 349
		-- upvalues: u88 (ref), self (copy)
		u88 = self:IsScrolledDown()
	end)

	return self
end

return t1
