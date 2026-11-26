local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local sendPromptModalSkippedEvent = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/sendPromptModalSkippedEvent")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/Types/PromptEntry")

local fFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle

local v5 = {
	AlreadyShown = "alreadyShown",
	NotFocused = "notFocused",
	IncompleteEntry = "incompleteEntry",
	LegacyMetadata = "legacyMetadata"
}

local v6 = {}
local set = {}

local function getModalType(p2)
	return (if fFlagPromptsImpressionUsesTitle then p2.title else p2.robloxComponentType) or ""
end

local function log(p2, p3, item)
	local identifier = item.identifier or ""
	local v8 = (if fFlagPromptsImpressionUsesTitle then item.title else item.robloxComponentType) or ""

	local v9 = v6[p3]

	if
		p2 == v5.AlreadyShown
		and v9 ~= nil
		and item.identifier ~= nil
		and v9.identifier == item.identifier
	then
		return
	end

	local v10 = p3 .. "|" .. identifier .. "|" .. v8 .. "|" .. p2

	if set[v10] then
		return
	end

	set[v10] = true

	local v12 = {
		reason = p2,
		modalId = identifier,
		modalType = v8,
		entryPoint = p3,
		shownByModalId = v9 and v9.identifier or "",
		shownByModalType = 0
	}
	local v13 = if v9 then (if fFlagPromptsImpressionUsesTitle then v9.title else v9.robloxComponentType) or "" else ""

	v12.shownByModalType = v13
	sendPromptModalSkippedEvent(v12)
end

return {
	Reason = v5,
	log = log,
	logAll = function(p2, p3, items)
		for k, item in items do
			log(p2, p3, item)
		end
	end,
	markShown = function(p2, p3)
		if v6[p2] == nil then
			v6[p2] = p3
		end
	end,
	resetForTests = function()
		v6 = {}
		set = {}
	end
}
