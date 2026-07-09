local Parent = script:FindFirstAncestor("ItemsReceivedAlert").Parent
local React = require(Parent.React)
local useDefaultFocusBehavior = require(Parent.ReactFocusNavigation).useDefaultFocusBehavior
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useDesignTokens = require(Parent.Style).useDesignTokens

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: useScreenSize (copy), useDefaultFocusBehavior (copy), useDispatch (copy), useDesignTokens (copy), React (copy), StyledTextLabel (copy), ButtonType (copy), InteractiveAlert (copy)
	local v12 = useScreenSize()
	local v13, v14 = useDefaultFocusBehavior()
	local v15 = useDispatch()
	local v16 = useDesignTokens(function(p1) -- line: 39
		return {
			thumbnailContainerTransparency = 0.92,
			listPadding = p1.Size.Size_400,
			thumbnailContainerRadius = p1.Size.Size_300,
			bodyTextFont = p1.Typography.BodyLarge,
			bodyTextColor = p1.Color.Content.Default,
			buttonStackSpacing = p1.Size.Size_300,
			buttonTextFont = p1.Typography.BodyLarge
		}
	end)
	local v17 = React.useCallback(function() -- line: 51
		-- upvalues: React (copy), v16 (copy), t1 (copy), StyledTextLabel (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v16.listPadding)
			}),
			AvatarThumbnailContainer = React.createElement("Frame", {
				LayoutOrder = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, t1.avatarThumbnailDisplayHeight),
				BackgroundTransparency = v16.thumbnailContainerTransparency,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v16.thumbnailContainerRadius)
				}),
				AvatarThumbnail = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = t1.avatarThumbnail,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromScale(1, 1)
				})
			}),
			BodyText = if not t1.bodyText then nil else React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				richText = true,
				textWrapped = true,
				automaticSize = Enum.AutomaticSize.XY,
				fontStyle = v16.bodyTextFont,
				colorStyle = v16.bodyTextColor,
				text = t1.bodyText,
				textXAlignment = Enum.TextXAlignment.Center
			})
		})
	end, {
		t1.avatarThumbnail,
		t1.avatarThumbnailDisplayHeight,
		t1.bodyText,
		v16
	})
	local t2 = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = function() -- line: 101
				-- upvalues: t1 (copy), v15 (copy)
				if t1.onPrimaryButtonActivated then
					t1.onPrimaryButtonActivated()

					return
				end

				if t1.closeCentralOverlayThunk then
					v15(t1.closeCentralOverlayThunk())
				end
			end,
			text = t1.primaryButtonText,
			buttonRef = v13,
			fontStyle = v16.buttonTextFont
		}
	}
	local v19 = t1.secondaryButtonText and {
		buttonType = ButtonType.Secondary,
		props = {
			onActivated = function() -- line: 118
				-- upvalues: t1 (copy), v15 (copy)
				if t1.onSecondaryButtonActivated then
					t1.onSecondaryButtonActivated()

					return
				end

				if t1.closeCentralOverlayThunk then
					v15(t1.closeCentralOverlayThunk())
				end
			end,
			text = t1.secondaryButtonText,
			fontStyle = v16.buttonTextFont
		}
	}

	return React.createElement(InteractiveAlert, {
		defaultChildRef = v14,
		screenSize = v12,
		title = t1.titleText,
		middleContent = v17,
		buttonStackInfo = {
			disableGamepadRefs = true,
			marginBetween = v16.buttonStackSpacing,
			buttons = if not t1.secondaryButtonText then { t2 } else {
				v19,
				t2
			}
		}
	})
end
