local module = require("@luauforge/bundled/hUT")
local module2 = require("@luauforge/bundled/hUP")

local view = module.View
local divider = module.Divider

local module3 = require("@luauforge/bundled/hUR")
local windowProtocolService = module3.WindowProtocolService
local experienceService = module3.ExperienceService

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local module4 = require("@luauforge/bundled/hUU")

local useStyle = require("@luauforge/bundled/hUW").Core.Style.useStyle

local module5 = require("@luauforge/bundled/hUX")
local module6 = require("@luauforge/bundled/hUY")
local module7 = require("@luauforge/bundled/hVd")
local module8 = require("@luauforge/bundled/hVf")

local module9 = require("@luauforge/bundled/hVg")

return function(props)
	local state, setState = module2.useState(UserGameSettings:InFullScreen())

	local useState = module2.useState
	local v5 = if module9 then experienceService:IsInExperience() else false
	local state2, setState2 = useState(v5)

	module2.useEffect(function()
		local fullscreenChangedConnection = UserGameSettings.FullscreenChanged:Connect(function(p2)
			setState(p2)
		end)
		return function()
			fullscreenChangedConnection:Disconnect()
		end
	end, {})

	module2.useEffect(function()
		local connection = experienceService:RegisterForExperienceJoin(function()
			setState2(true)
		end)
		local connection2 = experienceService:RegisterForExperienceLeave(function()
			setState2(false)
		end)

		if module9 then
			setState2(experienceService:IsInExperience())
		end

		return function()
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {})
	local v6 = not (state or state2)
	local window = props.window

	module2.useEffect(function()
		local v9 = if state2 then Enum.TitleBarMode.Native else Enum.TitleBarMode.Custom
		windowProtocolService:SetTitleBarMode(window, v9)
	end, { state2, window })

	module2.useEffect(function()
		windowProtocolService:SetCustomTitleBarHeight(window, not v6 and 0 or props.height)
	end, { v6, window, props.height })

	module2.useEffect(function()
		return function()
			windowProtocolService:SetTitleBarMode(window, Enum.TitleBarMode.Native)
			windowProtocolService:SetCustomTitleBarHeight(window, 0)
		end
	end, { window })

	local v7 = useStyle()
	local v8 = module4()

	if not v6 then
		return nil
	end

	local createElement = module2.createElement
	local v10 = {
		backgroundStyle = {
			Color3 = v7.Theme.BackgroundDefault.Color,
			Transparency = v7.Theme.BackgroundDefault.Transparency
		},
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, props.height),
		testId = "custom-title-bar-root"
	}

	local children = {
		ShiftOverlay = module2.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v8.Color.Shift.Shift_100.Color3,
			BackgroundTransparency = v8.Color.Shift.Shift_100.Transparency,
			BorderSizePixel = 0,
			ZIndex = module5.SHIFT_OVERLAY_Z_INDEX
		}),
		DragArea = module2.createElement(module6, { window = window }),
		TitleLabel = 0,
		CaptionButtons = 0,
		BottomDivider = 0
	}

	local v11 = if props.title then module2.createElement(module8, {
		window = window,
		title = props.title
	}) else nil
	children.TitleLabel = v11

	children.CaptionButtons = module2.createElement(module7, { window = window })

	children.BottomDivider = module2.createElement(view, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		ZIndex = module5.BOTTOM_DIVIDER_Z_INDEX
	}, {
		Line = module2.createElement(divider, {})
	})
	return (createElement(view, v10, children))
end
