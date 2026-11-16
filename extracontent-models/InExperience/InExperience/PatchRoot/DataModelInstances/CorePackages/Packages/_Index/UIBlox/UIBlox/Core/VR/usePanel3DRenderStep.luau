local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local React = require(parent2.React)

local Constants = require(parent.Constants)

local function GetUserCFrameWorldSpace(head, vrService)
	local userCFrame = vrService:GetUserCFrame(head)
	local currentCamera = workspace.CurrentCamera

	if not currentCamera.HeadLocked then
		userCFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head):Inverse() * userCFrame
	end

	return currentCamera.CFrame * (CFrame.new(userCFrame.p * currentCamera.HeadScale) * (userCFrame - userCFrame.p))
end

local function usePanel3DRenderStep(data, p)
	if data.anchoring == Constants.AnchoringTypes.PanelManaged and data.connectPanelManagerFunction then
		return
	end

	local ref = React.useRef(data.offset)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)

	local vrService = data.vrService

	React.useEffect(function()
		ref.current = data.offset
	end, {})

	local v = React.useCallback(function(p2)
		local currentCamera = workspace.CurrentCamera

		local cframe = currentCamera.CFrame
		local headScale = currentCamera.HeadScale
		local userCFrame = nil
		local cframe2, finalPosition

		if data.anchoring == Constants.AnchoringTypes.Head then
			cframe2 = vrService:GetUserCFrame(Enum.UserCFrame.Head)

			local current = GetUserCFrameWorldSpace(Enum.UserCFrame.Head, vrService)

			if ref2.current == nil then
				ref2.current = current
			end

			assert(ref2.current ~= nil, "lastLookCFrame should not be nil.")

			if ref2.current.LookVector:Dot(current.LookVector) < 0.85 then
				ref3.current = true
			elseif ref2.current.LookVector:Dot(current.LookVector) > 0.99 then
				ref3.current = false
			end

			if ref3.current then
				ref2.current = ref2.current:Lerp(current, 7.2 * p2)
			end

			local v = current.Position + ref2.current.LookVector * headScale * 2
			finalPosition = Vector3.new(v.X, current.Position.Y, v.Z)

			local alignedPanel = data.alignedPanel

			if alignedPanel then
				local part = alignedPanel:GetPart()

				if
					part
					and alignedPanel:IsPositionLockedType()
					and (alignedPanel:IsVisible() or alignedPanel.alwaysUpdatePosition)
				then
					finalPosition = Vector3.new(part.Position.X, current.Position.Y - 0.4 * headScale, part.Position.Z)
				end
			end
		else
			if data.anchoring ~= Constants.AnchoringTypes.Wrist then
				return
			end

			if
				vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
				and vrService.GuiInputUserCFrame == Enum.UserCFrame.LeftHand
			then
				userCFrame = vrService:GetUserCFrame(Enum.UserCFrame.RightHand)
			elseif vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
				userCFrame = vrService:GetUserCFrame(Enum.UserCFrame.LeftHand)
			end

			cframe2 = userCFrame or vrService:GetUserCFrame(Enum.UserCFrame.Head)

			local v = cframe2.Position * headScale
			finalPosition = (cframe * CFrame.new(v)).Position
		end

		if data.offsetCallback then
			finalPosition = data.offsetCallback({
				finalPosition = finalPosition,
				cameraHeadScale = headScale
			})
		end

		if data.lerp and ref.current ~= nil then
			ref.current = ref.current:Lerp(data.offset, 7.2 * p2)
		else
			ref.current = data.offset
		end

		local v

		if ref.current ~= nil then
			if data.faceCamera then
				local userCFrameWorldSpace = GetUserCFrameWorldSpace(Enum.UserCFrame.Head, vrService)

				v = CFrame.new(finalPosition + ref.current.Position * headScale, userCFrameWorldSpace.Position)
			else
				local orientation, v2, v3 = cframe2:ToOrientation()
				local cframe3 = CFrame.new(ref.current.Position * headScale)
				v = CFrame.new(finalPosition) * CFrame.Angles(-orientation, v2, -v3) * cframe3
			end
		end

		if data.tiltCallback then
			v = data.tiltCallback({ panelCFrame = v, cameraHeadScale = headScale })
		end

		if p.current ~= nil then
			p.current.CFrame = v

			p.current.Size = Vector3.new(data.partSize.X * headScale, data.partSize.Y * headScale, 0.05)
		end
	end, {
		data.anchoring,
		data.faceCamera,
		data.lerp,
		data.offset,
		data.partSize,
		data.alignedPanel,
		data.offsetCallback,
		data.tiltCallback
	})

	React.useEffect(function()
		if data.anchoring == Constants.AnchoringTypes.World then
			return function() end
		end

		local cFrameChangedConnection = nil
		local cFrameChangedConnection2 = nil

		local function onCurrentCameraChanged()
			if cFrameChangedConnection then
				cFrameChangedConnection:Disconnect()
			end

			if workspace.CurrentCamera then
				cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
					v(0)
				end)
			end
		end

		local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
		onCurrentCameraChanged()

		if data.alignedPanel then
			local part = data.alignedPanel:GetPart()

			if part then
				cFrameChangedConnection2 = part:GetPropertyChangedSignal("CFrame"):Connect(function()
					v(0)
				end)
			end
		end

		local movementUpdateEventConnection = data.movementUpdateEvent:Connect(v)

		return function()
			movementUpdateEventConnection:Disconnect()
			currentCameraChangedConnection:Disconnect()

			if cFrameChangedConnection then
				cFrameChangedConnection:Disconnect()
			end

			if cFrameChangedConnection2 then
				cFrameChangedConnection2:Disconnect()
			end
		end
	end, { data.anchoring, v })
end

return usePanel3DRenderStep
