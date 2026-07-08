local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Cryo = require(ParentParentParent.Cryo)
local Images = require(ParentParent.App.ImageSet.Images)
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)
local DropdownMenuList = require(ParentParent.App.Menu.DropdownMenuList)
local DropdownMenuCell = require(ParentParent.App.Menu.DropdownMenuCell)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local bind = require(ParentParent.Utility.bind)
local useStyle = require(ParentParent.Core.Style.useStyle)
local StyleDefaults = require(script.Parent.StyleDefaults)

local function getCellDataKey(p1) -- line: 27
	if p1.key ~= nil then
		return p1.key
	end

	return p1.text
end

local v15 = Roact.Component:extend("DropdownMenu")

v15.validateProps = t.strictInterface({
	placeholder = t.string,
	onChange = t.callback,
	height = t.optional(t.UDim),
	screenSize = t.Vector2,
	showDropShadow = t.optional(t.boolean),
	fixedListHeight = t.optional(t.number),
	errorState = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	onMenuOpenChange = t.optional(t.callback),
	menuListBackground = t.optional(validateColorInfo),
	cellDatas = t.array(t.strictInterface({
		icon = t.optional(t.union(t.table, t.string)),
		text = t.string,
		key = t.optional(t.string),
		disabled = t.optional(t.boolean),
		keyCodeLabel = t.optional(t.union(t.enum(Enum.KeyCode), t.strictInterface({
			key = t.enum(Enum.KeyCode),
			axis = t.optional(t.string)
		}))),
		iconColorOverride = t.optional(t.Color3),
		textColorOverride = t.optional(t.Color3)
	})),
	menuStateColors = t.optional(t.strictInterface({
		buttonDefault = t.optional(validateColorInfo),
		contentDefault = t.optional(validateColorInfo),
		alert = t.optional(validateColorInfo)
	})),
	enableTokenOverride = t.optional(t.boolean),
	isForcedClosed = t.optional(t.boolean),
	selectionOrder = t.optional(t.number),
	dropdownMenuListPositionFixed = t.optional(t.boolean),
	defaultKey = t.optional(t.string)
})
v15.defaultProps = {
	showDropShadow = false,
	fixedListHeight = nil,
	enableTokenOverride = false,
	dropdownMenuListPositionFixed = false,
	defaultKey = nil
}

function v15.didUpdate(p2, _, p4) -- line: 129
	if p2.props.onMenuOpenChange and p2.state.menuOpen ~= p4.menuOpen then
		p2.props.onMenuOpenChange(p2.state.menuOpen)
	end
end
function v15.init(p5) -- line: 135
	-- upvalues: Cryo (copy), bind (copy)
	p5:setState({
		menuOpen = false,
		selectedKey = p5.props.defaultKey,
		absoluteSize = Vector2.new(0, 0)
	})

	function p5.openMenu() -- line: 142
		-- upvalues: p5 (copy)
		p5:setState({
			menuOpen = true
		})
	end
	function p5.closeMenu() -- line: 148
		-- upvalues: p5 (copy)
		p5:setState({
			menuOpen = false
		})
	end
	function p5.onSelect(p6) -- line: 154
		-- upvalues: p5 (copy)
		p5:setState({
			menuOpen = false,
			selectedKey = p6
		})
		p5.props.onChange(p6)
	end
	function p5.mapCellData(p7) -- line: 162
		-- upvalues: Cryo (copy), bind (copy), p5 (copy)
		local v46 = if p7.key == nil then p7.text else p7.key
		local v47 = Cryo.Dictionary.join(p7, {
			key = Cryo.None
		})

		v47.onActivated = bind(p5.onSelect, v46)
		v47.selected = v46 == p5.state.selectedKey

		return v47
	end
	function p5.onResize(p8) -- line: 172
		-- upvalues: p5 (copy)
		p5:setState({
			absoluteSize = p8.AbsoluteSize
		})
	end
end
function v15.getDerivedStateFromProps(p9, p10) -- line: 179
	-- upvalues: Roact (copy)
	local v23 = false

	for _, v25 in p9.cellDatas do
		if ((if v25.key == nil then v25.text else v25.key)) == p10.selectedKey then
			v23 = true

			break
		end
	end

	if not v23 then
		return {
			selectedKey = Roact.None
		}
	end

	return nil
end
function v15.render(p11) -- line: 197
	-- upvalues: Cryo (copy), ControlState (copy), Roact (copy), DropdownMenuCell (copy), Images (copy), DropdownMenuList (copy)
	local cellDatas = p11.props.cellDatas
	local v28 = Cryo.List.map(cellDatas, p11.mapCellData)
	local selectionOrder = p11.props.selectionOrder
	local v30 = Cryo.List.findWhere(v28, function(p12) -- line: 203
		return p12.selected
	end)
	local v31 = if v30 == nil then p11.props.placeholder else v28[v30].text
	local v32 = p11.state.absoluteSize.X > 640
	local t1, t2

	if p11.props.enableTokenOverride then
		local buttonDefault = p11.props.menuStateColors.buttonDefault
		local contentDefault = p11.props.menuStateColors.contentDefault

		if p11.props.errorState then
			buttonDefault = p11.props.menuStateColors.alert
		end

		t1 = {
			[ControlState.Default] = buttonDefault
		}
		t2 = {
			[ControlState.Default] = contentDefault
		}
	else
		local s1 = "SecondaryDefault"
		local s2 = "SecondaryOnHover"

		if p11.state.menuOpen then
			s2 = s1
		end

		if p11.props.errorState then
			s1 = "Alert"
			s2 = "Alert"
		end

		t1 = {
			[ControlState.Default] = s1,
			[ControlState.Hover] = s2
		}
		t2 = {
			[ControlState.Default] = "TextEmphasis"
		}
	end

	if p11.props.isForcedClosed and p11.state.menuOpen then
		p11:setState({
			menuOpen = false
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(UDim.new(1, 0), p11.props.height),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = p11.onResize,
		[Roact.Ref] = p11.props[Roact.Ref]
	}, {
		InnerFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			SpawnButton = Roact.createElement(DropdownMenuCell, {
				isLoading = false,
				userInteractionEnabled = true,
				Size = UDim2.fromScale(1, 1),
				buttonImage = Images["component_assets/circle_17_stroke_1"],
				buttonStateColorMap = t1,
				contentStateColorMap = t2,
				icon = p11.state.menuOpen and Images["truncate_arrows/actions_truncationCollapse"] or Images["truncate_arrows/actions_truncationExpand"],
				text = v31,
				isDisabled = p11.props.isDisabled,
				isActivated = p11.state.menuOpen,
				hasContent = v30 ~= nil,
				onActivated = function() -- line: 276
					-- upvalues: p11 (copy)
					if p11.state.menuOpen then
						p11.closeMenu()

						return
					end

					p11.openMenu()
				end,
				enableTokenOverride = p11.props.enableTokenOverride,
				SelectionOrder = selectionOrder
			}),
			DropdownMenuList = Roact.createElement(DropdownMenuList, {
				zIndex = 2,
				closeBackgroundVisible = false,
				buttonProps = v28,
				open = p11.state.menuOpen,
				openPositionY = UDim.new(0, 12),
				buttonSize = UDim2.fromScale(1, 1),
				menuListBackground = p11.props.menuListBackground,
				screenSize = p11.props.screenSize,
				showDropShadow = p11.props.showDropShadow,
				fixedListHeight = p11.props.fixedListHeight,
				onDismiss = p11.closeMenu,
				enableTokenOverride = p11.props.enableTokenOverride,
				selectionOrder = if not selectionOrder then nil else selectionOrder + 1,
				menuPositionFixed = p11.props.dropdownMenuListPositionFixed
			}),
			UISizeConstraint = v32 and Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(300, 1e999)
			}) or nil
		}) or nil
	})
end

return Roact.forwardRef(function(p13, p14) -- line: 311
	-- upvalues: useStyle (copy), StyleDefaults (copy), Cryo (copy), Roact (copy), v15 (copy)
	if p13.enableTokenOverride then
		local v41 = useStyle()
		local v42 = StyleDefaults.getDropdownMenuDefaultTokens(v41)
		local v43 = Cryo.Dictionary.join(v42.menuStateColors, p13.menuStateColors or {})

		p13 = Cryo.Dictionary.join(p13, {
			height = p13.height or v42.height,
			menuStateColors = v43
		})
	end

	return Roact.createElement(v15, Cryo.Dictionary.join(p13, {
		[Roact.Ref] = p14
	}))
end)
