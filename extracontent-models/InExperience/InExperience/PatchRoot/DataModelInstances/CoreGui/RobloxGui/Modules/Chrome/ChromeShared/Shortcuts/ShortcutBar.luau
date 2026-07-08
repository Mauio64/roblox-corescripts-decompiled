local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local GamepadConnector = require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local ShortcutBar = UIBlox.App.Navigation.ShortcutBar

require(CorePackages.Workspace.Packages.Chrome)

local Constants = require(ChromeShared.Unibar.Constants)
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useTokens = Foundation.Hooks.useTokens
local Service = require(ChromeShared.Service)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck

function ChromeShortcutBar(_) -- line: 28
	-- upvalues: React (copy), useTokens (copy), useObservableValue (copy), ViewportUtil (copy), FFlagGamepadIconSupportCheck (copy), GamepadConnector (copy), Service (copy), UserInputService (copy), isSpatial (copy), FFlagEnableConsoleExpControls (copy), ReactRoblox (copy), Constants (copy), ShortcutBar (copy), CoreGui (copy)
	local v21, v22 = React.useState({})
	local v23, v24 = React.useState({})
	local v25, v26 = React.useBinding(false)
	local v27 = useTokens()
	local v28 = useObservableValue(ViewportUtil.screenSize)
	local v29 = React.useRef(0)

	local function checkOverflow() -- line: 37
		-- upvalues: v29 (copy), v28 (copy), v21 (copy), v24 (copy)
		if v29.current > v28.X then
			local n1 = 1

			for v36, v37 in v21 do
				if v37.displayPriority <= v21[n1].displayPriority then
					n1 = v36
				end
			end

			local v38 = table.clone(v21)

			table.remove(v38, n1)
			v24(v38)
		end
	end

	React.useEffect(function() -- line: 54
		-- upvalues: v24 (copy), checkOverflow (copy)
		v24({})
		checkOverflow()
	end, { v28 })
	React.useEffect(function() -- line: 59
		-- upvalues: FFlagGamepadIconSupportCheck (copy), GamepadConnector (copy), Service (copy), v22 (copy), v24 (copy), UserInputService (copy), isSpatial (copy), FFlagEnableConsoleExpControls (copy), v26 (copy)
		local function updateShortcuts() -- line: 60
			-- upvalues: FFlagGamepadIconSupportCheck (copy), GamepadConnector (copy), Service (copy), v22 (copy), v24 (copy)
			if FFlagGamepadIconSupportCheck and not GamepadConnector:getGamepadActive():get() then
				return
			end

			local v46 = Service:getCurrentShortcuts()

			v22(v46)
			v24({})
		end

		Service:onShortcutBarChanged():connect(updateShortcuts)

		if FFlagGamepadIconSupportCheck then
			UserInputService.LastInputTypeChanged:Connect(updateShortcuts)
		end

		if not isSpatial() then
			local v40 = GamepadConnector:getShowTopBar()
			local v41 = GamepadConnector:getGamepadActive()

			if FFlagEnableConsoleExpControls then
				local function shouldHideShortcutBar() -- line: 79
					-- upvalues: v40 (copy), v41 (copy), Service (copy)
					local v47 = not v40:get() or not v41:get()

					Service:setHideShortcutBar("TopBar", v47)
				end

				local v43 = not v40:get() or not v41:get()

				Service:setHideShortcutBar("TopBar", v43)
				v40:connect(shouldHideShortcutBar)
				v41:connect(shouldHideShortcutBar)

				return
			end

			local function shouldShowShortcutBar() -- line: 87
				-- upvalues: v40 (copy), v41 (copy), v26 (copy)
				local v48 = v40:get() and v41:get()

				v26(v48)
			end

			v40:connect(shouldShowShortcutBar)
			v41:connect(shouldShowShortcutBar)
		end
	end, {})

	local t1 = {}

	for _, v33 in if not (#v23 > 0) then v21 else v23 do
		if v33.label then
			local t2 = {
				icon = "",
				text = ""
			}

			if v33.icon then
				t2.icon = v33.icon
			end

			t2.text = v33.label
			table.insert(t1, t2)
		end
	end

	return ReactRoblox.createPortal({
		Name = React.createElement("ScreenGui", {
			Name = "ShortcutBar",
			DisplayOrder = Constants.SHORTCUTBAR_DISPLAYORDER,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Enabled = if not FFlagEnableConsoleExpControls then v25 else nil
		}, { React.createElement("Frame", {
			Name = "ShortcutBarWrapper",
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 1, not v27 and 0 or -v27.Gap.Medium),
			AnchorPoint = Vector2.new(0.5, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = function(p2) -- line: 128
				-- upvalues: v29 (copy), checkOverflow (copy)
				v29.current = p2.AbsoluteSize.X
				checkOverflow()
			end
		}, {
			Layout = React.createElement("UIListLayout"),
			React.createElement(ShortcutBar, {
				items = t1
			})
		}) })
	}, CoreGui)
end

return ChromeShortcutBar
