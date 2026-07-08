local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local UtilAndTab = require(Components.UtilAndTab)
local v5 = Roact.PureComponent:extend("MainViewRequestOrchestrator")

function v5.render(p1) -- line: 9
	-- upvalues: Roact (copy), UtilAndTab (copy)
	local size = p1.props.size
	local formFactor = p1.props.formFactor
	local tabList = p1.props.tabList

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size
	}, {
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList
		})
	})
end

return v5
