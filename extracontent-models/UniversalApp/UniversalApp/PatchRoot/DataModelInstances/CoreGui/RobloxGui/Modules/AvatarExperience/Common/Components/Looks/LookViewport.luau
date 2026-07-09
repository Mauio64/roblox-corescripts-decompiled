local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local CameraPresetsUtility = require(CorePackages.Packages.Thumbnailing).CameraPresetsUtility

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local LookViewportUtils = require(script.Parent.LookViewportUtils)

require(Modules.AvatarExperience.Common.Types)

local GetFFlagAXLookViewportCameraAlignment = require(Modules.AvatarExperience.Flags.GetFFlagAXLookViewportCameraAlignment)
local GetFFlagAXLookViewportUseFallbackEmote = require(Modules.AvatarExperience.Flags.GetFFlagAXLookViewportUseFallbackEmote)
local v11 = game:DefineFastInt("AXLookViewportCameraFOV", 56)
local v12 = game:DefineFastString("AXLookViewportFallbackEmoteId", "136596589997464")
local GetFFlagAXAnimatedLooksThumbnails = require(Modules.AvatarExperience.Flags.GetFFlagAXAnimatedLooksThumbnails)

local function LookViewport(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), usePrevious (copy), HttpService (copy), LookViewportUtils (copy), GetFFlagAXLookViewportCameraAlignment (copy), GetFFlagAXLookViewportUseFallbackEmote (copy), v12 (copy), CameraPresetsUtility (copy), v11 (copy), GetFFlagAXAnimatedLooksThumbnails (copy)
	local v16 = React.useRef(nil)
	local v17 = React.useRef(nil)
	local v18 = React.useRef(nil)
	local v19 = React.useRef("")
	local v20, v21 = React.useBinding(CFrame.new())
	local v22 = usePrevious(t1.lookDetails)

	React.useEffect(function() -- line: 37
		-- upvalues: v18 (copy), v17 (copy)
		if v18.current then
			v18.current.CurrentCamera = v17.current
		end
	end, {
		v18,
		v17
	})

	local v23 = React.useCallback(function(p1) -- line: 45
		-- upvalues: v16 (copy), HttpService (copy), v19 (copy), LookViewportUtils (copy), GetFFlagAXLookViewportCameraAlignment (copy), GetFFlagAXLookViewportUseFallbackEmote (copy), v12 (copy), CameraPresetsUtility (copy), v11 (copy), v21 (copy), GetFFlagAXAnimatedLooksThumbnails (copy), t1 (copy)
		if v16.current then
			v16.current:ClearAllChildren()
		end

		if not p1 then
			return
		end

		local guid = HttpService:GenerateGUID(false)

		v19.current = guid

		local v26 = LookViewportUtils.createAvatarModel(p1)

		if GetFFlagAXLookViewportCameraAlignment() then
			local u27 = p1.displayProperties and p1.displayProperties.emoteAssetId
			local v28 = false

			if GetFFlagAXLookViewportUseFallbackEmote() and not u27 then
				v28 = true
				u27 = v12
			end

			local v29 = CameraPresetsUtility.GetCameraCFrame_ForAvatarR15Action_LookAtGoldenRatioOfTheHumanoid(v26, function() -- line: 70
				-- upvalues: u27 (ref), LookViewportUtils (copy), v26 (copy)
				if u27 then
					LookViewportUtils.applyPose(u27, v26)
				end
			end, v28, v11)

			v21(v29)
		end

		if guid ~= v19.current then
			v26:Destroy()

			return
		end

		v26.Parent = v16.current

		if not GetFFlagAXLookViewportCameraAlignment() then
			v26:PivotTo(CFrame.new(0, 0, 0))

			local Pivot = v26:GetPivot()

			v21(CFrame.new(Pivot.Position + Pivot.LookVector * 6, Pivot.Position) - Vector3.new(0, 0.75, 0))
		end

		if GetFFlagAXAnimatedLooksThumbnails() and t1.avatarModelRef then
			t1.avatarModelRef.current = v26
		end
	end, { v16 })

	React.useEffect(function() -- line: 105
		-- upvalues: LookViewportUtils (copy), v22 (copy), t1 (copy), v23 (copy)
		if LookViewportUtils.areLooksDifferent(v22, t1.lookDetails) then
			task.spawn(function() -- line: 107
				-- upvalues: v23 (copy), t1 (copy)
				v23(t1.lookDetails)
			end)
		end
	end, {
		t1.lookDetails,
		v22,
		v23
	})

	return React.createElement("ViewportFrame", {
		BackgroundTransparency = 1,
		LightDirection = Vector3.new(-1, -1, 2),
		Size = UDim2.fromScale(1, 1),
		LightColor = Color3.fromRGB(218, 203, 173),
		ref = v18
	}, {
		WorldModel = React.createElement("WorldModel", {
			ref = v16
		}),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v20,
			ref = v17
		})
	})
end

return LookViewport
