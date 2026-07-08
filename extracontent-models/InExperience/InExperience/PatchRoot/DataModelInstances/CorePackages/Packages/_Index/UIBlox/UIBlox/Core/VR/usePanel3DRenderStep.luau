local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Constants = require(scriptParent.Constants)

local function GetUserCFrameWorldSpace(p1, p2) -- line: 12
	local UserCFrame = p2:GetUserCFrame(p1)
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera.HeadLocked then
		UserCFrame = p2:GetUserCFrame(Enum.UserCFrame.Head):Inverse() * UserCFrame
	end

	return CurrentCamera.CFrame * (CFrame.new(UserCFrame.p * CurrentCamera.HeadScale) * (UserCFrame - UserCFrame.p))
end
local function usePanel3DRenderStep(p3, p4) -- line: 24
	-- upvalues: Constants (copy), React (copy), GetUserCFrameWorldSpace (copy)
	if p3.anchoring == Constants.AnchoringTypes.PanelManaged and p3.connectPanelManagerFunction then
		return
	end

	local v13 = React.useRef(p3.offset)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(false)
	local vrService = p3.vrService

	React.useEffect(function() -- line: 35
		-- upvalues: v13 (copy), p3 (copy)
		v13.current = p3.offset
	end, {})

	local v17 = React.useCallback(function(p5) -- line: 39
		-- upvalues: p3 (copy), Constants (copy), vrService (copy), GetUserCFrameWorldSpace (copy), v14 (copy), v15 (copy), v13 (copy), p4 (copy)
		local CurrentCamera = workspace.CurrentCamera
		local CurrentCameraCFrame = CurrentCamera.CFrame
		local HeadScale = CurrentCamera.HeadScale
		local UserCFrame = nil
		local vector3

		if p3.anchoring == Constants.AnchoringTypes.Head then
			UserCFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)

			local v23 = GetUserCFrameWorldSpace(Enum.UserCFrame.Head, vrService)

			if v14.current == nil then
				v14.current = v23
			end

			assert(v14.current ~= nil, "lastLookCFrame should not be nil.")

			if v14.current.LookVector:Dot(v23.LookVector) < 0.85 then
				v15.current = true
			elseif v14.current.LookVector:Dot(v23.LookVector) > 0.99 then
				v15.current = false
			end

			if v15.current then
				v14.current = v14.current:Lerp(v23, 7.2 * p5)
			end

			local v24 = v23.Position + v14.current.LookVector * HeadScale * 2

			vector3 = Vector3.new(v24.X, v23.Position.Y, v24.Z)

			local alignedPanel = p3.alignedPanel

			if alignedPanel then
				local Part = alignedPanel:GetPart()

				if Part and (alignedPanel:IsPositionLockedType() and (alignedPanel:IsVisible() or alignedPanel.alwaysUpdatePosition)) then
					vector3 = Vector3.new(Part.Position.X, v23.Position.Y - 0.4 * HeadScale, Part.Position.Z)
				end
			end
		else
			if p3.anchoring ~= Constants.AnchoringTypes.Wrist then
				return
			end

			if vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and vrService.GuiInputUserCFrame == Enum.UserCFrame.LeftHand then
				UserCFrame = vrService:GetUserCFrame(Enum.UserCFrame.RightHand)
			elseif vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
				UserCFrame = vrService:GetUserCFrame(Enum.UserCFrame.LeftHand)
			end

			if not UserCFrame then
				UserCFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
			end

			local v28 = UserCFrame.Position * HeadScale

			vector3 = (CurrentCameraCFrame * CFrame.new(v28)).Position
		end

		if p3.offsetCallback then
			vector3 = p3.offsetCallback({
				finalPosition = vector3,
				cameraHeadScale = HeadScale
			})
		end

		if p3.lerp and v13.current ~= nil then
			v13.current = v13.current:Lerp(p3.offset, 7.2 * p5)
		else
			v13.current = p3.offset
		end

		local cFrame = nil

		if v13.current ~= nil then
			if p3.faceCamera then
				local v30 = GetUserCFrameWorldSpace(Enum.UserCFrame.Head, vrService)

				cFrame = CFrame.new(vector3 + v13.current.Position * HeadScale, v30.Position)
			else
				local v31, v32, v33 = UserCFrame:ToOrientation()
				local cFrame2 = CFrame.new(v13.current.Position * HeadScale)

				cFrame = CFrame.new(vector3) * CFrame.Angles(-v31, v32, -v33) * cFrame2
			end
		end

		if p3.tiltCallback then
			cFrame = p3.tiltCallback({
				panelCFrame = cFrame,
				cameraHeadScale = HeadScale
			})
		end

		if p4.current ~= nil then
			p4.current.CFrame = cFrame
			p4.current.Size = Vector3.new(p3.partSize.X * HeadScale, p3.partSize.Y * HeadScale, 0.05)
		end
	end, {
		p3.anchoring,
		p3.faceCamera,
		p3.lerp,
		p3.offset,
		p3.partSize,
		p3.alignedPanel,
		p3.offsetCallback,
		p3.tiltCallback
	})

	React.useEffect(function() -- line: 161
		-- upvalues: p3 (copy), Constants (copy), v17 (copy)
		if p3.anchoring ~= Constants.AnchoringTypes.World then
			local connection = nil
			local connection2 = nil

			local function onCurrentCameraChanged() -- line: 166
				-- upvalues: connection (ref), v17 (copy)
				if connection then
					connection:Disconnect()
				end

				if workspace.CurrentCamera then
					connection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 173
						-- upvalues: v17 (copy)
						v17(0)
					end)
				end
			end

			local connection3 = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

			onCurrentCameraChanged()

			if p3.alignedPanel then
				local Part = p3.alignedPanel:GetPart()

				if Part then
					connection2 = Part:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 186
						-- upvalues: v17 (copy)
						v17(0)
					end)
				end
			end

			local connection4 = p3.movementUpdateEvent:Connect(v17)

			return function() -- line: 194
				-- upvalues: connection4 (copy), connection3 (ref), connection (ref), connection2 (ref)
				connection4:Disconnect()
				connection3:Disconnect()

				if connection then
					connection:Disconnect()
				end

				if connection2 then
					connection2:Disconnect()
				end
			end
		end

		return function() -- line: 205
		end
	end, {
		p3.anchoring,
		v17
	})
end

return usePanel3DRenderStep
