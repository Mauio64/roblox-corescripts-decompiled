local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local class = {}

class.__index = class

function class.new()
	return (setmetatable({ listeners = {} }, class))
end

function class.addListener(p, p2: string, callback)
	if not p.listeners[p2] then
		p.listeners[p2] = {}
	end

	table.insert(p.listeners[p2], callback)
end

function class.removeListener(p, p2: string, callback)
	local listener = p.listeners[p2]

	if not listener then
		return
	end

	local index = table.find(listener, callback)

	if index then
		table.remove(listener, index)

		if #listener == 0 then
			p.listeners[p2] = nil
		end
	end
end

function class.removeAllListeners(p)
	table.clear(p.listeners)
end

function class.emit(p, p2: string, ...)
	local listener = p.listeners[p2]

	if not listener then
		return
	end

	local clone = table.clone(listener)

	for _, v in clone do
		pcall(function(...): nil
			v(...)
			return nil
		end, ...)
	end
end

local Utils = {}

function Utils.jsonDecode(json)
	local success, result = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if success and result then
		return result
	end

	return {}
end

Utils.EventEmitter = class

function Utils.shorten(p)
	return "..." .. string.sub(tostring(p), -4)
end

function Utils.avoidEmitting(folder)
	local function prune(descendant) -- 1 equivalent call inferred from this helper
		if descendant:HasTag("RbxDefaultVoiceEmitter") then
			task.defer(function()
				descendant:Destroy()
			end)
		end
	end
	folder.DescendantAdded:Connect(prune)

	for _, descendant in folder:GetDescendants() do
		prune(descendant) -- inferred equivalent call
	end
end

function Utils.destroyDefaultEmitter(instance)
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
end

function Utils.bind(p, p2)
	return function(...)
		return p[p2](p, ...)
	end
end

return Utils
