local AppStorageService = game:GetService("AppStorageService")

local defineFastInt = game:DefineFastInt("IAFlyoutTooltipMaxShownCount", 5)
local defineFastInt2 = game:DefineFastInt("IAFlyoutDailyTooltipMaxShownCount", 3)

local class = {}

class.__index = class

local function isSameDate(p: number, p2: number): boolean -- 1 equivalent call inferred from this helper
	local v = os.date("*t", p)
	local v2 = os.date("*t", p2)
	return v.year == v2.year and v.month == v2.month and v.day == v2.day
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

	local v, v2, v3 = string.match(result, "(%d+),(%d+),(%d+)")
	local v4 = tonumber(v) or 0
	local v5 = tonumber(v2) or 0
	local v6 = tonumber(v3)

	if v6 then
		return v4, v5, v6
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
		local time = self:_getTime()
		AppStorageService:SetItem(
			"IAFlyoutEntryPointTooltip",
			(string.format("%d,%d,%d", time, self._dailyCount, self._totalCount))
		)
		AppStorageService:Flush()
	end
end

function class:getTooltipCount()
	return self._totalCount
end

function class:tooltipSeenTimeHelper(p: number): boolean
	if not isSameDate(self:_getTime(), p) then -- inferred equivalent call
		self._dailyCount = 0
	end

	return self._dailyCount < defineFastInt2 and self._totalCount < defineFastInt
end

function class:updateTooltipAppStorageValue()
	self._dailyCount += 1
	self._totalCount += 1
	local time = self:_getTime()
	AppStorageService:SetItem(
		"IAFlyoutEntryPointTooltip",
		(string.format("%d,%d,%d", time, self._dailyCount, self._totalCount))
	)
	AppStorageService:Flush()
end

function class:isTooltipActive(): boolean
	if self._hasChecked then
		return false
	end

	self._hasChecked = true

	local v, dailyCount, totalCount = readStorage()
	self._dailyCount = dailyCount
	self._totalCount = totalCount

	if defineFastInt <= self._dailyCount or defineFastInt <= self._totalCount or not self:tooltipSeenTimeHelper(v) then
		return false
	end

	self:updateTooltipAppStorageValue()
	return true
end

return class.new()
