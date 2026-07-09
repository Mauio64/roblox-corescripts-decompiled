local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Constants = require(Modules.LuaApp.Constants)
local FitChildren = require(Modules.LuaApp.FitChildren)
local RoactMotion = require(Modules.LuaApp.RoactMotion)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local LocalizedTextLabel = require(Modules.LuaApp.Components.LocalizedTextLabel)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT = Constants.DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT
local v12 = Roact.PureComponent:extend("FramePopup")

v12.defaultProps = {
	enableCancelButton = true,
	Selectable = false
}

function v12.init(p1) -- line: 31
	-- upvalues: Roact (copy), DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT (copy), DEPRECATED_ImageSetLabel (copy), LocalizedTextLabel (copy), Constants (copy), FitChildren (copy), withStyle (copy)
	p1.state = {
		hidden = true
	}
	p1.yAnchorPoint = not p1.state.hidden and 1 or 0
	p1.stiffness = nil
	p1.damping = nil
	p1.onRested = nil

	function p1.closeCallback() -- line: 42
		-- upvalues: p1 (copy)
		p1:close()
	end
	function p1.renderCancelButton(p2) -- line: 46
		-- upvalues: Roact (copy), DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT (copy), p1 (copy), DEPRECATED_ImageSetLabel (copy), LocalizedTextLabel (copy), Constants (copy)
		return Roact.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
			Size = UDim2.new(1, 0, 0, DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT),
			Text = "",
			[Roact.Event.Activated] = p1.closeCallback
		}, {
			Icon = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Image = "LuaApp/icons/navigation/close",
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = p2.Theme.IconDefault.Color,
				ImageTransparency = p2.Theme.IconDefault.Transparency,
				Position = UDim2.new(0, 20, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20)
			}),
			Cancel = Roact.createElement(LocalizedTextLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "Feature.GamePage.LabelCancelField",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Constants.Color.WHITE,
				Position = UDim2.new(0, 60, 0.5, 0),
				Size = UDim2.new(1, -70, 1, 0),
				Font = p2.Font.Body.Font,
				TextSize = p2.Font.BaseSize * p2.Font.Body.RelativeSize,
				TextColor3 = p2.Theme.TextDefault.Color,
				TextTransparency = p2.Theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end
	function p1.renderPopupFrame(p3, p4) -- line: 89
		-- upvalues: p1 (copy), Roact (copy), FitChildren (copy)
		local v24 = p1.props[Roact.Children]
		local enableCancelButton = p1.props.enableCancelButton
		local contentPosition = p1.props.contentPosition
		local screenSize = p1.props.screenSize
		local uDim2 = UDim2.new(0, 0, 1, 0)

		if contentPosition then
			uDim2 = UDim2.new(0, 0, 0, screenSize.Y)
		end

		local ReducedMotion = p3.Settings.ReducedMotion

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			Position = uDim2,
			AnchorPoint = if not ReducedMotion then Vector2.new(0, p4.animValue) else Vector2.new(0, 1),
			fitAxis = FitChildren.FitAxis.Height
		}, {
			UIPadding = contentPosition and Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, screenSize.X * contentPosition.X.Scale + contentPosition.X.Offset),
				PaddingBottom = UDim.new(0, screenSize.Y - (screenSize.Y * contentPosition.Y.Scale + contentPosition.Y.Offset))
			}),
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			Frame = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, v24),
			Separator = enableCancelButton and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				BackgroundColor3 = p3.Theme.BackgroundUIDefault.Color,
				BackgroundTransparency = p3.Theme.BackgroundUIDefault.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}, {
				SeparatorBar = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = p3.Theme.Divider.Color,
					BackgroundTransparency = p3.Theme.Divider.Transparency
				})
			}),
			Cancel = enableCancelButton and p1.renderCancelButton(p3)
		})
	end
	function p1.onRender(p5) -- line: 149
		-- upvalues: withStyle (copy), Roact (copy), p1 (copy)
		return withStyle(function(p6) -- line: 150
			-- upvalues: Roact (copy), p5 (copy), p1 (copy)
			if p6.Settings.ReducedMotion then
				return Roact.createElement("CanvasGroup", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					GroupTransparency = 1 - p5.animValue
				}, {
					PopupFrame = p1.renderPopupFrame(p6, p5)
				})
			end

			return p1.renderPopupFrame(p6, p5)
		end)
	end
end
function v12.open(p7) -- line: 168
	p7.yAnchorPoint = 1
	p7.stiffness = nil
	p7.damping = nil
	p7.onRested = nil
	p7:setState({
		hidden = false
	})
end
function v12.close(p8) -- line: 179
	local onCancel = p8.props.onCancel

	p8.yAnchorPoint = 0
	p8.stiffness = 270
	p8.damping = nil
	p8.onRested = onCancel
	p8:setState({
		hidden = true
	})
end
function v12.didMount(p9) -- line: 192
	p9:open()
end
function v12.render(p10) -- line: 196
	-- upvalues: Roact (copy), RoactMotion (copy)
	return Roact.createElement("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Text = "",
		[Roact.Event.Activated] = p10.closeCallback,
		Selectable = p10.props.Selectable
	}, {
		AnimatedPopup = Roact.createElement(RoactMotion.SimpleMotion, {
			style = {
				animValue = RoactMotion.spring(p10.yAnchorPoint, p10.stiffness, p10.damping)
			},
			onRested = p10.onRested,
			render = p10.onRender
		})
	})
end

return RoactRodux.connect(function(p11, _) -- line: 215
	return {
		screenSize = p11.ScreenSize
	}
end)(v12)
