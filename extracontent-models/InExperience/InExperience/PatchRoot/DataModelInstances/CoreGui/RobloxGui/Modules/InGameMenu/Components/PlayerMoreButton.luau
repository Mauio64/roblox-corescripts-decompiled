local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local withStyle = UIBlox.Core.Style.withStyle

local parent = script.Parent.Parent
local FFlagLuaMenuPerfImprovements = require(parent.Flags.FFlagLuaMenuPerfImprovements)

local Assets = require(parent.Resources.Assets)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local extended = Roact.PureComponent:extend("MoreButton")

extended.validateProps = t.strictInterface({
	onActivated = t.callback,
	LayoutOrder = t.integer,
	userId = FFlagLuaMenuPerfImprovements and t.number or nil
})

function extended:init()
	if FFlagLuaMenuPerfImprovements then
		function self.onActivated()
			self.props.onActivated(self.props.userId)
		end
	end
end

function extended.render(p)
	return withStyle(function(p2)
		local onActivated = p.props.onActivated

		if FFlagLuaMenuPerfImprovements then
			onActivated = p.props.onActivated and p.onActivated or nil
		end

		return Roact.createElement(ImageSetButton, {
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Image = Assets.Images.MoreActions,
			ImageColor3 = p2.Theme.IconEmphasis.Color,
			LayoutOrder = p.props.LayoutOrder,
			[Roact.Event.Activated] = onActivated
		})
	end)
end

return extended
