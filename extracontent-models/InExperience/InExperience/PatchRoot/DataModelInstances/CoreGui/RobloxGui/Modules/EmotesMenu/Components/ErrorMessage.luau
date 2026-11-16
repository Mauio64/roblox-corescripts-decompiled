local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local actions = parent.Actions
local HideError = require(actions.HideError)

local Constants = require(parent.Constants)

local extended = Roact.PureComponent:extend("ErrorMessage")

function extended.render(p)
	local layout = Constants.Layouts[p.props.layout]

	return Roact.createElement("Frame", {
		Size = layout.ErrorFrameSize,
		Position = layout.ErrorFramePosition,
		BackgroundColor3 = Constants.Colors.Black,
		BackgroundTransparency = Constants.ErrorFrameBackgroundTransparency,
		BorderSizePixel = Constants.ErrorFrameBorderSize,
		Selectable = false,
		Visible = p.props.displayOptions.errorVisible,
		[Roact.Event.TouchTap] = function()
			p.props.close()
		end,
		[Roact.Event.InputBegan] = function(_, p2)
			if p2.UserInputType == Enum.UserInputType.MouseButton1 then
				p.props.close()
			end
		end
	}, {
		AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = layout.ErrorFrameAspectRatio
		}),
		SizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = layout.ErrorFrameMinSize,
			MaxSize = layout.ErrorFrameMaxSize
		}),
		ErrorIcon = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, layout.ErrorIconOffset, 0.5, 0),
			Size = UDim2.new(0.2, -layout.ErrorIconOffset * 2, 1, -layout.ErrorIconOffset * 2),
			Image = layout.ErrorIcon,
			BackgroundTransparency = 1
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		}),
		ErrorText = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.2, -layout.ErrorIconOffset, 0.5, 0),
			Size = UDim2.new(0.8, 0, 1, 0),
			Text = p.props.displayOptions.errorText,
			TextScaled = true,
			TextSize = layout.ErrorTextSize,
			TextColor3 = Constants.Colors.White,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = layout.ErrorTextFont,
			BackgroundTransparency = 1
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(layout.ErrorFrameMaxSize.X, layout.ErrorTextSize + Constants.TextPadding)
			}),
			TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = layout.ErrorTextSize
			})
		})
	})
end

local function mapStateToProps(p)
	return { displayOptions = p.displayOptions, layout = p.layout }
end

local function mapDispatchToProps(callback)
	return {
		close = function()
			return callback(HideError())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
