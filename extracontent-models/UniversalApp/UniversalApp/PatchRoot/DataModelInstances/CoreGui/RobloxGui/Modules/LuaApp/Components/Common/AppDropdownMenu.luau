local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useEventMap = ReactFocusNavigation.useEventMap
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local GetFFlagDisableUADPadNavigationInVR = require(Modules.LuaApp.Flags.GetFFlagDisableUADPadNavigationInVR)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local DropdownMenu = UIBlox.App.Menu.DropdownMenu

return function(t1: {[any]: any}) -- line: 57
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), React (copy), FocusNavigationEventNameEnum (copy), useEventMap (copy), useLastInputMethod (copy), GetFFlagDisableUADPadNavigationInVR (copy), IsVRAppBuild (copy), GuiService (copy), ContextActionService (copy), Cryo (copy), DropdownMenu (copy)
	local v19 = useRoactService(RoactAnalytics)
	local v20, v21 = React.useState(nil)
	local v22, v23 = React.useState(false)
	local v24, v25 = React.useState(false)
	local v26 = React.useMemo(function() -- line: 63
		-- upvalues: v22 (copy), FocusNavigationEventNameEnum (copy)
		if v22 then
			return {
				[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NoOpEvent,
				[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NoOpEvent
			}
		end

		return {}
	end, { v22 })
	local v27 = useEventMap(v26, v21)
	local v28 = useLastInputMethod()
	local v29 = if not GetFFlagDisableUADPadNavigationInVR() then v28 == "Gamepad" or v28 == "Keyboard" else (v28 == "Gamepad" or v28 == "Keyboard") and not IsVRAppBuild()
	local v30 = React.useCallback(function(p1) -- line: 80
		-- upvalues: t1 (copy), v19 (copy)
		if t1.analyticsContext then
			v19.EventStream:setRBXEvent(t1.analyticsContext, "DropdownMenuState", {
				menuOpen = p1
			})
		end
	end, {
		v19,
		t1.analyticsContext
	})
	local v31 = React.useCallback(function(p2) -- line: 88
		-- upvalues: t1 (copy), v19 (copy)
		if t1.analyticsContext then
			v19.EventStream:setRBXEvent(t1.analyticsContext, "DropdownMenuSelect", {
				selection = tostring(p2)
			})
		end

		return t1.onChange(p2)
	end, {
		v19,
		t1.analyticsContext,
		t1.onChange
	})
	local v32 = React.useCallback(function(p3) -- line: 97
		-- upvalues: v23 (copy), v30 (copy), v25 (copy), v20 (copy), t1 (copy), GuiService (copy), ContextActionService (copy), v29 (copy)
		v23(p3)
		v30(p3)
		v25(false)

		if v20 and t1.selectionGroupName then
			if p3 then
				GuiService:AddSelectionParent(t1.selectionGroupName, v20)
				ContextActionService:BindAction("CloseDropdownBind", function() -- line: 106
					-- upvalues: v25 (copy)
					v25(true)
				end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
			else
				ContextActionService:UnbindAction("CloseDropdownBind")
				v25(false)
				GuiService:RemoveSelectionGroup(t1.selectionGroupName)

				if v29 then
					GuiService:Select(v20)
				end
			end
		end

		if t1.onMenuOpenChange then
			t1.onMenuOpenChange(p3)
		end
	end, {
		v20,
		t1.selectionGroupName,
		t1.onMenuOpenChange
	})
	local v33 = Cryo.Dictionary.join(t1, {
		selectionOrder = 1,
		onMenuOpenChange = v32,
		onChange = v31,
		selectionGroupName = Cryo.None,
		analyticsContext = Cryo.None,
		isForcedClosed = v24
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		ref = v27
	}, {
		DropdownMenu = React.createElement(DropdownMenu, v33)
	})
end
