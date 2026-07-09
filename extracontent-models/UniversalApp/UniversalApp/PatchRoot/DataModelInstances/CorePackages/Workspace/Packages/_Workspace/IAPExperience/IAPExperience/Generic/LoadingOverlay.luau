local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)

require(scriptParentParentParent.React)

local Otter = require(scriptParentParentParent.Otter)
local UIBlox = require(scriptParentParentParent.UIBlox)
local Foundation = require(scriptParentParentParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local withStyle = UIBlox.Core.Style.withStyle
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local LoadingOverlayState = require(scriptParent.LoadingOverlayState)
local v13 = Roact.Component:extend(script.Name)
local t1 = {
	dampingRatio = 1,
	frequency = 1
}

function v13.init(p1) -- line: 36
	-- upvalues: Roact (copy), Otter (copy), t1 (copy)
	local v16, v17 = Roact.createBinding(0)

	p1.motor = Otter.createSingleMotor(0)
	p1.motor:start()
	p1.motor:onStep(v17)
	p1.animationProgress = v16
	p1.motor:setGoal(Otter.spring(p1.props.loadingState == nil and 0 or 1, t1))
end
function v13.getLoadingMessage(_: {[any]: any}, t3: {[any]: any}, p2) -- line: 48
	-- upvalues: LoadingOverlayState (copy)
	if p2 == LoadingOverlayState.PurchasingItem then
		return t3.PurchasingItem
	end

	if p2 == LoadingOverlayState.PurchasingRobux then
		return t3.PurchasingRobux
	end

	if p2 == LoadingOverlayState.WaitingForPurchase then
		return t3.WaitingForPurchase
	end

	if p2 == LoadingOverlayState.WaitingForRobux then
		return t3.WaitingForRobux
	end

	return nil
end
function v13.didUpdate(t4: {[any]: any}, t5: {[any]: any}, _) -- line: 61
	-- upvalues: Otter (copy), t1 (copy)
	local props = t4.props

	if t5.loadingState ~= props.loadingState then
		t4.motor:setGoal(Otter.spring(props.loadingState == nil and 0 or 1, t1))
	end
end
function v13.willUnmount(p4) -- line: 69
	p4.motor:destroy()
end
function v13.render(p5) -- line: 73
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			PurchasingItem = {
				key = "IAPExperience.Loading.Text.PurchasingItem"
			},
			PurchasingRobux = {
				key = "IAPExperience.Loading.Text.PurchasingRobux"
			},
			WaitingForPurchase = {
				key = "IAPExperience.Loading.Text.WaitingForPurchase"
			},
			WaitingForRobux = {
				key = "IAPExperience.Loading.Text.WaitingForRobux"
			}
		},
		render = function(t6: {[any]: any}) -- line: 89
			-- upvalues: p5 (copy)
			return p5:renderAlert(t6)
		end
	})
end
function v13.renderAlert(t7: {[any]: any}, t8: {[any]: any}) -- line: 95
	-- upvalues: LoadingOverlayState (copy), withStyle (copy), Roact (copy), Loading (copy), IconSize (copy)
	local props = t7.props
	local v30 = props.loadingState ~= LoadingOverlayState.None and props.loadingState ~= nil
	local v31 = t7:getLoadingMessage(t8, props.loadingState)

	return withStyle(function(p6) -- line: 101
		-- upvalues: Roact (copy), t7 (copy), props (copy), v30 (copy), Loading (copy), IconSize (copy), v31 (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font

		return Roact.createElement("Frame", {
			BackgroundColor3 = Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = t7.animationProgress:map(function(p7) -- line: 106
				-- upvalues: props (copy), Theme (copy)
				if props.showOverlay then
					if props.shouldAnimate then
						return 1 - (1 - Theme.BackgroundUIContrast.Transparency) * p7
					end

					return Theme.BackgroundUIContrast.Transparency
				end

				return 1
			end),
			Size = UDim2.new(1, 0, 1, 0),
			Visible = props.showOverlay
		}, {
			StopPropagationOverlay = Roact.createElement("TextButton", {
				Active = false,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Selectable = false,
				Text = "",
				ZIndex = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}),
			MiddleContent = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20),
					[Roact.Change.AbsoluteContentSize] = t7.onListLayoutAbsoluteContentSizeChanged
				}),
				Spinner = v30 and Roact.createElement(Loading, {
					size = IconSize.Large,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}) or nil,
				PreText = v31 and Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = p6Font.Body.Font,
					Text = v31,
					TextSize = p6Font.BaseSize * p6Font.Body.RelativeSize,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}) or nil
			}),
			Children = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, t7.props[Roact.Children])
		})
	end)
end

return v13
