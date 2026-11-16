local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
require(script.Parent.Types)
require(script.Parent.Parent.UniversalMessage.Types)

local function presetMessageToContent(data) -- 1 equivalent call inferred from this helper
	if data.presetId == "" then
		return nil
	end

	local v = { kind = "preset", presetId = data.presetId, text = 0, presetVersion = 0 }
	local text

	if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		text = data.text
	else
		text = data.value
	end

	v.text = text
	v.presetVersion = data.presetVersion

	return v
end

return {
	presetMessageToContent = presetMessageToContent,
	presetMessageToExpressionItem = function(data)
		local content = presetMessageToContent(data) -- inferred equivalent call

		if content == nil then
			return nil
		end

		return { content = content }
	end
}
