local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local UpdateChatSettings = require(script.Parent.Parent.Actions.UpdateChatSettings)
local ChatSettings = require(script.Parent.Parent.ChatSettings)
local function deepCopy(ChatSettings2)
	if type(ChatSettings2) ~= "table" then
		return ChatSettings2
	end

	local result = {}

	for k, item in pairs(ChatSettings2) do
		result[k] = deepCopy(item)
	end

	return result
end

local function mergeInto(p, items)
	for k, item in pairs(items) do
		if type(item) == "table" then
			if p[k] then
				mergeInto(p[k], item)
			end
		else
			p[k] = item
		end
	end
end

return (Rodux.createReducer(ChatSettings, {
	[UpdateChatSettings.name] = function(_, p)
		local v = deepCopy(ChatSettings)
		mergeInto(v, p.settings)

		local userSpecificSettings = p.settings.UserSpecificSettings

		if not userSpecificSettings then
			return v
		end

		for k, userSpecificSetting in pairs(userSpecificSettings) do
			local v2 = deepCopy(ChatSettings)
			v2.UserSpecificSettings = nil
			mergeInto(v2, userSpecificSetting)
			v.UserSpecificSettings[k] = v2
		end

		return v
	end
}))
