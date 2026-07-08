local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local EmoteUtility = require(CorePackages.Packages.Thumbnailing).EmoteUtility
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local EmoteThumbnailParameters = require(script.Parent.EmoteThumbnailParameters)
local v8 = Roact.PureComponent:extend("EmoteThumbnailView")

v8.validateProps = t.strictInterface({
	animationClip = t.instanceIsA("AnimationClip"),
	thumbnailParameters = EmoteThumbnailParameters.validate,
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	size = t.optional(t.UDim2)
})

function v8.updateCameraAndCharacterPose(p1) -- line: 32
	-- upvalues: EmoteUtility (copy), RunService (copy)
	if p1.character == nil then
		return
	end

	local props = p1.props
	local character = p1.character
	local animationClip = props.animationClip
	local thumbnailParameters = props.thumbnailParameters
	local thumbnailTime = thumbnailParameters.thumbnailTime
	local thumbnailKeyframe = thumbnailParameters.thumbnailKeyframe
	local thumbnailCharacterRotation = thumbnailParameters.thumbnailCharacterRotation
	local v17 = nil

	if animationClip:IsA("CurveAnimation") then
		v17 = EmoteUtility.GetThumbnailKeyframeFromCurve(thumbnailTime, animationClip, thumbnailCharacterRotation)
	elseif animationClip:IsA("KeyframeSequence") then
		v17 = EmoteUtility.GetThumbnailKeyframe(thumbnailKeyframe, animationClip, thumbnailCharacterRotation)
	else
		error("Unsupported Animation data:", animationClip.ClassName)
	end

	EmoteUtility.SetPlayerCharacterNeutralPose(character)
	EmoteUtility.ApplyKeyframe(character, v17)
	task.spawn(function() -- line: 64
		-- upvalues: RunService (copy), character (copy), EmoteUtility (copy), thumbnailParameters (copy), p1 (copy)
		RunService.PreAnimation:Wait()
		RunService.PostSimulation:Wait()

		local Folder = Instance.new("Folder")

		Folder.Parent = character
		Folder:Destroy()

		local ModelCFrame = character:GetModelCFrame()
		local v30 = EmoteUtility.ThumbnailZoomExtents(character, 20, thumbnailParameters.thumbnailHorizontalOffset, thumbnailParameters.thumbnailVerticalOffset, thumbnailParameters.thumbnailZoom)

		p1.updateCameraCFrameBinding(v30)
		p1.updateCameraFocusBinding(ModelCFrame)
	end)
end
function v8.addCharacterToViewportIfNeeded(p2) -- line: 90
	if p2.character ~= nil and p2.character.Parent ~= nil then
		return
	end

	if p2.worldModelRef:getValue() and p2.character ~= nil then
		p2.character.Parent = p2.worldModelRef:getValue()
		p2:updateCameraAndCharacterPose()
	end
end
function v8.init(p3) -- line: 101
	-- upvalues: Roact (copy), Players (copy)
	p3.cameraRef = Roact.createRef()
	p3.worldModelRef = Roact.createRef()

	local v20, v21 = Roact.createBinding(CFrame.new())

	p3.cameraCFrameBinding = v20
	p3.updateCameraCFrameBinding = v21

	local v22, v23 = Roact.createBinding(CFrame.new())

	p3.cameraFocusBinding = v22
	p3.updateCameraFocusBinding = v23
	task.spawn(function() -- line: 108
		-- upvalues: Players (copy), p3 (copy)
		local ok, result = pcall(function() -- line: 110
			-- upvalues: Players (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return (Players:GetHumanoidDescriptionFromOutfitIdAsync(1342485078))
			end

			return (Players:GetHumanoidDescriptionFromOutfitId(1342485078))
		end)

		if not ok then
			result = Instance.new("HumanoidDescription")
		end

		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p3.character = Players:CreateHumanoidModelFromDescriptionAsync(result, Enum.HumanoidRigType.R15)
		else
			p3.character = Players:CreateHumanoidModelFromDescription(result, Enum.HumanoidRigType.R15)
		end

		p3:addCharacterToViewportIfNeeded()
	end)
end
function v8.render(p4) -- line: 136
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		Position = p4.props.position or UDim2.fromScale(0, 0),
		AnchorPoint = p4.props.anchorPoint or Vector2.new(0, 0),
		Size = p4.props.size or UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ViewportFrame = Roact.createElement("ViewportFrame", {
			ImageTransparency = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = Color3.new(0, 0, 0),
			CurrentCamera = p4.cameraRef
		}, {
			Camera = Roact.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = 20,
				CFrame = p4.cameraCFrameBinding,
				Focus = p4.cameraFocusBinding,
				[Roact.Ref] = p4.cameraRef
			}),
			WorldModel = Roact.createElement("WorldModel", {
				[Roact.Ref] = p4.worldModelRef
			})
		})
	})
end
function v8.didMount(p5) -- line: 185
	p5:addCharacterToViewportIfNeeded()
end
function v8.didUpdate(p6, _) -- line: 189
	p6:updateCameraAndCharacterPose()
end

return v8
