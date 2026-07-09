local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local DateTime = require(CorePackages.Workspace.Packages.Time).DateTime
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local DevSubPlanStatus = require(Modules.LuaApp.Enum.DevSubPlanStatus)
local v13 = Roact.PureComponent:extend("DevSubListItem")
local _ = {
	TOP = 15,
	LEFT = 24,
	RIGHT = 25
}

v13.defaultProps = {
	layoutOrder = 0
}

function v13.getRenewalText(_, p2, p3) -- line: 39
	if p2.isAutoRenewing then
		return p3.renewalDate
	end

	return p3.expirationDate
end
function v13.render(p4) -- line: 47
	-- upvalues: DateTime (copy), withLocalization (copy), withStyle (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DevSubStatus (copy), DevSubPlanStatus (copy), DEPRECATED_ImageSetLabel (copy), Cryo (copy)
	local devSub = p4.props.devSub
	local Values = DateTime.fromIsoDate(devSub.expirationDate):GetValues()
	local v21 = string.format("%d/%d/%d", Values.Month, Values.Day, Values.Year)

	return withLocalization({
		monthlyPrice = {
			"Feature.DevSubs.UserManagement.MonthlyPrice",
			robuxAmount = devSub.price
		},
		renewalDate = {
			"Feature.DevSubs.Label.RenewalDate",
			date = v21
		},
		expirationDate = {
			"Feature.DevSubs.Label.ExpirationDate",
			date = v21
		},
		discontinueDate = {
			"Feature.DevSubs.Label.DiscontinueDate",
			date = v21
		}
	})(function(p5) -- line: 58
		-- upvalues: withStyle (copy), p4 (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DevSubStatus (copy), DevSubPlanStatus (copy), DEPRECATED_ImageSetLabel (copy), Cryo (copy)
		return withStyle(function(p6) -- line: 59
			-- upvalues: p4 (copy), p5 (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DevSubStatus (copy), DevSubPlanStatus (copy), DEPRECATED_ImageSetLabel (copy), Cryo (copy)
			local props = p4.props
			local devSub2 = props.devSub
			local layoutOrder = props.layoutOrder
			local maxSize = props.maxSize
			local hasFullDivider = props.hasFullDivider
			local onActivated = props.onActivated
			local uDim2, uDim2_2

			if hasFullDivider then
				uDim2 = UDim2.new(1, 49, 0, 1)
				uDim2_2 = UDim2.new(0, -24, 0, -15)
			else
				uDim2 = UDim2.new(1, 25, 0, 1)
				uDim2_2 = UDim2.new(0, 0, 0, -15)
			end

			local t1

			if devSub2.isAutoRenewing then
				t1 = {
					Font = p6.Font.CaptionBody.Font,
					TextSize = p6.Font.BaseSize * p6.Font.CaptionBody.RelativeSize,
					TextColor3 = p6.Theme.TextDefault.Color,
					TextTransparency = p6.Theme.TextDefault.Transparency,
					Text = p5.renewalDate
				}
			else
				t1 = {
					Font = p6.Font.CaptionHeader.Font,
					TextSize = p6.Font.BaseSize * p6.Font.CaptionHeader.RelativeSize,
					TextColor3 = p6.Theme.TextEmphasis.Color,
					TextTransparency = p6.Theme.TextEmphasis.Transparency,
					Text = p5.expirationDate
				}

				if devSub2.planStatus ~= "Open" then
					t1.Text = p5.discontinueDate
				end
			end

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, maxSize.Y),
				LayoutOrder = layoutOrder
			}, {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = maxSize
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 15),
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 25)
				}),
				MoreButton = Roact.createElement(DEPRECATED_ImageSetButton, {
					Image = "LuaApp/icons/navbar_more",
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.new(0, 26, 0, 26),
					Position = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Visible = devSub2.status == DevSubStatus.Active and devSub2.planStatus == DevSubPlanStatus.Open,
					[Roact.Event.Activated] = function(p7) -- line: 123
						-- upvalues: onActivated (copy)
						onActivated(p7.AbsolutePosition, p7.AbsoluteSize)
					end
				}),
				TextFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -51, 1, 0)
				}, {
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					Title = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 22),
						Font = p6.Font.Header2.Font,
						TextSize = p6.Font.BaseSize * p6.Font.Header2.RelativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = p6.Theme.TextDefault.Color,
						TextTransparency = p6.Theme.TextDefault.Transparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = devSub2.name
					}),
					PriceFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 17)
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						Icon = Roact.createElement(DEPRECATED_ImageSetLabel, {
							BackgroundTransparency = 1,
							Image = "LuaApp/icons/robux-hex",
							LayoutOrder = 1,
							Size = UDim2.new(0, 17, 0, 17)
						}),
						Text = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(1, -21, 1, 0),
							Font = p6.Font.CaptionBody.Font,
							TextSize = p6.Font.BaseSize * p6.Font.CaptionBody.RelativeSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = p6.Theme.TextDefault.Color,
							TextTransparency = p6.Theme.TextDefault.Transparency,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Text = devSub2.price
						})
					}),
					RenewalDate = Roact.createElement("TextLabel", Cryo.Dictionary.join(t1, {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 17),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd
					}))
				}),
				Divider = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = p6.Theme.Divider.Color,
					BackgroundTransparency = p6.Theme.Divider.Transparency,
					Size = uDim2,
					Position = uDim2_2
				})
			})
		end)
	end)
end

return v13
