local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

local count = 0

local function getNextUidKey()
	count += 1
	return (tostring(count))
end

local function useUidRefString()
	local ref = React.useRef(nil)

	if ref.current == nil then
		count += 1
		ref.current = tostring(count)
	end

	return ref
end

return useUidRefString
