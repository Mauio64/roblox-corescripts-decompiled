local module = require("@luauforge/deferred/eWI")
local module2 = require("@luauforge/deferred/eWH")

local view = module.View
local useTokens = module.Hooks.useTokens

local function ProgressBar(p2)
	local v5 = useTokens()

	return module2.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_500),
			BackgroundTransparency = 1
		},
		{
			Track = module2.createElement(
				view,
				{
					tag = "position-center-left anchor-center-left",
					Size = UDim2.new(1, 0, 0, v5.Size.Size_100),
					backgroundStyle = v5.Color.Shift.Shift_200,
					cornerRadius = UDim.new(0, v5.Radius.Circle)
				},
				{
					ProgressSegment = module2.createElement(view, {
						Size = p2.progress:map(function(value)
							return UDim2.fromScale(math.clamp(value, 0, 1), 1)
						end),
						backgroundStyle = v5.Color.Extended.White.White_100,
						cornerRadius = UDim.new(0, v5.Radius.Circle)
					})
				}
			)
		}
	)
end

return module2.memo(ProgressBar)
