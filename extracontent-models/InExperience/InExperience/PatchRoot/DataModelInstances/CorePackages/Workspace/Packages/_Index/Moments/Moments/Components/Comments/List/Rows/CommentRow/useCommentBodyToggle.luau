local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local function useCommentBodyToggle(p, callback, current: string, flag: boolean, flag2: boolean)
	local containsPoint = p.containsPoint

	local ref = React.useRef(nil)

	local onTap = React.useCallback(function(vector2: Vector2, p2: number)
		ref.current = nil

		if callback == nil or not containsPoint(vector2) then
			return
		end

		local v = p2 < 2

		if flag2 and (not v or flag) then
			if v then
				ref.current = current
			end
		else
			callback(current)
		end
	end, { callback, containsPoint, current, flag, flag2 })

	local onSingleTapConfirmed = React.useCallback(function()
		local current2 = ref.current
		ref.current = nil

		if current2 ~= nil and callback ~= nil then
			callback(current2)
		end
	end, { callback })
	local isActive = callback ~= nil
	local isTruncatable = isActive and p.isTruncatable

	if not isTruncatable then
		onTap = nil
	end

	if not (isTruncatable and flag2) then
		onSingleTapConfirmed = nil
	end

	return {
		isActive = isActive,
		canToggle = isTruncatable,
		onTap = onTap,
		onSingleTapConfirmed = onSingleTapConfirmed
	}
end

return useCommentBodyToggle
