local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

local class = {}
class.__index = class

function class.new(p2)
	return (setmetatable({ memStorageKey = p2 }, class))
end

function class.getItem(p2)
	local success, result = pcall(function()
		local item = MemStorageService:GetItem(p2.memStorageKey)

		if item and item ~= "" then
			return HttpService:JSONDecode(item)
		end

		return nil
	end)

	if success then
		return result
	end

	return nil
end

function class.setItem(p2, p3)
	local success, result = pcall(function()
		MemStorageService:SetItem(
			p2.memStorageKey,
			(not p3 or p3 == "") and "" or HttpService:JSONEncode(p3)
		)
	end)
	return success
end

function class:bindAndFire(callback)
	return (MemStorageService:BindAndFire(self.memStorageKey, function(json)
		local v5 = if json and json ~= "" then HttpService:JSONDecode(json) else nil

		if callback then
			callback(v5)
		end
	end))
end

return class
