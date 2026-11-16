local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local callbackInputBox = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.CallbackInputBox

local function EditSocialNetworksItem(props)
	local ref = React.useRef(nil)

	local v = useStyle()
	local font = v.Font
	local theme = v.Theme
	local v2 = font.BaseSize * font.Body.RelativeSize
	local v3 = useScreenSize()

	local v4 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({ isExposureEnabled = true })
	local v5

	if v4 then
		if v4 == SocialNetworksInEditProfileIXP.Variants.VisibilityFirst then
			v5 = props.isVisibilityNoOne
		else
			v5 = false
		end
	end

	local v6 = React.useCallback(function()
		if UserInputService.OnScreenKeyboardVisible then
			if ref.current and ref.current:IsFocused() then
				local v6 = UserInputService.OnScreenKeyboardPosition.Y - (ref.current.AbsolutePosition.Y + ref.current.AbsoluteSize.Y)

				if v6 < 0 then
					props.setKeyboardOffset(v6)
				else
					props.setKeyboardOffset(0)
				end
			end
		else
			props.setKeyboardOffset(0)
		end
	end, { v3, props.setKeyboardOffset })

	React.useEffect(function()
		local v7 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v6),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v6)
		}

		if props.focusOn then
			task.spawn(function()
				if ref and ref.current then
					ref.current:captureFocus()
				end
			end)
		end

		return function()
			for _, connection in v7 do
				connection:Disconnect()
			end
		end
	end, { v6 })

	local createElement = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		Interactable = not v5
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		Padding = 0,
		NetworkLabel = 0,
		InputBackground = 0
	}

	local createElement2 = React.createElement
	local paddingTop

	if v4 == SocialNetworksInEditProfileIXP.Variants.VisibilityFirst then
		paddingTop = UDim.new(0, 12)
	end

	local paddingBottom

	if v4 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast then
		paddingBottom = UDim.new(0, 12)
	end

	children.Padding = createElement2("UIPadding", {
		PaddingTop = paddingTop,
		PaddingBottom = paddingBottom
	})

	local createElement3 = React.createElement
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Body.Font
	end

	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	children.NetworkLabel = createElement3("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Font = font2,
		FontFace = fontFace,
		Text = props.networkTitle,
		TextSize = v2,
		TextColor3 = theme.TextDefault.Color,
		AutomaticSize = Enum.AutomaticSize.XY,
		RichText = true
	})

	local createElement4 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, v2 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Image = Images["component_assets/circle_21"],
		ImageColor3 = theme.UIMuted.Color,
		ImageTransparency = theme.UIMuted.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}

	local createElement5 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, v2 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Image = Images["component_assets/circle_21_stroke_1"],
		ImageColor3 = theme.Divider.Color,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}
	local v10 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		TextBox = 0
	}

	local createElement6 = React.createElement
	local v11 = {
		captureFocusOnMount = props.focusOn,
		clearButtonDisabled = false,
		clearButtonSize = IconSize.Small,
		clearIcon = Images["icons/actions/edit/clear_small"],
		clearIconColor3 = theme.IconEmphasis.Color,
		clearIconTransparency = 0,
		initialInputText = 0,
		inputBoxRef = 0,
		inputTextColor3 = 0,
		inputTextSize = 0,
		inputTextTransparency = 0,
		inputTextXAlignment = 0,
		placeholderText = 0,
		placeholderTextColor3 = 0,
		placeholderTextTransparency = 0,
		textChangedCallback = 0
	}
	local clearIconTransparency

	if v5 then
		clearIconTransparency = theme.PlaceHolder.Transparency
	end

	v11.clearIconTransparency = clearIconTransparency
	v11.initialInputText = props.initialText
	v11.inputBoxRef = ref
	v11.inputTextColor3 = theme.TextDefault.Color
	v11.inputTextSize = v2
	local inputTextTransparency

	if v5 then
		inputTextTransparency = theme.PlaceHolder.Transparency
	else
		inputTextTransparency = theme.TextDefault.Transparency
	end

	v11.inputTextTransparency = inputTextTransparency

	v11.inputTextXAlignment = Enum.TextXAlignment.Left
	v11.placeholderText = props.placeholderText
	v11.placeholderTextColor3 = theme.TextDefault.Color
	local placeholderTextTransparency

	if v5 then
		placeholderTextTransparency = theme.PlaceHolder.Transparency
	end

	v11.placeholderTextTransparency = placeholderTextTransparency
	v11.textChangedCallback = props.textChanged
	v10.TextBox = createElement6(callbackInputBox, v11)
	children.InputBackground = createElement4(ImageSetLabel, v8, {
		InputBorder = createElement5(ImageSetLabel, v9, v10)
	})
	return createElement("Frame", v7, children)
end

return EditSocialNetworksItem
