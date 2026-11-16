local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)

local v = success and result

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v2 = success2 and result2

local MessageLogDisplay = {}
MessageLogDisplay.ScrollBarThickness = 4
local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent
local MessageLabelCreator = require(parent:WaitForChild("MessageLabelCreator"))
local CurveUtil = require(parent:WaitForChild("CurveUtil"))

local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local v3 = MessageLabelCreator.new()

local class = {}
class.__index = class

local function CreateGuiObjects()
	local frame = Instance.new("Frame")
	frame.Selectable = false
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1

	local scroller = Instance.new("ScrollingFrame")
	scroller.Selectable = ChatSettings.GamepadNavigationEnabled
	scroller.Name = "Scroller"
	scroller.BackgroundTransparency = 1
	scroller.BorderSizePixel = 0
	scroller.Position = UDim2.new(0, 0, 0, 3)
	scroller.Size = UDim2.new(1, -4, 1, -6)
	scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroller.ScrollBarThickness = MessageLogDisplay.ScrollBarThickness
	scroller.Active = true
	scroller.Parent = frame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = scroller

	return frame, scroller, uiListLayout
end

function class:Destroy()
	self.GuiObject:Destroy()
	self.Destroyed = true
end

function class.SetActive(p, visible)
	p.GuiObject.Visible = visible
end

function class:UpdateMessageFiltered(p)
	local messageObjectLog = self.MessageObjectLog
	local v4 = 1
	local v5 = nil

	while v4 <= #messageObjectLog do
		local v6 = messageObjectLog[v4]

		if v6.ID == p.ID then
			v5 = v6
			break
		end

		v4 += 1
	end

	if v5 then
		if v then
			if p.Message == "" then
				self:RemoveMessageAtIndex(v4)
				return
			end

			v5.UpdateTextFunction(p)
			self:PositionMessageLabelInWindow(v5, v4)
		else
			v5.UpdateTextFunction(p)
			self:PositionMessageLabelInWindow(v5, v4)
		end
	end
end

function class:RefreshMessagePlacement(p)
	local messageObjectLog = self.MessageObjectLog
	local v4 = 1
	local v5 = nil

	while v4 <= #messageObjectLog do
		local v6 = messageObjectLog[v4]

		if v6.ID == p.ID then
			v5 = v6
			break
		end

		v4 += 1
	end

	if v5 then
		self:PositionMessageLabelInWindow(v5, v4)
	end
end

function class:AddMessage(p)
	self:WaitUntilParentedCorrectly()
	local v4

	if v2 then
		v4 = v3:CreateMessageLabel_Chat(p, self.CurrentChannelName, function()
			self:RefreshMessagePlacement(p)
		end)
	else
		v4 = v3:CreateMessageLabel(p, self.CurrentChannelName)
	end

	if v4 == nil then
		return
	end

	table.insert(self.MessageObjectLog, v4)
	self:PositionMessageLabelInWindow(v4, #self.MessageObjectLog)
end

function class:RemoveMessageAtIndex(p)
	self:WaitUntilParentedCorrectly()

	local v4 = self.MessageObjectLog[p]

	if v4 then
		v4:Destroy()
		table.remove(self.MessageObjectLog, p)
	end
end

function class:AddMessageAtIndex(p, p2)
	local v4

	if v2 then
		v4 = v3:CreateMessageLabel_Chat(p, self.CurrentChannelName, function()
			self:RefreshMessagePlacement(p)
		end)
	else
		v4 = v3:CreateMessageLabel(p, self.CurrentChannelName)
	end

	if v4 == nil then
		return
	end

	table.insert(self.MessageObjectLog, p2, v4)

	self:PositionMessageLabelInWindow(v4, p2)
end

function class:RemoveLastMessage()
	self:WaitUntilParentedCorrectly()

	self.MessageObjectLog[1]:Destroy()
	table.remove(self.MessageObjectLog, 1)
end

function class:IsScrolledDown(): boolean
	local offset = self.Scroller.CanvasSize.Y.Offset
	local y = self.Scroller.AbsoluteWindowSize.Y
	local y2 = self.Scroller.CanvasPosition.Y

	return offset < y or offset - y2 <= y + 5
end

function class:UpdateMessageTextHeight(data)
	local baseFrame = data.BaseFrame

	for i = 1, 10 do
		if data.BaseMessage.TextFits then
			break
		end

		local v4 = self.Scroller.AbsoluteSize.X - i
		baseFrame.Size = UDim2.new(1, 0, 0, data.GetHeightFunction(v4))
	end
end

function class:PositionMessageLabelInWindow(data, p)
	self:WaitUntilParentedCorrectly()

	local isScrolledDown = self:IsScrolledDown()

	local baseFrame = data.BaseFrame
	local layoutOrder

	if self.MessageObjectLog[p - 1] then
		if p == #self.MessageObjectLog then
			layoutOrder = self.MessageObjectLog[p - 1].BaseFrame.LayoutOrder + 1
		else
			layoutOrder = self.MessageObjectLog[p - 1].BaseFrame.LayoutOrder
		end
	else
		layoutOrder = 1
	end

	baseFrame.LayoutOrder = layoutOrder

	baseFrame.Size = UDim2.new(1, 0, 0, data.GetHeightFunction(self.Scroller.AbsoluteSize.X))
	baseFrame.Parent = self.Scroller

	if data.BaseMessage then
		self:UpdateMessageTextHeight(data)
	end

	if isScrolledDown then
		self.Scroller.CanvasPosition = Vector2.new(
			0,
			(math.max(0, self.Scroller.CanvasSize.Y.Offset - self.Scroller.AbsoluteSize.Y))
		)
	end
end

function class:ReorderAllMessages()
	self:WaitUntilParentedCorrectly()

	if self.GuiObject.AbsoluteSize.Y < 1 then
		return
	end

	local canvasPosition = self.Scroller.CanvasPosition
	local isScrolledDown = self:IsScrolledDown()

	for _, v4 in pairs(self.MessageObjectLog) do
		self:UpdateMessageTextHeight(v4)
	end

	if isScrolledDown then
		self.Scroller.CanvasPosition = Vector2.new(
			0,
			(math.max(0, self.Scroller.CanvasSize.Y.Offset - self.Scroller.AbsoluteSize.Y))
		)
	else
		self.Scroller.CanvasPosition = canvasPosition
	end
end

function class:Clear()
	for _, v4 in pairs(self.MessageObjectLog) do
		v4:Destroy()
	end

	self.MessageObjectLog = {}
end

function class:SetCurrentChannelName(currentChannelName)
	self.CurrentChannelName = currentChannelName
end

function class.FadeOutBackground(_, _) end

function class.FadeInBackground(_, _) end

function class.FadeOutText(p, p2)
	for i = 1, #p.MessageObjectLog do
		if p.MessageObjectLog[i].FadeOutFunction then
			p.MessageObjectLog[i].FadeOutFunction(p2, CurveUtil)
		end
	end
end

function class.FadeInText(p, p2)
	for i = 1, #p.MessageObjectLog do
		if p.MessageObjectLog[i].FadeInFunction then
			p.MessageObjectLog[i].FadeInFunction(p2, CurveUtil)
		end
	end
end

function class.Update(p, p2)
	for i = 1, #p.MessageObjectLog do
		if p.MessageObjectLog[i].UpdateAnimFunction then
			p.MessageObjectLog[i].UpdateAnimFunction(p2, CurveUtil)
		end
	end
end

function class:WaitUntilParentedCorrectly()
	while true do
		local guiObject = self.GuiObject
		local Players = game:GetService("Players")

		if guiObject:IsDescendantOf(Players.LocalPlayer) then
			break
		end

		self.GuiObject.AncestryChanged:wait()
	end
end

function MessageLogDisplay.new()
	local messageLogDisplay = setmetatable({}, class)
	messageLogDisplay.Destroyed = false

	local guiObject, scroller, layout = CreateGuiObjects()
	messageLogDisplay.GuiObject = guiObject
	messageLogDisplay.Scroller = scroller
	messageLogDisplay.Layout = layout

	messageLogDisplay.MessageObjectLog = {}

	messageLogDisplay.Name = "MessageLogDisplay"
	messageLogDisplay.GuiObject.Name = "Frame_" .. messageLogDisplay.Name

	messageLogDisplay.CurrentChannelName = ""

	messageLogDisplay.GuiObject:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		spawn(function()
			messageLogDisplay:ReorderAllMessages()
		end)
	end)

	local v4 = true

	messageLogDisplay.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local absoluteContentSize = messageLogDisplay.Layout.AbsoluteContentSize
		messageLogDisplay.Scroller.CanvasSize = UDim2.new(0, 0, 0, absoluteContentSize.Y)

		if v4 then
			local absoluteWindowSize = messageLogDisplay.Scroller.AbsoluteWindowSize
			messageLogDisplay.Scroller.CanvasPosition = Vector2.new(0, absoluteContentSize.Y - absoluteWindowSize.Y)
		end
	end)

	messageLogDisplay.Scroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		v4 = messageLogDisplay:IsScrolledDown()
	end)

	return messageLogDisplay
end

return MessageLogDisplay
