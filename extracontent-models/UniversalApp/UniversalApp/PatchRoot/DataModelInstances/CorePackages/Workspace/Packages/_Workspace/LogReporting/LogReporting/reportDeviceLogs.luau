local Parent = script:FindFirstAncestor("LogReporting").Parent
local FFlagEnableLuaLogReporterMultipleLogs = require(Parent.SharedFlags).FFlagEnableLuaLogReporterMultipleLogs
local Base64 = require(Parent.AuthCommon).Utils.Base64
local random = Random.new()

local function generateHexString(p1) -- line: 10
	-- upvalues: random (ref)
	local s1 = ""

	for _ = 1, p1 do
		local v12 = random:NextInteger(1, 16)

		s1 ..= string.sub("0123456789abcdef", v12, v12)
	end

	return s1
end
local function setHexStringSeed(p2) -- line: 20
	-- upvalues: random (ref)
	random = Random.new(p2)
end
local function generateLogMetadata(n1: number, n2: number, b1: boolean) -- line: 24
	-- upvalues: random (ref), generateHexString (copy), Base64 (copy)
	local v17 = math.floor(tick() * 1000 + n1)

	random = Random.new(v17)

	local v18 = generateHexString(10)
	local v19 = string.format("%s-%s-%s-%s-%s", generateHexString(8), generateHexString(4), generateHexString(4), generateHexString(4), (generateHexString(12)))
	local v20 = generateHexString(64)
	local t1 = {
		reportId = v18,
		userId = n1 and tostring(n1) or "",
		placeId = tostring(n2),
		voiceEnabled = b1
	}
	local v22 = string.format("https://console.backtrace.rbx.com/p/LogReports/debug?time=all&filters=%s", Base64.Encode("[[\"reportId\",\"equal\",\"" .. v18 .. "\"]]"):sub(0, -2))
	local v23 = Base64.Encode(v20):sub(0, -2)

	return {
		desc = "clientDump",
		url = v22,
		reportId = v18,
		fingerprint = v23,
		uuid = v19,
		attributes = t1
	}
end
local function reportDeviceLogs(p3, n3: number, n4: number, b2: boolean) -- line: 70
	-- upvalues: generateLogMetadata (copy), FFlagEnableLuaLogReporterMultipleLogs (copy)
	local v28 = generateLogMetadata(n3, n4, b2)

	if FFlagEnableLuaLogReporterMultipleLogs and game:GetEngineFeature("LogReporterMultipleLogs") then
		p3:ReportMultipleLogs(v28.fingerprint, v28.uuid, v28.desc, v28.attributes, {}, 2)
	else
		p3:ReportLog(v28.fingerprint, v28.uuid, v28.desc, v28.attributes, {})
	end

	return {
		url = v28.url,
		reportId = v28.reportId
	}
end

return reportDeviceLogs
