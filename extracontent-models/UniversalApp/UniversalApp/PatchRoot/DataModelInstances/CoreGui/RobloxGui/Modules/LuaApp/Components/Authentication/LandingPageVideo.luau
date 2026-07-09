local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local React = require(CorePackages.Packages.React)
local useState = React.useState

local function LandingPageVideo(t1: {[any]: any}) -- line: 34
	-- upvalues: useStyle (copy), React (copy), useState (copy), RunService (copy)
	local v8 = useStyle()
	local v9 = React.useRef(false)
	local v10, v11 = useState(1)

	React.useEffect(function() -- line: 54
		-- upvalues: RunService (copy)
		RunService:setThrottleFramerateEnabled(false)

		return function() -- line: 56
			-- upvalues: RunService (copy)
			RunService:setThrottleFramerateEnabled(true)
		end
	end, {})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		VideoBox = React.createElement("Frame", {
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, t1.videoBottomOffsetHeight * -1)
		}, {
			Video = React.createElement("VideoFrame", {
				Video = t1.landingVideoAsset,
				Size = (function() -- line: 39
					-- upvalues: t1 (copy), v10 (copy)
					if t1.screenSize.X / (t1.screenSize.Y - t1.videoBottomOffsetHeight) < v10 then
						return UDim2.new(0, 1e999, 1, 0)
					end

					return UDim2.new(1, 0, 0, 1e999)
				end)(),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Looped = true,
				Playing = true,
				Volume = 0,
				BorderSizePixel = 0,
				[React.Event.Loaded] = function(p1) -- line: 61
					-- upvalues: v11 (copy)
					local Resolution = p1.Resolution

					if Resolution.X > 0 and Resolution.Y > 0 then
						v11(Resolution.X / Resolution.Y)
					end
				end,
				ref = v9
			}, {
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
					AspectRatio = v10,
					AspectType = Enum.AspectType.FitWithinMaxSize
				})
			})
		}),
		FadeToBlack = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, t1.videoBottomOffsetGradientHeight),
			Position = UDim2.new(0, 0, 1, t1.videoBottomOffsetHeight * -1 + 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v8.Theme.DropShadow.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 270,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v8.Theme.DropShadow.Color),
					ColorSequenceKeypoint.new(1, v8.Theme.DropShadow.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		BlackBackground = React.createElement("Frame", {
			Visible = true,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, t1.videoBottomOffsetHeight),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v8.Theme.BackgroundUIContrast.Color
		})
	})
end

return LandingPageVideo
