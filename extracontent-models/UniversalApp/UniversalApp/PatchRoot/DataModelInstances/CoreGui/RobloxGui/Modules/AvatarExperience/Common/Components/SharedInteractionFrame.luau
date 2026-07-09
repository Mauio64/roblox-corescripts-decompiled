local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local t = require(CorePackages.Packages.t)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local v19 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.scene")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXPhotoboothReplacesFullview = AvatarExperienceFlags.FFlagAXPhotoboothReplacesFullview
local FFlagAXPhotoboothAnalytics = AvatarExperienceFlags.FFlagAXPhotoboothAnalytics
local sendUnifiedEventLogForInstance = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventLogForInstance
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums

local function splitInputType(p1) -- line: 43
	local v33 = p1.UserInputType == Enum.UserInputType.Touch
	local v34 = p1.UserInputType == Enum.UserInputType.MouseButton1
	local v35 = p1.UserInputType == Enum.UserInputType.MouseButton2

	return v33, v34 or v35, v34, v35
end
local function isDoubleTapToZoomEnabled(p2) -- line: 52
	-- upvalues: AvatarScreen (copy), FFlagAXPhotoboothReplacesFullview (copy), GetFFlagAXEnableSlotBasedEditor (copy)
	return p2 == AvatarScreen.AvatarEditor or (p2 == AvatarScreen.Catalog or (p2 == AvatarScreen.ProfilePictureEditorEmotes or (p2 == AvatarScreen.CatalogSearch or (p2 == AvatarScreen.MySharedAvatars or (FFlagAXPhotoboothReplacesFullview and p2 == AvatarScreen.Photobooth or (GetFFlagAXEnableSlotBasedEditor() and p2 == AvatarScreen.AvatarSwitcher or GetFFlagAXEnableSlotBasedEditor() and p2 == AvatarScreen.EditEmotes))))))
end

local u28 = nil

if FFlagAXPhotoboothReplacesFullview then
	function u28(p3) -- line: 65
		-- upvalues: AvatarScreen (copy), GetFFlagAXEnableSlotBasedEditor (copy)
		return p3 == AvatarScreen.AvatarEditor or (p3 == AvatarScreen.Photobooth or GetFFlagAXEnableSlotBasedEditor() and p3 == AvatarScreen.AvatarSwitcher)
	end
end

local v29 = Roact.PureComponent:extend("SharedInteractionFrame")

v29.validateProps = t.interface({
	panByPixels = t.callback,
	rotateByPixels = t.callback,
	setAngularVelocityByPixels = t.callback,
	zoomToPoint = t.callback,
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	ZIndex = t.optional(t.number),
	fullView = t.optional(t.userdata),
	setFullView = t.callback,
	analytics = t.table
})

function v29.disconnectEvents(p4) -- line: 92
	p4.inputChangedConnection:Disconnect()
	p4.inputEndedConnection:Disconnect()
	p4.renderSteppedConnection:Disconnect()
	p4.inputChangedConnection = nil
	p4.inputEndedConnection = nil
	p4.renderSteppedConnection = nil
end
function v29.getActiveInput(p5, p6) -- line: 101
	local v41 = p6.UserInputType == Enum.UserInputType.Touch
	local v42 = p6.UserInputType == Enum.UserInputType.MouseButton1
	local v43 = p6.UserInputType == Enum.UserInputType.MouseButton2
	local v44 = v42 or v43
	local v45 = p6.UserInputType == Enum.UserInputType.MouseMovement or v44

	if not v45 and not v41 then
		return
	end

	local v46 = nil

	if v45 then
		return p5.activeMouseInput
	end

	if v41 then
		v46 = p5.activeTouchInputs[p6]
	end

	return v46
end
function v29.removeActivePointerInput(p7, p8, p9) -- line: 120
	-- upvalues: UserInputService (copy)
	if p9 then
		if not not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
			return
		end

		p7.activeMouseInput = nil
	else
		p7.activeTouchInputs[p8] = nil
		p7.numActiveTouchInputs = p7.numActiveTouchInputs - 1
	end

	p7.numActiveInputs = p7.numActiveInputs - 1

	if p7.numActiveInputs == 0 then
		p7:disconnectEvents()
	end
end
function v29.doubleTapToggleFullView(p10) -- line: 143
	-- upvalues: isDoubleTapToZoomEnabled (copy), FFlagAXPhotoboothReplacesFullview (copy), u28 (ref), AvatarScreen (copy), FFlagAXPhotoboothAnalytics (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), FullView (copy)
	local name = p10.props.avatarRoute.opaque.name

	if not isDoubleTapToZoomEnabled(name) then
		return
	end

	if FFlagAXPhotoboothReplacesFullview and u28(name) then
		if name == AvatarScreen.Photobooth then
			p10.props.navigation.goBack()

			return
		end

		if FFlagAXPhotoboothAnalytics and p10.frameRef and p10.frameRef.current then
			sendUnifiedEventLogForInstance(p10.frameRef.current, {
				elementName = "Photobooth_Opened",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK
			})
		end

		p10.props.navigation.navigate(AvatarScreen.Photobooth)

		return
	end

	local v52 = p10.props.fullView == FullView.None and FullView.SceneFullView or FullView.None

	p10.props.setFullView(p10.props.analytics, name, v52)
end
function v29.handleDoubleTap(p11, p12, p13) -- line: 169
	if p11.lastPrimaryPointerInputBeganPosition then
		local v56 = p11.lastPrimaryPointerInputBeganPosition - p12.Position
		local v57 = p13 - p11.lastPrimaryPointerInputBeganTime

		if v56.Magnitude < 30 and v57 < 0.25 then
			p11:doubleTapToggleFullView()
		end
	end

	p11.lastPrimaryPointerInputBeganPosition = p12.Position
	p11.lastPrimaryPointerInputBeganTime = p13
end
function v29.addActivePointerInput(p14, p15, p16, p17) -- line: 183
	-- upvalues: Cryo (copy), UserInputService (copy), RunService (copy)
	if p14:getActiveInput(p15) then
		return
	end

	local t1 = {
		lastPosition = p15.Position,
		lastTime = p17
	}

	if p16 then
		p14.activeMouseInput = t1
	else
		p14.activeTouchInputs[p15] = Cryo.Dictionary.join(t1, {
			lastDeltaTime = 0,
			lastDeltaPosition = Vector3.new(0, 0, 0)
		})
		p14.numActiveTouchInputs = p14.numActiveTouchInputs + 1
	end

	p14.numActiveInputs = p14.numActiveInputs + 1

	if p14.numActiveInputs == 1 then
		p14.props.setAngularVelocityByPixels(0)
		p14.inputChangedConnection = UserInputService.InputChanged:Connect(p14.onInputChanged)
		p14.inputEndedConnection = UserInputService.InputEnded:Connect(p14.onInputEnded)
		p14.renderSteppedConnection = RunService.RenderStepped:Connect(p14.setInputNotChanged)
	end
end
function v29.init(p18) -- line: 212
	-- upvalues: Roact (copy), UserInputService (copy)
	p18.inputChangedConnection = nil
	p18.inputEndedConnection = nil
	p18.frameRef = Roact.createRef()
	p18.lastPinchDistance = 1
	p18.lastPanTime = 0
	p18.lastPrimaryPointerInputBeganTime = 0
	p18.lastPrimaryPointerInputBeganPosition = nil
	p18.activeTouchInputs = {}
	p18.numActiveTouchInputs = 0
	p18.activeMouseInput = nil
	p18.numActiveInputs = 0

	function p18.handleScroll(_, p20) -- line: 228
		-- upvalues: p18 (copy), UserInputService (copy)
		if p20.UserInputType == Enum.UserInputType.MouseWheel then
			local v78 = -p20.Position.Z

			p18.props.zoomToPoint(v78, UserInputService:GetMouseLocation())
		end
	end
	function p18.setInputNotChanged(_) -- line: 235
		-- upvalues: p18 (copy)
		for _, v81 in p18.activeTouchInputs do
			v81.changedThisFrame = false
		end
	end
	function p18.onInputChanged(p22, _) -- line: 241
		-- upvalues: p18 (copy), UserInputService (copy)
		local v84 = p22.UserInputType == Enum.UserInputType.MouseMovement
		local v85 = p22.UserInputType == Enum.UserInputType.Touch

		if not v84 and not v85 then
			return
		end

		local v86 = p18:getActiveInput(p22)

		if not v86 then
			return
		end

		local timestamp = tick()
		local v88 = timestamp - v86.lastTime
		local v89 = p22.Position - v86.lastPosition
		local v90 = Vector2.new(v89.X, v89.Y) * Vector2.new(-1, 1)
		local v91 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local v92 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		local v93 = timestamp - p18.lastPanTime > 0.1

		if (v84 and v91 or v85 and p18.numActiveTouchInputs == 1) and v93 then
			p18.props.rotateByPixels(-v90.X)
		end

		if v84 and v92 or v85 and p18.numActiveTouchInputs == 2 then
			local v94 = v90 / p18.numActiveInputs

			p18.props.panByPixels(v94)
			p18.lastPanTime = timestamp
		end

		v86.lastPosition = p22.Position
		v86.lastTime = timestamp

		if v85 then
			if v86.changedThisFrame then
				v86.lastDeltaPosition = v89 + v86.lastDeltaPosition
				v86.lastDeltaTime = v88 + v86.lastDeltaTime

				return
			end

			v86.lastDeltaPosition = v89
			v86.lastDeltaTime = v88
			v86.changedThisFrame = true
		end
	end
	function p18.onInputEnded(p24, _) -- line: 293
		-- upvalues: p18 (copy)
		local v97 = p24.UserInputType == Enum.UserInputType.Touch
		local v98 = p24.UserInputType == Enum.UserInputType.MouseButton1
		local v99 = p24.UserInputType == Enum.UserInputType.MouseButton2
		local v100 = v98 or v99

		if not v97 and not v100 then
			return
		end

		local v101 = p18:getActiveInput(p24)

		if not v101 then
			return
		end

		local timestamp = tick()
		local v103 = timestamp - p18.lastPanTime
		local v104 = v97 and v101.changedThisFrame
		local v105 = p18.numActiveInputs == 1 and v103 > 0.1

		if (v104 or v98) and v105 then
			local v106, v107

			if v98 then
				v106 = p24.Position - v101.lastPosition
				v107 = timestamp - v101.lastTime
			else
				v106 = v101.lastDeltaPosition
				v107 = v101.lastDeltaTime
			end

			p18.props.setAngularVelocityByPixels(v106.X / v107)
		end

		p18:removeActivePointerInput(p24, v100)
	end
	function p18.onInputBegan(p26, p27) -- line: 331
		-- upvalues: p18 (copy)
		p18.handleScroll(p26, p27)

		local v110 = p27.UserInputType == Enum.UserInputType.Touch
		local v111 = p27.UserInputType == Enum.UserInputType.MouseButton1
		local v112 = p27.UserInputType == Enum.UserInputType.MouseButton2
		local v113 = v111 or v112

		if not v110 and not v113 then
			return
		end

		local v114 = v110 or v111
		local timestamp = tick()

		if v114 then
			p18:handleDoubleTap(p27, timestamp)
		end

		p18:addActivePointerInput(p27, v113, timestamp)
	end
	function p18.onTouchPinch(_, p29, _, _, p32) -- line: 351
		-- upvalues: p18 (copy)
		if p29[2] == nil then
			return
		end

		if p32 == Enum.UserInputState.Begin then
			p18.lastPinchDistance = (p29[1] - p29[2]).Magnitude

			return
		end

		local Magnitude = (p29[1] - p29[2]).Magnitude
		local v122 = Magnitude - p18.lastPinchDistance

		p18.lastPinchDistance = Magnitude
		p18.props.zoomToPoint(v122 * -0.05, (p29[1] + p29[2]) / 2)
	end
end
function v29.willUnmount(p33) -- line: 368
	if p33.inputChangedConnection then
		p33:disconnectEvents()
	end
end
function v29.shouldBeVisible(p34) -- line: 374
	-- upvalues: AvatarScreenProperties (copy)
	local v66 = AvatarScreenProperties[p34.props.avatarRoute.current.name]

	if v66 and (v66.coversSceneWhenExpanded and p34.props.itemDetailsExpanded) then
		return false
	end

	return true
end
function v29.render(p35) -- line: 387
	-- upvalues: v19 (copy), Roact (copy)
	local v68 = p35:shouldBeVisible()

	v19:trace("SharedInteractionFrame visible: {}", v68)

	local v69 = p35.props.Size or UDim2.new(1, 0, 1, 0)
	local propsPosition = p35.props.Position
	local propsZIndex = p35.props.ZIndex

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v69,
		Position = propsPosition,
		ZIndex = propsZIndex,
		Visible = v68,
		Active = true,
		[Roact.Event.InputBegan] = p35.onInputBegan,
		[Roact.Event.InputChanged] = p35.handleScroll,
		[Roact.Event.TouchPinch] = p35.onTouchPinch,
		[Roact.Ref] = p35.frameRef
	}, p35.props[Roact.Children])
end

local v30 = RoactRodux.connect(function(p36, p37) -- line: 411
	-- upvalues: selectIsFullView (copy)
	local name = p37.avatarRoute.opaque.name

	return {
		fullView = selectIsFullView(p36, name),
		itemDetailsExpanded = p36.AvatarExperience.Common.ItemDetailsExpanded
	}
end, function(p38) -- line: 418
	-- upvalues: SetFullView (copy)
	return {
		setFullView = function(p39, p40, p41) -- line: 420
			-- upvalues: p38 (copy), SetFullView (copy)
			p38(SetFullView(p39, p40, p41))
		end
	}
end)(v29)
local v31 = withAppRoute((RoactServices.connect({
	analytics = Analytics
})(v30)))

if FFlagAXPhotoboothReplacesFullview then
	v31 = RoactNavigation.withNavigation(v31)
end

return v31
