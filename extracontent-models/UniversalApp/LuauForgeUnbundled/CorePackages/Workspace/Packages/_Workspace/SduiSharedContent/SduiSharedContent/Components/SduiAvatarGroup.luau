local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local function normalizeAvatars(avatars)
	if typeof(avatars) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in avatars do
		if typeof(item) == "table" then
			local userId = tonumber(item.userId)

			if userId then
				table.insert(result, {
					userId = userId,
					userPresence = item.userPresence
				})
			end
		else
			local v5 = tonumber(item)

			if v5 then
				table.insert(result, { userId = v5 })
			end
		end
	end

	return result
end

local function SduiAvatarGroup(props)
	local avatars = normalizeAvatars(props.avatars)

	if avatars then
		return React.createElement(Foundation.AvatarGroup, {
			LayoutOrder = props.layoutOrder,
			Visible = props.visible,
			ZIndex = props.zIndex,
			avatars = avatars,
			backplateStyle = props.backplateStyle,
			max = props.max,
			size = props.size,
			testId = props.testId,
			type = props.type
		})
	end

	return nil
end

return React.memo(SduiAvatarGroup)
