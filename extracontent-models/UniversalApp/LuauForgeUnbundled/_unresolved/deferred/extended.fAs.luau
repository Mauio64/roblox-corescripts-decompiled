local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local module2 = require("@luauforge/deferred/fAo")

local module3 = require("@luauforge/bundled/edC")
local withStyle = UIBlox.Style.withStyle

local vector2 = Vector2.new(375, 104)

local v5 = { LEFT = 20 }

local module4 = require("@luauforge/deferred/fAt")
local AlertViewLabel = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewLabel")

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
				Title = 0
			}

			local createElement = Roact.createElement
			local v8 = {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 70)
			}
			local v9 = {
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
				Text = 0
			}

			local createElement2 = Roact.createElement
			local v11 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -54, 0, 40),
				LayoutOrder = 2,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextTruncate = 0,
				Text = 0
			}

			local v12 = if not foundationFontFaceMigration then props.Font.Title.Font else nil
			v11.Font = v12

			local v13 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.HeadingLarge.Font) else nil
			v11.FontFace = v13

			v11.TextSize = props.Font.BaseSize * props.Font.Title.RelativeSize
			v11.TextXAlignment = Enum.TextXAlignment.Left
			v11.TextColor3 = props.Theme.TextDefault.Color
			v11.TextTransparency = props.Theme.TextDefault.Transparency
			v11.TextTruncate = Enum.TextTruncate.AtEnd

			v11.Text = Game.name
			v9.Text = createElement2("TextLabel", v11)
			v6.Title = createElement("Frame", v8, v9)

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
				local v14 = not a.isAutoRenewing or a.planStatus ~= module2.Open
				local v15 = not b.isAutoRenewing or b.planStatus ~= module2.Open

				if v14 and v15 then
					return string.upper(a.name) < string.upper(b.name)
				end

				return v14
			end)

			local v14 = #devSubs3 > 0 and #devSubs2 > 0

			local v15 = 1

			table.insert(
				v6,
				v14 and Roact.createElement(AlertViewLabel, {
					layoutOrder = v15,
					maxSize = vector2,
					text = p3.activeSubs
				})
			)

			local v16 = v15 + 1

			local function addDevSub(k, p4)
				table.insert(v6, Roact.createElement(module4, {
					devSub = p4,
					maxSize = vector2,
					layoutOrder = v16,
					hasFullDivider = v14 and k == 1,
					onActivated = function(...)
						onDevSubActivated(p4, ...)
					end
				}))

				v16 += 1
			end

			for k, v17 in pairs(devSubs3) do
				addDevSub(k, v17)
			end

			table.insert(
				v6,
				v14 and Roact.createElement(AlertViewLabel, {
					layoutOrder = v16,
					maxSize = vector2,
					text = p3.inactiveSubs
				})
			)

			v16 += 1

			for k, v17 in pairs(devSubs2) do
				addDevSub(k, v17)
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
