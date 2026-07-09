local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local UserLib = require(EditProfileParent.UserLib)
local FocusNavigationUtils = require(EditProfileParent.FocusNavigationUtils)
local useFocusGuiObject = require(EditProfileParent.ReactFocusNavigation).useFocusGuiObject
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local EditProfileTopBar = require(EditProfile.Components.EditProfileTopBar)
local EditTextButton = require(EditProfile.Components.EditTextButton)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)

require(EditProfile.Common.Types)

local Constants = require(EditProfile.Common.Constants)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local UserProfileSettingsNetworking = require(EditProfile.Networking.UserProfileSettingsNetworking)
local useDispatch = require(EditProfileParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Foundation = require(EditProfileParent.Foundation)
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local useUserExperiment = require(EditProfileParent.RoactAppExperiment).useUserExperiment
local FFlagEditProfileBackgroundEnabled = require(EditProfileParent.SharedFlags).FFlagEditProfileBackgroundEnabled
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab
local useNavigation = require(EditProfileParent.Navigation).useNavigation
local EditProfileBackgroundViewport = require(EditProfile.Components.EditProfileBackgroundViewport)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FFlagEditProfileNavigateToAvatar = require(EditProfile.Flags.FFlagEditProfileNavigateToAvatar)
local FStringEditProfileToAvatarLayerName = require(EditProfile.Flags.FStringEditProfileToAvatarLayerName)
local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local v36 = game:DefineFastFlag("EditProfileScrollable", false)
local FFlagMoveInExperienceModeToEditProfile = require(EditProfileParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local FFlagAuthSecExclusions = require(EditProfileParent.SharedFlags).FFlagAuthSecExclusions
local UniversalAppPolicy = require(EditProfileParent.UniversalAppPolicy)
local v40 = utf8.char(57346)

local function EditProfileEntryPoint(t1: {[any]: any}) -- line: 95
	-- upvalues: FFlagEditProfileBackgroundEnabled (copy), useNavigation (copy), useLastInputMode (copy), useFocusGuiObject (copy), useUserExperiment (copy), FStringEditProfileToAvatarLayerName (copy), SocialNetworksInEditProfileIXP (copy), FFlagAuthSecExclusions (copy), UniversalAppPolicy (copy), useStyle (copy), useLocalization (copy), TextKeys (copy), FFlagMoveInExperienceModeToEditProfile (copy), useDispatch (copy), v40 (copy), useDisplayNameText (copy), React (copy), UserProfileSettingsNetworking (copy), Constants (copy), ImageSetLabel (copy), Images (copy), FFlagEditProfileFixFocusNavigation (copy), EditTextButton (copy), FFlagAXEnableProfileTab (copy), v36 (copy), EditProfileTopBar (copy), FFlagEditProfileNavigateToAvatar (copy), EditProfileBackgroundViewport (copy), Foundation (copy), Button (copy), ButtonSize (copy), LoadableImage (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), StyledTextLabel (copy), VerticalScrollView (copy)
	local v43 = if not FFlagEditProfileBackgroundEnabled then nil else useNavigation()
	local v44 = useLastInputMode()
	local v45 = useFocusGuiObject()
	local v46 = useUserExperiment({ FStringEditProfileToAvatarLayerName }, function(p1) -- line: 99
		-- upvalues: FStringEditProfileToAvatarLayerName (copy)
		return (p1[FStringEditProfileToAvatarLayerName] or {}).profile_picture_on
	end)
	local v47 = SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled()
	local v48 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({
		isExposureEnabled = true
	})
	local v49 = v48 and v48 ~= SocialNetworksInEditProfileIXP.Variants.Control
	local v50 = if not FFlagAuthSecExclusions then nil else UniversalAppPolicy.useAppPolicy(function(p2) -- line: 110
		return p2.getExcludeUsernameUpdateModeration()
	end)
	local v51 = useStyle()
	local Theme = v51.Theme
	local Font = v51.Font
	local v54 = useLocalization({
		thousand = TextKeys.UsernamePrice
	})
	local v55 = if not FFlagMoveInExperienceModeToEditProfile then nil else useDispatch()
	local v56 = useLocalization({
		About = TextKeys.About,
		AboutModalCaption = TextKeys.AboutModalCaption,
		AboutPlaceholder = TextKeys.AboutPlaceholder,
		Username = TextKeys.Username,
		UsernameCaption = {
			TextKeys.UsernameDescription,
			icon = v40,
			price = v54.thousand
		},
		EditBackground = if not FFlagEditProfileBackgroundEnabled then nil else TextKeys.EditBackground,
		SocialNetworks = if not v47 or not v49 then nil else TextKeys.SocialNetworks,
		SocialNetworksCaption = if not v47 or (not v49 or (not t1.socialInfo or not t1.socialInfo.visibility)) then nil else TextKeys[t1.socialInfo.visibility]
	})
	local v57 = useDisplayNameText()
	local v58 = if not FFlagMoveInExperienceModeToEditProfile then nil else React.useCallback(function() -- line: 145
		-- upvalues: v55 (copy), UserProfileSettingsNetworking (copy), t1 (copy)
		v55(UserProfileSettingsNetworking.SetUserProfileSettings.API({
			isInExperienceNameEnabled = not t1.isInExperienceNameEnabled
		})):andThen(function(p3) -- line: 148
			-- upvalues: t1 (copy)
			if p3.responseBody.successfullyUpdated then
				t1.onToggleInExperienceMode()
			end
		end)
	end, {
		t1.onToggleInExperienceMode,
		t1.isInExperienceNameEnabled,
		UserProfileSettingsNetworking.SetUserProfileSettings
	})
	local u59 = false
	local v60 = if not v47 then nil else React.useMemo(function() -- line: 164
		-- upvalues: t1 (copy), Constants (copy), React (copy), Theme (copy), ImageSetLabel (copy), Images (copy), u59 (ref)
		local t2 = {}

		if t1.socialInfo and t1.socialInfo.socialLinks then
			for i, v in ipairs(Constants.SocialMediaOrder) do
				t2[v] = React.createElement("ImageButton", {
					LayoutOrder = i,
					BackgroundTransparency = 0,
					Size = UDim2.new(0, 40, 0, 40),
					BackgroundColor3 = Theme.BackgroundUIDefault.Color,
					[React.Event.Activated] = if not t1.openEditSocialLinksModal then nil else function() -- line: 174
						-- upvalues: t1 (copy), i (copy)
						t1.openEditSocialLinksModal(i)
					end
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					}),
					Icon = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = Images[Constants.SocialMediaIcons[v]],
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = not t1.socialInfo.socialLinks[v] and 0.5 or 0,
						Size = UDim2.new(0, 28, 0, 28),
						Position = UDim2.new(0, 6, 0, 6)
					})
				})

				if t1.socialInfo.socialLinks[v] then
					u59 = true
				end
			end
		end

		return t2
	end, {
		t1.socialInfo,
		Theme,
		t1.openEditSocialLinksModal
	})
	local v61 = nil

	if FFlagEditProfileFixFocusNavigation then
		v61 = React.useCallback(function(p4) -- line: 203
			-- upvalues: v44 (copy), v45 (copy)
			if p4 and v44 == "Focus" then
				v45(p4)
			end
		end, {})
	end

	local v62 = if not v50 then React.createElement(EditTextButton, {
		layoutOrder = 2,
		expandSizing = false,
		transparentText = false,
		shouldShimmerName = t1.shouldShimmerName,
		title = v56.Username,
		description = v56.UsernameCaption,
		placeHolderText = "@" .. t1.username,
		localUserId = t1.localUserId,
		onActivated = t1.navigateToEditUsername
	}) else nil
	local v63 = FFlagAXEnableProfileTab and t1.fullBleed
	local v64 = React.createElement("Frame", {
		BackgroundColor3 = v51.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v51.Theme.BackgroundDefault.Transparency,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = if not v36 then nil else Enum.AutomaticSize.Y,
		Position = if not v63 then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0),
		AnchorPoint = if not v63 then Vector2.new(1, 0) else Vector2.new(0, 0)
	}, {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = if not v63 then Vector2.new(640, 1e999) else Vector2.new(1e999, 1e999)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 24)
		}),
		TopPadding = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20)
		}),
		TopBar = React.createElement(EditProfileTopBar, {
			layoutOrder = 1,
			onClose = t1.onClose
		}),
		ProfilePicture = if not FFlagEditProfileNavigateToAvatar and not v46 then nil else if not FFlagEditProfileBackgroundEnabled then React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(1, 0, 0, 100)
		}, {
			Picture = React.createElement("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				LayoutOrder = 1,
				Size = UDim2.new(0, 100, 0, 100),
				BackgroundTransparency = 1,
				BorderSizePixel = 10,
				[React.Event.Activated] = t1.openEditProfilePicture
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.5, 0)
				}),
				UserAvatar = React.createElement(LoadableImage, {
					useShimmerAnimationWhileLoading = true,
					shouldHandleReloads = true,
					Size = UDim2.new(1, 0, 1, 0),
					cornerRadius = UDim.new(0.5, 0),
					Image = getStandardSizeAvatarHeadShotRbxthumb(t1.localUserId),
					BackgroundColor3 = Theme.PlaceHolder.Color,
					BackgroundTransparency = Theme.PlaceHolder.Transparency
				})
			}),
			Button = React.createElement("ImageButton", {
				Size = UDim2.new(0, 36, 0, 36),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 80, 1, 0),
				BackgroundTransparency = Theme.UIMuted.Transparency,
				BackgroundColor3 = Theme.UIMuted.Color,
				[React.Event.Activated] = t1.openEditProfilePicture
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 4)
				}),
				Icon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["icons/menu/profilepicture_large"],
					ImageColor3 = Theme.IconEmphasis.Color,
					Size = UDim2.new(0, 28, 0, 28),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			})
		}) else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(1, 0, 0, 200)
		}, {
			Bar = React.createElement("Frame", {
				LayoutOrder = 1,
				ZIndex = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 150)
			}, {
				ProfileBackgroundBanner = React.createElement(EditProfileBackgroundViewport, {
					height = 150
				}),
				EditBackgroundButton = React.createElement(Foundation.View, {
					tag = "position-center-center anchor-center-center auto-xy",
					ZIndex = 2
				}, {
					Button = React.createElement(Button, {
						text = v56.EditBackground,
						onActivated = function() -- line: 278
							-- upvalues: v43 (copy), t1 (copy)
							v43.navigate(t1.profileScreens.EditProfileBackground)
						end,
						variant = Foundation.Enums.ButtonVariant.SubEmphasis,
						size = ButtonSize.Small
					})
				}),
				Picture = React.createElement("ImageButton", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 24, 1, 0),
					Size = UDim2.new(0, 100, 0, 100),
					BackgroundTransparency = 0,
					BorderSizePixel = 10,
					ZIndex = 2,
					[React.Event.Activated] = t1.openEditProfilePicture
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0.5, 0)
					}),
					UserAvatar = React.createElement(LoadableImage, {
						useShimmerAnimationWhileLoading = true,
						shouldHandleReloads = true,
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						cornerRadius = UDim.new(0.5, 0),
						Image = getStandardSizeAvatarHeadShotRbxthumb(t1.localUserId),
						BackgroundColor3 = Theme.PlaceHolder.Color,
						BackgroundTransparency = Theme.PlaceHolder.Transparency
					}),
					Button = React.createElement("ImageButton", {
						Size = UDim2.new(0, 32, 0, 32),
						AnchorPoint = Vector2.new(0.5, 1),
						Position = UDim2.new(0.5, 35, 1, 0),
						BackgroundTransparency = 0,
						BackgroundColor3 = Theme.BackgroundUIDefault.Color,
						ZIndex = 3,
						[React.Event.Activated] = t1.openEditProfilePicture
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0.5, 0)
						}),
						Icon = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							ZIndex = 3,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Image = Images["icons/actions/edit/edit"],
							ImageColor3 = Theme.IconEmphasis.Color,
							Size = UDim2.new(0, 22, 0, 22),
							Position = UDim2.fromScale(0.5, 0.5)
						})
					})
				})
			})
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -48, 0, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 24)
			}),
			DisplayNameButton = React.createElement(EditTextButton, {
				layoutOrder = 1,
				expandSizing = false,
				transparentText = false,
				shouldShimmerName = t1.shouldShimmerName,
				title = v57.displayNameTitle,
				description = v57.displayNameCaption,
				placeHolderText = t1.displayName,
				localUserId = t1.localUserId,
				onActivated = t1.openDisplayNameModal,
				forwardRef = v61
			}),
			UsernameButton = v62,
			Divider = React.createElement("Frame", {
				LayoutOrder = 3,
				BorderSizePixel = 0,
				BackgroundColor3 = v51.Theme.Divider.Color,
				BackgroundTransparency = v51.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			AboutMeButton = React.createElement(EditTextButton, {
				layoutOrder = 4,
				shouldShimmerName = false,
				expandSizing = true,
				title = v56.About,
				description = v56.AboutModalCaption,
				placeHolderText = if t1.description == nil or t1.description == "" then v56.AboutPlaceholder else t1.description,
				localUserId = t1.localUserId,
				onActivated = t1.openEditDescription,
				transparentText = not t1.description or t1.description == ""
			}),
			Divider2 = if not v47 or (not v49 or t1.isUnder13) then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = not FFlagMoveInExperienceModeToEditProfile and 5 or 8,
				BackgroundColor3 = v51.Theme.Divider.Color,
				BackgroundTransparency = v51.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			SocialNetworksButton = if not v47 or (not v49 or (not t1.socialInfo or (not t1.socialInfo.socialLinks or t1.isUnder13))) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = not FFlagMoveInExperienceModeToEditProfile and 6 or 9,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 20)
				}),
				Title = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					text = v56.SocialNetworks,
					fontStyle = Font.Header2,
					colorStyle = Theme.TextEmphasis
				}),
				Description = if not u59 then nil else React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					lineHeight = 1,
					text = v56.SocialNetworksCaption,
					fontStyle = Font.CaptionBody,
					colorStyle = Theme.TextDefault,
					automaticSize = Enum.AutomaticSize.Y,
					size = UDim2.new(1, 0, 0, 0)
				}),
				NetworkIcons = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 40)
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12)
					}),
					SocialNetworks = React.createElement(React.Fragment, {}, v60),
					Padding = React.createElement("Frame", {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -318, 0, 40)
					}),
					PencilIcon = React.createElement("ImageButton", {
						LayoutOrder = 7,
						BackgroundTransparency = 0,
						Size = UDim2.new(0, 40, 0, 40),
						BackgroundColor3 = v51.Theme.BackgroundDefault.Color,
						BorderSizePixel = 0,
						[React.Event.Activated] = if not t1.openEditSocialLinksModal then nil else function() -- line: 514
							-- upvalues: t1 (copy)
							t1.openEditSocialLinksModal(-1)
						end
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						}),
						Icon = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Image = Images["icons/actions/edit/edit"],
							ImageColor3 = Theme.IconEmphasis.Color,
							Size = UDim2.new(0, 28, 0, 28),
							Position = UDim2.new(0, 6, 0, 6)
						})
					})
				})
			}),
			Divider3 = if not FFlagMoveInExperienceModeToEditProfile or not t1.canSeeInExperienceMode then nil else React.createElement("Frame", {
				LayoutOrder = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = v51.Theme.Divider.Color,
				BackgroundTransparency = v51.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			InExperienceModeSection = if not FFlagMoveInExperienceModeToEditProfile or not t1.canSeeInExperienceMode then nil else React.createElement("Frame", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20)
				}),
				React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = "In-Experience Mode",
						Size = UDim2.fromOffset(0, 0),
						TextYAlignment = Enum.TextYAlignment.Center,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextSize = Font.BaseSize * Font.Body.RelativeSize,
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = Font.Header2.Font,
						TextColor3 = Theme.TextEmphasis.Color
					}),
					InExperienceNameToggleButton = React.createElement(Button, {
						LayoutOrder = 2,
						text = not t1.isInExperienceNameEnabled and "Start" or "Stop",
						onActivated = v58,
						size = ButtonSize.XSmall
					})
				}),
				InExperienceModeButton = React.createElement(EditTextButton, {
					layoutOrder = 2,
					description = "When in-experience mode is on, this temporary Name will replace your Name in most experiences.",
					transparentText = true,
					expandSizing = true,
					shouldShimmerName = false,
					placeHolderText = t1.inExperienceName or "",
					localUserId = t1.localUserId
				}),
				BottomPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 24)
				})
			})
		})
	})

	if v36 then
		return React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never
		}, { v64 })
	end

	return v64
end

return EditProfileEntryPoint
