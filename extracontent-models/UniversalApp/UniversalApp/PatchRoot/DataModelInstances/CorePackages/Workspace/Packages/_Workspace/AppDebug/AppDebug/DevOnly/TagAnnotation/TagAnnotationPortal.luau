local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("AppDebug").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local Parent2 = require(script.Parent)

local function TagAnnotationPortal() -- line: 17
	-- upvalues: Parent2 (copy), ReactRoblox (copy), React (copy), CoreGui (copy)
	local config = Parent2.useContext().config
	local v8 = config.displayMode == "overlay"
	local v9 = Parent2.useTagScanner()

	return ReactRoblox.createPortal({
		TagAnnotation = React.createElement("ScreenGui", {
			Name = "TagAnnotation",
			DisplayOrder = 9999,
			ResetOnSpawn = false,
			IgnoreGuiInset = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Enabled = v8
		}, {
			Overlay = if not v8 then nil else React.createElement(Parent2.Overlay, {
				tags = v9.tags,
				showClassName = config.showClassName,
				showPosition = config.showPosition,
				filterPattern = config.filterPattern,
				tooltipOpacity = config.tooltipOpacity,
				highlightOnHover = config.highlightOnHover
			})
		})
	}, CoreGui)
end

return TagAnnotationPortal
