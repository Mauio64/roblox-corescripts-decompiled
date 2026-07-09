local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local Constants = require(script.Parent.Constants)
local Flags = require(script.Parent.Flags)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local Menu = Foundation.Menu
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local FFlagTraversalHistoryMenuFocusNavFix = Flags.FFlagTraversalHistoryMenuFocusNavFix
local FFlagFixTraversalHistoryMenuFixesV3 = Flags.FFlagFixTraversalHistoryMenuFixesV3

local function formatTags(p1) -- line: 43
	if typeof(p1) == "table" then
		return p1
	end

	return {
		[p1] = true
	}
end
local function setMenuSelection(p2, p3, p4) -- line: 50
	-- upvalues: PopoverSide (copy)
	if not p2 or not p2.current then
		return
	end

	if p4 == PopoverSide.Top then
		p2.current.NextSelectionUp = p3

		return
	end

	if p4 == PopoverSide.Bottom then
		p2.current.NextSelectionDown = p3
	end
end
local function HistoryMenu(t1: {[any]: any}, p5) -- line: 65
	-- upvalues: FFlagFixTraversalHistoryMenuFixesV3 (copy), React (copy), Constants (copy), useLocalization (copy), PopoverSide (copy), Cryo (copy), FFlagTraversalHistoryMenuFocusNavFix (copy), TraversalTelemetry (copy), IconName (copy), View (copy), Icon (copy), Menu (copy), PopoverAlign (copy)
	local v27 = nil

	if not FFlagFixTraversalHistoryMenuFixesV3 then
		v27 = React.useRef(nil)
	end

	local v28 = if t1.idleButtonStateIsDown == nil then Constants.DEFAULT_CHEVRON_BUTTON_STATE else t1.idleButtonStateIsDown
	local v29, v30 = React.useState(false)
	local v31 = v29 and not v28 or not v29 and v28
	local v32 = useLocalization({
		history = "CoreScripts.TopBar.Traversal.History"
	})
	local v33 = if not FFlagFixTraversalHistoryMenuFixesV3 then nil else React.useRef(nil)
	local v34 = nil

	if FFlagFixTraversalHistoryMenuFixesV3 then
		v34 = React.useCallback(function(p6) -- line: 88
			-- upvalues: v33 (copy), t1 (copy), PopoverSide (copy)
			local v42 = v33
			local menuSide = t1.menuSide

			if v42 then
				if not v42.current then
					return
				end

				if menuSide == PopoverSide.Top then
					v42.current.NextSelectionUp = p6

					return
				end

				if menuSide == PopoverSide.Bottom then
					v42.current.NextSelectionDown = p6
				end
			end
		end, { t1.menuSide })
	end

	local v35 = React.useMemo(function() -- line: 93
		-- upvalues: t1 (copy), Cryo (copy)
		local v45

		if t1.historyButtonTags then
			local historyButtonTags = t1.historyButtonTags

			v45 = if typeof(historyButtonTags) ~= "table" then {
				[historyButtonTags] = true
			} else historyButtonTags
		else
			v45 = {}
		end

		return Cryo.Dictionary.join({
			["row auto-xy align-y-center align-x-center radius-medium"] = true
		}, v45)
	end, { t1.historyButtonTags })
	local v36 = React.useCallback(function() -- line: 100
		-- upvalues: t1 (copy), v29 (copy), v30 (copy)
		if t1.onMenuToggled then
			t1.onMenuToggled(not v29)
		end

		v30(not v29)
	end, {
		v29,
		t1.onMenuToggled
	})
	local v37 = React.useCallback(function() -- line: 108
		-- upvalues: v30 (copy), FFlagTraversalHistoryMenuFocusNavFix (copy), t1 (copy)
		v30(false)

		if FFlagTraversalHistoryMenuFocusNavFix and t1.onMenuToggled then
			t1.onMenuToggled(false)
		end
	end, {})

	if FFlagTraversalHistoryMenuFocusNavFix then
		React.useEffect(function() -- line: 116
			-- upvalues: t1 (copy), v37 (copy)
			if not t1.closeMenuConn then
				return
			end

			local v46 = t1.closeMenuConn(v37)

			return function() -- line: 122
				-- upvalues: v46 (copy)
				for _, v51 in v46 do
					v51:Disconnect()
				end
			end
		end, {
			t1.closeMenuConn,
			v37
		})
	else
		React.useEffect(function() -- line: 129
			-- upvalues: t1 (copy), v37 (copy)
			if t1.forceMenuClose then
				v37()
			end
		end, {
			t1.forceMenuClose,
			v37
		})
	end

	local v38 = React.useCallback(function(n1: number) -- line: 136
		-- upvalues: TraversalTelemetry (copy), v37 (copy), t1 (copy)
		TraversalTelemetry.sendHistoryMenuItemClick({
			integration_id = "history_dropdown",
			event_type = "click",
			destination_universe_id = tostring(n1)
		})
		v37()

		if not t1.onMenuItemSelected then
			return
		end

		t1.onMenuItemSelected(n1)
	end, {
		v37,
		t1.onMenuItemSelected
	})
	local v39 = React.useCallback(function() -- line: 150
		-- upvalues: TraversalTelemetry (copy), v37 (copy), t1 (copy)
		TraversalTelemetry.sendHistoryMenuHistoryClick({
			integration_id = "history_landing",
			event_type = "click"
		})
		v37()
		t1.onHistorySelected()
	end, {
		v37,
		t1.onHistorySelected
	})
	local v40 = React.useMemo(function() -- line: 160
		-- upvalues: Cryo (copy), t1 (copy), v32 (copy), IconName (copy), v39 (copy)
		local v48 = Cryo.List.map(t1.historyItems, function(p7) -- line: 161
			return {
				id = p7.universeId,
				text = p7.text,
				icon = p7.icon
			}
		end)
		local t2 = {
			id = "history",
			text = v32.history,
			icon = IconName.ClockSpinReverse,
			onActivated = v39
		}

		return (Cryo.List.join(v48, { t2 }))
	end, { t1.historyItems })

	return React.createElement(View, {
		tag = "auto-xy"
	}, {
		ChevronButton = React.createElement(View, {
			testId = "--chevron-button",
			tag = v35,
			onActivated = function() -- line: 184
				-- upvalues: TraversalTelemetry (copy), v29 (copy), v36 (copy)
				TraversalTelemetry.sendHistoryMenuButtonActionEvent({
					integration_id = "history_chevron",
					event_type = v29 and "close" or "open"
				})
				v36()
			end,
			ref = if not FFlagFixTraversalHistoryMenuFixesV3 then if not p5 then v27 else nil else v33
		}, {
			Chevron = React.createElement(Icon, {
				name = if not v31 then IconName.ChevronLargeUp else IconName.ChevronLargeDown
			})
		}),
		Menu = React.createElement(Menu, {
			align = PopoverAlign.Start,
			anchorRef = p5 or if not FFlagFixTraversalHistoryMenuFixesV3 then v27 else v33,
			isOpen = v29,
			items = v40,
			onActivated = v38,
			onPressedOutside = v37,
			side = t1.menuSide,
			size = t1.menuSize,
			width = if not FFlagFixTraversalHistoryMenuFixesV3 or (not p5 or not p5.current) then nil else UDim.new(0, p5.current.AbsoluteSize.X),
			ref = if not FFlagFixTraversalHistoryMenuFixesV3 then nil else v34
		})
	})
end

return React.memo(React.forwardRef(HistoryMenu))
