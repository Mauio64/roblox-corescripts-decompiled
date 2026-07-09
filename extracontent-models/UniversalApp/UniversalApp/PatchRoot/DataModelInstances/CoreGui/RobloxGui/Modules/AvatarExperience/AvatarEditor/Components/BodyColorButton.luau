local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local SetBodyColor3 = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetBodyColor3)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local selectRangeIdForSelectedBodyParts = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectRangeIdForSelectedBodyParts)
local selectButtonColor3 = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectButtonColor3)
local selectButtonSliderValue = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectButtonSliderValue)
local selectDefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColorsToggled)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local v22 = Roact.PureComponent:extend("BodyColorButton")
local v23 = Images["icons/actions/selectOn"]

v22.validateProps = t.strictInterface({
	rangeId = t.optional(t.string),
	userId = t.optional(t.string),
	sliderValue = t.number,
	isBodyColorButtonSelected = t.boolean,
	buttonColor3 = t.Color3,
	sendAnalytics = t.callback,
	setBodyColor3 = t.callback,
	analytics = t.table,
	disabled = t.optional(t.boolean)
})

function v22.onActivated(p1) -- line: 56
	local rangeId = p1.props.rangeId
	local buttonColor3 = p1.props.buttonColor3
	local sliderValue = p1.props.sliderValue

	p1.props.setBodyColor3(buttonColor3, rangeId, sliderValue, p1.props.analytics)
end
function v22.render(p2) -- line: 64
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v23 (copy), withSelectionCursorProvider (copy), Focusable (copy), CursorKind (copy)
	return withStyle(function(p3) -- line: 65
		-- upvalues: p2 (copy), Roact (copy), ImageSetLabel (copy), v23 (copy), withSelectionCursorProvider (copy), Focusable (copy), CursorKind (copy)
		local Theme = p3.Theme
		local isBodyColorButtonSelected = p2.props.isBodyColorButtonSelected
		local u40 = nil

		if isBodyColorButtonSelected then
			u40 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.8, 0, 0.8, 0),
				BackgroundTransparency = Theme.Overlay.Transparency,
				BackgroundColor3 = Theme.Overlay.Color
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.5, 0)
				}),
				Checkmark = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 30, 0, 30),
					Image = v23,
					ImageColor3 = Theme.ContextualPrimaryContent.Color,
					ImageTransparency = Theme.ContextualPrimaryContent.Transparency
				})
			})
		end

		local buttonColor3 = p2.props.buttonColor3

		assert(buttonColor3 ~= nil, "backgroundColor3 is nil")

		return withSelectionCursorProvider(function(p4) -- line: 101
			-- upvalues: Roact (copy), Focusable (copy), buttonColor3 (copy), CursorKind (copy), p2 (copy), u40 (ref), Theme (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				TextButton = Roact.createElement(Focusable.TextButton, {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 0,
					BackgroundColor3 = buttonColor3,
					Text = "",
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 2,
					SelectionImageObject = p4(CursorKind.SkinToneCircle),
					[Roact.Event.Activated] = not p2.props.disabled and function(_) -- line: 120
						-- upvalues: p2 (copy)
						p2:onActivated()
					end or nil
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0.5, 0)
					}),
					EquippedFrame = u40
				}),
				Border = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 1,
					Size = UDim2.new(1, 2, 1, 2),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0.5, 0)
					})
				})
			})
		end)
	end)
end

local v24 = RoactServices.connect({
	analytics = Analytics
})(v22)

return (RoactRodux.connect(function(p6, p7) -- line: 152
	-- upvalues: selectDefaultTryOnBodyColorsToggled (copy), selectButtonColor3 (copy), selectRangeIdForSelectedBodyParts (copy), Utils (copy), selectButtonSliderValue (copy)
	local v32 = selectDefaultTryOnBodyColorsToggled(p6)
	local v33 = selectButtonColor3(p6.AvatarExperience, p7.rangeId)
	local v34 = selectRangeIdForSelectedBodyParts(p6) == p7.rangeId and not v32
	local v35 = Utils.getUserId(p6)

	return {
		sliderValue = selectButtonSliderValue(p6.AvatarExperience, p7.rangeId),
		buttonColor3 = v33,
		isBodyColorButtonSelected = v34,
		userId = v35,
		disabled = v32
	}
end, function(p8) -- line: 169
	-- upvalues: SendAnalytics (copy), SetBodyColor3 (copy)
	return {
		sendAnalytics = function(p9, p10) -- line: 171
			-- upvalues: p8 (copy), SendAnalytics (copy)
			p8(SendAnalytics(p9, p10))
		end,
		setBodyColor3 = function(p11, p12, p13, p14) -- line: 174
			-- upvalues: p8 (copy), SetBodyColor3 (copy)
			p8(SetBodyColor3(p11, p12, p13, p14))
		end
	}
end)(v24))
