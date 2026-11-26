local fFlagEnableLuaLogReporterMultipleLogs = require("@luauforge/bundled/hWW").FFlagEnableLuaLogReporterMultipleLogs
local base64 = require("@luauforge/bundled/hWX").Utils.Base64

local random = Random.new()

local function generateHexString(p2)
	local hexString = ""

	for i = 1, p2 do
		local integer = random:NextInteger(1, 16)
		hexString ..= string.sub("0123456789abcdef", integer, integer)
	end

	return hexString
end

local function setHexStringSeed(p2)
	random = Random.new(p2)
end

local function generateLogMetadata(p2, p3, voiceEnabled)
	local v5 = math.floor(tick() * 1000 + p2)
	random = Random.new(v5)

	local v6 = generateHexString(10)
	local v7 = string.format(
		"%s-%s-%s-%s-%s",
		generateHexString(8),
		generateHexString(4),
		generateHexString(4),
		generateHexString(4),
		generateHexString(12)
	)

	local v8 = generateHexString(64)

	local v9 = {}
	v9.reportId = v6
	v9.userId = p2 and tostring(p2) or ""

	v9.placeId = tostring(p3)
	v9.voiceEnabled = voiceEnabled

	return {
		url = string.format(
			"https://console.backtrace.rbx.com/p/LogReports/debug?time=all&filters=%s",
			base64.Encode("[[\"reportId\",\"equal\",\"" .. v6 .. "\"]]"):sub(0, -2)
		),
		reportId = v6,
		fingerprint = base64.Encode(v8):sub(0, -2),
		uuid = v7,
		desc = "clientDump",
		attributes = v9
	}
end

local function reportDeviceLogs(object, p2, p3, p4)
	local v5 = generateLogMetadata(p2, p3, p4)

	if fFlagEnableLuaLogReporterMultipleLogs and game:GetEngineFeature("LogReporterMultipleLogs") then
		object:ReportMultipleLogs(v5.fingerprint, v5.uuid, v5.desc, v5.attributes, {}, 2)
	else
		object:ReportLog(v5.fingerprint, v5.uuid, v5.desc, v5.attributes, {})
	end

	return { url = v5.url, reportId = v5.reportId }
end

return reportDeviceLogs
