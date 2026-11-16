local MessageLabelCreator = {}

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local MessageCreatorModules = ClientChatModules:WaitForChild("MessageCreatorModules")
local Util = require(MessageCreatorModules:WaitForChild("Util"))
local parent = script.Parent
require(ClientChatModules:WaitForChild("ChatSettings"))
local ObjectPool = require(parent:WaitForChild("ObjectPool"))
require(parent:WaitForChild("MessageSender"))

local class = {}
class.__index = class

function mergeProps(items, p)
	if not items then
		return
	end

	for k, item in pairs(items) do
		p[k] = item
	end
end

function ReturnToObjectPoolRecursive(instance, object)
	local children = instance:GetChildren()

	for i = 1, #children do
		ReturnToObjectPoolRecursive(children[i], object)
	end

	instance.Parent = nil
	object:ReturnInstance(instance)
end

function GetMessageCreators()
	local children = MessageCreatorModules:GetChildren()
	local messageCreators = {}

	for i = 1, #children do
		if not (children[i]:IsA("ModuleScript") and children[i].Name ~= "Util") then
			continue
		end

		local module = require(children[i])
		messageCreators[module[Util.KEY_MESSAGE_TYPE]] = module[Util.KEY_CREATOR_FUNCTION]
	end

	return messageCreators
end

function class:WrapIntoMessageObject(p, p2)
	local baseFrame = p2[Util.KEY_BASE_FRAME]
	local baseMessage

	if Util.KEY_BASE_MESSAGE then
		baseMessage = p2[Util.KEY_BASE_MESSAGE]
	end

	local v = p2[Util.KEY_UPDATE_TEXT_FUNC]
	local getHeightFunction = p2[Util.KEY_GET_HEIGHT]
	local fadeInFunction = p2[Util.KEY_FADE_IN]
	local fadeOutFunction = p2[Util.KEY_FADE_OUT]
	local updateAnimFunction = p2[Util.KEY_UPDATE_ANIMATION]

	return {
		["ID"] = p.ID,
		BaseFrame = baseFrame,
		BaseMessage = baseMessage,
		UpdateTextFunction = v or function()
			warn("NO MESSAGE RESIZE FUNCTION")
		end,
		GetHeightFunction = getHeightFunction,
		FadeInFunction = fadeInFunction,
		FadeOutFunction = fadeOutFunction,
		UpdateAnimFunction = updateAnimFunction,
		ObjectPool = self.ObjectPool,
		Destroyed = false,
		Destroy = function(state)
			ReturnToObjectPoolRecursive(state.BaseFrame, state.ObjectPool)
			state.Destroyed = true
		end
	}
end

function class:CreateMessageLabel_Chat(state, channel, p)
	state.Channel = channel
	local v = nil
	pcall(function()
		v = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnClientFormattingMessage, state)
	end)
	state.ExtraData = state.ExtraData or {}
	local mergeProps = mergeProps
	local v2 = v
	mergeProps(v2, state.ExtraData)

	local messageType = state.MessageType

	if self.MessageCreators[messageType] then
		local v3 = self.MessageCreators[messageType](state, channel, p)

		if v3 then
			return self:WrapIntoMessageObject(state, v3)
		end
	elseif self.DefaultCreatorType then
		local v3 = self.MessageCreators[self.DefaultCreatorType](state, channel, p)

		if v3 then
			return self:WrapIntoMessageObject(state, v3)
		end
	else
		error("No message creator available for message type: " .. messageType)
	end
end

function class:CreateMessageLabel(state, channel)
	state.Channel = channel
	local v = nil
	pcall(function()
		v = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnClientFormattingMessage, state)
	end)
	state.ExtraData = state.ExtraData or {}
	local mergeProps = mergeProps
	local v2 = v
	mergeProps(v2, state.ExtraData)

	local messageType = state.MessageType

	if self.MessageCreators[messageType] then
		local v3 = self.MessageCreators[messageType](state, channel)

		if v3 then
			return self:WrapIntoMessageObject(state, v3)
		end
	elseif self.DefaultCreatorType then
		local v3 = self.MessageCreators[self.DefaultCreatorType](state, channel)

		if v3 then
			return self:WrapIntoMessageObject(state, v3)
		end
	else
		error("No message creator available for message type: " .. messageType)
	end
end

function MessageLabelCreator.new()
	local self = setmetatable({}, class)

	self.ObjectPool = ObjectPool.new(50)
	self.MessageCreators = GetMessageCreators()
	self.DefaultCreatorType = Util.DEFAULT_MESSAGE_CREATOR

	Util:RegisterObjectPool(self.ObjectPool)

	return self
end

function MessageLabelCreator:GetStringTextBounds(p, p2, p3, p4)
	return Util:GetStringTextBounds(p, p2, p3, p4)
end

return MessageLabelCreator
