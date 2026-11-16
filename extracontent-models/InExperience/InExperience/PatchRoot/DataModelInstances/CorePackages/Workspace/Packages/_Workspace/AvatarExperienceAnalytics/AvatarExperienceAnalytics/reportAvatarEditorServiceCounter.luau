local Constants = require(script.Parent.Constants)
local sendAXCounterV2 = require(script.Parent.sendAXCounterV2)

local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS

local function reportAvatarEditorServiceCounter(p: string, status, p2)
	local v = { status = status }

	if status == AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error and p2 ~= nil then
		local v2

		if typeof(p2) == "EnumItem" then
			v2 = p2.Name
		else
			v2 = tostring(p2)
		end

		v.message = string.sub(v2, 1, 256)
	end

	sendAXCounterV2(p, v)
end

return reportAvatarEditorServiceCounter
