local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withStyle = UIBlox.Style.withStyle
local getPageMargin = UIBlox.App.Container.getPageMargin
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local FitTextLabel = FitFrame.FitTextLabel
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXFixGamepadNavigationOnOutfitManagement = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixGamepadNavigationOnOutfitManagement
local AssetManagementConstants = require(script.Parent.AssetManagementConstants)
local v23 = Images["icons/actions/edit/edit"]
local v24 = Images["icons/actions/edit/delete"]
local v25 = Roact.PureComponent:extend("ManageActionBar")

v25.validateProps = t.strictInterface({
	gradientFade = t.optional(t.boolean),
	multiSelect = t.optional(t.boolean),
	selectedOutfits = t.array(t.string),
	deleteOutfit = t.callback,
	renameOutfit = t.callback,
	bottomPadding = t.optional(t.number),
	ZIndex = t.integer,
	NextSelectionUp = t.optional(t.table),
	forwardRef = t.optional(t.table),
	showCustomOutfitNames = t.boolean,
	isPortrait = t.boolean
})
v25.defaultProps = {
	gradientFade = false,
	multiSelect = false
}

function v25.init(p1) -- line: 77
	-- upvalues: Roact (copy), getPageMargin (copy)
	p1.renameButtonRef = Roact.createRef()
	p1.deleteButtonRef = Roact.createRef()

	local v30, v31 = Roact.createBinding(UDim.new(0, 24))

	p1.marginBinding = v30
	p1.updateMarginBinding = v31

	function p1.absoluteSizeChanged(p2) -- line: 83
		-- upvalues: getPageMargin (copy), p1 (copy)
		local v60 = getPageMargin(p2.AbsoluteSize.X)

		p1.updateMarginBinding(UDim.new(0, v60))
	end
end
function v25.renderBarItems(p3, p4, p5, _) -- line: 90
	-- upvalues: Roact (copy), FitTextLabel (copy), IconButton (copy), v23 (copy), IconSize (copy), v24 (copy)
	local t1 = {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = p3.marginBinding,
			PaddingRight = p3.marginBinding
		})
	}
	local Theme = p5.Theme

	if p3.props.gradientFade then
		t1.UIGradient = Roact.createElement("UIGradient", {
			Rotation = 270,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, Theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(0.8, Theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(1, 1)
			})
		})
	end

	if p3.props.multiSelect then
		local Header2Font = p5.Font.Header2.Font
		local v39 = p5.Font.BaseSize * p5.Font.Header2.RelativeSize
		local selectItem = p4.selectItem

		if #p3.props.selectedOutfits > 0 then
			selectItem = p4.countSelected
		end

		t1.SelectedCountTextLabel = Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			width = FitTextLabel.Width.FitToText,
			Text = selectItem,
			Font = Header2Font,
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			TextColor3 = p5.Theme.TextEmphasis.Color,
			TextSize = v39
		})
	elseif p3.props.showCustomOutfitNames then
		t1.RenameButton = Roact.createElement(IconButton, {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.fromScale(0, 0.5),
			size = UDim2.new(0, 44, 1, 0),
			icon = v23,
			iconSize = IconSize.Medium,
			iconColor3 = Theme.SystemPrimaryDefault.Color,
			iconTransparency = Theme.SystemPrimaryDefault.Transparency,
			onActivated = p3.props.renameOutfit,
			buttonRef = p3.renameButtonRef,
			NextSelectionRight = p3.deleteButtonRef
		})
	end

	local v41 = #p3.props.selectedOutfits > 0

	t1.DeleteButton = Roact.createElement(IconButton, {
		anchorPoint = Vector2.new(1, 0.5),
		position = UDim2.fromScale(1, 0.5),
		size = UDim2.new(0, 44, 1, 0),
		icon = v24,
		iconSize = IconSize.Medium,
		iconColor3 = Theme.SystemPrimaryDefault.Color,
		iconTransparency = v41 and Theme.SystemPrimaryDefault.Transparency or 0.5,
		onActivated = v41 and p3.props.deleteOutfit or nil,
		buttonRef = p3.deleteButtonRef,
		NextSelectionLeft = not p3.props.multiSelect and p3.renameButtonRef or nil
	})

	return t1
end
function v25.renderWithProviders(p7, p8, p9, p10) -- line: 163
	-- upvalues: AssetManagementConstants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), Roact (copy), Focusable (copy)
	local Theme = p9.Theme
	local ActionBarHeight = AssetManagementConstants.ActionBarHeight

	if p7.props.isPortrait then
		ActionBarHeight += 24
	end

	if p7.props.bottomPadding then
		ActionBarHeight += p7.props.bottomPadding
	end

	local v48 = p7:renderBarItems(p8, p9, if not FFlagAXMigrateAXToGlobalAutofocus then p10 else nil)
	local deleteButtonRef = p7.deleteButtonRef

	if not p7.props.multiSelect and p7.props.showCustomOutfitNames then
		deleteButtonRef = p7.renameButtonRef
	end

	local forwardRef = p7.props.forwardRef
	local v51 = if not FFlagAXFixGamepadNavigationOnOutfitManagement then nil else if not p7.props.isPortrait then if not p7.props.bottomPadding then nil else p7.props.bottomPadding else 24

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, ActionBarHeight),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = p7.props.ZIndex,
		[Roact.Change.AbsoluteSize] = p7.absoluteSizeChanged,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then deleteButtonRef else nil,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p7.props.NextSelectionUp else nil,
		[Roact.Ref] = forwardRef
	}, {
		Background = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Size = UDim2.new(1, 0, 0, AssetManagementConstants.ActionBarHeight)
		}, v48),
		GapFiller = if not FFlagAXFixGamepadNavigationOnOutfitManagement or not v51 then if not p7.props.isPortrait then nil else Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		}) else Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Size = UDim2.new(1, 0, 0, v51),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		})
	})
end
function v25.render(p11) -- line: 235
	-- upvalues: withLocalization (copy), withStyle (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy)
	return withLocalization({
		selectItem = "Feature.Avatar.Label.SelectItem",
		countSelected = {
			"Feature.Avatar.Label.CountSelected",
			itemCount = #p11.props.selectedOutfits
		}
	})(function(p12) -- line: 242
		-- upvalues: withStyle (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p11 (copy), RoactGamepad (copy)
		return withStyle(function(p13) -- line: 243
			-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p11 (copy), p12 (copy), RoactGamepad (copy)
			if FFlagAXMigrateAXToGlobalAutofocus then
				return p11:renderWithProviders(p12, p13)
			end

			return RoactGamepad.withFocusController(function(p14) -- line: 247
				-- upvalues: p11 (copy), p12 (copy), p13 (copy)
				return p11:renderWithProviders(p12, p13, p14)
			end)
		end)
	end)
end

local v26 = RoactAppPolicy.connect(function(p15, _) -- line: 254
	return {
		showCustomOutfitNames = p15.getCustomOutfitNames()
	}
end)(v25)

local function mapStateToProps(p17, _) -- line: 260
	-- upvalues: DeviceOrientationMode (copy)
	return {
		isPortrait = p17.DeviceOrientation == DeviceOrientationMode.Portrait
	}
end

local u28 = RoactRodux.connect(mapStateToProps, nil)(v26)

return Roact.forwardRef(function(p19, p20) -- line: 271
	-- upvalues: Roact (copy), u28 (ref), Cryo (copy)
	return Roact.createElement(u28, Cryo.Dictionary.join(p19, {
		forwardRef = p20
	}))
end)
