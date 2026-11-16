local defineFastInt = game:DefineFastInt("CorescriptMemoryPeriodSeconds", 30)
local FFlagEnableCorescriptMemoryTracker = require(script.Parent.Parent.Flags.FFlagEnableCorescriptMemoryTracker)
local defineFastFlag = game:DefineFastFlag("EnableMemorySnapshotCategories", false)

local Stats = game:GetService("Stats")
local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("Memory").Parent
local Devices = require(parent.Devices)
local DeviceTier = Devices.DeviceTier

local MemoryScope = require(script.Parent.MemoryScope)

local function GetMemoryPerformanceStatsItem() -- 2 equivalent calls inferred from this helper
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	if performanceStats then
		return (performanceStats:FindFirstChild("Memory"))
	end

	return nil
end

local function GetChildValue(statsItem, value: string?)
	if value == nil then
		return (tostring(statsItem:GetValue()))
	end

	for _, childName in ipairs(string.split(value, "#")) do
		statsItem = statsItem:FindFirstChild(childName)

		if not (statsItem and statsItem:IsA("StatsItem")) then
			return "-1"
		end
	end

	return (tostring(statsItem:GetValue()))
end

local function GetLuaHeapMb() -- 3 equivalent calls inferred from this helper
	local success, result = pcall(gcinfo)

	if success and result then
		return string.format("%.2f", result / 1024)
	end

	return "-1"
end

local function GetCorescriptMemory()
	local memoryPerformanceStatsItem = GetMemoryPerformanceStatsItem() -- inferred equivalent call

	if memoryPerformanceStatsItem then
		for _, statsItem in memoryPerformanceStatsItem:GetChildren() do
			if statsItem:IsA("StatsItem") and statsItem.DisplayName == "CoreScriptMemory" then
				return statsItem:GetValue()
			end
		end
	end

	return nil
end

local v = {
	eventName = "CorescriptMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 7, 16 },
	throttlingPercentage = 10000,
	description = "Memory consumption for corescript, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local v2 = {
	eventName = "CorescriptSessionMaxMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 7, 16 },
	throttlingPercentage = 10000,
	description = "Maximum memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local v3 = {
	eventName = "CorescriptSessionAvgMemory",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 3, 4 },
	throttlingPercentage = 10000,
	description = "Average memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk"
}

local _ = { ACTIVE = 1, PAUSED = 2, STOPPED = 3 }

local class = {}
class.__index = class

function class.new(context: string?, memoryScope)
	return (setmetatable({
		memoryMb = 0,
		maxMemoryMb = 0,
		avgMemoryMb = 0,
		sampleCount = 0,
		context = context,
		memoryScope = memoryScope,
		status = 2,
		loggingTask = nil
	}, class))
end

function class:start()
	self.status = 1
	self.loggingTask = task.delay(defineFastInt, function()
		local corescriptMemory = GetCorescriptMemory()

		if corescriptMemory then
			self.maxMemoryMb = math.max(corescriptMemory, self.maxMemoryMb)
			self.sampleCount += 1
			self.avgMemoryMb += (corescriptMemory - self.avgMemoryMb) / self.sampleCount
			self:report(self.context, corescriptMemory)
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

function class:_buildCustomFields(context: string?)
	return {
		deviceTier = DeviceTier.GetDeviceMemoryTier(),
		context = context,
		memoryScope = self.memoryScope
	}
end

function class:report(p, p2)
	TelemetryService:LogStat(v, { customFields = self:_buildCustomFields(p) }, p2)
end

function class:reportMaxMemoryUsed(p, p2)
	if self.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(v2, { customFields = self:_buildCustomFields(p) }, p2)
end

function class:reportAvgMemoryUsed(p, p2)
	if self.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(v3, { customFields = self:_buildCustomFields(p) }, p2)
end

function class.getSnapshot()
	local memoryPerformanceStatsItem = GetMemoryPerformanceStatsItem() -- inferred equivalent call

	if memoryPerformanceStatsItem then
		local v4 = {
			luaHeapMb = GetLuaHeapMb(), -- inferred equivalent call
			totalMemory = tostring(memoryPerformanceStatsItem:GetValue()),
			coreMemory = GetChildValue(memoryPerformanceStatsItem, "CoreMemory"),
			placeMemory = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory"),
			placeLuaHeap = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#LuaHeap"),
			coreScriptMemory = GetChildValue(memoryPerformanceStatsItem, "CoreScriptMemory"),
			untrackedMemory = GetChildValue(memoryPerformanceStatsItem, "UntrackedMemory")
		}

		if not defineFastFlag then
			return v4
		end

		v4.placeInstances = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Instances")
		v4.placeSignals = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Signals")
		v4.placeScript = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Script")
		v4.placePhysicsCollision = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#PhysicsCollision")
		v4.placeGraphicsSolidModels = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#GraphicsSolidModels")
		v4.placeGraphicsMeshParts = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#GraphicsMeshParts")
		v4.placeGraphicsParticles = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#GraphicsParticles")
		v4.placeGraphicsTerrain = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#GraphicsTerrain")
		v4.placeGraphicsTexture = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#GraphicsTexture")
		v4.placeGraphicsTextureCharacter = GetChildValue(
			memoryPerformanceStatsItem,
			"PlaceMemory#GraphicsTextureCharacter"
		)
		v4.placeSounds = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Sounds")
		v4.placeTerrainVoxels = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#TerrainVoxels")
		v4.placeGui = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Gui")
		v4.placeAnimation = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Animation")
		v4.placeNavigation = GetChildValue(memoryPerformanceStatsItem, "PlaceMemory#Navigation")

		v4.coreRenderTarget = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/target")
		v4.coreRenderGpuGeomMgr = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/gpu_geom_mgr")
		v4.coreRenderTextureLocal = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/texture/local")
		v4.coreRenderFonts = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/fonts")
		v4.coreRenderLightgrid = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/lightgrid")
		v4.coreGuiFontData = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#gui/FontData")
		v4.coreRenderEnvmap = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/envmap")
		v4.coreRenderShader = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/shader")
		v4.coreRenderSystem = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#render/system")
		v4.coreDynamicTexture = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#dynamic/texture")
		v4.coreDynamicMesh = GetChildValue(memoryPerformanceStatsItem, "CoreMemory#dynamic/mesh")

		return v4
	end

	return { luaHeapMb = GetLuaHeapMb() } -- inferred equivalent call
end

function class.getLuaHeapOnly()
	return { luaHeapMb = GetLuaHeapMb() } -- inferred equivalent call
end

local v4 = nil

return function(p: string?, p2)
	if not FFlagEnableCorescriptMemoryTracker then
		return nil
	end

	if not v4 then
		v4 = class.new(p, p2)
	end

	return v4
end
