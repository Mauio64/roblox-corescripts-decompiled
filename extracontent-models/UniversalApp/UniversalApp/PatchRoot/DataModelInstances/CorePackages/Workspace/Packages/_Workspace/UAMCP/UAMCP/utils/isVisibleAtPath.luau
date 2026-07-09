local resolveInstance = require(script.Parent.resolveInstance)

local function isVisibleAtPath(s1: string) -- line: 3
	-- upvalues: resolveInstance (copy)
	local v4 = resolveInstance(s1)

	if not v4 or not v4:IsA("GuiObject") then
		return false
	end

	return v4.Visible
end

return isVisibleAtPath
