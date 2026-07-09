local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local wrapWithSceneInteractionCallbacks = require(Modules.AvatarExperience.Common.Context.wrapWithSceneInteractionCallbacks)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	vertical = {
		key = "Feature.Avatar.Action.Zoom"
	},
	horizontal = {
		key = "Feature.Avatar.Action.Rotate"
	}
}
local v27 = Roact.PureComponent:extend("SceneGamepadHandler")

v27.validateProps = t.interface({
	[Roact.Children] = t.optional(t.table),
	panByDistance = t.callback,
	rotateByRadians = t.callback,
	zoomStraight = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	defaultChild = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	isSceneFullView = t.boolean,
	focusGuiObject = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t.optional(t.callback)
})

function v27.init(p1) -- line: 77
	-- upvalues: Roact (copy), GamepadUtils (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GuiService (copy), FullView (copy)
	p1.mainRef = Roact.createRef()
	p1.isolateRef = Roact.createRef()

	function p1.rotateAndZoom(p2, p3) -- line: 81
		-- upvalues: GamepadUtils (copy), p1 (copy)
		GamepadUtils.rotateAndZoom(p2, p3, p1.props.setAngularVelocityByPixels, p1.props.rotateByRadians, p1.props.zoomStraight)
	end
	function p1.pan(p4, p5) -- line: 91
		-- upvalues: GamepadUtils (copy), p1 (copy)
		local v43 = GamepadUtils.normalizeStickByDeadzone(p4.Position)

		if v43 == Vector2.new(0, 0) then
			return
		end

		p1.props.panByDistance(p5 * v43 * 5)
	end
	function p1.toggleFullView() -- line: 100
		-- upvalues: p1 (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GuiService (copy), FullView (copy)
		local name = p1.props.avatarRoute.opaque.name

		if name ~= AvatarScreen.AvatarEditor and (name ~= AvatarScreen.MySharedAvatars and (name ~= AvatarScreen.Catalog and (name ~= AvatarScreen.CatalogSearch and name ~= AvatarScreen.ProfilePictureEditorEmotes))) then
			return
		end

		if p1.props.isSceneFullView then
			if FFlagAXMigrateAXToGlobalAutofocus then
				if p1.props.focusGuiObject and p1.oldFocus.current then
					p1.props.focusGuiObject(p1.oldFocus.current)
				end
			else
				p1.props.focusController.moveFocusTo(p1.oldFocus.current)
				p1.oldFocus = nil
			end
		elseif FFlagAXMigrateAXToGlobalAutofocus then
			p1.oldFocus.current = GuiService.SelectedCoreObject

			if p1.props.focusGuiObject and p1.isolateRef.current then
				p1.props.focusGuiObject(p1.isolateRef.current)
			end
		else
			p1.oldFocus = p1.props.focusController.getCurrentFocus()
			p1.props.focusController.moveFocusTo(p1.isolateRef)
		end

		local setFullView = p1.props.setFullView
		local v46 = if not p1.props.isSceneFullView then FullView.SceneFullView else FullView.None

		setFullView(p1.props.analytics, p1.props.avatarRoute.opaque.name, v46)
	end
	function p1.renderWithCursorCallback(...) -- line: 146
		-- upvalues: p1 (copy)
		return p1:renderWithCursor(...)
	end
end
function v27.renderWithCursor(p6, p7) -- line: 151
	-- upvalues: Roact (copy), Focusable (copy), RoactGamepad (copy), Constants (copy), t1 (copy), Cryo (copy), CursorKind (copy)
	local isSceneFullView = p6.props.isSceneFullView

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		inputBindings = {
			RotateAndZoom = RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, p6.rotateAndZoom, {
				tag = Constants.SceneGamepad.FullViewIndicatorTag,
				axes = isSceneFullView and t1 or nil
			}),
			Pan = isSceneFullView and RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick1, p6.pan, {
				key = "Feature.Avatar.Action.Pan"
			}) or nil,
			ToggleFullView = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR3, p6.toggleFullView, {
				tag = Constants.SceneGamepad.FullViewIndicatorTag,
				key = if not isSceneFullView then nil else "Feature.Avatar.Action.DefaultView"
			}),
			ExitFullView = if not isSceneFullView then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p6.toggleFullView)
		},
		NextSelectionLeft = p6.props.NextSelectionLeft,
		NextSelectionRight = p6.props.NextSelectionRight,
		NextSelectionUp = p6.props.NextSelectionUp,
		NextSelectionDown = p6.props.NextSelectionDown,
		defaultChild = p6.props.defaultChild,
		[Roact.Ref] = p6.mainRef
	}, Cryo.Dictionary.join(p6.props[Roact.Children], {
		FocusIsolate = Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			SelectionImageObject = p7(CursorKind.Invisible),
			[Roact.Ref] = p6.isolateRef
		})
	}))
end
function v27.render(p8) -- line: 195
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(p8.renderWithCursorCallback)
end

local v28 = RoactRodux.connect(function(p9, p10) -- line: 199
	-- upvalues: Utils (copy)
	return {
		isSceneFullView = Utils.getIsSceneFullViewFromState(p9, p10.avatarRoute)
	}
end, function(p11) -- line: 203
	-- upvalues: SetFullView (copy)
	return {
		setFullView = function(p12, p13, p14) -- line: 205
			-- upvalues: p11 (copy), SetFullView (copy)
			p11(SetFullView(p12, p13, p14))
		end
	}
end)(v27)
local u29 = RoactServices.connect({
	analytics = Analytics
})(v28)

return (withAppRoute((wrapWithSceneInteractionCallbacks(function(p15) -- line: 215
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusGuiObject (copy), Roact (copy), u29 (ref), RoactGamepad (copy), Cryo (copy)
	if FFlagAXMigrateAXToGlobalAutofocus then
		p15.focusGuiObject = useFocusGuiObject()

		return Roact.createElement(u29, p15)
	end

	return RoactGamepad.withFocusController(function(p16) -- line: 222
		-- upvalues: Roact (copy), u29 (ref), Cryo (copy), p15 (copy)
		return Roact.createElement(u29, Cryo.Dictionary.join(p15, {
			focusController = p16
		}))
	end)
end))))
