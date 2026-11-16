local parent = script:FindFirstAncestor("FriendsCalling").Parent

require(parent.FloatingWindow)

local function safeAreaInsets(deviceInsets, margin: number) -- 2 equivalent calls inferred from this helper
	return {
		bottom = math.max(deviceInsets.bottom, margin),
		left = math.max(deviceInsets.left, margin),
		right = math.max(deviceInsets.right, margin),
		top = math.max(deviceInsets.top, margin)
	}
end

local function resolveExpanded(data)
	local deviceInsets = data.deviceInsets

	if data.isPortrait then
		if data.exposesTopSafeArea then
			return {
				boundsInsets = { bottom = 0, left = 0, right = 0, top = deviceInsets.top },
				hasRoundedCorners = true,
				size = UDim2.fromScale(1, 1),
				topPadding = 0
			}
		end

		return {
			boundsInsets = { bottom = 0, left = 0, right = 0, top = 0 },
			hasRoundedCorners = false,
			size = UDim2.fromScale(1, 1),
			topPadding = deviceInsets.top
		}
	end

	return {
		boundsInsets = safeAreaInsets(deviceInsets, data.margin), -- inferred equivalent call
		hasRoundedCorners = true,
		size = UDim2.new(0, 416, 1, 0),
		topPadding = 0
	}
end

local function resolveGeometry(p)
	return {
		collapsed = {
			boundsInsets = safeAreaInsets(p.deviceInsets, p.margin) -- inferred equivalent call
		},
		expanded = resolveExpanded(p)
	}
end

return resolveGeometry
