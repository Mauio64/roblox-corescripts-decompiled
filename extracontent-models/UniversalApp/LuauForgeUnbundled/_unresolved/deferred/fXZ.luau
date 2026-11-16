local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local impressionsTagUtility = require("@luauforge/bundled/edd").ImpressionsTagUtility

local UIBlox = require(CorePackages.Packages.UIBlox)

local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local iconButton = UIBlox.App.Button.IconButton

local medium = iconSize.Medium

local extended = Roact.Component:extend("LogoTray")

extended.validateProps = t.strictInterface({
	itemList = t.array(t.strictInterface({ key = t.string, logo = validateImage })),
	layoutOrder = t.integer,
	padding = t.optional(t.UDim),
	handleItemClick = t.optional(t.callback),
	designTokens = t.table,
	impressionsTag = t.string,
	onAbsolutePositionChanged = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})
extended.defaultProps = {
	padding = UDim.new(0, 12),
	handleItemClick = function() end
}

function LUAUFORGE_MODULE_GLOBALS_fXZ_LogoTrayItem(props)
	local ref = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { ref, props.impressionsTag, props.index })

	return Roact.createElement(iconButton, Cryo.Dictionary.join(props.iconButtonProps, {
		buttonRef = ref
	}))
end

function extended:init()
	function self.getInteractableItemTable()
		local v5 = {}
		Cryo.List.map(self.props.itemList, function(p2)
			assert(v5[p2.key] == nil, "Duplicate logo key is not allowed.")
			v5[p2.key] = p2
		end)
		return v5
	end

	function self.getMeasuredItemSize()
		local iconSize2 = getIconSize(medium)
		return UDim2.fromOffset(iconSize2, iconSize2)
	end

	function self.renderItem(p2)
		assert(p2.logo ~= nil, "Invalid icon: " .. p2.key)
		local v5 = Cryo.List.find(self.props.itemList, p2)
		return (Roact.createElement(LUAUFORGE_MODULE_GLOBALS_fXZ_LogoTrayItem, {
			iconButtonProps = {
				icon = p2.logo,
				size = self.getMeasuredItemSize(),
				iconColor3 = self.props.designTokens.Color.Shift.Shift_400.Color3,
				iconSize = medium,
				onActivated = function()
					self.props.handleItemClick(p2.key)
				end,
				layoutOrder = v5
			},
			index = v5,
			impressionsTag = self.props.impressionsTag
		}))
	end

	function self.renderList(p2)
		local result = {}

		for k, v5 in self.getInteractableItemTable() do
			local item = self.renderItem(v5)
			result[v5.key] = item
		end

		result.Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = self.props.padding,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})

		return result
	end
end

function extended.render(props)
	local measuredItemSize = props.getMeasuredItemSize()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, measuredItemSize.Y.Offset),
		LayoutOrder = props.props.layoutOrder,
		[Roact.Change.AbsolutePosition] = props.props.onAbsolutePositionChanged,
		[Roact.Ref] = props.props.forwardRef
	}, props.renderList(measuredItemSize))
end

return function(p2)
	local v5 = useDesignTokens()

	local joined = Cryo.Dictionary.join(p2, { designTokens = v5 })

	return Roact.createElement(extended, joined)
end
