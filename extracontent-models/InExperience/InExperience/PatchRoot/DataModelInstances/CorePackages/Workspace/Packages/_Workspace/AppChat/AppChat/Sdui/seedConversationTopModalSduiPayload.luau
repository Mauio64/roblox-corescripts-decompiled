local parent = script:FindFirstAncestor("AppChat").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local SduiConstants = require(script.Parent.SduiConstants)

local function isBlankPayload(value): boolean -- 1 equivalent call inferred from this helper
	if value == nil then
		return true
	end

	if typeof(value) == "string" then
		return string.match(value, "^%s*$") ~= nil
	end

	return typeof(value) == "table" and next(value) == nil
end

local function seedConversationTopModalSduiPayload(value, p: string)
	local conversationTopModalConfigKey = SduiConstants.getConversationTopModalConfigKey(p)
	local sduiApiStore = getSduiApiStore()

	if isBlankPayload(value) then -- inferred equivalent call
		sduiApiStore.clearConfigEntries(conversationTopModalConfigKey)
		return
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local partyChatResponse = ServiceContractsProto.apppageplatform.partychat.party_chat.PartyChatResponse
	local jsonDecode = partyChatResponse.jsonDecode(value)

	sduiApiStore.seedFromDecodedResponse({
		surfaceKey = SduiConstants.SurfaceKey,
		configKey = conversationTopModalConfigKey,
		decodedResponse = jsonDecode,
		loadTimer = SduiLoadTimer.createLoadTimer(SduiConstants.SurfaceKey),
		apiProto = partyChatResponse,
		replace = true
	})
end

return seedConversationTopModalSduiPayload
