local AppStorageService = game:GetService("AppStorageService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local RoactUtils = require(ParentParentParent.RoactUtils)
local Constants = require(ParentParent.Constants)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function v7() -- line: 19
	-- upvalues: AppStorageService (copy), Constants (copy)
	pcall(function() -- line: 20
		-- upvalues: AppStorageService (copy), Constants (copy)
		AppStorageService:SetItem(Constants.LastFlashOccurrenceTsLocalStorageKey, (tostring(DateTime.now().UnixTimestampMillis)))
		AppStorageService:Flush()
	end)
end

return function(p1) -- line: 29
	-- upvalues: AppStorageService (copy), useSelector (copy), Constants (copy), v7 (copy)
	local v9 = p1 or AppStorageService

	if not useSelector(function(p2) -- line: 32
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsOverlayFlashActive
	end) then
		return false, v7
	end

	local ok, result = pcall(function() -- line: 40
		-- upvalues: v9 (copy), Constants (copy)
		return v9:GetItem(Constants.LastFlashOccurrenceTsLocalStorageKey)
	end)

	if not ok then
		return false, v7
	end

	local num = tonumber(result)

	if num == nil then
		return false, v7
	end

	assert(num ~= nil, "lastFlashOccurrenceTs cannot be nil")

	if DateTime.now().UnixTimestampMillis - num < 500 then
		return false, v7
	end

	return true, v7
end
