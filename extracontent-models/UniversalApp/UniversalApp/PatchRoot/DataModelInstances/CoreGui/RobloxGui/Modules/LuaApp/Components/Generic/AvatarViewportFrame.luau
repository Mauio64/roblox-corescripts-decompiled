local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local getCameraSettingsToFitModel = require(Modules.LuaApp.getCameraSettingsToFitModel)
local ViewportFrame = require(Modules.LuaApp.Components.Generic.ViewportFrame)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppContentProvider = require(CorePackages.Workspace.Packages.RoactServiceTags).AppContentProvider
local vector3 = Vector3.new(0, -300, 0)

local function getRobloxAnimationId(p1) -- line: 39
	return "http://www.roblox.com/asset/?id=" .. p1
end

local v13 = t.interface({
	modelRef = t.optional(t.strictInterface({
		value = t.instanceIsA("Model")
	})),
	animationIds = t.optional(t.array(t.string)),
	pauseAnimations = t.optional(t.boolean),
	cameraCFrameOffset = t.optional(t.CFrame),
	topOffsetScale = t.optional(t.number),
	bottomOffsetScale = t.optional(t.number),
	cameraUpdatedCallback = t.optional(t.callback),
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	contentProvider = t.any
})
local v14 = Roact.PureComponent:extend("AvatarViewportFrame")

v14.defaultProps = {
	topOffsetScale = 0.01,
	bottomOffsetScale = 0.01,
	cameraCFrameOffset = CFrame.new()
}

function v14.init(p2) -- line: 81
	-- upvalues: vector3 (ref)
	p2.state = {
		cameraDistance = nil,
		cameraFocusPoint = nil,
		cameraLookVector = nil,
		cameraUpVector = nil
	}
	p2.isMounted = false
	p2.animationTracks = nil
	p2.animationSpeeds = nil
	p2.modelCFrameOrientation = CFrame.new()

	local v18 = vector3

	vector3 += Vector3.new(30, 0, 0)
	p2.modelPosition = v18
	p2.gameModelFolder = nil
	p2.gameModel = nil
	p2.partsToCopy = {}
	p2.renderSteppedConnection = nil

	function p2.collectPartsRecursive(p3, p4) -- line: 106
		-- upvalues: p2 (copy)
		if p3 == nil or p4 == nil then
			return
		end

		local children = p3:GetChildren()
		local children2 = p4:GetChildren()

		for i = 1, #children do
			local v60 = children[i]
			local v61 = children2[i]

			if v60:IsA("BasePart") and v61:IsA("BasePart") then
				table.insert(p2.partsToCopy, {
					srcPart = v60,
					targetPart = v61
				})
				v60.Transparency = 1
			end

			p2.collectPartsRecursive(v60, v61)
		end
	end
end
function v14.updateCamera(p5) -- line: 133
	-- upvalues: getCameraSettingsToFitModel (copy)
	local modelRef = p5.props.modelRef
	local cameraCFrameOffset = p5.props.cameraCFrameOffset
	local topOffsetScale = p5.props.topOffsetScale
	local bottomOffsetScale = p5.props.bottomOffsetScale

	if modelRef ~= nil then
		local v24 = p5.gameModel or modelRef.value

		spawn(function() -- line: 143
			-- upvalues: p5 (copy), v24 (copy), cameraCFrameOffset (copy), getCameraSettingsToFitModel (copy), bottomOffsetScale (copy), topOffsetScale (copy)
			p5.props.contentProvider:PreloadAsync(p5.animationTracks or {})
			p5.props.contentProvider:PreloadAsync({ v24 })

			if (p5.gameModel or p5.props.modelRef.value) ~= v24 then
				return
			end

			local _, v63 = v24:GetBoundingBox()
			local v64 = CFrame.fromMatrix(Vector3.new(), -p5.modelCFrameOrientation.rightVector, p5.modelCFrameOrientation.UpVector) * cameraCFrameOffset
			local lookVector = v64.lookVector
			local upVector = v64.upVector
			local v67 = getCameraSettingsToFitModel({
				cameraFieldOfView = 70,
				model = v24,
				upVector = upVector,
				lookVector = lookVector,
				bottomOffset = bottomOffsetScale * v63.Y,
				topOffset = topOffsetScale * v63.Y
			})

			if p5.isMounted then
				p5:setState({
					cameraDistance = v67.distance,
					cameraFocusPoint = v67.focusPoint,
					cameraLookVector = lookVector,
					cameraUpVector = upVector
				})
			end

			if p5.props.cameraUpdatedCallback then
				p5.props.cameraUpdatedCallback()
			end
		end)
	end
end
function v14.updateAnimation(p6) -- line: 188
	-- upvalues: RunService (copy)
	if p6.animationTracks ~= nil then
		p6:RemoveAllAnimations()
	end

	if p6.gameModel ~= nil then
		p6.gameModel:Destroy()
		p6.gameModel = nil
	end

	local modelRef = p6.props.modelRef
	local animationIds = p6.props.animationIds

	if modelRef == nil or animationIds == nil or #animationIds == 0 then
		return
	end

	p6.gameModel = modelRef.value:Clone()

	if p6.gameModelFolder == nil then
		p6.gameModelFolder = Instance.new("Folder")
		p6.gameModelFolder.Name = "LuaApp-AvatarViewportFrameModel-" .. tostring(p6)
		p6.gameModelFolder.Parent = game.Workspace
	end

	p6.gameModel.Parent = p6.gameModelFolder
	p6.gameModel:SetPrimaryPartCFrame(CFrame.new(p6.modelPosition))
	modelRef.value:SetPrimaryPartCFrame(CFrame.new(p6.modelPosition))
	p6.partsToCopy = {}
	p6.collectPartsRecursive(p6.gameModel, modelRef.value)

	local gameModel = p6.gameModel

	p6.animationTracks = {}

	for _, v in ipairs(animationIds) do
		local Animation = Instance.new("Animation")

		Animation.AnimationId = "http://www.roblox.com/asset/?id=" .. v
		Animation.Parent = gameModel

		local track = gameModel.Humanoid:LoadAnimation(Animation)

		track:Play()
		table.insert(p6.animationTracks, track)
	end

	if p6.renderSteppedConnection == nil then
		p6.renderSteppedConnection = RunService.renderStepped:Connect(function() -- line: 246
			-- upvalues: p6 (copy)
			if p6.gameModel == nil or (p6.props.modelRef == nil or p6.props.pauseAnimations == true) then
				return
			end

			for _, v in ipairs(p6.partsToCopy) do
				v.targetPart.CFrame = v.srcPart.CFrame
			end
		end)
	end
end
function v14.PauseAnimations(p7) -- line: 258
	if p7.animationTracks ~= nil then
		p7.animationSpeeds = {}

		for i, v in ipairs(p7.animationTracks) do
			p7.animationSpeeds[i] = v.Speed
			v:AdjustSpeed(0)
		end
	end
end
function v14.UnPauseAnimations(p8) -- line: 268
	if p8.animationTracks ~= nil and p8.animationSpeeds ~= nil then
		for i, v in ipairs(p8.animationTracks) do
			v:AdjustSpeed(p8.animationSpeeds[i])
		end

		p8.animationSpeeds = nil
	end
end
function v14.RemoveAllAnimations(p9) -- line: 277
	if p9.animationTracks ~= nil then
		for _, v in ipairs(p9.animationTracks) do
			v:Stop()
		end

		p9.animationTracks = nil
		p9.animationSpeeds = nil
	end
end
function v14.updateModelPosition(p10) -- line: 292
	local modelRef = p10.props.modelRef

	if modelRef then
		modelRef.value:SetPrimaryPartCFrame(p10.modelCFrameOrientation + p10.modelPosition)
	end
end
function v14.didMount(p11) -- line: 300
	p11.isMounted = true
	p11:updateModelPosition()
	p11:updateAnimation()
	p11:updateCamera()
end
function v14.didUpdate(p12, p13) -- line: 308
	if p13.modelRef ~= p12.props.modelRef or p13.animationIds ~= p12.props.animationIds then
		p12:updateModelPosition()
		p12:updateAnimation()
		p12:updateCamera()
	end

	if p13.pauseAnimations ~= p12.props.pauseAnimations then
		if p12.props.pauseAnimations == true then
			p12:PauseAnimations()

			return
		end

		p12:UnPauseAnimations()
	end
end
function v14.render(p14) -- line: 324
	-- upvalues: v13 (copy), Cryo (copy), Roact (copy), ViewportFrame (copy)
	assert(v13(p14.props))

	local modelRef = p14.props.modelRef
	local cameraDistance = p14.state.cameraDistance
	local cameraFocusPoint = p14.state.cameraFocusPoint
	local cameraLookVector = p14.state.cameraLookVector
	local cameraUpVector = p14.state.cameraUpVector
	local v53 = Cryo.Dictionary.join(p14.props, {
		modelRef = Cryo.None,
		animationIds = Cryo.None,
		pauseAnimations = Cryo.None,
		cameraCFrameOffset = Cryo.None,
		topOffsetScale = Cryo.None,
		bottomOffsetScale = Cryo.None,
		cameraUpdatedCallback = Cryo.None,
		contentProvider = Cryo.None
	})

	return Roact.createElement(ViewportFrame, {
		regularProps = v53,
		modelRef = modelRef,
		cameraDistance = cameraDistance,
		cameraFocusPoint = cameraFocusPoint,
		cameraLookVector = cameraLookVector,
		cameraUpVector = cameraUpVector
	})
end
function v14.willUnmount(p15) -- line: 354
	p15.isMounted = false

	if p15.gameModel ~= nil then
		p15.gameModel:Destroy()
		p15.gameModel = nil
	end

	if p15.gameModelFolder ~= nil then
		p15.gameModelFolder:Destroy()
		p15.gameModelFolder = nil
	end

	if p15.renderSteppedConnection ~= nil then
		p15.renderSteppedConnection:Disconnect()
		p15.renderSteppedConnection = nil
	end
end

return (RoactServices.connect({
	contentProvider = AppContentProvider
})(v14))
