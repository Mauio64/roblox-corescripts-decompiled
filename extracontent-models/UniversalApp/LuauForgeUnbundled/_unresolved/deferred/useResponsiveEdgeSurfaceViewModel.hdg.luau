local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/deferred/hcT")
local module2 = require("@luauforge/deferred/hcS")

require("@luauforge/deferred/hdf")

local v5 = { guiService = GuiService, userInputService = UserInputService }

local function useResponsiveEdgeSurfaceViewModel(p2, p3)
	local v6 = p3 or v5
	local guiService = v6.guiService
	local userInputService = v6.userInputService
	local v7 = module.Hooks.useTokens()

	local ref = module2.useRef(nil)
	local state, setState = module2.useState(true)
	local state2, setState2 = module2.useState(0)
	local state3, setState3 = module2.useState(0)
	local state4, setState4 = module2.useState(guiService.ViewportDisplaySize)

	local v8 = module2.useCallback(function(p4)
		local v9 = p4 or ref.current

		if v9 == nil or not userInputService.OnScreenKeyboardVisible then
			setState3(0)
			return
		end

		local v10 = v9.AbsolutePosition.Y + v9.AbsoluteSize.Y
		setState3((math.clamp(
			v10 - userInputService.OnScreenKeyboardPosition.Y,
			0,
			userInputService.OnScreenKeyboardSize.Y
		)))
	end, { userInputService })

	local v9 = module2.useCallback(function(current)
		if current == nil then
			ref.current = nil
			return
		end

		ref.current = current
		setState(current.AbsoluteSize.X > current.AbsoluteSize.Y)
		setState2(current.AbsoluteSize.X)
		v8(current)
	end, { v8 })

	module2.useEffect(function()
		local viewportDisplaySizeChangedConnection = guiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
			setState4(guiService.ViewportDisplaySize)
		end)
		local v10 = {
			userInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
				v8()
			end),
			userInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(function()
				v8()
			end),
			userInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(function()
				v8()
			end)
		}

		return function()
			viewportDisplaySizeChangedConnection:Disconnect()

			for k, connection in v10 do
				connection:Disconnect()
			end
		end
	end, { guiService, v8, userInputService })

	local scale = v7.Config.UI.Scale
	local v10 = math.clamp(state2 * 0.4, 360 * scale, 440 * scale)

	return {
		children = p2.children,
		isDocked = state4 == Enum.DisplaySize.Small and not state,
		sideWidth = v10,
		keyboardInset = state3,
		margin = v7.Padding.Medium,
		shadowStyle = v7.Color.Extended.Black.Black_10,
		hostRef = v9,
		onHostMeasured = v9,
		LayoutOrder = p2.LayoutOrder
	}
end

return useResponsiveEdgeSurfaceViewModel
