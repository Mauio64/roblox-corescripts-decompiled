local TnSAvatarIdentification = script:FindFirstAncestor("TnSAvatarIdentification")
local TnSAvatarIdentificationParent = TnSAvatarIdentification.Parent
local GetFFlagReportAnythingFixConvexHullCalculation = require(TnSAvatarIdentification.Flags.GetFFlagReportAnythingFixConvexHullCalculation)
local GetFFlagAvatarIdentificationSafeAreaFix = require(TnSAvatarIdentificationParent.SharedFlags).GetFFlagAvatarIdentificationSafeAreaFix
local CoreGui = nil

if GetFFlagAvatarIdentificationSafeAreaFix() then
	CoreGui = game:GetService("CoreGui")
end

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1e999, 1e999)

function worldToFullViewportPointNormalized(vector3: Vector3, p1, t1: {[any]: any}) -- line: 63
	local v17, _ = p1:WorldToViewportPoint(vector3)
	local vector2_3 = Vector2.new((v17.X + t1.insets.left) / t1.width, (v17.Y + t1.insets.top) / t1.height)

	return vector2_3, v17.Z, not (vector2_3.Y < 0 or (vector2_3.Y > 1 or (vector2_3.X < 0 or vector2_3.X > 1))) and v17.Z > 0
end
function getViewportCorners(t2: {[any]: any}, p2, t3: {[any]: any}?) -- line: 80
	-- upvalues: vector2_2 (copy), vector2 (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), GetFFlagReportAnythingFixConvexHullCalculation (copy)
	local v23 = vector2_2
	local v24 = vector2
	local ViewportSize = p2.ViewportSize
	local n1 = 0

	for _, v in ipairs(t2) do
		local v29, v31

		if GetFFlagAvatarIdentificationSafeAreaFix() then
			assert(t3, "getViewportCorners requires viewportInfo when FFlagAvatarIdentificationSafeAreaFix is enabled")

			local v30

			v29, v30, v31 = worldToFullViewportPointNormalized(v, p2, t3)
		else
			local v32

			v32, v31 = p2:WorldToViewportPoint(v)
			v29 = Vector2.new(v32.X / ViewportSize.X, v32.Y / ViewportSize.Y)
		end

		if not v31 then
			v29 = Vector2.new(math.clamp(v29.X, 0, 1), (math.clamp(v29.Y, 0, 1)))
		end

		if GetFFlagReportAnythingFixConvexHullCalculation() then
			if v31 then
				n1 += 1
			end
		else
			n1 += 1
		end

		v23 = v23:Min(v29)
		v24 = v24:Max(v29)
	end

	if n1 <= 2 then
		return vector2_2, vector2
	end

	return v23, v24
end
function shouldIgnoreLocalCharacter(p3) -- line: 125
	local Head = p3:FindFirstChild("Head")

	if Head and Head:IsA("BasePart") then
		return Head.LocalTransparencyModifier >= 0.95
	end

	return false
end
function getLocalCharacterPosition(p4) -- line: 134
	local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	return HumanoidRootPart.Position
end

return {
	getViewportInfo = function() -- line: 24
		-- upvalues: CoreGui (ref)
		assert(CoreGui, "getViewportInfo requires CoreGui to be available")

		local _FullscreenTestGui_AvatarID = CoreGui:FindFirstChild("_FullscreenTestGui_AvatarID")

		if not _FullscreenTestGui_AvatarID then
			_FullscreenTestGui_AvatarID = Instance.new("ScreenGui")
			_FullscreenTestGui_AvatarID.Name = "_FullscreenTestGui_AvatarID"
			_FullscreenTestGui_AvatarID.Parent = CoreGui
			_FullscreenTestGui_AvatarID.ScreenInsets = Enum.ScreenInsets.None
		end

		local _DeviceTestGui_AvatarID = CoreGui:FindFirstChild("_DeviceTestGui_AvatarID")

		if not _DeviceTestGui_AvatarID then
			_DeviceTestGui_AvatarID = Instance.new("ScreenGui")
			_DeviceTestGui_AvatarID.Name = "_DeviceTestGui_AvatarID"
			_DeviceTestGui_AvatarID.Parent = CoreGui
			_DeviceTestGui_AvatarID.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		end

		local v10 = _DeviceTestGui_AvatarID.AbsolutePosition - _FullscreenTestGui_AvatarID.AbsolutePosition
		local v11 = _FullscreenTestGui_AvatarID.AbsolutePosition + _FullscreenTestGui_AvatarID.AbsoluteSize - (_DeviceTestGui_AvatarID.AbsolutePosition + _DeviceTestGui_AvatarID.AbsoluteSize)
		local t4 = {
			left = v10.X,
			top = v10.Y,
			right = v11.X,
			bottom = v11.Y
		}

		return {
			width = _FullscreenTestGui_AvatarID.AbsoluteSize.X,
			height = _FullscreenTestGui_AvatarID.AbsoluteSize.Y,
			insets = t4
		}
	end,
	getViewportCorners = getViewportCorners,
	worldToFullViewportPointNormalized = worldToFullViewportPointNormalized,
	shouldIgnoreLocalCharacter = shouldIgnoreLocalCharacter,
	getLocalCharacterPosition = getLocalCharacterPosition,
	defaultMin = vector2_2
}
