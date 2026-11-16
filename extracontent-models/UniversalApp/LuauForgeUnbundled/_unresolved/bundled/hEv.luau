local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module3 = require("@luauforge/bundled/dwA")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module5 = require("@luauforge/bundled/edq")
local module6 = require("@luauforge/bundled/edi")
local module7 = require("@luauforge/bundled/fXo")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFacePlayerList
	and Foundation.Utility.Flags.FoundationFontFaceMigration

local DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT = module3.DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT

local extended = module.PureComponent:extend("FramePopup")

extended.defaultProps = { enableCancelButton = true, Selectable = false }

function extended:init()
	self.state = { hidden = true }

	self.yAnchorPoint = self.state.hidden and 0 or 1
	self.stiffness = nil
	self.damping = nil
	self.onRested = nil

	function self.closeCallback()
		self:close()
	end

	function self.renderCancelButton(props)
		local createElement = module.createElement
		local closeCallbacksByActivated = {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			BackgroundColor3 = props.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = props.Theme.BackgroundUIDefault.Transparency,
			Size = UDim2.new(1, 0, 0, DEFAULT_CONTEXTUAL_MENU_CANCEL_HEIGHT),
			Text = "",
			[module.Event.Activated] = self.closeCallback
		}
		local v6 = {
			Icon = module.createElement(module6, {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Image = "LuaApp/icons/navigation/close",
				ImageColor3 = props.Theme.IconDefault.Color,
				ImageTransparency = props.Theme.IconDefault.Transparency,
				Position = UDim2.new(0, 20, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20)
			}),
			Cancel = 0
		}

		local createElement2 = module.createElement
		local v8 = {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = module3.Color.WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 60, 0.5, 0),
			Size = UDim2.new(1, -70, 1, 0),
			Text = "Feature.GamePage.LabelCancelField",
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}

		local v9 = if not foundationFontFaceMigration then props.Font.Body.Font else nil
		v8.Font = v9

		local v10 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v8.FontFace = v10

		v8.TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		v8.TextColor3 = props.Theme.TextDefault.Color
		v8.TextTransparency = props.Theme.TextDefault.Transparency
		v8.TextXAlignment = Enum.TextXAlignment.Left
		v8.TextYAlignment = Enum.TextYAlignment.Center
		v6.Cancel = createElement2(module7, v8)
		return createElement("TextButton", closeCallbacksByActivated, v6)
	end

	function self.renderPopupFrame(p2, p3)
		local v5 = self.props[module.Children]
		local enableCancelButton = self.props.enableCancelButton
		local contentPosition = self.props.contentPosition
		local screenSize = self.props.screenSize

		local udim = UDim2.new(0, 0, 1, 0)

		if contentPosition then
			udim = UDim2.new(0, 0, 0, screenSize.Y)
		end

		local reducedMotion = p2.Settings.ReducedMotion

		local createElement = module.createElement
		local fitFrame = FitChildren.FitFrame
		local v6 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Position = udim,
			AnchorPoint = 0,
			BorderSizePixel = 0,
			fitAxis = 0
		}

		local v7 = if reducedMotion then Vector2.new(0, 1) else Vector2.new(0, p3.animValue)
		v6.AnchorPoint = v7

		v6.fitAxis = FitChildren.FitAxis.Height
		return createElement(fitFrame, v6, {
			UIPadding = contentPosition and module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, screenSize.X * contentPosition.X.Scale + contentPosition.X.Offset),
				PaddingBottom = UDim.new(
					0,
					screenSize.Y - (screenSize.Y * contentPosition.Y.Scale + contentPosition.Y.Offset)
				)
			}),
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			Frame = module.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, v5),
			Separator = enableCancelButton and module.createElement("Frame", {
				BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
				BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1)
			}, {
				SeparatorBar = module.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = p2.Theme.Divider.Color,
					BackgroundTransparency = p2.Theme.Divider.Transparency,
					BorderSizePixel = 0
				})
			}),
			Cancel = enableCancelButton and self.renderCancelButton(p2)
		})
	end

	function self.onRender(p2)
		return withStyle(function(p3)
			if p3.Settings.ReducedMotion then
				return module.createElement("CanvasGroup", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					GroupTransparency = 1 - p2.animValue
				}, { PopupFrame = self.renderPopupFrame(p3, p2) })
			end

			return self.renderPopupFrame(p3, p2)
		end)
	end
end

function extended:open()
	self.yAnchorPoint = 1
	self.stiffness = nil
	self.damping = nil
	self.onRested = nil

	self:setState({ hidden = false })
end

function extended:close()
	local onCancel = self.props.onCancel
	self.yAnchorPoint = 0

	self.stiffness = 270
	self.damping = nil
	self.onRested = onCancel

	self:setState({ hidden = true })
end

function extended:didMount()
	self:open()
end

function extended.render(props)
	return module.createElement("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Text = "",
		[module.Event.Activated] = props.closeCallback,
		Selectable = props.props.Selectable
	}, {
		AnimatedPopup = module.createElement(module5.SimpleMotion, {
			style = {
				animValue = module5.spring(props.yAnchorPoint, props.stiffness, props.damping)
			},
			onRested = props.onRested,
			render = props.onRender
		})
	})
end

return useSheetNavigation.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end)(extended)
