local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function normalizeAvatars(t1: {[any]: any}?) -- line: 26
	if typeof(t1) ~= "table" then
		return nil
	end

	local t2 = {}

	for _, v9 in t1 do
		if typeof(v9) == "table" then
			local num = tonumber(v9.userId)

			if num then
				table.insert(t2, {
					userId = num,
					userPresence = v9.userPresence
				})
			end
		else
			local num = tonumber(v9)

			if num then
				table.insert(t2, {
					userId = num
				})
			end
		end
	end

	return t2
end
local function SduiAvatarGroup(t3: {[any]: any}) -- line: 52
	-- upvalues: normalizeAvatars (copy), React (copy), Foundation (copy)
	local v13 = normalizeAvatars(t3.avatars)

	if not v13 then
		return nil
	end

	return React.createElement(Foundation.AvatarGroup, {
		LayoutOrder = t3.layoutOrder,
		Visible = t3.visible,
		ZIndex = t3.zIndex,
		avatars = v13,
		backplateStyle = t3.backplateStyle,
		max = t3.max,
		size = t3.size,
		testId = t3.testId,
		type = t3.type
	})
end

return React.memo(SduiAvatarGroup)
