local CommandProcessor = {}
local class = {}
class.__index = class

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local CommandModules = ClientChatModules:WaitForChild("CommandModules")
local Util = require(CommandModules:WaitForChild("Util"))
local parent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

function class:SetupCommandProcessors()
	local children = CommandModules:GetChildren()

	for i = 1, #children do
		if not (children[i]:IsA("ModuleScript") and children[i].Name ~= "Util") then
			continue
		end

		local module = require(children[i])
		local v = module[Util.KEY_COMMAND_PROCESSOR_TYPE]
		local v2 = module[Util.KEY_PROCESSOR_FUNCTION]

		if v == Util.IN_PROGRESS_MESSAGE_PROCESSOR then
			table.insert(self.InProgressMessageProcessors, v2)
		elseif v == Util.COMPLETED_MESSAGE_PROCESSOR then
			table.insert(self.CompletedMessageProcessors, v2)
		end
	end
end

function class.ProcessCompletedChatMessage(p, p2, p3): boolean
	for i = 1, #p.CompletedMessageProcessors do
		if p.CompletedMessageProcessors[i](p2, p3, ChatSettings) then
			return true
		end
	end

	return false
end

function class.ProcessInProgressChatMessage(p, p2, p3, p4)
	for i = 1, #p.InProgressMessageProcessors do
		local v = p.InProgressMessageProcessors[i](p2, p3, p4, ChatSettings)

		if v then
			return v
		end
	end

	return nil
end

function CommandProcessor.new()
	local self = setmetatable({}, class)

	self.CompletedMessageProcessors = {}
	self.InProgressMessageProcessors = {}

	self:SetupCommandProcessors()

	return self
end

return CommandProcessor
