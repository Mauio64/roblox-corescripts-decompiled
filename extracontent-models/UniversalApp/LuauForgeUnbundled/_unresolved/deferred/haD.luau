local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module = require("@luauforge/bundled/gJz")
local module2 = require("@luauforge/deferred/haE")
local module3 = require("@luauforge/deferred/haF")
local module4 = require("@luauforge/bundled/fCe")

local module5 = require("@luauforge/deferred/haG")
local module6 = require("@luauforge/deferred/haI")
local module7 = require("@luauforge/deferred/haJ")

local module8 = require("@luauforge/bundled/gKW")

local module9 = require("@luauforge/deferred/haH")
local module10 = require("@luauforge/bundled/fCI")
require("@luauforge/bundled/dKT")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings
local fFlagAXFixBodyColorButtonStaleRanges = AvatarExperienceFlags.FFlagAXFixBodyColorButtonStaleRanges
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/haA")
else
	v5 = nil
end

local extended = Roact.PureComponent:extend("BodyColorButton")
local iconsactionsselectOn = images["icons/actions/selectOn"]

local strictInterface = t.strictInterface
local v6 = {
	rangeId = t.optional(t.string),
	defaultBodyColorRanges = 0,
	pickerSelectedBodyPartIndex = 0,
	pickerBodyPartsToSliderAndColor3Values = 0,
	userId = 0,
	sliderValue = 0,
	isBodyColorButtonSelected = 0,
	buttonColor3 = 0,
	sendAnalytics = 0,
	setBodyColor3 = 0,
	analytics = 0,
	disabled = 0
}

local v7 = if fFlagAXUseSignalsForBodyColorPickerSettings and fFlagAXFixBodyColorButtonStaleRanges then t.table else nil
v6.defaultBodyColorRanges = v7

v6.pickerSelectedBodyPartIndex = t.optional(t.number)
v6.pickerBodyPartsToSliderAndColor3Values = t.optional(t.table)

v6.userId = t.optional(t.string)
v6.sliderValue = t.number
v6.isBodyColorButtonSelected = t.boolean
v6.buttonColor3 = t.Color3

v6.sendAnalytics = t.callback
v6.setBodyColor3 = t.callback

v6.analytics = t.table
v6.disabled = t.optional(t.boolean)
extended.validateProps = strictInterface(v6)

function extended.onActivated(p2)
	local rangeId = p2.props.rangeId
	local buttonColor3 = p2.props.buttonColor3
	local sliderValue = p2.props.sliderValue

	p2.props.setBodyColor3(buttonColor3, rangeId, sliderValue, p2.props.analytics)
end

function extended:render()
	return withStyle(function(p2)
		local theme = p2.Theme
		local v8

		if self.props.isBodyColorButtonSelected then
			v8 = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.8, 0, 0.8, 0),
				BackgroundTransparency = theme.Overlay.Transparency,
				BackgroundColor3 = theme.Overlay.Color,
				BorderSizePixel = 0
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.5, 0)
				}),
				Checkmark = Roact.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 30, 0, 30),
					BackgroundTransparency = 1,
					Image = iconsactionsselectOn,
					ImageColor3 = theme.ContextualPrimaryContent.Color,
					ImageTransparency = theme.ContextualPrimaryContent.Transparency
				})
			})
		else
			v8 = nil
		end

		local buttonColor3 = self.props.buttonColor3
		assert(buttonColor3 ~= nil, "backgroundColor3 is nil")

		return withSelectionCursorProvider(function(callback)
			return Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				{
					TextButton = Roact.createElement(focusable.TextButton, {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 0,
						BackgroundColor3 = buttonColor3,
						Text = "",
						BorderSizePixel = 0,
						AutoButtonColor = false,
						ZIndex = 2,
						SelectionImageObject = callback(cursorKind.SkinToneCircle),
						[Roact.Event.Activated] = not self.props.disabled and function(p3)
							self:onActivated()
						end or nil
					}, {
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0.5, 0)
						}),
						EquippedFrame = v8
					}),
					Border = Roact.createElement("Frame", {
						Size = UDim2.new(1, 2, 1, 2),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						BorderSizePixel = 0,
						ZIndex = 1
					}, {
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0.5, 0)
						})
					})
				}
			)
		end)
	end)
end

local v8 = roactServices.connect({ analytics = module })(extended)

local v9 = RoactRodux.connect(function(p2, data)
	local v10 = module8(p2)
	local v11

	if fFlagAXUseSignalsForBodyColorPickerSettings then
		local getColor3ForBodyPartIndex = module10.getColor3ForBodyPartIndex
		local rangeId = data.rangeId
		local pickerSelectedBodyPartIndex = data.pickerSelectedBodyPartIndex
		local pickerBodyPartsToSliderAndColor3Values = data.pickerBodyPartsToSliderAndColor3Values
		local v12

		if fFlagAXFixBodyColorButtonStaleRanges then
			v12 = data.defaultBodyColorRanges
		else
			v12 = p2.AvatarExperience.AvatarEditor.DefaultBodyColorRanges
		end

		v11 = getColor3ForBodyPartIndex(
			rangeId,
			pickerSelectedBodyPartIndex,
			pickerBodyPartsToSliderAndColor3Values,
			v12
		)
	else
		v11 = module6(p2.AvatarExperience, data.rangeId)
	end

	local v12

	if fFlagAXUseSignalsForBodyColorPickerSettings then
		v12 = module9(p2, data.pickerSelectedBodyPartIndex)
	else
		v12 = module5(p2)
	end

	local v13 = v12 == data.rangeId and not v10
	local userId = module4.getUserId(p2)

	return {
		sliderValue = if fFlagAXUseSignalsForBodyColorPickerSettings then module10.getSliderValueForBodyPartIndex(
			data.pickerSelectedBodyPartIndex,
			data.pickerBodyPartsToSliderAndColor3Values
		) else module7(p2.AvatarExperience, data.rangeId),
		buttonColor3 = v11,
		isBodyColorButtonSelected = v13,
		userId = userId,
		disabled = v10
	}
end, function(callback)
	return {
		sendAnalytics = function(p2, p3)
			callback(module3(p2, p3))
		end,
		setBodyColor3 = function(p2, p3, p4, p5)
			callback(module2(p2, p3, p4, p5))
		end
	}
end)(v8)

local function BodyColorButtonWithSignals(p2)
	local v10 = v5(false)

	local v11 = useSignalState(v10.getBodyPartsToSliderAndColor3ValuesForRange(p2.rangeId))
	local v12 = useSignalState(v10.getSelectedBodyPartIndex)
	return React.createElement(
		v9,
		Cryo.Dictionary.union(p2, {
			pickerSelectedBodyPartIndex = v12,
			pickerBodyPartsToSliderAndColor3Values = v11
		})
	)
end

if fFlagAXUseSignalsForBodyColorPickerSettings then
	return React.memo(BodyColorButtonWithSignals)
end

return v9
