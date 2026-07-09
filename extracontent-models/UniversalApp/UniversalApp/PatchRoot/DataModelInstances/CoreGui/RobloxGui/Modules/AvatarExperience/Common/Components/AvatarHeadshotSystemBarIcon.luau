local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withAnimation = UIBlox.Core.Animation.withAnimation
local Placement = UIBlox.App.Navigation.Enum.Placement
local Modules = CoreGui.RobloxGui.Modules
local AvatarHeadshotLocalIcon = require(Modules.AvatarExperience.Common.Components.AvatarHeadshotLocalIcon)
local t1 = {
	frequency = 3
}
local v12 = Roact.PureComponent:extend("AvatarHeadshotSystemBarIcon")

v12.validateProps = t.strictInterface({
	placement = Placement.isEnumValue,
	hovered = t.boolean,
	selected = t.boolean,
	pressed = t.boolean,
	badgeValue = t.optional(t.union(t.number, t.string)),
	size = t.optional(t.number)
})

function v12.render(p1) -- line: 36
	-- upvalues: withStyle (copy), Placement (copy), withAnimation (copy), Roact (copy), AvatarHeadshotLocalIcon (copy), t1 (copy)
	local v14 = p1.props.size or 42

	return withStyle(function(_) -- line: 39
		-- upvalues: p1 (copy), Placement (copy), withAnimation (copy), Roact (copy), AvatarHeadshotLocalIcon (copy), v14 (copy), t1 (copy)
		local n1 = 0
		local n2 = 0

		if p1.props.hovered then
			if p1.props.placement == Placement.Bottom then
				n2 = -4
			else
				n1 = 4
			end
		end

		return withAnimation({
			hoverOffsetX = n1,
			hoverOffsetY = n2
		}, function(p3) -- line: 53
			-- upvalues: Roact (copy), AvatarHeadshotLocalIcon (copy), v14 (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, math.floor(p3.hoverOffsetX + 0.5), 0.5, (math.floor(p3.hoverOffsetY + 0.5))),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(42, 42)
			}, {
				AvatarHeadshotLocalIcon = Roact.createElement(AvatarHeadshotLocalIcon, {
					ZIndex = 2,
					Size = v14
				})
			})
		end, t1)
	end)
end

return v12
