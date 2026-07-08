local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local LoadingBar = require(CorePackages.Workspace.Packages.AppBlox).LoadingBar
local Roact = require(CorePackages.Packages.Roact)
local v4 = Roact.PureComponent:extend("LoadingFriendsPage")

function v4.render(p1) -- line: 14
	-- upvalues: Roact (copy), LoadingBar (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local propsZIndex = p1.props.ZIndex
	local n1 = 0

	local function incrementLayoutOrder() -- line: 20
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end

	local createElement = Roact.createElement
	local t1 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = propsLayoutOrder,
		ZIndex = propsZIndex
	}
	local t2 = {
		listLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local createElement2 = Roact.createElement
	local t3 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 70, 0, 16)
	}

	n1 += 1
	t3.LayoutOrder = n1
	t3.ZIndex = propsZIndex
	t2.loadingIndicator = createElement2("Frame", t3, {
		loadingBar = Roact.createElement(LoadingBar, {
			ZIndex = propsZIndex
		})
	})

	return createElement("Frame", t1, t2)
end

return v4
