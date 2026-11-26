local defineFastInt = game:DefineFastInt("CorescriptMemoryPeriodSeconds", 30)
local FFlagEnableCorescriptMemoryTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Flags/FFlagEnableCorescriptMemoryTracker")
local defineFastFlag = game:DefineFastFlag("EnableMemorySnapshotCategories", false)

local Stats = game:GetService("Stats")
local TelemetryService = game:GetService("TelemetryService")

local deviceTier = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Devices").DeviceTier

local MemoryScope = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/MemoryScope")

local function GetMemoryPerformanceStatsItem()
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	if performanceStats then
		return (performanceStats:FindFirstChild("Memory"))
	end

	return nil
end

local function GetChildValue(statsItem, value)
	if value == nil then
		return (tostring(statsItem:GetValue()))
	end

	for i, childName in ipairs(string.split(value, "#")) do
		statsItem = statsItem:FindFirstChild(childName)

		if not (statsItem and statsItem:IsA("StatsItem")) then
			return "-1"
		end
	end

	return (tostring(statsItem:GetValue()))
end

local function GetLuaHeapMb()
	local success, result = pcall(gcinfo)

	if success and result then
		return string.format("%.2f", result / 1024)
	end

	return "-1"
end

local function GetCorescriptMemory()
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	local memory = if performanceStats then performanceStats:FindFirstChild("Memory") else nil

	if memory then
		for i, statsItem in memory:GetChildren() do
			if statsItem:IsA("StatsItem") and statsItem.DisplayName == "CoreScriptMemory" then
				return statsItem:GetValue()
			end
		end
	end

	return nil
end

local v5 = {
	eventName = "CorescriptMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 7, 16 },
	throttlingPercentage = 10000,
	description = "Memory consumption for corescript, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local v6 = {
	eventName = "CorescriptSessionMaxMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 7, 16 },
	throttlingPercentage = 10000,
	description = "Maximum memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local v7 = {
	eventName = "CorescriptSessionAvgMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 3, 4 },
	throttlingPercentage = 10000,
	description = "Average memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local v8 = { ACTIVE = 1, PAUSED = 2, STOPPED = 3 }

local class = {}
class.__index = class

function class.new(p2, p3)
	return (setmetatable({
		memoryMb = 0,
		maxMemoryMb = 0,
		avgMemoryMb = 0,
		sampleCount = 0,
		context = p2,
		memoryScope = p3,
		status = 2,
		loggingTask = nil
	}, class))
end

function class:start()
	self.status = 1
	self.loggingTask = task.delay(defineFastInt, function()
		local v9 = GetCorescriptMemory()

		if v9 then
			self.maxMemoryMb = math.max(v9, self.maxMemoryMb)
			self.sampleCount += 1
			self.avgMemoryMb += (v9 - self.avgMemoryMb) / self.sampleCount
			self:report(self.context, v9)
		end

		if self.status == 1 then
			self:start()
		end
	end)
end

function class:pause()
	if self.loggingTask then
		task.cancel(self.loggingTask)
		self.loggingTask = nil
	end

	self.status = 2
end

function class:resume()
	if self.status == 2 then
		self:start()
	end
end

function class:destroy()
	if self.loggingTask then
		task.cancel(self.loggingTask)
		self.loggingTask = nil
	end

	self.status = 3

	if self.maxMemoryMb > 0 then
		self:reportMaxMemoryUsed(self.context, self.maxMemoryMb)
	end

	if self.sampleCount > 0 then
		self:reportAvgMemoryUsed(self.context, self.avgMemoryMb)
	end
end

function class:_buildCustomFields(p3)
	return {
		deviceTier = deviceTier.GetDeviceMemoryTier(),
		context = p3,
		memoryScope = self.memoryScope
	}
end

function class:report(p2, p3)
	TelemetryService:LogStat(v5, { customFields = self:_buildCustomFields(p2) }, p3)
end

function class:reportMaxMemoryUsed(p2, p3)
	if self.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(v6, { customFields = self:_buildCustomFields(p2) }, p3)
end

function class:reportAvgMemoryUsed(p2, p3)
	if self.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(v7, { customFields = self:_buildCustomFields(p2) }, p3)
end

function class.getSnapshot()
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	local memory = if performanceStats then performanceStats:FindFirstChild("Memory") else nil

	if memory then
		local success, result = pcall(gcinfo)
		local v9 = {
			luaHeapMb = not (success and result) and "-1" or string.format("%.2f", result / 1024),
			totalMemory = tostring(memory:GetValue()),
			coreMemory = GetChildValue(memory, "CoreMemory"),
			placeMemory = GetChildValue(memory, "PlaceMemory"),
			placeLuaHeap = GetChildValue(memory, "PlaceMemory#LuaHeap"),
			coreScriptMemory = GetChildValue(memory, "CoreScriptMemory"),
			untrackedMemory = GetChildValue(memory, "UntrackedMemory")
		}

		if not defineFastFlag then
			return v9
		end

		v9.placeInstances = GetChildValue(memory, "PlaceMemory#Instances")
		v9.placeSignals = GetChildValue(memory, "PlaceMemory#Signals")
		v9.placeScript = GetChildValue(memory, "PlaceMemory#Script")
		v9.placePhysicsCollision = GetChildValue(memory, "PlaceMemory#PhysicsCollision")
		v9.placeGraphicsSolidModels = GetChildValue(memory, "PlaceMemory#GraphicsSolidModels")
		v9.placeGraphicsMeshParts = GetChildValue(memory, "PlaceMemory#GraphicsMeshParts")
		v9.placeGraphicsParticles = GetChildValue(memory, "PlaceMemory#GraphicsParticles")
		v9.placeGraphicsTerrain = GetChildValue(memory, "PlaceMemory#GraphicsTerrain")
		v9.placeGraphicsTexture = GetChildValue(memory, "PlaceMemory#GraphicsTexture")
		v9.placeGraphicsTextureCharacter = GetChildValue(memory, "PlaceMemory#GraphicsTextureCharacter")
		v9.placeSounds = GetChildValue(memory, "PlaceMemory#Sounds")
		v9.placeTerrainVoxels = GetChildValue(memory, "PlaceMemory#TerrainVoxels")
		v9.placeGui = GetChildValue(memory, "PlaceMemory#Gui")
		v9.placeAnimation = GetChildValue(memory, "PlaceMemory#Animation")
		v9.placeNavigation = GetChildValue(memory, "PlaceMemory#Navigation")

		v9.coreRenderTarget = GetChildValue(memory, "CoreMemory#render/target")
		v9.coreRenderGpuGeomMgr = GetChildValue(memory, "CoreMemory#render/gpu_geom_mgr")
		v9.coreRenderTextureLocal = GetChildValue(memory, "CoreMemory#render/texture/local")
		v9.coreRenderFonts = GetChildValue(memory, "CoreMemory#render/fonts")
		v9.coreRenderLightgrid = GetChildValue(memory, "CoreMemory#render/lightgrid")
		v9.coreGuiFontData = GetChildValue(memory, "CoreMemory#gui/FontData")
		v9.coreRenderEnvmap = GetChildValue(memory, "CoreMemory#render/envmap")
		v9.coreRenderShader = GetChildValue(memory, "CoreMemory#render/shader")
		v9.coreRenderSystem = GetChildValue(memory, "CoreMemory#render/system")
		v9.coreDynamicTexture = GetChildValue(memory, "CoreMemory#dynamic/texture")
		v9.coreDynamicMesh = GetChildValue(memory, "CoreMemory#dynamic/mesh")

		return v9
	else
		local success, result = pcall(gcinfo)

		return {
			luaHeapMb = not (success and result) and "-1" or string.format("%.2f", result / 1024)
		}
	end
end

function class.getLuaHeapOnly()
	local success, result = pcall(gcinfo)

	return {
		luaHeapMb = not (success and result) and "-1" or string.format("%.2f", result / 1024)
	}
end

local v9 = nil

return function(p2, p3)
	if not FFlagEnableCorescriptMemoryTracker then
		return nil
	end

	if not v9 then
		v9 = class.new(p2, p3)
	end

	return v9
end
