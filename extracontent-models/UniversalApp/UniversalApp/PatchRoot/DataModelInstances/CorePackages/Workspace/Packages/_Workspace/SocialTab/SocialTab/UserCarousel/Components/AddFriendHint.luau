local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local Tooltip = UIBlox.App.Dialog.Tooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withLocalization = dependencies.withLocalization
local LocalizedKeys = require(SocialTab.Enums.LocalizedKeys)
local v10 = Roact.PureComponent:extend("AddFriendHint")

v10.defaultProps = {
	layoutOrder = 0,
	maxHintHeight = 100
}
v10.validateProps = t.interface({
	layoutOrder = t.optional(t.number),
	maxHintHeight = t.number
})

function v10.render(p1) -- line: 26
	-- upvalues: withLocalization (copy), LocalizedKeys (copy), Roact (copy), Tooltip (copy), TooltipOrientation (copy)
	return withLocalization({
		addFriendsHintText = LocalizedKeys.AddFriendsHintText.rawValue(),
		addFriendsHintTitle = LocalizedKeys.AddFriendsHintTitle.rawValue()
	})(function(p2) -- line: 30
		-- upvalues: Roact (copy), p1 (copy), Tooltip (copy), TooltipOrientation (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = p1.props.layoutOrder
		}, {
			HintFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, p1.props.maxHintHeight)
			}, {
				Tooltip = Roact.createElement(Tooltip, {
					forceClickTriggerPoint = true,
					isDirectChild = true,
					triggerPosition = Vector2.new(0, p1.props.maxHintHeight),
					triggerSize = Vector2.new(-12, p1.props.maxHintHeight),
					bodyText = p2.addFriendsHintText,
					headerText = p2.addFriendsHintTitle,
					orientation = TooltipOrientation.Right
				})
			})
		})
	end)
end

return v10
