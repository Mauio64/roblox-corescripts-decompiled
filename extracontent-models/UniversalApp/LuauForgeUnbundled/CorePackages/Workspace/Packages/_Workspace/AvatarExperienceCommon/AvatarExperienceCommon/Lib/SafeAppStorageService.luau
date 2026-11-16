local AppStorageService = game:GetService("AppStorageService")

local __DEV__ = _G.__DEV__ or false

local v5 = {}

return {
	getItem = function(p2, p3)
		if __DEV__ or p3 then
			return v5[p2] or ""
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(p2)
		end)

		if success then
			return result
		end

		return v5[p2] or ""
	end,
	setItem = function(p2, p3, p4)
		if __DEV__ or p4 then
			v5[p2] = p3
		elseif not pcall(function()
			AppStorageService:SetItem(p2, p3)
		end) then
			v5[p2] = p3
		end
	end,
	flush = function()
		pcall(function()
			AppStorageService:Flush()
		end)
	end,
	_resetMemStorageForTesting = function(options)
		v5 = options or {}
	end
}
