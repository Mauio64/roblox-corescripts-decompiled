local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local SharedFlags = require(parent.SharedFlags)
local sendPromptModalSkippedEvent = require(ServerTriggeredModals.sendPromptModalSkippedEvent)
require(ServerTriggeredModals.SduiV2.Types.PromptEntry)

local FFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle

local reason = {
	AlreadyShown = "alreadyShown",
	NotFocused = "notFocused",
	IncompleteEntry = "incompleteEntry",
	LegacyMetadata = "legacyMetadata"
}

local v = {}
local set = {}

local function getModalType(p) -- 2 equivalent calls inferred from this helper
	local v2

	if FFlagPromptsImpressionUsesTitle then
		v2 = p.title
	else
		v2 = p.robloxComponentType
	end

	return v2 or ""
end

local function log(reason2: string, entryPoint: string, item)
	local identifier = item.identifier or ""
	local modalType = getModalType(item) -- inferred equivalent call
	local v2 = v[entryPoint]

	if reason2 == reason.AlreadyShown and v2 ~= nil and item.identifier ~= nil and v2.identifier == item.identifier then
		return
	end

	local v3 = entryPoint .. "|" .. identifier .. "|" .. modalType .. "|" .. reason2

	if set[v3] then
		return
	end

	set[v3] = true

	local v4 = {
		reason = reason2,
		modalId = identifier,
		modalType = modalType,
		entryPoint = entryPoint,
		shownByModalId = v2 and v2.identifier or "",
		shownByModalType = 0
	}
	local shownByModalType

	if v2 then
		shownByModalType = getModalType(v2) -- inferred equivalent call
	else
		shownByModalType = ""
	end

	v4.shownByModalType = shownByModalType
	sendPromptModalSkippedEvent(v4)
end

local LogPromptModalSkipped = {}
LogPromptModalSkipped.Reason = reason
LogPromptModalSkipped.log = log

function LogPromptModalSkipped.logAll(reason2: string, entryPoint: string, items)
	for _, item in items do
		log(reason2, entryPoint, item)
	end
end

function LogPromptModalSkipped.markShown(p: string, p2)
	if v[p] == nil then
		v[p] = p2
	end
end

function LogPromptModalSkipped.resetForTests()
	v = {}
	set = {}
end

return LogPromptModalSkipped
