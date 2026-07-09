local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local ImpressionsTagUtility = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTagUtility
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconButton = UIBlox.App.Button.IconButton
local Medium = IconSize.Medium
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local v16 = Roact.Component:extend("LogoTray")

v16.validateProps = t.strictInterface({
	itemList = t.array(t.strictInterface({
		key = t.string,
		logo = validateImage
	})),
	layoutOrder = t.integer,
	padding = t.optional(t.UDim),
	handleItemClick = t.optional(t.callback),
	designTokens = t.table,
	impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.string,
	onAbsolutePositionChanged = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.optional(t.callback),
	forwardRef = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.optional(t.table)
})
v16.defaultProps = {
	padding = UDim.new(0, 12),
	handleItemClick = function() -- line: 25
	end
}

function LogoTrayItem(p1) -- line: 67
	-- upvalues: React (copy), ImpressionsTagUtility (copy), Roact (copy), IconButton (copy), Cryo (copy)
	local v19 = React.useRef(nil)

	React.useEffect(function() -- line: 69
		-- upvalues: ImpressionsTagUtility (copy), v19 (copy), p1 (copy)
		ImpressionsTagUtility.AddTag(v19, p1.impressionsTag, p1.index)

		return function() -- line: 71
			-- upvalues: ImpressionsTagUtility (copy), v19 (copy), p1 (copy)
			ImpressionsTagUtility.RemoveTag(v19, p1.impressionsTag, p1.index)
		end
	end, {
		v19,
		p1.impressionsTag,
		p1.index
	})

	return Roact.createElement(IconButton, Cryo.Dictionary.join(p1.iconButtonProps, {
		buttonRef = v19
	}))
end
function v16.init(p2) -- line: 84
	-- upvalues: Cryo (copy), getIconSize (copy), Medium (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), IconButton (copy)
	function p2.getInteractableItemTable() -- line: 85
		-- upvalues: Cryo (copy), p2 (copy)
		local t1 = {}

		Cryo.List.map(p2.props.itemList, function(p3) -- line: 87
			-- upvalues: t1 (copy)
			assert(t1[p3.key] == nil, "Duplicate logo key is not allowed.")
			t1[p3.key] = p3
		end)

		return t1
	end
	function p2.getMeasuredItemSize() -- line: 94
		-- upvalues: getIconSize (copy), Medium (copy)
		local v27 = getIconSize(Medium)

		return UDim2.fromOffset(v27, v27)
	end
	function p2.renderItem(p4) -- line: 99
		-- upvalues: Cryo (copy), p2 (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Medium (copy), IconButton (copy)
		assert(p4.logo ~= nil, "Invalid icon: " .. p4.key)

		local v29 = Cryo.List.find(p2.props.itemList, p4)

		if FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then
			return (Roact.createElement(LogoTrayItem, {
				iconButtonProps = {
					icon = p4.logo,
					size = p2.getMeasuredItemSize(),
					iconColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p2.props.designTokens.Semantic.Color.Ui.Emphasis else p2.props.designTokens.Color.Shift.Shift_400)).Color3,
					iconSize = Medium,
					onActivated = function() -- line: 111
						-- upvalues: p2 (copy), p4 (copy)
						p2.props.handleItemClick(p4.key)
					end,
					layoutOrder = v29
				},
				index = v29,
				impressionsTag = p2.props.impressionsTag
			}))
		end

		return (Roact.createElement(IconButton, {
			icon = p4.logo,
			size = p2.getMeasuredItemSize(),
			iconColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p2.props.designTokens.Semantic.Color.Ui.Emphasis else p2.props.designTokens.Color.Shift.Shift_400)).Color3,
			iconSize = Medium,
			onActivated = function() -- line: 128
				-- upvalues: p2 (copy), p4 (copy)
				p2.props.handleItemClick(p4.key)
			end,
			layoutOrder = v29
		}))
	end
	function p2.renderList(_) -- line: 137
		-- upvalues: p2 (copy), Roact (copy)
		local t2 = {}

		for _, v33 in p2.getInteractableItemTable() do
			local v34 = p2.renderItem(v33)

			t2[v33.key] = v34
		end

		t2.Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = p2.props.padding,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})

		return t2
	end
end
function v16.render(p6) -- line: 153
	-- upvalues: Roact (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy)
	local v22 = p6.getMeasuredItemSize()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v22.Y.Offset),
		LayoutOrder = p6.props.layoutOrder,
		[Roact.Change.AbsolutePosition] = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p6.props.onAbsolutePositionChanged,
		[Roact.Ref] = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p6.props.forwardRef
	}, p6.renderList(v22))
end

local v17 = v16

return function(p7) -- line: 168
	-- upvalues: useDesignTokens (copy), Cryo (copy), Roact (copy), v17 (copy)
	local v24 = useDesignTokens()
	local v25 = Cryo.Dictionary.join(p7, {
		designTokens = v24
	})

	return Roact.createElement(v17, v25)
end
