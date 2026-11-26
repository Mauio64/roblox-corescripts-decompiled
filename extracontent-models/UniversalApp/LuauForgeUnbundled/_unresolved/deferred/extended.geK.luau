local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local module2 = require("@luauforge/deferred/geG")

local module3 = require("@luauforge/bundled/egZ")
local withStyle = UIBlox.Style.withStyle

local vector2 = Vector2.new(375, 104)

local v5 = { LEFT = 20 }

local module4 = require("@luauforge/deferred/geL")
local module5 = require("@luauforge/deferred/geN")

local extended = Roact.PureComponent:extend("DevSubList")

local function willDevSubExpire(p2): boolean
	return not p2.isAutoRenewing or p2.planStatus ~= module2.Open
end

function extended.render(p2)
	return module3({
		inactiveSubs = "Feature.DevSubs.Label.InactiveSubscriptions",
		activeSubs = "Feature.DevSubs.Label.ActiveSubscriptions"
	})(function(p3)
		return withStyle(function(props)
			local props2 = p2.props
			local devSubs = props2.devSubs
			local Game = props2.game
			local onDevSubActivated = props2.onDevSubActivated

			local v6 = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 0)
				}),
				Title = Roact.createElement(
					"Frame",
					{
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 70)
					},
					{
						SizeConstraint = Roact.createElement("UISizeConstraint", {
							MaxSize = vector2
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 20)
						}),
						Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 10)
						}),
						Icon = Roact.createElement("ImageLabel", {
							Size = UDim2.new(0, 44, 0, 44),
							LayoutOrder = 1,
							BackgroundTransparency = Game.icon == nil and 0 or 1,
							Image = Game.icon
						}),
						Text = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -54, 0, 40),
							LayoutOrder = 2,
							FontFace = normalizeFontFace(props.Tokens.Typography.HeadingLarge.Font),
							TextSize = props.Font.BaseSize * props.Font.Title.RelativeSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = props.Theme.TextDefault.Color,
							TextTransparency = props.Theme.TextDefault.Transparency,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Text = Game.name
						})
					}
				)
			}

			local devSubs2 = {}
			local devSubs3 = {}

			for k, devSub in pairs(devSubs) do
				if devSub.status == "Active" then
					table.insert(devSubs3, devSub)
				else
					table.insert(devSubs2, devSub)
				end
			end

			table.sort(devSubs3, function(a, b)
				local v7 = not a.isAutoRenewing or a.planStatus ~= module2.Open
				local v8 = not b.isAutoRenewing or b.planStatus ~= module2.Open

				if v7 and v8 then
					return string.upper(a.name) < string.upper(b.name)
				end

				return v7
			end)

			local v7 = #devSubs3 > 0 and #devSubs2 > 0

			local v8 = 1

			table.insert(
				v6,
				v7 and Roact.createElement(module5, {
					layoutOrder = v8,
					maxSize = vector2,
					text = p3.activeSubs
				})
			)

			local v9 = v8 + 1

			local function addDevSub(k, p4)
				table.insert(v6, Roact.createElement(module4, {
					devSub = p4,
					maxSize = vector2,
					layoutOrder = v9,
					hasFullDivider = v7 and k == 1,
					onActivated = function(...)
						onDevSubActivated(p4, ...)
					end
				}))

				v9 += 1
			end

			for k, v10 in pairs(devSubs3) do
				addDevSub(k, v10)
			end

			table.insert(
				v6,
				v7 and Roact.createElement(module5, {
					layoutOrder = v9,
					maxSize = vector2,
					text = p3.inactiveSubs
				})
			)

			v9 += 1

			for k, v10 in pairs(devSubs2) do
				addDevSub(k, v10)
			end

			return Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				fitFields = { Size = FitChildren.FitAxis.Height }
			}, v6)
		end)
	end)
end

return extended
