local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

local PersistStorage = {}
PersistStorage.__index = PersistStorage

function PersistStorage.new(memStorageKey)
	return (setmetatable({ memStorageKey = memStorageKey }, PersistStorage))
end

function PersistStorage.getItem(p)
	local success, result = pcall(function()
		local item = MemStorageService:GetItem(p.memStorageKey)

		if item and item ~= "" then
			return HttpService:JSONDecode(item)
		end

		return nil
	end)
	return if success then result else nil
end

function PersistStorage.setItem(p, p2)
	local success, _ = pcall(function()
		MemStorageService:SetItem(p.memStorageKey, (not p2 or p2 == "") and "" or HttpService:JSONEncode(p2))
	end)
	return success
end

function PersistStorage.bindAndFire(p, callback)
	return (MemStorageService:BindAndFire(p.memStorageKey, function(json)
		local v

		if json and json ~= "" then
			v = HttpService:JSONDecode(json)
		end

		if callback then
			callback(v)
		end
	end))
end

return PersistStorage
