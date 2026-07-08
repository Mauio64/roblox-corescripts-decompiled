local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local HideError = require(Actions.HideError)
local Constants = require(ParentParent.Constants)
local v8 = Roact.PureComponent:extend("ErrorMessage")

function v8.render(p1) -- line: 17
	-- upvalues: Constants (copy), Roact (copy)
	local v12 = Constants.Layouts[p1.props.layout]

	return Roact.createElement("Frame", {
		Size = v12.ErrorFrameSize,
		Position = v12.ErrorFramePosition,
		BackgroundColor3 = Constants.Colors.Black,
		BackgroundTransparency = Constants.ErrorFrameBackgroundTransparency,
		BorderSizePixel = Constants.ErrorFrameBorderSize,
		Selectable = false,
		Visible = p1.props.displayOptions.errorVisible,
		[Roact.Event.TouchTap] = function() -- line: 29
			-- upvalues: p1 (copy)
			p1.props.close()
		end,
		[Roact.Event.InputBegan] = function(_, p3) -- line: 33
			-- upvalues: p1 (copy)
			if p3.UserInputType == Enum.UserInputType.MouseButton1 then
				p1.props.close()
			end
		end
	}, {
		AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = v12.ErrorFrameAspectRatio
		}),
		SizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = v12.ErrorFrameMinSize,
			MaxSize = v12.ErrorFrameMaxSize
		}),
		ErrorIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v12.ErrorIconOffset, 0.5, 0),
			Size = UDim2.new(0.2, -v12.ErrorIconOffset * 2, 1, -v12.ErrorIconOffset * 2),
			Image = v12.ErrorIcon
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		}),
		ErrorText = Roact.createElement("TextLabel", {
			TextScaled = true,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.2, -v12.ErrorIconOffset, 0.5, 0),
			Size = UDim2.new(0.8, 0, 1, 0),
			Text = p1.props.displayOptions.errorText,
			TextSize = v12.ErrorTextSize,
			TextColor3 = Constants.Colors.White,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = v12.ErrorTextFont
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v12.ErrorFrameMaxSize.X, v12.ErrorTextSize + Constants.TextPadding)
			}),
			TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v12.ErrorTextSize
			})
		})
	})
end

local function mapStateToProps(p4) -- line: 86
	return {
		displayOptions = p4.displayOptions,
		layout = p4.layout
	}
end
local function mapDispatchToProps(p5) -- line: 93
	-- upvalues: HideError (copy)
	return {
		close = function() -- line: 95
			-- upvalues: p5 (copy), HideError (copy)
			return p5(HideError())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v8)
