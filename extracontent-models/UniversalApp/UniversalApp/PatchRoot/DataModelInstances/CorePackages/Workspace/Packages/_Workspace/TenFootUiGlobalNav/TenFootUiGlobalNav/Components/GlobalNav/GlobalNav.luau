local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local TenFootUiGlobalNavParent = TenFootUiGlobalNav.Parent
local Cryo = require(TenFootUiGlobalNavParent.Cryo)
local React = require(TenFootUiGlobalNavParent.React)
local UIBlox = require(TenFootUiGlobalNavParent.UIBlox)
local Style = require(TenFootUiGlobalNavParent.Style)
local Responsive = require(TenFootUiGlobalNavParent.Responsive)
local GlobalNavOptionGroup = require(TenFootUiGlobalNav.Components.GlobalNavOptionGroup)
local eraseKeys = require(TenFootUiGlobalNav.Components.utils.eraseKeys)
local IconTabGroup = UIBlox.App.Navigation.PrimaryNavBar.IconTabGroup
local useDesignTokens = Style.useDesignTokens
local getVirtualResolutionScale = Responsive.getVirtualResolutionScale
local v13 = React.forwardRef(function(p1, p2) -- line: 15
	-- upvalues: eraseKeys (copy), React (copy), getVirtualResolutionScale (copy), Cryo (copy)
	local v16 = eraseKeys({
		"children",
		"GroupTransparency"
	}, p1)

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		GroupTransparency = p1.GroupTransparency,
		ResolutionScale = getVirtualResolutionScale(),
		ref = p2
	}, React.createElement("Frame", Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5)
	}, v16), p1.children))
end)

return (React.forwardRef(function(t1: {[any]: any}, p3) -- line: 71
	-- upvalues: useDesignTokens (copy), eraseKeys (copy), React (copy), v13 (copy), IconTabGroup (copy), GlobalNavOptionGroup (copy), Cryo (copy)
	local v19 = useDesignTokens(function(p4) -- line: 72
		return p4.Size.Size_1600
	end)
	local v20 = useDesignTokens(function(p5) -- line: 75
		return p5.Size.Size_200
	end)
	local v21 = eraseKeys({
		"optionGroupProps",
		"tabGroupProps",
		"animationProps"
	}, t1)
	local v22 = nil
	local v23 = nil

	if t1.tabGroupProps then
		v22 = React.createElement(v13, {
			GroupTransparency = t1.animationProps.tabGroupTransparency,
			ref = t1.animationProps.tabGroupRef
		}, React.createElement(IconTabGroup, t1.tabGroupProps))
	end

	if t1.optionGroupProps then
		v23 = React.createElement(v13, {
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			GroupTransparency = t1.animationProps.optionGroupTransparency,
			ref = t1.animationProps.optionGroupRef
		}, React.createElement(GlobalNavOptionGroup, Cryo.Dictionary.join(t1.optionGroupProps, {
			AnchorPoint = Vector2.new(1, 0),
			spacing = v20
		})))
	end

	return React.createElement("Frame", Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ref = p3
	}, v21), React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, v19),
		PaddingLeft = UDim.new(0, v19)
	}), {
		TabGroup = v22,
		OptionGroup = v23
	})
end))
