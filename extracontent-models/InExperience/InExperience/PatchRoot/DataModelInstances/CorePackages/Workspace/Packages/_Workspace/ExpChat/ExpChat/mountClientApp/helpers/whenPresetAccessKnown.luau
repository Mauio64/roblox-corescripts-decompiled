local ExpChat = script:FindFirstAncestor("ExpChat")
require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)
local Constants = require(ExpChat.PresetChat.Constants)
local whenFirstTrue = require(ExpChat.whenFirstTrue)

local v = {}

local function whenPresetAccessKnown(data, callback)
	local v2 = nil
	local v3 = false
	v2 = whenFirstTrue(function(p): boolean
		return not data.getIsLoading(p)
	end, function()
		v3 = true

		if v2 then
			v[v2] = nil
		end

		local v4 = data.getIsEnabled(false) and data.getAccessLevel(false) == Constants.AccessLevel.Enabled

		task.spawn(callback, v4)
	end)

	if not v3 and v2 then
		v[v2] = true
	end
end

return whenPresetAccessKnown
