local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitChildren = require(Modules.LuaApp.FitChildren)
local DevSubPlanStatus = require(Modules.LuaApp.Enum.DevSubPlanStatus)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local vector2 = Vector2.new(375, 104)
local _ = {
	LEFT = 20
}
local DevSubListItem = require(Modules.LuaApp.Components.More.DevSubListItem)
local DevSubListHeader = require(Modules.LuaApp.Components.More.DevSubListHeader)
local v13 = Roact.PureComponent:extend("DevSubList")

local function willDevSubExpire(p1) -- line: 30
	-- upvalues: DevSubPlanStatus (copy)
	return not p1.isAutoRenewing or p1.planStatus ~= DevSubPlanStatus.Open
end

function v13.render(p2) -- line: 34
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), vector2 (copy), DevSubPlanStatus (copy), DevSubListHeader (copy), DevSubListItem (copy), FitChildren (copy)
	return withLocalization({
		inactiveSubs = "Feature.DevSubs.Label.InactiveSubscriptions",
		activeSubs = "Feature.DevSubs.Label.ActiveSubscriptions"
	})(function(p3) -- line: 38
		-- upvalues: withStyle (copy), p2 (copy), Roact (copy), vector2 (copy), DevSubPlanStatus (copy), DevSubListHeader (copy), DevSubListItem (copy), FitChildren (copy)
		return withStyle(function(p4) -- line: 39
			-- upvalues: p2 (copy), Roact (copy), vector2 (copy), DevSubPlanStatus (copy), DevSubListHeader (copy), p3 (copy), DevSubListItem (copy), FitChildren (copy)
			local props = p2.props
			local devSubs = props.devSubs
			local game2 = props.game
			local onDevSubActivated = props.onDevSubActivated
			local t1 = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 0)
				}),
				Title = Roact.createElement("Frame", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 70)
				}, {
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
						LayoutOrder = 1,
						Size = UDim2.new(0, 44, 0, 44),
						BackgroundTransparency = game2.icon == nil and 0 or 1,
						Image = game2.icon
					}),
					Text = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, -54, 0, 40),
						Font = p4.Font.Title.Font,
						TextSize = p4.Font.BaseSize * p4.Font.Title.RelativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = p4.Theme.TextDefault.Color,
						TextTransparency = p4.Theme.TextDefault.Transparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = game2.name
					})
				})
			}
			local t2 = {}
			local t3 = {}

			for _, v in pairs(devSubs) do
				if v.status == "Active" then
					table.insert(t2, v)
				else
					table.insert(t3, v)
				end
			end

			table.sort(t2, function(p5, p6) -- line: 112
				-- upvalues: DevSubPlanStatus (copy)
				local v38 = not p5.isAutoRenewing or p5.planStatus ~= DevSubPlanStatus.Open
				local v39 = not p6.isAutoRenewing or p6.planStatus ~= DevSubPlanStatus.Open

				if v38 and v39 then
					return string.upper(p5.name) < string.upper(p6.name)
				end

				return v38
			end)

			local v28 = #t2 > 0 and #t3 > 0
			local n1 = 1

			table.insert(t1, v28 and Roact.createElement(DevSubListHeader, {
				layoutOrder = n1,
				maxSize = vector2,
				text = p3.activeSubs
			}))

			local u30 = n1 + 1

			local function addDevSub(p7, p8) -- line: 138
				-- upvalues: t1 (copy), Roact (copy), DevSubListItem (copy), vector2 (copy), u30 (ref), v28 (copy), onDevSubActivated (copy)
				table.insert(t1, Roact.createElement(DevSubListItem, {
					devSub = p8,
					maxSize = vector2,
					layoutOrder = u30,
					hasFullDivider = v28 and p7 == 1,
					onActivated = function(...) -- line: 148
						-- upvalues: onDevSubActivated (copy), p8 (copy)
						onDevSubActivated(p8, ...)
					end
				}))
				u30 += 1
			end

			for k, v in pairs(t2) do
				addDevSub(k, v)
			end

			table.insert(t1, v28 and Roact.createElement(DevSubListHeader, {
				layoutOrder = u30,
				maxSize = vector2,
				text = p3.inactiveSubs
			}))
			u30 += 1

			for k, v in pairs(t3) do
				addDevSub(k, v)
			end

			return Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				fitFields = {
					Size = FitChildren.FitAxis.Height
				}
			}, t1)
		end)
	end)
end

return v13
