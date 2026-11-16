local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
require(parent3.React)
local Otter = require(parent3.Otter)

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)

local LoadingOverlayState = require(parent.LoadingOverlayState)

local extended = Roact.Component:extend(script.Name)

local v = { dampingRatio = 1, frequency = 1 }

function extended:init()
	local binding, v2 = Roact.createBinding(0)

	self.motor = Otter.createSingleMotor(0)
	self.motor:start()

	self.motor:onStep(v2)
	self.animationProgress = binding

	self.motor:setGoal(Otter.spring(self.props.loadingState == nil and 0 or 1, v))
end

function extended:getLoadingMessage(data, p)
	if p == LoadingOverlayState.PurchasingItem then
		return data.PurchasingItem
	end

	if p == LoadingOverlayState.PurchasingRobux then
		return data.PurchasingRobux
	end

	if p == LoadingOverlayState.WaitingForPurchase then
		return data.WaitingForPurchase
	end

	if p == LoadingOverlayState.WaitingForRobux then
		return data.WaitingForRobux
	end

	return nil
end

function extended.didUpdate(p, p2, _)
	local props = p.props

	if p2.loadingState ~= props.loadingState then
		p.motor:setGoal(Otter.spring(props.loadingState == nil and 0 or 1, v))
	end
end

function extended.willUnmount(p)
	p.motor:destroy()
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			PurchasingItem = { key = "IAPExperience.Loading.Text.PurchasingItem" },
			PurchasingRobux = { key = "IAPExperience.Loading.Text.PurchasingRobux" },
			WaitingForPurchase = { key = "IAPExperience.Loading.Text.WaitingForPurchase" },
			WaitingForRobux = { key = "IAPExperience.Loading.Text.WaitingForRobux" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(p)
	local props = self.props
	local v2

	if props.loadingState == LoadingOverlayState.None then
		v2 = false
	else
		v2 = props.loadingState ~= nil
	end

	local loadingMessage = self:getLoadingMessage(p, props.loadingState)

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		local createElement = Roact.createElement
		local v3 = {
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			BackgroundTransparency = self.animationProgress:map(function(p2)
				if not props.showOverlay then
					return 1
				end

				if props.shouldAnimate then
					return 1 - (1 - theme.BackgroundUIContrast.Transparency) * p2
				end

				return theme.BackgroundUIContrast.Transparency
			end),
			Size = UDim2.new(1, 0, 1, 0),
			Visible = props.showOverlay
		}
		local children = {
			StopPropagationOverlay = Roact.createElement("TextButton", {
				Active = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Selectable = false,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				ZIndex = 0
			}),
			MiddleContent = 0,
			Children = 0
		}

		local createElement2 = Roact.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ZIndex = 1
		}

		local v5 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20),
				[Roact.Change.AbsoluteContentSize] = self.onListLayoutAbsoluteContentSizeChanged
			}),
			Spinner = v2 and Roact.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}) or nil,
			PreText = 0
		}
		local preText

		if loadingMessage then
			local createElement3 = Roact.createElement
			local v6 = {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextWrapped = true,
				Font = 0,
				FontFace = 0,
				Text = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = font.Body.Font
			end

			v6.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
			end

			v6.FontFace = fontFace

			v6.Text = loadingMessage
			v6.TextSize = font.BaseSize * font.Body.RelativeSize
			v6.TextColor3 = theme.TextDefault.Color
			v6.TextTransparency = theme.TextDefault.Transparency
			preText = createElement3("TextLabel", v6) or nil
		end

		v5.PreText = preText
		children.MiddleContent = createElement2("Frame", v4, v5)

		children.Children = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
			self.props[Roact.Children]
		)
		return createElement("Frame", v3, children)
	end)
end

return extended
