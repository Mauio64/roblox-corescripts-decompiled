local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local class = {}

class.__index = class

function class.new()
	return (setmetatable({ listeners = {} }, class))
end

function class.addListener(p2, p3, p4)
	if not p2.listeners[p3] then
		p2.listeners[p3] = {}
	end

	table.insert(p2.listeners[p3], p4)
end

function class:removeListener(p3, p4)
	local listener = self.listeners[p3]

	if not listener then
		return
	end

	local index = table.find(listener, p4)

	if index then
		table.remove(listener, index)

		if #listener == 0 then
			self.listeners[p3] = nil
		end
	end
end

function class:removeAllListeners()
	table.clear(self.listeners)
end

function class.emit(p2, p3, ...)
	local listener = p2.listeners[p3]

	if not listener then
		return
	end

	local clone = table.clone(listener)

	for k, v5 in clone do
		pcall(function(...): nil
			v5(...)
			return nil
		end, ...)
	end
end

return {
	jsonDecode = function(json)
		local success, result = pcall(function()
			return HttpService:JSONDecode(json)
		end)

		if success and result then
			return result
		end

		return {}
	end,
	EventEmitter = class,
	shorten = function(p2)
		return "..." .. string.sub(tostring(p2), -4)
	end,
	avoidEmitting = function(folder)
		local function prune(instance)
			if instance:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function()
					instance:Destroy()
				end)
			end
		end
		folder.DescendantAdded:Connect(prune)

		for i, descendant in folder:GetDescendants() do
			if descendant:HasTag("RbxDefaultVoiceEmitter") then
				task.defer(function()
					descendant:Destroy()
				end)
			end
		end
	end,
	destroyDefaultEmitter = function(instance)
		local localPlayer = Players.LocalPlayer

		if not localPlayer then
			return
		end

		local character = localPlayer.Character

		if not character then
			return
		end

		if instance:IsDescendantOf(character) then
			task.defer(function()
				instance:Destroy()
			end)
		end
	end,
	bind = function(p2, p3)
		return function(...)
			return p2[p3](p2, ...)
		end
	end
}
