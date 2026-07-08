local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Otter = InGameMenuDependencies.Otter
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local Pages = require(script.Parent.Pages)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)
local withLocalization = require(ParentParent.Localization.withLocalization)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v20 = Roact.PureComponent:extend("NavigationButton")

function v20.init(p1, p2) -- line: 45
	-- upvalues: Roact (copy), Otter (copy)
	local v24 = not p2.selected and 0 or 1
	local v25, v26 = Roact.createBinding(v24)

	p1.fillSize = v25:map(function(p3) -- line: 49
		return UDim2.new(p3, 0, 1, 0)
	end)

	local v27, v28 = Roact.createBinding(0)

	p1.hoverTransparency = v27
	p1.setHoverTransparency = v28
	p1.motor = Otter.createGroupMotor({
		hoverTransparency = 0,
		fillProgress = v24
	})
	p1.motor:onStep(function(p4) -- line: 61
		-- upvalues: v26 (copy), p1 (copy)
		v26(p4.fillProgress)
		p1.setHoverTransparency(p4.hoverTransparency)
	end)
	p1:setState({
		hovering = false,
		pressing = false
	})
end
function v20.renderWithSelectionCursor(p5, p6) -- line: 72
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy)
	local props = p5.props

	return withLocalization({
		text = props.text
	})(function(p7) -- line: 77
		-- upvalues: withStyle (copy), p5 (copy), props (copy), Roact (copy), p6 (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy)
		return withStyle(function(p8) -- line: 78
			-- upvalues: p5 (copy), props (copy), Roact (copy), p6 (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy), p7 (copy)
			local v49 = p5.state.pressing and not props.selected
			local t1 = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			}

			if p5.state.pressing then
				t1 = p8.Theme.BackgroundOnPress
			elseif p5.state.hovering then
				t1 = p8.Theme.BackgroundOnHover
			end

			return Roact.createElement("TextButton", {
				AutoButtonColor = false,
				BackgroundTransparency = t1.Transparency,
				BackgroundColor3 = t1.Color,
				BorderSizePixel = 0,
				LayoutOrder = props.LayoutOrder,
				Size = UDim2.new(1, 0, 0, 70),
				Text = "",
				SelectionImageObject = p6(CursorKind.Square),
				[Roact.Event.Activated] = props.onActivated,
				[Roact.Ref] = props.LayoutOrder == 1 and props.mainPageFirstButtonRef or nil,
				[Roact.Event.MouseEnter] = function() -- line: 102
					-- upvalues: p5 (copy)
					p5:setState({
						hovering = true
					})
				end,
				[Roact.Event.MouseLeave] = function() -- line: 107
					-- upvalues: p5 (copy)
					p5:setState({
						hovering = false,
						pressing = false
					})
				end,
				[Roact.Event.InputBegan] = function(_, p10) -- line: 113
					-- upvalues: p5 (copy)
					if p10.UserInputType == Enum.UserInputType.MouseButton1 or p10.UserInputType == Enum.UserInputType.Touch then
						p5:setState({
							pressing = true
						})
					end
				end,
				[Roact.Event.InputEnded] = function(_, p12) -- line: 123
					-- upvalues: p5 (copy)
					if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
						p5:setState({
							pressing = false
						})
					end
				end
			}, {
				ContentContainer = Roact.createElement("Frame", {
					ZIndex = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					Icon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						ZIndex = 3,
						AnchorPoint = Vector2.new(0, 0.5),
						Image = props.image,
						ImageColor3 = p8.Theme.IconEmphasis.Color,
						ImageTransparency = divideTransparency(p8.Theme.IconEmphasis.Transparency, not v49 and 1 or 2),
						Position = UDim2.new(0, 28, 0.5, 0),
						Size = UDim2.new(0, 36, 0, 36)
					}),
					Text = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						ZIndex = 3,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 80, 0.5, 0),
						Size = UDim2.new(1, -104, 1, 0),
						Text = p7.text,
						TextTransparency = divideTransparency(p8.Theme.TextEmphasis.Transparency, not v49 and 1 or 2),
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				SelectedFill = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 2,
					Size = p5.fillSize,
					BackgroundColor3 = p8.Theme.BackgroundMuted.Color
				})
			})
		end)
	end)
end
function v20.render(p13) -- line: 181
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p14) -- line: 182
		-- upvalues: p13 (copy)
		return p13:renderWithSelectionCursor(p14)
	end)
end
function v20.didUpdate(p15) -- line: 187
	-- upvalues: Otter (copy)
	p15.motor:setGoal({
		fillProgress = Otter.spring(not p15.props.selected and 0 or 1, {
			frequency = 2.5
		}),
		hoverTransparency = Otter.spring(not p15.state.hovering and 0 or 1, {
			frequency = 5
		})
	})
end

local function PageNavigation(p16) -- line: 198
	-- upvalues: Roact (copy), Pages (copy), Constants (copy), v20 (copy), Divider (copy)
	local t2 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}
	local v36 = #Pages.pagesByIndex
	local n1 = 1

	for i, v in ipairs(Pages.pagesByIndex) do
		if v.parentPage == Constants.MainPagePageKey then
			t2["Page" .. v.key] = Roact.createElement(v20, {
				image = v.icon,
				LayoutOrder = n1,
				selected = p16.currentPage == v.key,
				text = v.title,
				onActivated = function() -- line: 216
					-- upvalues: p16 (copy), v (copy)
					p16.setCurrentPage(v.key)
				end,
				mainPageFirstButtonRef = n1 == 1 and p16.mainPageFirstButtonRef or nil
			})
			n1 += 1

			if i < v36 then
				t2["Divider" .. n1] = Roact.createElement(Divider, {
					LayoutOrder = n1,
					Size = UDim2.new(1, -24, 0, 1)
				})
				n1 += 1
			end
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = p16.Position,
		Size = UDim2.new(1, -Constants.Zone.ContentOffset, 0, v36 * 70 + (v36 - 1))
	}, t2)
end

return RoactRodux.UNSTABLE_connect2(function(p17, _) -- line: 243
	return {
		currentPage = p17.menuPage
	}
end, function(p19) -- line: 247
	-- upvalues: SetCurrentPage (copy), SendAnalytics (copy), Constants (copy)
	return {
		setCurrentPage = function(p20) -- line: 249
			-- upvalues: p19 (copy), SetCurrentPage (copy), SendAnalytics (copy), Constants (copy)
			p19(SetCurrentPage(p20))
			SendAnalytics("open_" .. p20 .. "_tab", Constants.AnalyticsMenuActionName, {})
		end
	}
end)(PageNavigation)
