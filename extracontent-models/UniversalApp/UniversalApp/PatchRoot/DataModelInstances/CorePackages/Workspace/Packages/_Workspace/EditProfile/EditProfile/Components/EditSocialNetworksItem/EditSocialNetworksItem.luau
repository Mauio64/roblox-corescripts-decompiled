local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local CallbackInputBox = require(EditProfileParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Components.CallbackInputBox

local function EditSocialNetworksItem(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), useStyle (copy), useScreenSize (copy), SocialNetworksInEditProfileIXP (copy), UserInputService (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), IconSize (copy)
	local v15 = React.useRef(nil)
	local v16 = useStyle()
	local Font = v16.Font
	local Theme = v16.Theme
	local v19 = Font.BaseSize * Font.Body.RelativeSize
	local v20 = useScreenSize()
	local v21 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({
		isExposureEnabled = true
	})
	local v22 = if not v21 then nil else v21 == SocialNetworksInEditProfileIXP.Variants.VisibilityFirst and t1.isVisibilityNoOne
	local v23 = React.useCallback(function() -- line: 48
		-- upvalues: UserInputService (copy), v15 (copy), t1 (copy)
		if UserInputService.OnScreenKeyboardVisible then
			if v15.current and v15.current:IsFocused() then
				local v24 = UserInputService.OnScreenKeyboardPosition.Y - (v15.current.AbsolutePosition.Y + v15.current.AbsoluteSize.Y)

				if v24 < 0 then
					t1.setKeyboardOffset(v24)

					return
				end

				t1.setKeyboardOffset(0)

				return
			end
		else
			t1.setKeyboardOffset(0)
		end
	end, {
		v20,
		t1.setKeyboardOffset
	})

	React.useEffect(function() -- line: 64
		-- upvalues: UserInputService (copy), v23 (copy), t1 (copy), v15 (copy)
		local t2 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v23),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v23)
		}

		if t1.focusOn then
			task.spawn(function() -- line: 71
				-- upvalues: v15 (copy)
				if v15 and v15.current then
					v15.current:captureFocus()
				end
			end)
		end

		return function() -- line: 78
			-- upvalues: t2 (copy)
			for _, v27 in t2 do
				v27:Disconnect()
			end
		end
	end, { v23 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Interactable = not v22
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = if v21 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityFirst then nil else UDim.new(0, 12),
			PaddingBottom = if v21 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast then nil else UDim.new(0, 12)
		}),
		NetworkLabel = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			RichText = true,
			Font = Font.Body.Font,
			Text = t1.networkTitle,
			TextSize = v19,
			TextColor3 = Theme.TextDefault.Color,
			AutomaticSize = Enum.AutomaticSize.XY
		}),
		InputBackground = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v19 + 20),
			Image = Images["component_assets/circle_21"],
			ImageColor3 = Theme.UIMuted.Color,
			ImageTransparency = Theme.UIMuted.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9)
		}, {
			InputBorder = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v19 + 20),
				Image = Images["component_assets/circle_21_stroke_1"],
				ImageColor3 = Theme.Divider.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				TextBox = React.createElement(CallbackInputBox, {
					clearButtonDisabled = false,
					captureFocusOnMount = t1.focusOn,
					clearButtonSize = IconSize.Small,
					clearIcon = Images["icons/actions/edit/clear_small"],
					clearIconColor3 = Theme.IconEmphasis.Color,
					clearIconTransparency = if not v22 then nil else Theme.PlaceHolder.Transparency,
					initialInputText = t1.initialText,
					inputBoxRef = v15,
					inputTextColor3 = Theme.TextDefault.Color,
					inputTextSize = v19,
					inputTextTransparency = if not v22 then Theme.TextDefault.Transparency else Theme.PlaceHolder.Transparency,
					inputTextXAlignment = Enum.TextXAlignment.Left,
					placeholderText = t1.placeholderText,
					placeholderTextColor3 = Theme.TextDefault.Color,
					placeholderTextTransparency = if not v22 then nil else Theme.PlaceHolder.Transparency,
					textChangedCallback = t1.textChanged
				})
			})
		})
	})
end

return EditSocialNetworksItem
