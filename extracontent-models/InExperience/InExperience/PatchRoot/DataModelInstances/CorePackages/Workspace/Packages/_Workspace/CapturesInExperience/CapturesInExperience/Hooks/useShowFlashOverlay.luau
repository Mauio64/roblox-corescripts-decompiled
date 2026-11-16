local AppStorageService = game:GetService("AppStorageService")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local RoactUtils = require(parent2.RoactUtils)

local Constants = require(parent.Constants)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function fn()
	pcall(function()
		AppStorageService:SetItem(
			Constants.LastFlashOccurrenceTsLocalStorageKey,
			(tostring(DateTime.now().UnixTimestampMillis))
		)

		AppStorageService:Flush()
	end)
end

return function(p)
	local v = p or AppStorageService

	if not useSelector(function(p2)
		return p2[Constants.RoduxKey].IsOverlayFlashActive
	end) then
		return false, fn
	end

	local success, result = pcall(function()
		return v:GetItem(Constants.LastFlashOccurrenceTsLocalStorageKey)
	end)

	if not success then
		return false, fn
	end

	local v2 = tonumber(result)

	if v2 == nil then
		return false, fn
	end

	assert(v2 ~= nil, "lastFlashOccurrenceTs cannot be nil")

	if DateTime.now().UnixTimestampMillis - v2 < 500 then
		return false, fn
	end

	return true, fn
end
