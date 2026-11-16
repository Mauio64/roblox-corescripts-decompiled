local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
require(script.Parent.Types)

local union = t.union(t.literal("Enabled"), t.literal("ReadOnly"), t.literal("Disabled"))

local v = t.interface({
	categories = t.array(t.interface({
		[EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint and "contents" or "messages"] = t.array(t.interface({
			[EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint and "text" or "value"] = t.string,
			presetId = t.string
		}))
	}))
})

local function normalizePresetCatalog(data)
	if type(data) ~= "table" then
		return nil
	end

	local accessLevel

	if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		accessLevel = data.status
	else
		accessLevel = data.accessLevel
	end

	if not union(accessLevel) then
		return nil
	end

	local version = data.version

	if
		not EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
		and accessLevel ~= "Disabled"
		and (type(version) ~= "string" or version == "")
	then
		return nil
	end

	local categoryGroups = {}

	if type(data.categoryGroups) == "table" then
		for _, categoryGroup in data.categoryGroups do
			if v(categoryGroup) then
				table.insert(categoryGroups, categoryGroup)
			end
		end
	end

	return {
		accessLevel = accessLevel,
		categoryGroups = categoryGroups,
		version = type(version) ~= "string" and "" or version
	}
end

return normalizePresetCatalog
