local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local UIBlox = require(Parent.UIBlox)
local useFocusedTextBox = require(Parent.FocusNavigationUtils).useFocusedTextBox
local ShortcutBar = UIBlox.App.Navigation.ShortcutBar
local v8 = game:DefineFastFlag("ShortcutBarMinSize", false)
local v9 = game:DefineFastFlag("DisableAppShortcutBarAndroidTV", false)

function AppShortcutBar(t1: {[any]: any}) -- line: 23
	-- upvalues: useFocusedTextBox (copy), Responsive (copy), React (copy), UserInputService (copy), v9 (copy), v8 (copy), ShortcutBar (copy)
	local v11 = if not t1.Position then UDim2.fromScale(0.5, 0) else t1.Position
	local v12 = if not t1.AnchorPoint then Vector2.new(0.5, 0) else t1.AnchorPoint
	local v13 = useFocusedTextBox()
	local v14 = Responsive.useLastInput()
	local v15, v16 = React.useState(v14 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.Thumbstick1))

	if v9 then
		React.useEffect(function() -- line: 34
			-- upvalues: UserInputService (copy), v16 (copy), v14 (copy), Responsive (copy)
			local connection = UserInputService.LastInputTypeChanged:Connect(function() -- line: 35
				-- upvalues: v16 (copy), v14 (copy), Responsive (copy), UserInputService (copy)
				v16(v14 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(UserInputService:GetLastInputType(), Enum.KeyCode.Thumbstick1))
			end)

			return function() -- line: 44
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { v14 })
	end

	local v17 = #t1.items > 0 and (not v13 and (not v9 or v15))

	if v8 then
		local v18 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v19 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)
		local v20 = not v18 and not v19

		v17 = v17 and v20
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = if not v8 or not t1.Size then UDim2.fromScale(1, 1) else t1.Size
	}, if not v17 then nil else React.createElement(ShortcutBar, {
		items = t1.items,
		position = v11,
		anchorPoint = v12
	}))
end

return AppShortcutBar
