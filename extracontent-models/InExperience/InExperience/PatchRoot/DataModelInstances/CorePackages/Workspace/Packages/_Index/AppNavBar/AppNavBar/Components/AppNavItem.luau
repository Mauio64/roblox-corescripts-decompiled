local ParentParent = script.Parent.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local React = require(ParentParent.React)
local UIBlox = require(ParentParent.UIBlox)
local Localization = require(ParentParent.Localization)
local SharedFlags = require(ParentParent.SharedFlags)
local useStyle = UIBlox.Core.Style.useStyle
local ControlState = UIBlox.Core.Control.Enum.ControlState
local NavigationTab = UIBlox.App.Navigation.NavigationTab
local NavigationTabLayout = UIBlox.App.Navigation.Enum.NavigationTabLayout
local useLocalization = Localization.Hooks.useLocalization
local FFlagAppNavLabelScaling = SharedFlags.FFlagAppNavLabelScaling
local FFlagShrinkAppNavBar = SharedFlags.FFlagShrinkAppNavBar

local function arePropsEqual(t1: {[any]: any}, t2: {[any]: any}) -- line: 43
	-- upvalues: Cryo (copy), FFlagShrinkAppNavBar (copy)
	return Cryo.Dictionary.equals(t1.item, t2.item) and ((FFlagShrinkAppNavBar or t1.systemBarLabelTextSizeBinding == t2.systemBarLabelTextSizeBinding) and (t1.isChecked == t2.isChecked and (t1.isCenterPositioned == t2.isCenterPositioned and t1.hasLabel == t2.hasLabel)))
end
local function AppNavItem(t3: {[any]: any}) -- line: 52
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), ControlState (copy), FFlagShrinkAppNavBar (copy), FFlagAppNavLabelScaling (copy), NavigationTab (copy), NavigationTabLayout (copy)
	local Tokens = useStyle().Tokens
	local v20 = useLocalization({
		labelText = t3.item.labelText
	})
	local v21, v22 = React.useState(ControlState.Initialize)
	local CaptionSmall = Tokens.Typography.CaptionSmall
	local v24 = if not FFlagShrinkAppNavBar then t3.systemBarLabelTextSizeBinding.default:getBinding() else nil

	if not FFlagShrinkAppNavBar then
		React.useEffect(function() -- line: 62
			-- upvalues: FFlagAppNavLabelScaling (copy), t3 (copy), v20 (copy), CaptionSmall (copy), Tokens (copy)
			if FFlagAppNavLabelScaling then
				t3.systemBarLabelTextSizeBinding.default:setTextToMaxSize(v20.labelText or "", CaptionSmall.Font, Vector2.new(Tokens.Size.Size_1200, Tokens.Size.Size_1200), Tokens.FontSize.FontSize_300)

				return
			end

			t3.systemBarLabelTextSizeBinding.default:getMinTextSize(v20.labelText or "", CaptionSmall.Font, Vector2.new(Tokens.Size.Size_1200, Tokens.Size.Size_1200))
		end, {
			v24,
			v20.labelText,
			Tokens
		})
	end

	return React.createElement(NavigationTab, {
		iconImage = t3.item.iconImage,
		iconCheckedImage = t3.item.iconCheckedImage,
		renderIcon = if not t3.item.renderIcon then nil else function(b1: boolean) -- line: 84
			-- upvalues: t3 (copy), v21 (copy)
			return t3.item.renderIcon(b1, v21)
		end,
		hasLabel = t3.hasLabel,
		labelText = v20.labelText,
		labelTypography = if not FFlagShrinkAppNavBar then {
			Font = CaptionSmall.Font,
			FontSize = v24,
			LineHeight = CaptionSmall.LineHeight,
			LetterSpacing = CaptionSmall.LetterSpacing
		} else Tokens.Typography.CaptionSmall,
		isChecked = t3.isChecked,
		badgeVariant = t3.item.badgeVariant,
		badgeValue = t3.item.badgeValue,
		layout = NavigationTabLayout.Stacked,
		anchorPoint = if not t3.isCenterPositioned then nil else Vector2.new(0.5, 0.5),
		position = if not t3.isCenterPositioned then nil else UDim2.fromScale(0.5, 0.5),
		onActivated = t3.item.onActivated,
		onStateChanged = if not t3.item.renderIcon then nil else function(_, p2) -- line: 106
			-- upvalues: v22 (copy)
			v22(p2)
		end
	})
end

return React.memo(AppNavItem, arePropsEqual)
