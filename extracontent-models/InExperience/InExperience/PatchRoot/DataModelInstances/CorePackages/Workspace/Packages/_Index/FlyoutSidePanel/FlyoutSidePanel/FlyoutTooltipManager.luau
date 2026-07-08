local AppStorageService = game:GetService("AppStorageService")
local v2 = game:DefineFastInt("IAFlyoutTooltipMaxShownCount", 5)
local v3 = game:DefineFastInt("IAFlyoutDailyTooltipMaxShownCount", 3)
local t1 = {}

t1.__index = t1

local function isSameDate(n1: number, n2: number) -- line: 23
	local v9 = os.date("*t", n1)
	local v10 = os.date("*t", n2)

	return v9.year == v10.year and (v9.month == v10.month and v9.day == v10.day)
end
local function readStorage() -- line: 29
	-- upvalues: AppStorageService (copy)
	local ok, result = pcall(function() -- line: 30
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("IAFlyoutEntryPointTooltip")
	end)

	if ok and result then
		if result == "FLYOUT_OPENED" then
			return 0, 0, 0
		end

		if string.find(result, ",") then
			local v13, v14, v15 = string.match(result, "(%d+),(%d+),(%d+)")
			local v16 = tonumber(v13) or 0
			local v17 = tonumber(v14) or 0
			local num = tonumber(v15)

			if num then
				return v16, v17, num
			end
		end
	end

	return 0, 0, 0
end

function t1.new() -- line: 51
	-- upvalues: t1 (copy)
	return (setmetatable({
		_hasChecked = false,
		_dailyCount = 0,
		_totalCount = 0,
		_getTime = function() -- line: 56
			return os.time()
		end
	}, t1))
end
function t1.setTimeProvider(p1, p2: ((...any) -> ...any)) -- line: 63
	p1._getTime = p2
end
function t1.flyoutSidePanelOpened(p3) -- line: 67
	-- upvalues: v2 (copy), AppStorageService (copy)
	if p3._dailyCount < v2 then
		p3._dailyCount = v2

		local v22 = p3:_getTime()
		local v23 = string.format("%d,%d,%d", v22, p3._dailyCount, p3._totalCount)

		AppStorageService:SetItem("IAFlyoutEntryPointTooltip", v23)
		AppStorageService:Flush()
	end
end
function t1.getTooltipCount(p4) -- line: 78
	return p4._totalCount
end
function t1.tooltipSeenTimeHelper(p5, n3: number) -- line: 82
	-- upvalues: v3 (copy), v2 (copy)
	local v27 = p5:_getTime()
	local v28 = os.date("*t", v27)
	local v29 = os.date("*t", n3)

	if v28.year ~= v29.year or (v28.month ~= v29.month or v28.day ~= v29.day) then
		p5._dailyCount = 0
	end

	return p5._dailyCount < v3 and p5._totalCount < v2
end
function t1.updateTooltipAppStorageValue(p6) -- line: 92
	-- upvalues: AppStorageService (copy)
	p6._dailyCount = p6._dailyCount + 1
	p6._totalCount = p6._totalCount + 1

	local v31 = p6:_getTime()
	local v32 = string.format("%d,%d,%d", v31, p6._dailyCount, p6._totalCount)

	AppStorageService:SetItem("IAFlyoutEntryPointTooltip", v32)
	AppStorageService:Flush()
end
function t1.isTooltipActive(p7) -- line: 101
	-- upvalues: readStorage (copy), v2 (copy)
	if p7._hasChecked then
		return false
	end

	p7._hasChecked = true

	local v34, v35, v36 = readStorage()

	p7._dailyCount = v35
	p7._totalCount = v36

	if p7._dailyCount >= v2 or p7._totalCount >= v2 then
		return false
	end

	if p7:tooltipSeenTimeHelper(v34) then
		p7:updateTooltipAppStorageValue()

		return true
	end

	return false
end

return t1.new()
