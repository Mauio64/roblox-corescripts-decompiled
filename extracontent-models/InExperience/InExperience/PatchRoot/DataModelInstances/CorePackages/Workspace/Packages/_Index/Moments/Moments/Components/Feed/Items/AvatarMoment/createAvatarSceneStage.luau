local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local observeGuiOnScreen = require(script.Parent.observeGuiOnScreen)

local cframe = CFrame.new(0, 2000, 0)

local function saveCamera(avatarMomentCamera) -- 1 equivalent call inferred from this helper
	return {
		instance = avatarMomentCamera,
		cframe = avatarMomentCamera.CFrame,
		focus = avatarMomentCamera.Focus,
		fieldOfView = avatarMomentCamera.FieldOfView,
		fieldOfViewMode = avatarMomentCamera.FieldOfViewMode,
		cameraType = avatarMomentCamera.CameraType
	}
end

local function guiToViewportY(y: number) -- 1 equivalent call inferred from this helper
	return y + GuiService:GetGuiInset().Y
end

local function getStudsPerPixel(camera, p: number) -- 2 equivalent calls inferred from this helper
	return 2 * (camera.Focus.Position - camera.CFrame.Position).Magnitude * math.tan(math.rad(camera.FieldOfView) / 2) / p
end

local function getCoverage(p) -- 1 equivalent call inferred from this helper
	local y = p.pager.AbsolutePosition.Y
	local y2 = p.pager.AbsoluteSize.Y

	if y2 <= 0 then
		return 0
	end

	local y3 = p.page.AbsolutePosition.Y
	return (math.clamp((math.min(y3 + p.page.AbsoluteSize.Y, y + y2) - math.max(y3, y)) / y2, 0, 1))
end

local function createAvatarSceneStage()
	local v = {}
	local v2 = {}
	local v3 = {}
	local count = 0
	local v4 = nil
	local v5 = nil
	local v6 = nil
	local v7 = nil
	local cframe2 = nil
	local flag = false
	local renderSteppedConnection = nil
	local connections = {}

	local function acquireCamera() -- 1 equivalent call inferred from this helper
		local avatarMomentCamera = Workspace.CurrentCamera

		if avatarMomentCamera == nil then
			avatarMomentCamera = Instance.new("Camera")
			avatarMomentCamera.Name = "AvatarMomentCamera"
			avatarMomentCamera.Parent = Workspace
			Workspace.CurrentCamera = avatarMomentCamera
			v6 = avatarMomentCamera
		end

		v5 = avatarMomentCamera
		v7 = saveCamera(avatarMomentCamera) -- inferred equivalent call
		cframe2 = nil
	end

	local function releaseCamera()
		local v8 = v7
		local v9 = v5
		v7 = nil
		v5 = nil

		if
			v8 ~= nil
			and v9 ~= nil
			and v8.instance.Parent ~= nil
			and Workspace.CurrentCamera == v8.instance
			and (cframe2 == nil or v9.CFrame == cframe2)
		then
			v9.CFrame = v8.cframe
			v9.Focus = v8.focus
			v9.FieldOfView = v8.fieldOfView
			v9.FieldOfViewMode = v8.fieldOfViewMode
			v9.CameraType = v8.cameraType
		end

		cframe2 = nil
		local v10 = v6
		v6 = nil

		if v10 ~= nil then
			if Workspace.CurrentCamera == v10 then
				Workspace.CurrentCamera = nil
			end

			v10:Destroy()
		end
	end

	local function moveToViewportFrame(p) -- 2 equivalent calls inferred from this helper
		if p.worldModel.Parent == nil then
			return
		end

		local root = p.scene.root
		root:PivotTo(CFrame.identity)
		root.Parent = p.worldModel
	end

	local function moveToWorkspace(p) -- 1 equivalent call inferred from this helper
		local root = p.scene.root
		root.Parent = Workspace
		root:PivotTo(cframe)
	end

	local function setOwner(p) -- 1 equivalent call inferred from this helper
		if p == v4 then
			return
		end

		local v8 = v4
		v4 = p

		if p == nil then
			releaseCamera()
		end

		if v8 ~= nil then
			moveToViewportFrame(v8) -- inferred equivalent call
		end

		if p ~= nil then
			if v8 == nil then
				acquireCamera() -- inferred equivalent call
			end

			moveToWorkspace(p) -- inferred equivalent call
		end
	end

	local function updateWorkspaceCamera(data, p: number)
		local v8 = v5

		if v8 == nil or Workspace.CurrentCamera ~= v8 then
			return
		end

		local camera = data.scene.camera
		local v9 = not (p > 0) and 0
			or (data.page.AbsolutePosition.Y - data.pager.AbsolutePosition.Y) * getStudsPerPixel(camera, p) -- inferred equivalent call

		v8.CameraType = Enum.CameraType.Scriptable

		v8.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
		v8.FieldOfView = camera.FieldOfView
		v8.CFrame = cframe * camera.CFrame * CFrame.new(0, v9, 0)
		v8.Focus = cframe * camera.Focus
		cframe2 = v8.CFrame
	end

	local function updateViewportCamera(data, p: number)
		local camera = data.scene.camera
		local viewportCamera = data.viewportCamera
		local y = data.viewportFrame.AbsoluteSize.Y
		viewportCamera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical

		if p <= 0 or y <= 0 then
			viewportCamera.FieldOfView = camera.FieldOfView
			viewportCamera.CFrame = camera.CFrame
		else
			viewportCamera.FieldOfView = math.deg(math.atan(math.tan(math.rad(camera.FieldOfView) / 2) * y / p) * 2)

			local v8 = data.viewportFrame.AbsolutePosition.Y - data.page.AbsolutePosition.Y
			local v9 = guiToViewportY(data.pager.AbsolutePosition.Y) + v8 + y / 2 - p / 2 -- inferred equivalent call
			viewportCamera.CFrame = camera.CFrame * CFrame.new(0, -v9 * getStudsPerPixel(camera, p), 0) -- inferred equivalent call
		end
	end

	local function setViewportFrameVisible(state, flag2: boolean) -- 2 equivalent calls inferred from this helper
		if state.viewportFrameVisible ~= flag2 then
			state.viewportFrameVisible = flag2
			state.viewportFrame.Visible = flag2
		end
	end

	local function isCameraTakenOver(): boolean -- 1 equivalent call inferred from this helper
		local v8 = v5

		return v8 ~= nil and cframe2 ~= nil and (Workspace.CurrentCamera ~= v8 or v8.CFrame ~= cframe2)
	end

	local function step(): boolean
		if isCameraTakenOver() then -- inferred equivalent call
			flag = true
			v7 = nil
		end

		local v8 = -1
		local pager = nil

		for _, v9 in v2 do
			local v10

			if v9.isOnScreen then
				v10 = v3[v9.pager]
			end

			if not (v10 ~= nil and v8 < v10) then
				continue
			end

			pager = v9.pager
			v8 = v10
		end

		local v9 = 0
		local v10 = 0
		local v11 = nil

		for _, v12 in v do
			local coverage

			if v12.presence.isOnScreen and v12.pager == pager then
				coverage = getCoverage(v12) -- inferred equivalent call
			else
				coverage = 0
			end

			v12.coverage = coverage

			if v12 == v4 then
				v10 = v12.coverage
			end

			if not (v9 < v12.coverage) then
				continue
			end

			v9 = v12.coverage
			v11 = v12
		end

		local v12 = v4

		if v12 == nil or v10 <= 0 or v10 + 0.1 < v9 then
			v12 = v11
		end

		if flag then
			v12 = nil
		end

		setOwner(v12) -- inferred equivalent call

		if v9 <= 0 then
			flag = false
		end

		local currentCamera = Workspace.CurrentCamera
		local v13 = currentCamera == nil and 0 or currentCamera.ViewportSize.Y

		for _, v14 in v do
			setViewportFrameVisible(v14, v14.coverage > 0) -- inferred equivalent call

			if v14 ~= v4 and v14.coverage > 0 then
				updateViewportCamera(v14, v13)
			end
		end

		if v4 ~= nil then
			updateWorkspaceCamera(v4, v13)
		end

		return v9 > 0
	end

	local function stopRendering() -- 2 equivalent calls inferred from this helper
		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function stopWatchingForMovement() -- 3 equivalent calls inferred from this helper
		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	local refresh

	local function watchForMovement()
		stopRendering() -- inferred equivalent call
		stopWatchingForMovement() -- inferred equivalent call

		for _, v8 in v do
			if not v8.presence.isOnScreen then
				continue
			end

			table.insert(connections, v8.page:GetPropertyChangedSignal("AbsolutePosition"):Connect(refresh))

			table.insert(connections, v8.page:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh))
			table.insert(connections, v8.pager:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh))
		end
	end

	local function onRenderStepped()
		if not step() then
			watchForMovement()
		end
	end

	refresh = function()
		local flag2 = false

		for _, v8 in v do
			if v8.presence.isOnScreen then
				flag2 = true
				break
			end
		end

		if flag2 then
			if not step() then
				watchForMovement()
				return
			end

			stopWatchingForMovement() -- inferred equivalent call

			if renderSteppedConnection == nil then
				renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
			end
		else
			stopRendering() -- inferred equivalent call
			stopWatchingForMovement() -- inferred equivalent call
			flag = false

			if v4 ~= nil then
				local v8 = v4
				v4 = nil

				releaseCamera()

				if v8 ~= nil then
					moveToViewportFrame(v8) -- inferred equivalent call
				end
			end

			for _, v8 in v do
				setViewportFrameVisible(v8, false) -- inferred equivalent call
			end
		end
	end

	local function updatePagerOrder(pager)
		local count2 = 0

		for _, v8 in v2 do
			if v8.pager == pager and v8.isOnScreen then
				count2 += 1
			end
		end

		if count2 == 0 then
			v3[pager] = nil
		elseif v3[pager] == nil then
			count += 1
			v3[pager] = count
		end
	end

	local function retainPage(instance)
		local v8 = v2[instance]

		if v8 ~= nil then
			v8.refCount += 1
			return v8
		end

		local pager = instance:FindFirstAncestorWhichIsA("ScrollingFrame")
		local v9 = {
			page = instance,
			pager = 0,
			isOnScreen = false,
			refCount = 1,
			disconnectOnScreen = 0
		}

		if pager == nil then
			pager = instance
		end

		v9.pager = pager

		function v9.disconnectOnScreen() end

		v2[instance] = v9
		v9.disconnectOnScreen = observeGuiOnScreen(instance, function(isOnScreen: boolean)
			v9.isOnScreen = isOnScreen
			updatePagerOrder(v9.pager)
			refresh()
		end)
		return v9
	end

	local function releasePage(state) -- 2 equivalent calls inferred from this helper
		state.refCount -= 1

		if state.refCount > 0 then
			return
		end

		state.disconnectOnScreen()
		v2[state.page] = nil
		updatePagerOrder(state.pager)
		refresh()
	end

	return {
		trackPage = function(page)
			local v8 = retainPage(page)
			local flag2 = true
			return function()
				if flag2 then
					flag2 = false
					releasePage(v8) -- inferred equivalent call
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

			local presence = retainPage(data.page)
			local v8 = {
				scene = data.scene,
				page = data.page,
				viewportFrame = data.viewportFrame,
				worldModel = data.worldModel,
				pager = presence.pager,
				presence = presence,
				viewportCamera = avatarMomentViewportCamera,
				coverage = 0,
				viewportFrameVisible = nil
			}

			table.insert(v, v8)
			refresh()

			local v9 = true
			return function()
				if not v9 then
					return
				end

				v9 = false

				if v4 == v8 then
					v4 = nil
					releaseCamera()
				end

				local index = table.find(v, v8)

				if index ~= nil then
					table.remove(v, index)
				end

				if v8.viewportFrame.CurrentCamera == avatarMomentViewportCamera then
					v8.viewportFrame.CurrentCamera = nil
				end

				avatarMomentViewportCamera:Destroy()
				releasePage(presence) -- inferred equivalent call
				refresh()
			end
		end,
		getOwnerScene = function()
			return if v4 ~= nil then v4.scene else nil
		end
	}
end

return createAvatarSceneStage
