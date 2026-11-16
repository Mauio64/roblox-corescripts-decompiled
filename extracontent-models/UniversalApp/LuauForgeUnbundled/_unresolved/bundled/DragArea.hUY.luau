local module = require("@luauforge/bundled/hUP")

local windowProtocolService = require("@luauforge/bundled/hUR").WindowProtocolService

local module2 = require("@luauforge/bundled/hUZ")
local module3 = require("@luauforge/bundled/hVa")
local module4 = require("@luauforge/bundled/hVb")

local module5 = require("@luauforge/bundled/hUX")

local function DragArea(p2)
	local window = p2.window

	local function onInputBegan(p3, p4)
		local userInputType = p4.UserInputType

		if
			userInputType ~= Enum.UserInputType.MouseButton1
			and userInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		if module3 then
			module2.default:logRobloxTelemetryCounter(module4.DragAreaInteraction, 1, {
				action = "DragBegan"
			})
		end

		windowProtocolService:BeginDrag(window)
	end

	local function onActivated(p3, p4, p5)
		if p5 ~= 1 then
			return
		end

		local userInputType = p4.UserInputType

		if
			userInputType ~= Enum.UserInputType.MouseButton1
			and userInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		if module3 then
			module2.default:logRobloxTelemetryCounter(module4.DragAreaInteraction, 1, {
				action = "DoubleClicked"
			})
		end

		windowProtocolService:OnDragAreaDoubleClicked(window)
	end

	local function onSecondaryActivated(p3, p4)
		if module3 then
			module2.default:logRobloxTelemetryCounter(module4.DragAreaInteraction, 1, {
				action = "RightClicked"
			})
		end

		windowProtocolService:OnDragAreaRightClicked(window)
	end

	return module.createElement("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = false,
		ZIndex = module5.DRAG_LAYER_Z_INDEX,
		[module.Event.InputBegan] = onInputBegan,
		[module.Event.Activated] = onActivated,
		[module.Event.SecondaryActivated] = onSecondaryActivated
	})
end

return DragArea
