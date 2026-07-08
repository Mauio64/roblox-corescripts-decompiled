local t1 = {}
local t2 = {}

t2.__index = t2

local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local CommandModules = ClientChatModules:WaitForChild("CommandModules")
local Util = require(CommandModules:WaitForChild("Util"))
local _ = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

function t2.SetupCommandProcessors(p1) -- line: 19
	-- upvalues: CommandModules (copy), Util (copy)
	local children = CommandModules:GetChildren()

	for i = 1, #children do
		if children[i]:IsA("ModuleScript") and children[i].Name ~= "Util" then
			local lib = require(children[i])
			local v12 = lib[Util.KEY_COMMAND_PROCESSOR_TYPE]
			local v13 = lib[Util.KEY_PROCESSOR_FUNCTION]

			if v12 == Util.IN_PROGRESS_MESSAGE_PROCESSOR then
				table.insert(p1.InProgressMessageProcessors, v13)
			elseif v12 == Util.COMPLETED_MESSAGE_PROCESSOR then
				table.insert(p1.CompletedMessageProcessors, v13)
			end
		end
	end
end
function t2.ProcessCompletedChatMessage(p2, p3, p4) -- line: 37
	-- upvalues: ChatSettings (copy)
	for i = 1, #p2.CompletedMessageProcessors do
		if p2.CompletedMessageProcessors[i](p3, p4, ChatSettings) then
			return true
		end
	end

	return false
end
function t2.ProcessInProgressChatMessage(p5, p6, p7, p8) -- line: 47
	-- upvalues: ChatSettings (copy)
	for i = 1, #p5.InProgressMessageProcessors do
		local v23 = p5.InProgressMessageProcessors[i](p6, p7, p8, ChatSettings)

		if v23 then
			return v23
		end
	end

	return nil
end
function t1.new() -- line: 60
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.CompletedMessageProcessors = {}
	self.InProgressMessageProcessors = {}
	self:SetupCommandProcessors()

	return self
end

return t1
