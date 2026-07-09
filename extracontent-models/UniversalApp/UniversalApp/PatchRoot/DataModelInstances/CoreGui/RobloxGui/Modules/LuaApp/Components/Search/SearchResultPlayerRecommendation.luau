local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Roact = require(Modules.Common.Roact)
local FitTextButton = require(Modules.LuaApp.Components.FitTextButton)
local FitChildren = require(Modules.LuaApp.FitChildren)
local LocalizedFitTextLabel = require(Modules.LuaApp.Components.LocalizedFitTextLabel)
local DoPlayerSearch = require(Modules.LuaApp.Components.Search.DoPlayerSearch)
local v9 = Roact.PureComponent:extend("GamesSearchForPlayers")

function v9.init(p1) -- line: 24
	-- upvalues: DoPlayerSearch (copy)
	function p1.onPlayerSearchButtonActivated() -- line: 25
		-- upvalues: DoPlayerSearch (copy), p1 (copy)
		DoPlayerSearch(p1.props.analytics, p1.props.guiService, p1.props.keyword, p1.props.openWebview, p1.props.localization, "CommonUI.Features.Label.Players")
	end
end
function v9.render(p2) -- line: 37
	-- upvalues: withStyle (copy), Roact (copy), LocalizedFitTextLabel (copy), FitChildren (copy), FitTextButton (copy)
	local keyword = p2.props.keyword
	local layoutOrder = p2.props.layoutOrder

	return withStyle(function(p3) -- line: 41
		-- upvalues: Roact (copy), layoutOrder (copy), LocalizedFitTextLabel (copy), FitChildren (copy), FitTextButton (copy), keyword (copy), p2 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = layoutOrder
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2)
			}),
			PlayerSearchTitleText = Roact.createElement(LocalizedFitTextLabel, {
				Text = "Feature.GamePage.LabelSearchInsteadForPlayersNamed",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(0, 0, 1, 0),
				TextSize = p3.Font.Body.RelativeSize * p3.Font.BaseSize,
				Font = p3.Font.Body.Font,
				TextColor3 = p3.Theme.TextDefault.Color,
				TextTransparency = p3.Theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				fitAxis = FitChildren.FitAxis.Width
			}),
			PlayerSearchKeyword = Roact.createElement(FitTextButton, {
				Text = keyword,
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 1,
				TextSize = p3.Font.Body.RelativeSize * p3.Font.BaseSize,
				Font = p3.Font.Body.Font,
				TextColor3 = p3.Theme.TextEmphasis.Color,
				TextTransparency = p3.Theme.TextEmphasis.Transparency,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				fitAxis = FitChildren.FitAxis.Width,
				[Roact.Event.Activated] = p2.onPlayerSearchButtonActivated
			}, {
				Underline = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = p3.Theme.TextEmphasis.Color,
					BackgroundTransparency = p3.Theme.TextEmphasis.Transparency
				})
			})
		})
	end)
end

return v9
