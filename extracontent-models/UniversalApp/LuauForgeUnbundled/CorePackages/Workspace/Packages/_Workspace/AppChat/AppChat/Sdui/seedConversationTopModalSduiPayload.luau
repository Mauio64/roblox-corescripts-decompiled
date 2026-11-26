local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SduiSharedUtilities")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local SduiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Sdui/SduiConstants")

local function isBlankPayload(value): boolean
	if value == nil then
		return true
	end

	if typeof(value) == "string" then
		return string.match(value, "^%s*$") ~= nil
	end

	if typeof(value) == "table" then
		return next(value) == nil
	end

	return false
end

local function seedConversationTopModalSduiPayload(value, p2)
	local conversationTopModalConfigKey = SduiConstants.getConversationTopModalConfigKey(p2)
	local sduiApiStore = getSduiApiStore()
	local v5

	if value == nil then
		v5 = true
	elseif typeof(value) == "string" then
		v5 = string.match(value, "^%s*$") ~= nil
	else
		v5 = typeof(value) == "table" and next(value) == nil
	end

	if v5 then
		sduiApiStore.clearConfigEntries(conversationTopModalConfigKey)
		return
	end

	local partyChatResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ServiceContractsProto").apppageplatform.partychat.party_chat.PartyChatResponse
	local jsonDecode = partyChatResponse.jsonDecode(value)

	sduiApiStore.seedFromDecodedResponse({
		surfaceKey = SduiConstants.SurfaceKey,
		configKey = conversationTopModalConfigKey,
		decodedResponse = jsonDecode,
		loadTimer = sduiLoadTimer.createLoadTimer(SduiConstants.SurfaceKey),
		apiProto = partyChatResponse,
		replace = true
	})
end

return seedConversationTopModalSduiPayload
