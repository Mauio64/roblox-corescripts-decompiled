local AppStorageService = game:GetService("AppStorageService")

local defineFastInt = game:DefineFastInt("IAFlyoutTooltipMaxShownCount", 5)
local defineFastInt2 = game:DefineFastInt("IAFlyoutDailyTooltipMaxShownCount", 3)

local class = {}

class.__index = class

local function isSameDate(p2, p3): boolean
	local v5 = os.date("*t", p2)
	local v6 = os.date("*t", p3)
	return v5.year == v6.year and v5.month == v6.month and v5.day == v6.day
end

local function readStorage()
	local success, result = pcall(function()
		return AppStorageService:GetItem("IAFlyoutEntryPointTooltip")
	end)

	if not (success and result and result ~= "FLYOUT_OPENED") then
		return 0, 0, 0
	end

	if not string.find(result, ",") then
		return 0, 0, 0
	end

	local v5, v6, v7 = string.match(result, "(%d+),(%d+),(%d+)")
	local v8 = tonumber(v5) or 0
	local v9 = tonumber(v6) or 0
	local v10 = tonumber(v7)

	if v10 then
		return v8, v9, v10
	end

	return 0, 0, 0
end

function class.new()
	return (setmetatable({
		_hasChecked = false,
		_dailyCount = 0,
		_totalCount = 0,
		_getTime = function()
			return os.time()
		end
	}, class))
end

function class:setTimeProvider(getTime)
	self._getTime = getTime
end

function class:flyoutSidePanelOpened()
	if self._dailyCount < defineFastInt then
		self._dailyCount = defineFastInt
		local time2 = self:_getTime()
		AppStorageService:SetItem(
			"IAFlyoutEntryPointTooltip",
			(string.format("%d,%d,%d", time2, self._dailyCount, self._totalCount))
		)
		AppStorageService:Flush()
	end
end

function class:getTooltipCount()
	return self._totalCount
end

function class:tooltipSeenTimeHelper(p2): boolean
	local time2 = self:_getTime()
	local v5 = os.date("*t", time2)
	local v6 = os.date("*t", p2)
	local v7 = v5.year == v6.year and v5.month == v6.month and v5.day == v6.day

	if not v7 then
		self._dailyCount = 0
	end

	return self._dailyCount < defineFastInt2 and self._totalCount < defineFastInt
end

function class:updateTooltipAppStorageValue()
	self._dailyCount += 1
	self._totalCount += 1
	local time2 = self:_getTime()
	AppStorageService:SetItem(
		"IAFlyoutEntryPointTooltip",
		(string.format("%d,%d,%d", time2, self._dailyCount, self._totalCount))
	)
	AppStorageService:Flush()
end

function class:isTooltipActive(): boolean
	if self._hasChecked then
		return false
	end

	self._hasChecked = true

	local v5, v6, v7 = readStorage()
	self._dailyCount = v6
	self._totalCount = v7

	if defineFastInt <= self._dailyCount then
		return false
	end

	if defineFastInt <= self._totalCount then
		return false
	end

	if not self:tooltipSeenTimeHelper(v5) then
		return false
	end

	self:updateTooltipAppStorageValue()
	return true
end

return class.new()
