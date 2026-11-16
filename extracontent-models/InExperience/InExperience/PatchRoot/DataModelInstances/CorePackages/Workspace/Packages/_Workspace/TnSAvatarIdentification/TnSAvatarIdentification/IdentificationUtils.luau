local TnSAvatarIdentification = script:FindFirstAncestor("TnSAvatarIdentification")

local GetFFlagReportAnythingFixConvexHullCalculation = require(TnSAvatarIdentification.Flags.GetFFlagReportAnythingFixConvexHullCalculation)

local CoreGui = game:GetService("CoreGui")

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1e999, 1e999)

function worldToFullViewportPointNormalized(vector3: Vector3, object, data)
	local worldToViewportPoint, _ = object:WorldToViewportPoint(vector3)
	local vector2_3 = Vector2.new(
		(worldToViewportPoint.X + data.insets.left) / data.width,
		(worldToViewportPoint.Y + data.insets.top) / data.height
	)
	return
		vector2_3,
		worldToViewportPoint.Z,
		not (vector2_3.Y < 0 or vector2_3.Y > 1 or vector2_3.X < 0 or vector2_3.X > 1) and worldToViewportPoint.Z > 0
end

function getViewportCorners(list, p, p2)
	local v = vector2_2
	local v2 = vector2
	local count = 0

	for _, item in ipairs(list) do
		assert(p2, "getViewportCorners requires viewportInfo")
		local v3, _, v4 = worldToFullViewportPointNormalized(item, p, p2)

		if not v4 then
			v3 = Vector2.new(math.clamp(v3.X, 0, 1), (math.clamp(v3.Y, 0, 1)))
		end

		if GetFFlagReportAnythingFixConvexHullCalculation() then
			if v4 then
				count += 1
			end
		else
			count += 1
		end

		v = v:Min(v3)
		v2 = v2:Max(v3)
	end

	if count <= 2 then
		return vector2_2, vector2
	end

	return v, v2
end

function shouldIgnoreLocalCharacter(instance): boolean
	local head = instance:FindFirstChild("Head")

	if head and head:IsA("BasePart") then
		return head.LocalTransparencyModifier >= 0.95
	end

	return false
end

function getLocalCharacterPosition(instance)
	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	return if humanoidRootPart then humanoidRootPart.Position else nil
end

return {
	getViewportInfo = function()
		assert(CoreGui, "getViewportInfo requires CoreGui to be available")

		local fullscreenTestGui_AvatarID = CoreGui:FindFirstChild("_FullscreenTestGui_AvatarID")

		if not fullscreenTestGui_AvatarID then
			fullscreenTestGui_AvatarID = Instance.new("ScreenGui")
			fullscreenTestGui_AvatarID.Name = "_FullscreenTestGui_AvatarID"
			fullscreenTestGui_AvatarID.Parent = CoreGui
			fullscreenTestGui_AvatarID.ScreenInsets = Enum.ScreenInsets.None
		end

		local deviceTestGui_AvatarID = CoreGui:FindFirstChild("_DeviceTestGui_AvatarID")

		if not deviceTestGui_AvatarID then
			deviceTestGui_AvatarID = Instance.new("ScreenGui")
			deviceTestGui_AvatarID.Name = "_DeviceTestGui_AvatarID"
			deviceTestGui_AvatarID.Parent = CoreGui
			deviceTestGui_AvatarID.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		end

		local v = deviceTestGui_AvatarID.AbsolutePosition - fullscreenTestGui_AvatarID.AbsolutePosition
		local v2 = fullscreenTestGui_AvatarID.AbsolutePosition + fullscreenTestGui_AvatarID.AbsoluteSize - (deviceTestGui_AvatarID.AbsolutePosition + deviceTestGui_AvatarID.AbsoluteSize)
		local insets = { left = v.X, top = v.Y, right = v2.X, bottom = v2.Y }

		return {
			width = fullscreenTestGui_AvatarID.AbsoluteSize.X,
			height = fullscreenTestGui_AvatarID.AbsoluteSize.Y,
			insets = insets
		}
	end,
	getViewportCorners = getViewportCorners,
	worldToFullViewportPointNormalized = worldToFullViewportPointNormalized,
	shouldIgnoreLocalCharacter = shouldIgnoreLocalCharacter,
	getLocalCharacterPosition = getLocalCharacterPosition,
	defaultMin = vector2_2
}
