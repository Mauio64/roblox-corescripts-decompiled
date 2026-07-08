local t1 = {}
local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local MessageCreatorModules = ClientChatModules:WaitForChild("MessageCreatorModules")
local Util = require(MessageCreatorModules:WaitForChild("Util"))
local scriptParent = script.Parent

require(ClientChatModules:WaitForChild("ChatSettings"))

local ObjectPool = require(scriptParent:WaitForChild("ObjectPool"))

require(scriptParent:WaitForChild("MessageSender"))

local t2 = {}

t2.__index = t2

function mergeProps(p1, p2) -- line: 26
	if not p1 then
		return
	end

	for k, v in pairs(p1) do
		p2[k] = v
	end
end
function ReturnToObjectPoolRecursive(p3, p4) -- line: 33
	local children = p3:GetChildren()

	for i = 1, #children do
		ReturnToObjectPoolRecursive(children[i], p4)
	end

	p3.Parent = nil
	p4:ReturnInstance(p3)
end
function GetMessageCreators() -- line: 42
	-- upvalues: MessageCreatorModules (copy), Util (copy)
	local t3 = {}
	local children = MessageCreatorModules:GetChildren()

	for i = 1, #children do
		if children[i]:IsA("ModuleScript") and children[i].Name ~= "Util" then
			local lib = require(children[i])

			t3[lib[Util.KEY_MESSAGE_TYPE]] = lib[Util.KEY_CREATOR_FUNCTION]
		end
	end

	return t3
end
function t2.WrapIntoMessageObject(p5, p6, p7) -- line: 56
	-- upvalues: Util (copy)
	local v24 = p7[Util.KEY_BASE_FRAME]
	local v25 = nil

	if Util.KEY_BASE_MESSAGE then
		v25 = p7[Util.KEY_BASE_MESSAGE]
	end

	local v26 = p7[Util.KEY_UPDATE_TEXT_FUNC]
	local v27 = p7[Util.KEY_GET_HEIGHT]
	local v28 = p7[Util.KEY_FADE_IN]
	local v29 = p7[Util.KEY_FADE_OUT]
	local v30 = p7[Util.KEY_UPDATE_ANIMATION]

	return {
		ID = p6.ID,
		BaseFrame = v24,
		BaseMessage = v25,
		UpdateTextFunction = v26 or function() -- line: 73
			warn("NO MESSAGE RESIZE FUNCTION")
		end,
		GetHeightFunction = v27,
		FadeInFunction = v28,
		FadeOutFunction = v29,
		UpdateAnimFunction = v30,
		ObjectPool = p5.ObjectPool,
		Destroyed = false,
		Destroy = function(p8) -- line: 81
			ReturnToObjectPoolRecursive(p8.BaseFrame, p8.ObjectPool)
			p8.Destroyed = true
		end
	}
end
function t2.CreateMessageLabel_Chat(p9, p10, p11, p12) -- line: 89
	-- upvalues: Chat (copy)
	p10.Channel = p11

	local u35 = nil

	pcall(function() -- line: 92
		-- upvalues: u35 (ref), Chat (copy), p10 (copy)
		u35 = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnClientFormattingMessage, p10)
	end)
	p10.ExtraData = p10.ExtraData or {}
	mergeProps(u35, p10.ExtraData)

	local MessageType = p10.MessageType

	if p9.MessageCreators[MessageType] then
		local v37 = p9.MessageCreators[MessageType](p10, p11, p12)

		if v37 then
			return p9:WrapIntoMessageObject(p10, v37)
		end
	elseif p9.DefaultCreatorType then
		local v38 = p9.MessageCreators[p9.DefaultCreatorType](p10, p11, p12)

		if v38 then
			return p9:WrapIntoMessageObject(p10, v38)
		end
	else
		error("No message creator available for message type: " .. MessageType)
	end
end
function t2.CreateMessageLabel(p13, p14, p15) -- line: 114
	-- upvalues: Chat (copy)
	p14.Channel = p15

	local u42 = nil

	pcall(function() -- line: 118
		-- upvalues: u42 (ref), Chat (copy), p14 (copy)
		u42 = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnClientFormattingMessage, p14)
	end)
	p14.ExtraData = p14.ExtraData or {}
	mergeProps(u42, p14.ExtraData)

	local MessageType = p14.MessageType

	if p13.MessageCreators[MessageType] then
		local v44 = p13.MessageCreators[MessageType](p14, p15)

		if v44 then
			return p13:WrapIntoMessageObject(p14, v44)
		end
	elseif p13.DefaultCreatorType then
		local v45 = p13.MessageCreators[p13.DefaultCreatorType](p14, p15)

		if v45 then
			return p13:WrapIntoMessageObject(p14, v45)
		end
	else
		error("No message creator available for message type: " .. MessageType)
	end
end
function t1.new() -- line: 143
	-- upvalues: t2 (copy), ObjectPool (copy), Util (copy)
	local self = setmetatable({}, t2)

	self.ObjectPool = ObjectPool.new(50)
	self.MessageCreators = GetMessageCreators()
	self.DefaultCreatorType = Util.DEFAULT_MESSAGE_CREATOR
	Util:RegisterObjectPool(self.ObjectPool)

	return self
end
function t1.GetStringTextBounds(_, p17, p18, p19, p20) -- line: 155
	-- upvalues: Util (copy)
	return Util:GetStringTextBounds(p17, p18, p19, p20)
end

return t1
