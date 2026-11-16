local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFp")

local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens

local text = module2.Text
local view = module2.View
local iconButton = module2.IconButton
local buttonVariant = module2.Enums.ButtonVariant
local iconName = module2.Enums.IconName
local inputSize = module2.Enums.InputSize

local function LoginV2DialogHeader(props)
	local v5 = useDesignTokens()

	local createElement = module.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement2 = module.createElement

	local v10 = if props.titleTopOffset then UDim2.fromOffset(0, props.titleTopOffset) else nil

	local v12 = if props.onBack then module.createElement("Frame", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		UIPadding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -v5.Size.Size_250)
		}),
		Button = module.createElement(iconButton, {
			icon = iconName.ChevronLargeLeft,
			variant = buttonVariant.Utility,
			size = inputSize.Medium,
			isCircular = true,
			onActivated = props.onBack,
			isDisabled = props.isDisabled
		})
	}) else nil
	return createElement("Frame", v7, {
		TitleRow = createElement2(
			view,
			{
				tag = "row align-y-center items-center gap-small size-full-1000",
				Position = v10
			},
			{
				BackButton = v12,
				Title = module.createElement(text, {
					LayoutOrder = 2,
					Text = props.titleText,
					tag = "shrink size-full-0 auto-y text-heading-small text-align-x-left content-emphasis"
				})
			}
		),
		NavButton = module.createElement(iconButton, {
			icon = props.icon,
			variant = buttonVariant.Utility,
			size = inputSize.Medium,
			isCircular = true,
			onActivated = props.onActivated,
			isDisabled = props.isDisabled,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0)
		})
	})
end

return LoginV2DialogHeader
