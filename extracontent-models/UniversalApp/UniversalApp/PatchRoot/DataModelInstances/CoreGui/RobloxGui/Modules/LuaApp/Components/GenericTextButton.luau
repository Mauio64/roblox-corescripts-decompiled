local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(Modules.Common.Roact)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local v8 = Roact.PureComponent:extend("GenericTextButton")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local GetFFlagLuaAppFixSelectionCursor = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppFixSelectionCursor

function v8.init(p1) -- line: 24
	p1.state = {
		isButtonPressed = false
	}

	function p1.onInputBegan() -- line: 29
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = true
		})
	end
	function p1.onInputEnded() -- line: 35
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = false
		})
	end
end

local function getCombinedTransparency(p2, p3) -- line: 42
	return 1 - (1 - p2) * (1 - p3)
end

function v8.render(p4) -- line: 46
	-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), withSelectionCursorProvider (copy)
	if GetFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p5) -- line: 48
			-- upvalues: p4 (copy)
			return p4:renderWithSelectionCursor(p5)
		end)
	end

	return p4:renderWithSelectionCursor(nil)
end
function v8.renderWithSelectionCursor(p6, p7) -- line: 56
	-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), CursorKind (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DEPRECATED_ImageSetLabel (copy), ShimmerAnimation (copy)
	local themeSettings = p6.props.themeSettings
	local propsSize = p6.props.Size
	local propsPosition = p6.props.Position
	local propsAnchorPoint = p6.props.AnchorPoint
	local propsLayoutOrder = p6.props.LayoutOrder
	local propsText = p6.props.Text
	local propsFont = p6.props.Font
	local propsTextSize = p6.props.TextSize
	local onActivated = p6.props.onActivated
	local isLoading = p6.props.isLoading
	local isDisabled = p6.props.isDisabled
	local isButtonPressed = p6.state.isButtonPressed
	local v32 = themeSettings.Border.Hidden == false
	local NextSelectionDown = p6.props.NextSelectionDown
	local NextSelectionLeft = p6.props.NextSelectionLeft
	local NextSelectionRight = p6.props.NextSelectionRight
	local NextSelectionUp = p6.props.NextSelectionUp
	local themeSettingsColor = themeSettings.Color
	local n1 = 0
	local g43 = nil
	local v42 = nil

	if isLoading or isDisabled then
		themeSettingsColor = themeSettings.DisabledColor
		n1 = themeSettings.DisabledTransparency
	elseif isButtonPressed then
		themeSettingsColor = themeSettings.OnPressColor
		n1 = themeSettings.OnPressTransparency
	end

	local themeSettingsTransparency = themeSettings.Transparency
	local v40 = 1 - (1 - n1) * (1 - themeSettingsTransparency)

	if v32 then
		local BorderTransparency = themeSettings.Border.Transparency

		v42 = 1 - (1 - n1) * (1 - BorderTransparency)

		if v42 then
			g43 = true
		end
	end

	if not g43 then
		v42 = 0
	end

	g43 = false

	local TextTransparency = themeSettings.Text.Transparency
	local v45 = 1 - (1 - n1) * (1 - TextTransparency)
	local forwardRef = p6.props.forwardRef
	local v47 = nil

	if GetFFlagLuaAppFixSelectionCursor() then
		v47 = p7(CursorKind.InputButton)
	end

	return Roact.createElement(DEPRECATED_ImageSetButton, {
		Size = propsSize,
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		LayoutOrder = propsLayoutOrder,
		BackgroundTransparency = 1,
		Image = "LuaApp/buttons/buttonFill",
		ImageColor3 = themeSettingsColor,
		ImageTransparency = v40,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		NextSelectionDown = NextSelectionDown,
		NextSelectionLeft = NextSelectionLeft,
		NextSelectionRight = NextSelectionRight,
		NextSelectionUp = NextSelectionUp,
		SelectionImageObject = v47,
		[Roact.Ref] = forwardRef,
		[Roact.Event.InputBegan] = p6.onInputBegan,
		[Roact.Event.InputEnded] = p6.onInputEnded,
		[Roact.Event.Activated] = onActivated
	}, {
		Border = v32 and Roact.createElement(DEPRECATED_ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonStroke",
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = themeSettings.Border.Color,
			ImageTransparency = v42,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9)
		}),
		Text = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, propsTextSize),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = propsText,
			Font = propsFont,
			TextSize = propsTextSize,
			TextColor3 = themeSettings.Text.Color,
			TextTransparency = v45,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		ShimmerAnimation = isLoading and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Shimmer = Roact.createElement(ShimmerAnimation, {
				shimmerSpeed = 1.5,
				Size = UDim2.new(1, 0, 2, 0),
				Position = UDim2.new(0, 0, 0, 0)
			})
		})
	})
end

return Roact.forwardRef(function(p8, p9) -- line: 157
	-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
	return Roact.createElement(v8, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
