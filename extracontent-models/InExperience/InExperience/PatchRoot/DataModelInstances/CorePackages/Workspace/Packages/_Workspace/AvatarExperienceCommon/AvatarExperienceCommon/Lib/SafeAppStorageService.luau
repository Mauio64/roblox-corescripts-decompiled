local AppStorageService = game:GetService("AppStorageService")

local __DEV__ = _G.__DEV__ or false

local v = {}
local SafeAppStorageService = {}

function SafeAppStorageService.getItem(p: string, flag: boolean?)
	if __DEV__ or flag then
		return v[p] or ""
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem(p)
	end)

	if success then
		return result
	end

	return v[p] or ""
end

function SafeAppStorageService.setItem(p: string, p2: string, flag: boolean?)
	if __DEV__ or flag then
		v[p] = p2
	elseif not pcall(function()
		AppStorageService:SetItem(p, p2)
	end) then
		v[p] = p2
	end
end

function SafeAppStorageService.flush()
	pcall(function()
		AppStorageService:Flush()
	end)
end

function SafeAppStorageService._resetMemStorageForTesting(options)
	v = options or {}
end

return SafeAppStorageService
