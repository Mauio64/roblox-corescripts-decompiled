local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Cryo = require(parent2.Cryo)

local Images = require(parent.App.ImageSet.Images)
local ControlState = require(parent.Core.Control.Enum.ControlState)

local DropdownMenuList = require(parent.App.Menu.DropdownMenuList)
local DropdownMenuCell = require(parent.App.Menu.DropdownMenuCell)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)

local bind = require(parent.Utility.bind)
local useStyle = require(parent.Core.Style.useStyle)
local StyleDefaults = require(script.Parent.StyleDefaults)

local function getCellDataKey(p) -- 2 equivalent calls inferred from this helper
	return if p.key == nil then p.text else p.key
end

local extended = Roact.Component:extend("DropdownMenu")

extended.validateProps = t.strictInterface({
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
		keyCodeLabel = t.optional(t.union(
			t.enum(Enum.KeyCode),
			t.strictInterface({ key = t.enum(Enum.KeyCode), axis = t.optional(t.string) })
		)),
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

extended.defaultProps = {
	showDropShadow = false,
	fixedListHeight = nil,
	enableTokenOverride = false,
	dropdownMenuListPositionFixed = false,
	defaultKey = nil
}

function extended.didUpdate(p, _, p2)
	if p.props.onMenuOpenChange and p.state.menuOpen ~= p2.menuOpen then
		p.props.onMenuOpenChange(p.state.menuOpen)
	end
end

function extended:init()
	self:setState({
		menuOpen = false,
		selectedKey = self.props.defaultKey,
		absoluteSize = Vector2.new(0, 0)
	})

	function self.openMenu()
		self:setState({ menuOpen = true })
	end

	function self.closeMenu()
		self:setState({ menuOpen = false })
	end

	function self.onSelect(selectedKey)
		self:setState({ menuOpen = false, selectedKey = selectedKey })

		self.props.onChange(selectedKey)
	end

	function self.mapCellData(p)
		local cellDataKey = getCellDataKey(p) -- inferred equivalent call
		local joined = Cryo.Dictionary.join(p, { key = Cryo.None })

		joined.onActivated = bind(self.onSelect, cellDataKey)
		joined.selected = self.state.selectedKey == cellDataKey
		return joined
	end

	function self.onResize(p)
		self:setState({ absoluteSize = p.AbsoluteSize })
	end
end

function extended.getDerivedStateFromProps(p, p2)
	local flag = false

	for _, cellData in p.cellDatas do
		if getCellDataKey(cellData) == p2.selectedKey then -- inferred equivalent call
			flag = true
			break
		end
	end

	if flag then
		return nil
	end

	return { selectedKey = Roact.None }
end

function extended.render(props)
	local cellDatas = props.props.cellDatas
	local mapped = Cryo.List.map(cellDatas, props.mapCellData)

	local selectionOrder = props.props.selectionOrder

	local where = Cryo.List.findWhere(mapped, function(p)
		return p.selected
	end)
	local text

	if where == nil then
		text = props.props.placeholder
	else
		text = mapped[where].text
	end

	local v = props.state.absoluteSize.X > 640
	local buttonStateColorMap, contentStateColorMap

	if props.props.enableTokenOverride then
		local v2 = props.props.menuStateColors.buttonDefault
		local contentDefault = props.props.menuStateColors.contentDefault

		if props.props.errorState then
			v2 = props.props.menuStateColors.alert
		end

		buttonStateColorMap = {}
		buttonStateColorMap[ControlState.Default] = v2

		contentStateColorMap = {}
		contentStateColorMap[ControlState.Default] = contentDefault
	else
		local v2 = "SecondaryDefault"

		local v3 = not props.state.menuOpen and "SecondaryOnHover" or v2

		if props.props.errorState then
			v2 = "Alert"
			v3 = "Alert"
		end

		buttonStateColorMap = {}
		buttonStateColorMap[ControlState.Default] = v2
		buttonStateColorMap[ControlState.Hover] = v3

		contentStateColorMap = {}
		contentStateColorMap[ControlState.Default] = "TextEmphasis"
	end

	if props.props.isForcedClosed and props.state.menuOpen then
		props:setState({ menuOpen = false })
	end

	local createElement = Roact.createElement
	local v2 = {
		Size = UDim2.new(UDim.new(1, 0), props.props.height),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = props.onResize,
		[Roact.Ref] = props.props[Roact.Ref]
	}

	local createElement2 = Roact.createElement
	local v3 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local v4 = {
		SpawnButton = Roact.createElement(DropdownMenuCell, {
			Size = UDim2.fromScale(1, 1),
			buttonImage = Images["component_assets/circle_17_stroke_1"],
			buttonStateColorMap = buttonStateColorMap,
			contentStateColorMap = contentStateColorMap,
			icon = props.state.menuOpen and Images["truncate_arrows/actions_truncationCollapse"] or Images["truncate_arrows/actions_truncationExpand"],
			text = text,
			isDisabled = props.props.isDisabled,
			isLoading = false,
			isActivated = props.state.menuOpen,
			hasContent = where ~= nil,
			userInteractionEnabled = true,
			onActivated = function()
				if props.state.menuOpen then
					props.closeMenu()
				else
					props.openMenu()
				end
			end,
			enableTokenOverride = props.props.enableTokenOverride,
			SelectionOrder = selectionOrder
		}),
		DropdownMenuList = 0,
		UISizeConstraint = 0
	}

	local createElement3 = Roact.createElement
	local v5 = {
		buttonProps = mapped,
		zIndex = 2,
		open = props.state.menuOpen,
		openPositionY = UDim.new(0, 12),
		buttonSize = UDim2.fromScale(1, 1),
		closeBackgroundVisible = false,
		menuListBackground = props.props.menuListBackground,
		screenSize = props.props.screenSize,
		showDropShadow = props.props.showDropShadow,
		fixedListHeight = props.props.fixedListHeight,
		onDismiss = props.closeMenu,
		enableTokenOverride = props.props.enableTokenOverride,
		selectionOrder = 0,
		menuPositionFixed = 0
	}
	local selectionOrder2

	if selectionOrder then
		selectionOrder2 = selectionOrder + 1
	end

	v5.selectionOrder = selectionOrder2
	v5.menuPositionFixed = props.props.dropdownMenuListPositionFixed
	v4.DropdownMenuList = createElement3(DropdownMenuList, v5)

	v4.UISizeConstraint = v and Roact.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(300, 1e999)
	}) or nil
	return createElement("Frame", v2, {
		InnerFrame = createElement2("Frame", v3, v4) or nil
	})
end

return Roact.forwardRef(function(props, p)
	if props.enableTokenOverride then
		local v = useStyle()
		local dropdownMenuDefaultTokens = StyleDefaults.getDropdownMenuDefaultTokens(v)

		local joined = Cryo.Dictionary.join(dropdownMenuDefaultTokens.menuStateColors, props.menuStateColors or {})
		props = Cryo.Dictionary.join(props, {
			height = props.height or dropdownMenuDefaultTokens.height,
			menuStateColors = joined
		})
	end

	return Roact.createElement(extended, Cryo.Dictionary.join(props, { [Roact.Ref] = p }))
end)
