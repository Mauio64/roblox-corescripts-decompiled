require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FloatingWindow")

local function safeAreaInsets(data, p2)
	return {
		bottom = math.max(data.bottom, p2),
		left = math.max(data.left, p2),
		right = math.max(data.right, p2),
		top = math.max(data.top, p2)
	}
end

local function resolveExpanded(data)
	local deviceInsets = data.deviceInsets

	if data.isPortrait then
		if data.exposesTopSafeArea then
			return {
				boundsInsets = {
					bottom = 0,
					left = 0,
					right = 0,
					top = deviceInsets.top
				},
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
	else
		local margin = data.margin
		return {
			boundsInsets = {
				bottom = math.max(deviceInsets.bottom, margin),
				left = math.max(deviceInsets.left, margin),
				right = math.max(deviceInsets.right, margin),
				top = math.max(deviceInsets.top, margin)
			},
			hasRoundedCorners = true,
			size = UDim2.new(0, 416, 1, 0),
			topPadding = 0
		}
	end
end

local function resolveGeometry(p2)
	local deviceInsets = p2.deviceInsets
	local margin = p2.margin
	return {
		collapsed = {
			boundsInsets = {
				bottom = math.max(deviceInsets.bottom, margin),
				left = math.max(deviceInsets.left, margin),
				right = math.max(deviceInsets.right, margin),
				top = math.max(deviceInsets.top, margin)
			}
		},
		expanded = resolveExpanded(p2)
	}
end

return resolveGeometry
