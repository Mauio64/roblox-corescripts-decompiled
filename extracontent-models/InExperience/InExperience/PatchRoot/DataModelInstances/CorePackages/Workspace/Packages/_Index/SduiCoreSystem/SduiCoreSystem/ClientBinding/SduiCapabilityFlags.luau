local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local SharedFlags = require(Parent.SharedFlags)

local function isPinShortcutServiceEnabled() -- line: 13
	return game:GetEngineFeature("PinShortcutServiceEnabled")
end
local function isPinShortcutAvailable() -- line: 17
	-- upvalues: SharedFlags (copy)
	if not SharedFlags.FFlagSduiPinShortcutAction then
		return false
	end

	if not game:GetEngineFeature("PinShortcutServiceEnabled") then
		return false
	end

	local PinShortcutService = nil

	pcall(function() -- line: 26
		-- upvalues: PinShortcutService (ref)
		PinShortcutService = game:GetService("PinShortcutService")
	end)

	if PinShortcutService == nil then
		return false
	end

	local ok, result = pcall(function() -- line: 32
		-- upvalues: PinShortcutService (ref)
		return PinShortcutService:IsAvailable()
	end)

	if not ok then
		return false
	end

	return result == true
end

return {
	CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton,
	CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION = SharedFlags.FFlagSduiCapabilityDevStoreSeeAllWebviewFallback,
	CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION = isPinShortcutAvailable()
}
