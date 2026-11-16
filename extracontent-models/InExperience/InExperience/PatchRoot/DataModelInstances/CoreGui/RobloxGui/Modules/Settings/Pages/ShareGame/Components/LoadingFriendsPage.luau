local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local AppBlox = require(CorePackages.Workspace.Packages.AppBlox)
local LoadingBar = AppBlox.LoadingBar

local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.PureComponent:extend("LoadingFriendsPage")

function extended.render(p)
	local layoutOrder = p.props.LayoutOrder
	local zIndex = p.props.ZIndex

	local count = 0
	local function incrementLayoutOrder() -- 1 equivalent call inferred from this helper
		count += 1
		return count
	end

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = layoutOrder,
			ZIndex = zIndex
		},
		{
			listLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			loadingIndicator = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 70, 0, 16),
					LayoutOrder = incrementLayoutOrder(), -- inferred equivalent call
					ZIndex = zIndex
				},
				{
					loadingBar = Roact.createElement(LoadingBar, { ZIndex = zIndex })
				}
			)
		}
	)
end

return extended
