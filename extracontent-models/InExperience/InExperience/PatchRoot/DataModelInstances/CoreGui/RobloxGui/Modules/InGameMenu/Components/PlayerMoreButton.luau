local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local FFlagLuaMenuPerfImprovements = require(ParentParent.Flags.FFlagLuaMenuPerfImprovements)
local Assets = require(ParentParent.Resources.Assets)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local v11 = Roact.PureComponent:extend("MoreButton")

v11.validateProps = t.strictInterface({
	onActivated = t.callback,
	LayoutOrder = t.integer,
	userId = FFlagLuaMenuPerfImprovements and t.number or nil
})

function v11.init(p1) -- line: 25
	-- upvalues: FFlagLuaMenuPerfImprovements (copy)
	if FFlagLuaMenuPerfImprovements then
		function p1.onActivated() -- line: 27
			-- upvalues: p1 (copy)
			p1.props.onActivated(p1.props.userId)
		end
	end
end
function v11.render(p2) -- line: 33
	-- upvalues: withStyle (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), ImageSetButton (copy), Assets (copy)
	return withStyle(function(p3) -- line: 34
		-- upvalues: p2 (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), ImageSetButton (copy), Assets (copy)
		local onActivated = p2.props.onActivated

		if FFlagLuaMenuPerfImprovements then
			onActivated = p2.props.onActivated and p2.onActivated or nil
		end

		return Roact.createElement(ImageSetButton, {
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Image = Assets.Images.MoreActions,
			ImageColor3 = p3.Theme.IconEmphasis.Color,
			LayoutOrder = p2.props.LayoutOrder,
			[Roact.Event.Activated] = onActivated
		})
	end)
end

return v11
