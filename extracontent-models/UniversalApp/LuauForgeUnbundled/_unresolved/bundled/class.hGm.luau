local defineFastInt = game:DefineFastInt("ScrollingPerfTrackerEventStream", 0)
local defineFastInt2 = game:DefineFastInt("ScrollingPerfTrackerKibana", 0)

local defineFastInt3 = game:DefineFastInt("ScrollingPerfTrackerSampleCountThreshold", 50)
local defineFastInt4 = game:DefineFastInt("ScrollingPerfTrackerTargetFPS", 60)

function LUAUFORGE_MODULE_GLOBALS_hGm_applicationId()
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local item = AppStorageService:GetItem("AppInstallationId")
	local typeName = typeof(item)

	if typeName == "number" then
		return tonumber(item) or nil
	end

	if typeName ~= "string" or string.len(item) <= 0 then
		return nil
	end

	return (tonumber((string.sub(item, -string.len((tostring(1000)))))))
end

if not (defineFastInt > 0 or defineFastInt2 > 0) then
	return nil
end

local v5 = math.random(0, 1000)
local v6 = LUAUFORGE_MODULE_GLOBALS_hGm_applicationId()

if v6 == nil then
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	if localPlayer and localPlayer.UserId > 0 then
		v5 = (localPlayer.UserId + 647) % 1000
	end
else
	v5 = (v6 + 647) % 1000
end

local v7 = not (v5 < defineFastInt) and 0 or defineFastInt
local v8 = not (v5 < defineFastInt2) and 0 or defineFastInt2

if not (v7 > 0 or v8 > 0) then
	return nil
end

local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local module = require("@luauforge/bundled/hGn")

local v9 = not (defineFastInt4 > 0) and 1 / 60 or 1 / defineFastInt4

local class = {}
class.__index = class

function class.new(p2, p3)
	local v10 = {}
	v10.id = p2
	v10.lastScrollPosition = 0
	v10.histogram = {}
	v10.sampleCount = 0
	v10.renderStepConn = nil
	v10.canvasPositionConn = nil
	v10.scrollingFrame = nil
	v10.totalScrollDistance = 0

	if p3 then
		if p3.analyticsService then
			v10.analyticsService = p3.analyticsService.EventStream
		end

		v10.loggingProtocol = p3.loggingProtocol
	end

	return (setmetatable(v10, class))
end

function class:eventData()
	if self.sampleCount == 0 then
		return {}
	end

	local v10 = (self.histogram[1] or 0) / self.sampleCount
	local v11, v12

	if self.scrollingFrame then
		local absoluteSize = self.scrollingFrame.AbsoluteSize
		v11 = absoluteSize.X
		v12 = absoluteSize.Y
	else
		v11 = 0
		v12 = 0
	end

	return {
		component_id = self.id,
		sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
		smooth_ratio = v10,
		drop_count_0 = self.histogram[1] or 0,
		drop_count_1 = self.histogram[2] or 0,
		drop_count_2 = self.histogram[3] or 0,
		drop_count_3 = self.histogram[4] or 0,
		distance_pixels = math.ceil(self.totalScrollDistance),
		frame_width = v11,
		frame_height = v12
	}
end

function class:sendEvent()
	if self.sampleCount < defineFastInt3 or self.sampleCount == 0 then
		return
	end

	local eventData = self:eventData()
	self:resetCounts()

	if v7 > 0 and self.analyticsService then
		self.analyticsService:sendEventDeferred(self.id, "scrolling_performance", eventData)
	end

	if v8 > 0 and self.loggingProtocol then
		self.loggingProtocol:logRobloxTelemetryEvent(module, {}, eventData)
	end
end

function class:resetCounts()
	self.histogram = {}
	self.sampleCount = 0
	self.totalScrollDistance = 0
end

function class:canvasPositionChanged()
	if not self.renderStepConn then
		self.renderStepConn = RunService.Heartbeat:Connect(function(dt)
			self:captureFrameUpdate(dt)
		end)
	end
end

function class:captureFrameUpdate(p2)
	local y = self.scrollingFrame and self.scrollingFrame.CanvasPosition.Y or 0

	if y == self.lastScrollPosition then
		local renderStepConn = self.renderStepConn

		if renderStepConn then
			renderStepConn:Disconnect()
		end

		self.renderStepConn = nil
		self:sendEvent()
	else
		self.totalScrollDistance += math.abs(y - self.lastScrollPosition)

		local v10 = math.min(4, math.floor(math.max(0, p2 - 0.002) / v9) + 1)

		self.histogram[v10] = (self.histogram[v10] or 0) + 1
		self.lastScrollPosition = y
		self.sampleCount += 1
	end
end

function class:setScrollingFrame(scrollingFrame)
	if self.scrollingFrame ~= scrollingFrame then
		self.scrollingFrame = scrollingFrame
		local canvasPositionConn = self.canvasPositionConn

		if scrollingFrame then
			self.lastScrollPosition = scrollingFrame.CanvasPosition.Y
			self.canvasPositionConn = scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function(p2, p3, p4)
				self:canvasPositionChanged()
			end)
		else
			self.canvasPositionConn = nil
		end

		if canvasPositionConn then
			canvasPositionConn:Disconnect()
		end
	end
end

function class:clean()
	self:setScrollingFrame(nil)
	local renderStepConn = self.renderStepConn

	if renderStepConn then
		renderStepConn:Disconnect()
	end

	self.renderStepConn = nil
	self:resetCounts()
end

return class
