local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Otter")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local LoadingOverlayState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LoadingOverlayState")

local extended = Roact.Component:extend("LoadingOverlay")

local v5 = { dampingRatio = 1, frequency = 1 }

function extended:init()
	local binding, v6 = Roact.createBinding(0)

	self.motor = Otter.createSingleMotor(0)
	self.motor:start()

	self.motor:onStep(v6)
	self.animationProgress = binding

	self.motor:setGoal(Otter.spring(self.props.loadingState == nil and 0 or 1, v5))
end

function extended:getLoadingMessage(data, p3)
	if p3 == LoadingOverlayState.PurchasingItem then
		return data.PurchasingItem
	end

	if p3 == LoadingOverlayState.PurchasingRobux then
		return data.PurchasingRobux
	end

	if p3 == LoadingOverlayState.WaitingForPurchase then
		return data.WaitingForPurchase
	end

	if p3 == LoadingOverlayState.WaitingForRobux then
		return data.WaitingForRobux
	end

	return nil
end

function extended.didUpdate(p2, p3, p4)
	local props = p2.props

	if p3.loadingState ~= props.loadingState then
		p2.motor:setGoal(Otter.spring(props.loadingState == nil and 0 or 1, v5))
	end
end

function extended.willUnmount(p2)
	p2.motor:destroy()
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			PurchasingItem = { key = "IAPExperience.Loading.Text.PurchasingItem" },
			PurchasingRobux = { key = "IAPExperience.Loading.Text.PurchasingRobux" },
			WaitingForPurchase = {
				key = "IAPExperience.Loading.Text.WaitingForPurchase"
			},
			WaitingForRobux = { key = "IAPExperience.Loading.Text.WaitingForRobux" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(p2)
	local props = self.props

	local v6 = not (props.loadingState == LoadingOverlayState.None) and props.loadingState ~= nil
	local loadingMessage = self:getLoadingMessage(p2, props.loadingState)

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		return Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			BackgroundTransparency = self.animationProgress:map(function(p3)
				if not props.showOverlay then
					return 1
				end

				if props.shouldAnimate then
					return 1 - (1 - theme.BackgroundUIContrast.Transparency) * p3
				end

				return theme.BackgroundUIContrast.Transparency
			end),
			Size = UDim2.new(1, 0, 1, 0),
			Visible = props.showOverlay
		}, {
			StopPropagationOverlay = Roact.createElement("TextButton", {
				Active = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Selectable = false,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				ZIndex = 0
			}),
			MiddleContent = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ZIndex = 1
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 20),
						[Roact.Change.AbsoluteContentSize] = self.onListLayoutAbsoluteContentSizeChanged
					}),
					Spinner = v6 and Roact.createElement(loading, {
						size = iconSize.Large,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					}) or nil,
					PreText = loadingMessage and Roact.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextWrapped = true,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = loadingMessage,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency
					}) or nil
				}
			),
			Children = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				},
				self.props[Roact.Children]
			)
		})
	end)
end

return extended
