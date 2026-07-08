local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local FitFrameVertical = require(scriptParentParentParent.RoactFitComponents).FitFrameVertical
local UIBlox = require(scriptParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local ProductDetails = require(scriptParent.ProductDetails)
local v12 = Roact.Component:extend(script.Name)

v12.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v12.init(p1) -- line: 44
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0),
		footerSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 51
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
end
function v12.render(p3) -- line: 60
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientRobuxTitle = {
				key = "IAPExperience.InsufficientRobux.Title.InsufficientRobux"
			},
			YouNeed = {
				key = "IAPExperience.InsufficientRobux.Text.YouNeed"
			},
			RobuxStore = {
				key = "IAPExperience.InsufficientRobux.Action.RobuxStore"
			},
			ButtonCancel = {
				key = "IAPExperience.InsufficientRobux.Action.Cancel"
			}
		},
		render = function(t1: {[any]: any}) -- line: 76
			-- upvalues: p3 (copy)
			return p3:renderAlert(t1)
		end
	})
end
function v12.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 82
	-- upvalues: withStyle (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ProductDetails (copy), ButtonType (copy)
	local props = t2.props

	return withStyle(function(p4) -- line: 85
		-- upvalues: props (copy), t3 (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), t2 (copy), ProductDetails (copy), ButtonType (copy)
		local Theme = p4.Theme
		local p4Font = p4.Font
		local color3 = Color3.new(math.round(Theme.TextEmphasis.Color.R * 255), math.round(Theme.TextEmphasis.Color.G * 255), (math.round(Theme.TextEmphasis.Color.B * 255)))
		local v24 = props.itemRobuxCost - props.balanceAmount
		local v25 = string.format("<font color=\"rgb(%s)\">%s%s</font>", tostring(color3), utf8.char(57346), (tostring(v24)))
		local v26 = t3.YouNeed:gsub("{robux}", v25)

		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = t3.InsufficientRobuxTitle,
			middleContent = function() -- line: 109
				-- upvalues: Roact (copy), FitFrameVertical (copy), t2 (copy), ProductDetails (copy), props (copy), Theme (copy), p4Font (copy), v26 (copy)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 15),
					[Roact.Ref] = t2.contentRef,
					[Roact.Change.AbsoluteSize] = t2.changeContentSize
				}, {
					ProductDetails = Roact.createElement(ProductDetails, {
						layoutOrder = 1,
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					}),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					AdditionalBuyText = Roact.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						RichText = true,
						TextWrapped = true,
						Size = UDim2.new(0, t2.state.contentSize.X, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Font = p4Font.Body.Font,
						Text = v26,
						TextSize = p4Font.BaseSize * p4Font.Body.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextTransparency = Theme.TextDefault.Transparency
					})
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = props.cancelPurchaseActivated,
							text = t3.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.robuxStoreActivated,
							text = t3.RobuxStore,
							inputIcon = props.acceptControllerIcon
						}
					}
				}
			}
		})
	end)
end

return v12
