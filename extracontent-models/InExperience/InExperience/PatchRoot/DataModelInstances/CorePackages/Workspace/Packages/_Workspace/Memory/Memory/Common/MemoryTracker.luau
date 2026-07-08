local v1 = game:DefineFastInt("CorescriptMemoryPeriodSeconds", 30)
local FFlagEnableCorescriptMemoryTracker = require(script.Parent.Parent.Flags.FFlagEnableCorescriptMemoryTracker)
local v3 = game:DefineFastFlag("EnableMemorySnapshotCategories", false)
local Stats = game:GetService("Stats")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("Memory").Parent
local DeviceTier = require(Parent.Devices).DeviceTier
local MemoryScope = require(script.Parent.MemoryScope)

local function GetMemoryPerformanceStatsItem() -- line: 20
	-- upvalues: Stats (copy)
	local v19 = Stats and Stats:FindFirstChild("PerformanceStats")

	if not v19 then
		return nil
	end

	return (v19:FindFirstChild("Memory"))
end
local function GetChildValue(p1, s1: string?) -- line: 29
	if s1 == nil then
		return (tostring(p1:GetValue()))
	end

	for _, v in ipairs(string.split(s1, "#")) do
		p1 = p1:FindFirstChild(v)

		if not p1 or not p1:IsA("StatsItem") then
			return "-1"
		end
	end

	return (tostring(p1:GetValue()))
end
local function GetLuaHeapMb() -- line: 44
	local ok, result = pcall(gcinfo)

	if ok and result then
		return string.format("%.2f", result / 1024)
	end

	return "-1"
end
local function GetCorescriptMemory() -- line: 52
	-- upvalues: Stats (copy)
	local v26 = Stats and Stats:FindFirstChild("PerformanceStats")
	local v27 = if v26 then v26:FindFirstChild("Memory") else nil

	if v27 then
		for _, child in v27:GetChildren() do
			if child:IsA("StatsItem") and child.DisplayName == "CoreScriptMemory" then
				return child:GetValue()
			end
		end
	end

	return nil
end

local t1 = {
	eventName = "CorescriptMemory",
	throttlingPercentage = 10000,
	description = "Memory consumption for corescript, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		7,
		16
	}
}
local t2 = {
	eventName = "CorescriptSessionMaxMemory",
	throttlingPercentage = 10000,
	description = "Maximum memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		7,
		16
	}
}
local t3 = {
	eventName = "CorescriptSessionAvgMemory",
	throttlingPercentage = 10000,
	description = "Average memory consumption for corescript in the session, in MB",
	links = "https://docs.google.com/document/d/1BEOgxPzSelCLEHdrHdD_8Kh4ssIcGLlndDXrLmIBNmk",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2026,
		3,
		4
	}
}
local _ = {
	ACTIVE = 1,
	PAUSED = 2,
	STOPPED = 3
}
local t4 = {}

t4.__index = t4

function t4.new(s2: string?, p2) -- line: 120
	-- upvalues: t4 (copy)
	return (setmetatable({
		memoryMb = 0,
		maxMemoryMb = 0,
		avgMemoryMb = 0,
		sampleCount = 0,
		status = 2,
		loggingTask = nil,
		context = s2,
		memoryScope = p2
	}, t4))
end
function t4.start(p3) -- line: 135
	-- upvalues: v1 (copy), GetCorescriptMemory (copy)
	p3.status = 1
	p3.loggingTask = task.delay(v1, function() -- line: 137
		-- upvalues: GetCorescriptMemory (copy), p3 (copy)
		local v60 = GetCorescriptMemory()

		if v60 then
			p3.maxMemoryMb = math.max(v60, p3.maxMemoryMb)
			p3.sampleCount = p3.sampleCount + 1
			p3.avgMemoryMb = p3.avgMemoryMb + (v60 - p3.avgMemoryMb) / p3.sampleCount
			p3:report(p3.context, v60)
		end

		if p3.status == 1 then
			p3:start()
		end
	end)
end
function t4.pause(p4) -- line: 151
	if p4.loggingTask then
		task.cancel(p4.loggingTask)
		p4.loggingTask = nil
	end

	p4.status = 2
end
function t4.resume(p5) -- line: 159
	if p5.status == 2 then
		p5:start()
	end
end
function t4.destroy(p6) -- line: 165
	if p6.loggingTask then
		task.cancel(p6.loggingTask)
		p6.loggingTask = nil
	end

	p6.status = 3

	if p6.maxMemoryMb > 0 then
		p6:reportMaxMemoryUsed(p6.context, p6.maxMemoryMb)
	end

	if p6.sampleCount > 0 then
		p6:reportAvgMemoryUsed(p6.context, p6.avgMemoryMb)
	end
end
function t4._buildCustomFields(p7, s3: string?) -- line: 179
	-- upvalues: DeviceTier (copy)
	return {
		deviceTier = DeviceTier.GetDeviceMemoryTier(),
		context = s3,
		memoryScope = p7.memoryScope
	}
end
function t4.report(p8, p9, p10) -- line: 187
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogStat(t1, {
		customFields = p8:_buildCustomFields(p9)
	}, p10)
end
function t4.reportMaxMemoryUsed(p11, p12, p13) -- line: 191
	-- upvalues: MemoryScope (copy), TelemetryService (copy), t2 (copy)
	if p11.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(t2, {
		customFields = p11:_buildCustomFields(p12)
	}, p13)
end
function t4.reportAvgMemoryUsed(p14, p15, p16) -- line: 202
	-- upvalues: MemoryScope (copy), TelemetryService (copy), t3 (copy)
	if p14.memoryScope == MemoryScope.UniversalApp then
		return
	end

	TelemetryService:LogStat(t3, {
		customFields = p14:_buildCustomFields(p15)
	}, p16)
end
function t4.getSnapshot() -- line: 213
	-- upvalues: Stats (copy), GetChildValue (copy), v3 (copy)
	local v47 = Stats and Stats:FindFirstChild("PerformanceStats")
	local v48 = if v47 then v47:FindFirstChild("Memory") else nil

	if not v48 then
		local t5 = {}
		local ok, result = pcall(gcinfo)

		t5.luaHeapMb = (not ok or not result) and "-1" or string.format("%.2f", result / 1024)

		return t5
	end

	local t6 = {}
	local ok, result = pcall(gcinfo)

	t6.luaHeapMb = (not ok or not result) and "-1" or string.format("%.2f", result / 1024)
	t6.totalMemory = tostring(v48:GetValue())
	t6.coreMemory = GetChildValue(v48, "CoreMemory")
	t6.placeMemory = GetChildValue(v48, "PlaceMemory")
	t6.placeLuaHeap = GetChildValue(v48, "PlaceMemory#LuaHeap")
	t6.coreScriptMemory = GetChildValue(v48, "CoreScriptMemory")
	t6.untrackedMemory = GetChildValue(v48, "UntrackedMemory")

	if v3 then
		t6.placeInstances = GetChildValue(v48, "PlaceMemory#Instances")
		t6.placeSignals = GetChildValue(v48, "PlaceMemory#Signals")
		t6.placeScript = GetChildValue(v48, "PlaceMemory#Script")
		t6.placePhysicsCollision = GetChildValue(v48, "PlaceMemory#PhysicsCollision")
		t6.placeGraphicsSolidModels = GetChildValue(v48, "PlaceMemory#GraphicsSolidModels")
		t6.placeGraphicsMeshParts = GetChildValue(v48, "PlaceMemory#GraphicsMeshParts")
		t6.placeGraphicsParticles = GetChildValue(v48, "PlaceMemory#GraphicsParticles")
		t6.placeGraphicsTerrain = GetChildValue(v48, "PlaceMemory#GraphicsTerrain")
		t6.placeGraphicsTexture = GetChildValue(v48, "PlaceMemory#GraphicsTexture")
		t6.placeGraphicsTextureCharacter = GetChildValue(v48, "PlaceMemory#GraphicsTextureCharacter")
		t6.placeSounds = GetChildValue(v48, "PlaceMemory#Sounds")
		t6.placeTerrainVoxels = GetChildValue(v48, "PlaceMemory#TerrainVoxels")
		t6.placeGui = GetChildValue(v48, "PlaceMemory#Gui")
		t6.placeAnimation = GetChildValue(v48, "PlaceMemory#Animation")
		t6.placeNavigation = GetChildValue(v48, "PlaceMemory#Navigation")
		t6.coreRenderTarget = GetChildValue(v48, "CoreMemory#render/target")
		t6.coreRenderGpuGeomMgr = GetChildValue(v48, "CoreMemory#render/gpu_geom_mgr")
		t6.coreRenderTextureLocal = GetChildValue(v48, "CoreMemory#render/texture/local")
		t6.coreRenderFonts = GetChildValue(v48, "CoreMemory#render/fonts")
		t6.coreRenderLightgrid = GetChildValue(v48, "CoreMemory#render/lightgrid")
		t6.coreGuiFontData = GetChildValue(v48, "CoreMemory#gui/FontData")
		t6.coreRenderEnvmap = GetChildValue(v48, "CoreMemory#render/envmap")
		t6.coreRenderShader = GetChildValue(v48, "CoreMemory#render/shader")
		t6.coreRenderSystem = GetChildValue(v48, "CoreMemory#render/system")
		t6.coreDynamicTexture = GetChildValue(v48, "CoreMemory#dynamic/texture")
		t6.coreDynamicMesh = GetChildValue(v48, "CoreMemory#dynamic/mesh")
	end

	return t6
end
function t4.getLuaHeapOnly() -- line: 296
	local t7 = {}
	local ok, result = pcall(gcinfo)

	t7.luaHeapMb = (not ok or not result) and "-1" or string.format("%.2f", result / 1024)

	return t7
end

local u18 = nil

return function(s4: string?, p17) -- line: 302
	-- upvalues: FFlagEnableCorescriptMemoryTracker (copy), u18 (ref), t4 (copy)
	if not FFlagEnableCorescriptMemoryTracker then
		return nil
	end

	if not u18 then
		u18 = t4.new(s4, p17)
	end

	return u18
end
