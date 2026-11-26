local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local observeGuiOnScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/observeGuiOnScreen")

local cframe = CFrame.new(0, 2000, 0)

local function saveCamera(data)
	return {
		instance = data,
		cframe = data.CFrame,
		focus = data.Focus,
		fieldOfView = data.FieldOfView,
		fieldOfViewMode = data.FieldOfViewMode,
		cameraType = data.CameraType
	}
end

local function guiToViewportY(p2)
	return p2 + GuiService:GetGuiInset().Y
end

local function getStudsPerPixel(data, p2)
	return 2 * (data.Focus.Position - data.CFrame.Position).Magnitude * math.tan(math.rad(data.FieldOfView) / 2) / p2
end

local function getCoverage(p2)
	local y = p2.pager.AbsolutePosition.Y
	local y2 = p2.pager.AbsoluteSize.Y

	if y2 <= 0 then
		return 0
	end

	local y3 = p2.page.AbsolutePosition.Y
	return (math.clamp((math.min(y3 + p2.page.AbsoluteSize.Y, y + y2) - math.max(y3, y)) / y2, 0, 1))
end

local function createAvatarSceneStage()
	local v5 = {}
	local v6 = {}
	local v7 = {}
	local count = 0
	local v8 = nil
	local v9 = nil
	local v10 = nil
	local v11 = nil
	local cframe2 = nil
	local flag = false
	local renderSteppedConnection = nil
	local connections = {}

	local function acquireCamera()
		local avatarMomentCamera = Workspace.CurrentCamera

		if avatarMomentCamera == nil then
			avatarMomentCamera = Instance.new("Camera")
			avatarMomentCamera.Name = "AvatarMomentCamera"
			avatarMomentCamera.Parent = Workspace
			Workspace.CurrentCamera = avatarMomentCamera
			v10 = avatarMomentCamera
		end

		v9 = avatarMomentCamera
		v11 = {
			instance = avatarMomentCamera,
			cframe = avatarMomentCamera.CFrame,
			focus = avatarMomentCamera.Focus,
			fieldOfView = avatarMomentCamera.FieldOfView,
			fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
			cameraType = avatarMomentCamera.CameraType
		}
		cframe2 = nil
	end

	local function releaseCamera()
		local v12 = v11
		local v13 = v9
		v11 = nil
		v9 = nil

		if
			v12 ~= nil
			and v13 ~= nil
			and v12.instance.Parent ~= nil
			and Workspace.CurrentCamera == v12.instance
			and (cframe2 == nil or v13.CFrame == cframe2)
		then
			v13.CFrame = v12.cframe
			v13.Focus = v12.focus
			v13.FieldOfView = v12.fieldOfView
			v13.FieldOfViewMode = v12.fieldOfViewMode
			v13.CameraType = v12.cameraType
		end

		cframe2 = nil
		local v14 = v10
		v10 = nil

		if v14 ~= nil then
			if Workspace.CurrentCamera == v14 then
				Workspace.CurrentCamera = nil
			end

			v14:Destroy()
		end
	end

	local function moveToViewportFrame(p2)
		if p2.worldModel.Parent == nil then
			return
		end

		local root = p2.scene.root
		root:PivotTo(CFrame.identity)
		root.Parent = p2.worldModel
	end

	local function moveToWorkspace(p2)
		local root = p2.scene.root
		root.Parent = Workspace
		root:PivotTo(cframe)
	end

	local function setOwner(p2)
		if p2 == v8 then
			return
		end

		local v12 = v8
		v8 = p2

		if p2 == nil then
			releaseCamera()
		end

		if v12 ~= nil and v12.worldModel.Parent ~= nil then
			local root = v12.scene.root
			root:PivotTo(CFrame.identity)
			root.Parent = v12.worldModel
		end

		if p2 ~= nil then
			if v12 == nil then
				local avatarMomentCamera = Workspace.CurrentCamera

				if avatarMomentCamera == nil then
					avatarMomentCamera = Instance.new("Camera")
					avatarMomentCamera.Name = "AvatarMomentCamera"
					avatarMomentCamera.Parent = Workspace
					Workspace.CurrentCamera = avatarMomentCamera
					v10 = avatarMomentCamera
				end

				v9 = avatarMomentCamera
				v11 = {
					instance = avatarMomentCamera,
					cframe = avatarMomentCamera.CFrame,
					focus = avatarMomentCamera.Focus,
					fieldOfView = avatarMomentCamera.FieldOfView,
					fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
					cameraType = avatarMomentCamera.CameraType
				}
				cframe2 = nil
			end

			local root = p2.scene.root
			root.Parent = Workspace
			root:PivotTo(cframe)
		end
	end

	local function updateWorkspaceCamera(data, p2)
		local v12 = v9

		if v12 == nil or Workspace.CurrentCamera ~= v12 then
			return
		end

		local camera = data.scene.camera
		local v13 = not (p2 > 0) and 0
			or (data.page.AbsolutePosition.Y - data.pager.AbsolutePosition.Y) * (2 * (camera.Focus.Position - camera.CFrame.Position).Magnitude * math.tan(math.rad(camera.FieldOfView) / 2) / p2)

		v12.CameraType = Enum.CameraType.Scriptable

		v12.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
		v12.FieldOfView = camera.FieldOfView
		v12.CFrame = cframe * camera.CFrame * CFrame.new(0, v13, 0)
		v12.Focus = cframe * camera.Focus
		cframe2 = v12.CFrame
	end

	local function updateViewportCamera(data, p2)
		local camera = data.scene.camera
		local viewportCamera = data.viewportCamera
		local y = data.viewportFrame.AbsoluteSize.Y
		viewportCamera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical

		if p2 <= 0 or y <= 0 then
			viewportCamera.FieldOfView = camera.FieldOfView
			viewportCamera.CFrame = camera.CFrame
		else
			viewportCamera.FieldOfView = math.deg(math.atan(math.tan(math.rad(camera.FieldOfView) / 2) * y / p2) * 2)

			local v12 = data.viewportFrame.AbsolutePosition.Y - data.page.AbsolutePosition.Y
			local v13 = data.pager.AbsolutePosition.Y + GuiService:GetGuiInset().Y + v12 + y / 2 - p2 / 2
			viewportCamera.CFrame = camera.CFrame * CFrame.new(
				0,
				-v13 * (2 * (camera.Focus.Position - camera.CFrame.Position).Magnitude * math.tan(math.rad(camera.FieldOfView) / 2) / p2),
				0
			)
		end
	end

	local function setViewportFrameVisible(state, p2)
		if state.viewportFrameVisible ~= p2 then
			state.viewportFrameVisible = p2
			state.viewportFrame.Visible = p2
		end
	end

	local function isCameraTakenOver(): boolean
		local v12 = v9

		return v12 ~= nil and cframe2 ~= nil and (Workspace.CurrentCamera ~= v12 or v12.CFrame ~= cframe2)
	end

	local function step(): boolean
		local v12 = v9
		local v13

		if v12 == nil or cframe2 == nil then
			v13 = false
		else
			v13 = Workspace.CurrentCamera ~= v12 or v12.CFrame ~= cframe2
		end

		if v13 then
			flag = true
			v11 = nil
		end

		local v14 = -1
		local pager = nil

		for k, v15 in v6 do
			local v16 = if v15.isOnScreen then v7[v15.pager] else nil

			if not (v16 ~= nil and v14 < v16) then
				continue
			end

			pager = v15.pager
			v14 = v16
		end

		local v15 = 0
		local v16 = 0
		local v17 = nil

		for k, v18 in v5 do
			local v19

			if v18.presence.isOnScreen and v18.pager == pager then
				local y = v18.pager.AbsolutePosition.Y
				local y2 = v18.pager.AbsoluteSize.Y

				if y2 <= 0 then
					v19 = 0
				else
					local y3 = v18.page.AbsolutePosition.Y
					v19 = math.clamp(
						(math.min(y3 + v18.page.AbsoluteSize.Y, y + y2) - math.max(y3, y)) / y2,
						0,
						1
					)
				end
			else
				v19 = 0
			end

			v18.coverage = v19

			if v18 == v8 then
				v16 = v18.coverage
			end

			if not (v15 < v18.coverage) then
				continue
			end

			v15 = v18.coverage
			v17 = v18
		end

		local v18 = v8

		if v18 == nil or v16 <= 0 or v16 + 0.1 < v15 then
			v18 = v17
		end

		if flag then
			v18 = nil
		end

		if v18 ~= v8 then
			local v19 = v8
			v8 = v18

			if v18 == nil then
				releaseCamera()
			end

			if v19 ~= nil and v19.worldModel.Parent ~= nil then
				local root = v19.scene.root
				root:PivotTo(CFrame.identity)
				root.Parent = v19.worldModel
			end

			if v18 ~= nil then
				if v19 == nil then
					local avatarMomentCamera = Workspace.CurrentCamera

					if avatarMomentCamera == nil then
						avatarMomentCamera = Instance.new("Camera")
						avatarMomentCamera.Name = "AvatarMomentCamera"
						avatarMomentCamera.Parent = Workspace
						Workspace.CurrentCamera = avatarMomentCamera
						v10 = avatarMomentCamera
					end

					v9 = avatarMomentCamera
					v11 = {
						instance = avatarMomentCamera,
						cframe = avatarMomentCamera.CFrame,
						focus = avatarMomentCamera.Focus,
						fieldOfView = avatarMomentCamera.FieldOfView,
						fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
						cameraType = avatarMomentCamera.CameraType
					}
					cframe2 = nil
				end

				local root = v18.scene.root
				root.Parent = Workspace
				root:PivotTo(cframe)
			end
		end

		if v15 <= 0 then
			flag = false
		end

		local currentCamera = Workspace.CurrentCamera
		local v19 = currentCamera == nil and 0 or currentCamera.ViewportSize.Y

		for k, v20 in v5 do
			local v21 = v20.coverage > 0

			if v20.viewportFrameVisible ~= v21 then
				v20.viewportFrameVisible = v21
				v20.viewportFrame.Visible = v21
			end

			if v20 ~= v8 and v20.coverage > 0 then
				updateViewportCamera(v20, v19)
			end
		end

		if v8 ~= nil then
			updateWorkspaceCamera(v8, v19)
		end

		return v15 > 0
	end

	local function stopRendering()
		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function stopWatchingForMovement()
		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	local refresh

	local function watchForMovement()
		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		for k, v12 in v5 do
			if not v12.presence.isOnScreen then
				continue
			end

			table.insert(
				connections,
				v12.page:GetPropertyChangedSignal("AbsolutePosition"):Connect(refresh)
			)

			table.insert(connections, v12.page:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh))
			table.insert(connections, v12.pager:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh))
		end
	end

	local function onRenderStepped()
		if not step() then
			watchForMovement()
		end
	end

	refresh = function()
		local flag2 = false

		for k, v13 in v5 do
			if v13.presence.isOnScreen then
				flag2 = true
				break
			end
		end

		if flag2 then
			if not step() then
				watchForMovement()
				return
			end

			for k, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)

			if renderSteppedConnection == nil then
				renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
			end
		else
			if renderSteppedConnection ~= nil then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			for k, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)

			flag = false

			if v8 ~= nil then
				local v13 = v8
				v8 = nil

				releaseCamera()

				if v13 ~= nil and v13.worldModel.Parent ~= nil then
					local root = v13.scene.root
					root:PivotTo(CFrame.identity)
					root.Parent = v13.worldModel
				end
			end

			for k, v13 in v5 do
				if v13.viewportFrameVisible == false then
					continue
				end

				v13.viewportFrameVisible = false
				v13.viewportFrame.Visible = false
			end
		end
	end

	local function updatePagerOrder(pager)
		local count2 = 0

		for k, v12 in v6 do
			if v12.pager == pager and v12.isOnScreen then
				count2 += 1
			end
		end

		if count2 == 0 then
			v7[pager] = nil
		elseif v7[pager] == nil then
			count += 1
			v7[pager] = count
		end
	end

	local function retainPage(instance)
		local v12 = v6[instance]

		if v12 ~= nil then
			v12.refCount += 1
			return v12
		end

		local v13 = instance:FindFirstAncestorWhichIsA("ScrollingFrame")
		local v14 = {
			page = instance,
			pager = 0,
			isOnScreen = false,
			refCount = 1,
			disconnectOnScreen = 0
		}

		if v13 == nil then
			v13 = instance
		end

		v14.pager = v13

		function v14.disconnectOnScreen() end

		v6[instance] = v14
		v14.disconnectOnScreen = observeGuiOnScreen(instance, function(isOnScreen)
			v14.isOnScreen = isOnScreen
			updatePagerOrder(v14.pager)
			refresh()
		end)
		return v14
	end

	local function releasePage(state)
		state.refCount -= 1

		if state.refCount > 0 then
			return
		end

		state.disconnectOnScreen()
		v6[state.page] = nil
		updatePagerOrder(state.pager)
		refresh()
	end

	return {
		trackPage = function(p2)
			local v12 = retainPage(p2)
			local flag2 = true
			return function()
				if flag2 then
					flag2 = false
					local v13 = v12
					v13.refCount -= 1

					if v13.refCount > 0 then
						return
					end

					v13.disconnectOnScreen()
					v6[v13.page] = nil
					updatePagerOrder(v13.pager)
					refresh()
				end
			end
		end,
		register = function(data)
			local avatarMomentViewportCamera = Instance.new("Camera")
			avatarMomentViewportCamera.Name = "AvatarMomentViewportCamera"
			avatarMomentViewportCamera.Parent = data.viewportFrame
			data.viewportFrame.CurrentCamera = avatarMomentViewportCamera
			avatarMomentViewportCamera.CFrame = data.scene.camera.CFrame
			avatarMomentViewportCamera.FieldOfView = data.scene.camera.FieldOfView
			data.scene.root.Parent = data.worldModel

			local v12 = retainPage(data.page)
			local v13 = {
				scene = data.scene,
				page = data.page,
				viewportFrame = data.viewportFrame,
				worldModel = data.worldModel,
				pager = v12.pager,
				presence = v12,
				viewportCamera = avatarMomentViewportCamera,
				coverage = 0,
				viewportFrameVisible = nil
			}

			table.insert(v5, v13)
			refresh()

			local v14 = true
			return function()
				if not v14 then
					return
				end

				v14 = false

				if v8 == v13 then
					v8 = nil
					releaseCamera()
				end

				local index = table.find(v5, v13)

				if index ~= nil then
					table.remove(v5, index)
				end

				if v13.viewportFrame.CurrentCamera == avatarMomentViewportCamera then
					v13.viewportFrame.CurrentCamera = nil
				end

				avatarMomentViewportCamera:Destroy()
				local v15 = v12
				v15.refCount -= 1

				if not (v15.refCount > 0) then
					v15.disconnectOnScreen()
					v6[v15.page] = nil
					updatePagerOrder(v15.pager)
					refresh()
				end

				refresh()
			end
		end,
		getOwnerScene = function()
			if v8 == nil then
				return nil
			end

			return v8.scene
		end
	}
end

return createAvatarSceneStage
