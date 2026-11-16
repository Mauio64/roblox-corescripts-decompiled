local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local function useCommentBodyToggle(p2, callback, current, p3, p4)
	local containsPoint = p2.containsPoint

	local ref = React.useRef(nil)

	local v5 = React.useCallback(function(p5, p6)
		ref.current = nil

		if callback == nil or not containsPoint(p5) then
			return
		end

		local v6 = p6 < 2

		if p4 and (not v6 or p3) then
			if v6 then
				ref.current = current
			end
		else
			callback(current)
		end
	end, { callback, containsPoint, current, p3, p4 })

	local v6 = React.useCallback(function()
		local current2 = ref.current
		ref.current = nil

		if current2 ~= nil and callback ~= nil then
			callback(current2)
		end
	end, { callback })
	local v7 = callback ~= nil
	local isTruncatable = v7 and p2.isTruncatable

	if not isTruncatable then
		v5 = nil
	end

	if not (isTruncatable and p4) then
		v6 = nil
	end

	return {
		isActive = v7,
		canToggle = isTruncatable,
		onTap = v5,
		onSingleTapConfirmed = v6
	}
end

return useCommentBodyToggle
