local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Otter = InGameMenuDependencies.Otter
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
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
	-- upvalues: withLocalization (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy)
	local props = p5.props

	return withLocalization({
		text = props.text
	})(function(p7) -- line: 77
		-- upvalues: withFoundationOrUIBloxStyle (copy), p5 (copy), props (copy), Roact (copy), p6 (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy)
		return withFoundationOrUIBloxStyle(function(p8) -- line: 78
			return {
				Theme = {
					BackgroundOnPress = {
						Color = p8.Color.State.Press.Color3,
						Transparency = p8.Color.State.Press.Transparency
					},
					BackgroundOnHover = {
						Color = p8.Color.State.Hover.Color3,
						Transparency = p8.Color.State.Hover.Transparency
					},
					IconEmphasis = {
						Color = p8.Color.Content.Emphasis.Color3,
						Transparency = p8.Color.Content.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p8.Color.Content.Emphasis.Color3,
						Transparency = p8.Color.Content.Emphasis.Transparency
					},
					BackgroundMuted = {
						Color = p8.Color.Surface.Surface_200.Color3,
						Transparency = p8.Color.Surface.Surface_200.Transparency
					}
				}
			}
		end, function(p9) -- line: 88
			-- upvalues: p5 (copy), props (copy), Roact (copy), p6 (copy), CursorKind (copy), ImageSetLabel (copy), divideTransparency (copy), ThemedTextLabel (copy), p7 (copy)
			local v50 = p5.state.pressing and not props.selected
			local t1 = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			}

			if p5.state.pressing then
				t1 = p9.Theme.BackgroundOnPress
			elseif p5.state.hovering then
				t1 = p9.Theme.BackgroundOnHover
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
				[Roact.Event.MouseEnter] = function() -- line: 112
					-- upvalues: p5 (copy)
					p5:setState({
						hovering = true
					})
				end,
				[Roact.Event.MouseLeave] = function() -- line: 117
					-- upvalues: p5 (copy)
					p5:setState({
						hovering = false,
						pressing = false
					})
				end,
				[Roact.Event.InputBegan] = function(_, p11) -- line: 123
					-- upvalues: p5 (copy)
					if p11.UserInputType == Enum.UserInputType.MouseButton1 or p11.UserInputType == Enum.UserInputType.Touch then
						p5:setState({
							pressing = true
						})
					end
				end,
				[Roact.Event.InputEnded] = function(_, p13) -- line: 133
					-- upvalues: p5 (copy)
					if p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch then
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
						ImageColor3 = p9.Theme.IconEmphasis.Color,
						ImageTransparency = divideTransparency(p9.Theme.IconEmphasis.Transparency, not v50 and 1 or 2),
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
						TextTransparency = divideTransparency(p9.Theme.TextEmphasis.Transparency, not v50 and 1 or 2),
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				SelectedFill = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 2,
					Size = p5.fillSize,
					BackgroundColor3 = p9.Theme.BackgroundMuted.Color
				})
			})
		end)
	end)
end
function v20.render(p14) -- line: 191
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p15) -- line: 192
		-- upvalues: p14 (copy)
		return p14:renderWithSelectionCursor(p15)
	end)
end
function v20.didUpdate(p16) -- line: 197
	-- upvalues: Otter (copy)
	p16.motor:setGoal({
		fillProgress = Otter.spring(not p16.props.selected and 0 or 1, {
			frequency = 2.5
		}),
		hoverTransparency = Otter.spring(not p16.state.hovering and 0 or 1, {
			frequency = 5
		})
	})
end

local function PageNavigation(p17) -- line: 208
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
				selected = p17.currentPage == v.key,
				text = v.title,
				onActivated = function() -- line: 226
					-- upvalues: p17 (copy), v (copy)
					p17.setCurrentPage(v.key)
				end,
				mainPageFirstButtonRef = n1 == 1 and p17.mainPageFirstButtonRef or nil
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
		Position = p17.Position,
		Size = UDim2.new(1, -Constants.Zone.ContentOffset, 0, v36 * 70 + (v36 - 1))
	}, t2)
end

return RoactRodux.UNSTABLE_connect2(function(p18, _) -- line: 253
	return {
		currentPage = p18.menuPage
	}
end, function(p20) -- line: 257
	-- upvalues: SetCurrentPage (copy), SendAnalytics (copy), Constants (copy)
	return {
		setCurrentPage = function(p21) -- line: 259
			-- upvalues: p20 (copy), SetCurrentPage (copy), SendAnalytics (copy), Constants (copy)
			p20(SetCurrentPage(p21))
			SendAnalytics("open_" .. p21 .. "_tab", Constants.AnalyticsMenuActionName, {})
		end
	}
end)(PageNavigation)
