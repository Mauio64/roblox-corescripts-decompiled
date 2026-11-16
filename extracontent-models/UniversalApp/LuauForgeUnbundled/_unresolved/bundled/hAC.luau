local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local module = require("@luauforge/bundled/eeo")
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useEventMap = ReactFocusNavigation.useEventMap
local useLastInputMethod = module.useLastInputMethod

local module2 = require("@luauforge/bundled/eeH")
local module3 = require("@luauforge/bundled/dYT")

local module4 = require("@luauforge/bundled/hAD")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local dropdownMenu = UIBlox.App.Menu.DropdownMenu

return function(props)
	local v5 = module2(module3)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v7 = useEventMap(React.useMemo(function()
		if not state2 then
			return {}
		end

		return {
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NoOpEvent,
			[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NoOpEvent
		}
	end, { state2 }), setState)
	local v8 = useLastInputMethod()
	local v9

	if module4() then
		v9 = (v8 == "Gamepad" or v8 == "Keyboard") and not isVRAppBuild()
	else
		v9 = v8 == "Gamepad" or v8 == "Keyboard"
	end

	local v10 = React.useCallback(function(p2)
		if props.analyticsContext then
			v5.EventStream:setRBXEvent(props.analyticsContext, "DropdownMenuState", {
				menuOpen = p2
			})
		end
	end, { v5, props.analyticsContext })

	local v11 = React.useCallback(function(p2)
		if props.analyticsContext then
			v5.EventStream:setRBXEvent(props.analyticsContext, "DropdownMenuSelect", {
				selection = tostring(p2)
			})
		end

		return props.onChange(p2)
	end, { v5, props.analyticsContext, props.onChange })

	local v12 = React.useCallback(function(p2)
		setState2(p2)
		v10(p2)
		setState3(false)

		if state and props.selectionGroupName then
			if p2 then
				GuiService:AddSelectionParent(props.selectionGroupName, state)
				ContextActionService:BindAction("CloseDropdownBind", function()
					setState3(true)
				end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
			else
				ContextActionService:UnbindAction("CloseDropdownBind")
				setState3(false)

				GuiService:RemoveSelectionGroup(props.selectionGroupName)

				if v9 then
					GuiService:Select(state)
				end
			end
		end

		if props.onMenuOpenChange then
			props.onMenuOpenChange(p2)
		end
	end, { state, props.selectionGroupName, props.onMenuOpenChange })

	local joined = Cryo.Dictionary.join(props, {
		onMenuOpenChange = v12,
		onChange = v11,
		selectionGroupName = Cryo.None,
		analyticsContext = Cryo.None,
		selectionOrder = 1,
		isForcedClosed = state3
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Selectable = false,
		ref = v7
	}, {
		DropdownMenu = React.createElement(dropdownMenu, joined)
	})
end
