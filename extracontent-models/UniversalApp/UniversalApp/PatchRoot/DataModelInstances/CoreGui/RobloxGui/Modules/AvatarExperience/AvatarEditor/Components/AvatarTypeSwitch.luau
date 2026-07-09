local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameOnAxis = RoactFitComponents.FitFrameOnAxis
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetAvatarType = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarType)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local withNavigation = RoactNavigation.withNavigation

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXBlockMakeupEquipR6 = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBlockMakeupEquipR6
local v33 = Images["component_assets/circle_29"]
local v34 = Images["component_assets/circle_25"]
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v36 = Roact.PureComponent:extend("AvatarTypeSwitch")

local function resizeTextLabel(p1) -- line: 63
	-- upvalues: Text (copy)
	local uDim = UDim.new(0, Text.GetTextWidth(p1.Text, p1.Font, p1.TextSize))
	local uDim2 = UDim.new(0, p1.TextSize)

	p1.Size = UDim2.new(uDim, uDim2)
end

function v36.resizeTextLabels(p2) -- line: 69
	-- upvalues: resizeTextLabel (copy)
	local current = p2.r6Ref.current
	local current2 = p2.r15Ref.current

	if not current or not current2 then
		return
	end

	resizeTextLabel(current)
	resizeTextLabel(current2)

	local v48 = math.max(current.AbsoluteSize.x, current2.AbsoluteSize.x)

	current.Size = UDim2.new(0, v48, 0, current.Size.Y.Offset)
	current2.Size = UDim2.new(0, v48, 0, current2.Size.Y.Offset)
end
function v36.makeOnOverlayClosed(_, p4) -- line: 89
	-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	return function() -- line: 90
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p4 (copy)
		local v73 = wasLastInputGamepad()

		logOnOverlayClosed("AvatarTypeSwitch")

		if not FFlagAXMigrateAXToGlobalAutofocus and v73 then
			p4.captureFocus()
		end
	end
end
function v36.init(p5) -- line: 100
	-- upvalues: Roact (copy), Constants (copy), Utils (copy), FFlagAXBlockMakeupEquipR6 (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	p5.r6Ref = Roact.createRef()
	p5.r15Ref = Roact.createRef()

	local v52, v53 = Roact.createBinding(UDim2.fromScale(1, 1))

	p5.sizeBinding = v52
	p5.updateSizeBinding = v53

	function p5.absoluteSizeChanged(p6) -- line: 106
		-- upvalues: p5 (copy)
		p5.updateSizeBinding(UDim2.fromOffset(p6.AbsoluteSize.X, p6.AbsoluteSize.Y))
	end
	function p5.toggleAvatarType(p7) -- line: 110
		-- upvalues: p5 (copy), Constants (copy), Utils (copy), FFlagAXBlockMakeupEquipR6 (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local sendAnalytics = p5.props.sendAnalytics
		local analytics = p5.props.analytics
		local setAvatarType = p5.props.setAvatarType
		local v79 = if p5.props.avatarType ~= Constants.AvatarType.R6 then Constants.AvatarType.R6 else Constants.AvatarType.R15
		local v80 = Utils.hasWrapLayer(p5.props.currentCharacter)
		local v81 = if not FFlagAXBlockMakeupEquipR6 then nil else Utils.hasMakeup(p5.props.equippedAssets)

		if v79 == Constants.AvatarType.R6 and (v80 or v81) then
			p5.props.navigation.navigate(AvatarScreen.LayeredClothingR6SwitchPrompt, {
				onOverlayClosed = p5:makeOnOverlayClosed(if not FFlagAXMigrateAXToGlobalAutofocus then p7 else nil)
			})

			return
		end

		setAvatarType(v79)
		sendAnalytics(analytics.toggleAvatarType, v79)
	end
end
function v36.didMount(p8) -- line: 137
	p8:resizeTextLabels()
end
function v36.renderWithProviders(p9, p10, p11, p12, p13) -- line: 141
	-- upvalues: Constants (copy), Roact (copy), ImageSetLabel (copy), v33 (copy), SpringAnimatedItem (copy), t1 (copy), v34 (copy), Focusable (copy), CursorKind (copy), FitFrameOnAxis (copy), RoactFitComponents (copy)
	local propsLayoutOrder = p9.props.LayoutOrder
	local Theme = p11.Theme
	local p11Font = p11.Font
	local v63 = p9.props.avatarType ~= Constants.AvatarType.R15 and 0 or 0.5
	local forwardRef = p9.props.forwardRef

	return Roact.createElement(ImageSetLabel, {
		Size = p9.sizeBinding,
		Image = v33,
		ImageColor3 = Theme.BackgroundUIDefault.Color,
		ImageTransparency = Theme.BackgroundUIDefault.Transparency,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(14, 13, 15, 15),
		LayoutOrder = propsLayoutOrder,
		NextSelectionLeft = p9.props.NextSelectionLeft,
		NextSelectionRight = p9.props.NextSelectionRight,
		NextSelectionUp = p9.props.NextSelectionUp,
		NextSelectionDown = p9.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}, {
		AnimatedFrame = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			animatedValues = {
				positionX = v63
			},
			mapValuesToProps = function(p14) -- line: 184
				return {
					Position = UDim2.new(p14.positionX, 0, 0, 0)
				}
			end,
			springOptions = t1
		}, {
			SwitchImage = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Image = v34,
				ImageColor3 = Theme.UIEmphasis.Color,
				ImageTransparency = Theme.UIEmphasis.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 11, 13, 13)
			})
		}),
		SwitchButton = Roact.createElement(Focusable.ImageButton, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Event.Activated] = function() -- line: 153
				-- upvalues: p9 (copy), p13 (copy)
				p9.toggleAvatarType(p13)
			end,
			SelectionImageObject = p12(CursorKind.Toggle)
		}),
		LabelsContainer = Roact.createElement(FitFrameOnAxis, {
			axis = FitFrameOnAxis.Axis.Both,
			margin = RoactFitComponents.Rect.square(3),
			contentPadding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			BackgroundTransparency = 1,
			ZIndex = 2,
			[Roact.Change.AbsoluteSize] = p9.absoluteSizeChanged
		}, {
			R6Label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Font = p11Font.Body.Font,
				Text = p10.r6Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextSize = p11Font.CaptionHeader.RelativeSize * p11Font.BaseSize,
				TextColor3 = if p9.props.avatarType ~= Constants.AvatarType.R6 then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
				LayoutOrder = 1,
				[Roact.Ref] = p9.r6Ref
			}),
			R15Label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Font = p11Font.Body.Font,
				Text = p10.r15Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextSize = p11Font.CaptionHeader.RelativeSize * p11Font.BaseSize,
				TextColor3 = if p9.props.avatarType ~= Constants.AvatarType.R15 then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
				LayoutOrder = 2,
				[Roact.Ref] = p9.r15Ref
			})
		})
	})
end
function v36.render(p15) -- line: 250
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy)
	return withLocalization({
		r6Text = "Feature.Avatar.Label.R6",
		r15Text = "Feature.Avatar.Label.R15"
	})(function(p16) -- line: 254
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p15 (copy), RoactGamepad (copy)
		return withStyle(function(p17) -- line: 255
			-- upvalues: withSelectionCursorProvider (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p15 (copy), p16 (copy), RoactGamepad (copy)
			return withSelectionCursorProvider(function(p18) -- line: 256
				-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p15 (copy), p16 (copy), p17 (copy), RoactGamepad (copy)
				if FFlagAXMigrateAXToGlobalAutofocus then
					return p15:renderWithProviders(p16, p17, p18)
				end

				return RoactGamepad.withFocusController(function(p19) -- line: 260
					-- upvalues: p15 (copy), p16 (copy), p17 (copy), p18 (copy)
					return p15:renderWithProviders(p16, p17, p18, p19)
				end)
			end)
		end)
	end)
end

local v38 = withNavigation(RoactServices.connect({
	analytics = Analytics
})(v36), nil)

local function mapStateToProps(p20, _) -- line: 274
	local EquippedAssets = p20.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local CurrentCharacter = p20.AvatarExperience.AvatarScene.Character.CurrentCharacter

	return {
		equippedAssets = EquippedAssets,
		avatarType = p20.AvatarExperience.AvatarEditor.Character.AvatarType,
		currentCharacter = CurrentCharacter
	}
end
local function mapDispatchToProps(p22) -- line: 285
	-- upvalues: SetAvatarType (copy), SendAnalytics (copy)
	return {
		setAvatarType = function(p23) -- line: 287
			-- upvalues: p22 (copy), SetAvatarType (copy)
			p22(SetAvatarType(p23))
		end,
		sendAnalytics = function(p24, p25) -- line: 290
			-- upvalues: p22 (copy), SendAnalytics (copy)
			p22(SendAnalytics(p24, p25))
		end
	}
end

local u41 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v38)

return Roact.forwardRef(function(p26, p27) -- line: 298
	-- upvalues: Roact (copy), u41 (ref), Cryo (copy)
	return Roact.createElement(u41, Cryo.Dictionary.join(p26, {
		forwardRef = p27
	}))
end)
