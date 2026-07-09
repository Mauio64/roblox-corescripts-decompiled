local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local EditSocialNetworksItem = require(EditProfile.Components.EditSocialNetworksItem)
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local useNavigationProps = require(EditProfileParent.RobloxAppNavigation).useNavigationProps
local Constants = require(EditProfile.Common.Constants)

require(EditProfile.Common.Types)

local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

return function(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), Constants (copy), useLocalization (copy), TextKeys (copy), useNavigationProps (copy), SocialNetworksInEditProfileIXP (copy), useStyle (copy), useScreenSize (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), VerticalScrollView (copy), InteractiveAlert (copy), EditSocialNetworksItem (copy), DropdownMenu (copy), ButtonType (copy)
	local v20, v21 = React.useState(t1.socialNetworks.facebook)
	local v22, v23 = React.useState(t1.socialNetworks.twitter)
	local v24, v25 = React.useState(t1.socialNetworks.youtube)
	local v26, v27 = React.useState(t1.socialNetworks.twitch)
	local v28, v29 = React.useState(t1.socialNetworks.guilded)
	local v30, v31 = React.useState(t1.socialNetworksVisbility)
	local v32, v33 = React.useState(0)
	local v34 = v30 == Constants.VisibilitySettings.NoOne
	local v35 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		saveButtonText = TextKeys.SaveButtonText,
		socialNetworks = TextKeys.SocialNetworks,
		Facebook = TextKeys.Facebook,
		X = TextKeys.X,
		YouTube = TextKeys.YouTube,
		Twitch = TextKeys.Twitch,
		Guilded = TextKeys.Guilded,
		FacebookExample = TextKeys.FacebookExample,
		TwitterExample = TextKeys.TwitterExample,
		YouTubeExample = TextKeys.YouTubeExample,
		TwitchExample = TextKeys.TwitchExample,
		GuildedExample = TextKeys.GuildedExample,
		AllUsers = TextKeys.AllUsersDropDown,
		Friends = TextKeys.FriendsDropDown,
		NoOne = TextKeys.NoOneDropDown,
		FriendsFollowingAndFollowers = TextKeys.FriendsFollowingAndFollowersDropDown,
		FriendsAndFollowing = TextKeys.FriendsAndFollowingDropDown,
		VisibleTo = TextKeys.VisibleTo
	})
	local v36 = useNavigationProps(function(_, p2) -- line: 71
		return {
			focusOn = p2.focusOn
		}
	end)
	local v37 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({
		isExposureEnabled = true
	})
	local v38 = useStyle()
	local Font = v38.Font
	local Theme = v38.Theme
	local v41 = Font.BaseSize * Font.Body.RelativeSize
	local v42 = useScreenSize()

	local function onSave() -- line: 85
		-- upvalues: t1 (copy), v30 (copy), v20 (copy), v22 (copy), v24 (copy), v26 (copy), v28 (copy)
		t1.saveOnActivated(v30, v20, v22, v24, v26, v28)
	end

	local v44 = React.useCallback(function(p3) -- line: 89
		-- upvalues: v31 (copy)
		v31(p3)
	end, {})

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = t1.cancelOnActivated
		}, { React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never
		}, { React.createElement(InteractiveAlert, {
			title = v35.socialNetworks,
			screenSize = v42,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 30 + v32),
			middleContent = function() -- line: 107
				-- upvalues: React (copy), EditSocialNetworksItem (copy), v21 (copy), v35 (copy), v20 (copy), v37 (copy), SocialNetworksInEditProfileIXP (copy), v36 (copy), v34 (copy), v33 (copy), v23 (copy), v22 (copy), v25 (copy), v24 (copy), v27 (copy), v26 (copy), v29 (copy), v28 (copy), Font (copy), v41 (copy), Theme (copy), DropdownMenu (copy), v30 (copy), v44 (copy), v42 (copy), Constants (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Facebook = React.createElement(EditSocialNetworksItem, {
						textChanged = v21,
						networkTitle = v35.Facebook,
						initialText = v20,
						placeholderText = v35.FacebookExample,
						layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 1,
						focusOn = v36.focusOn == 1,
						isVisibilityNoOne = v34,
						setKeyboardOffset = v33
					}),
					Twitter = React.createElement(EditSocialNetworksItem, {
						textChanged = v23,
						networkTitle = v35.X,
						initialText = v22,
						placeholderText = v35.TwitterExample,
						layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 2,
						focusOn = v36.focusOn == 2,
						isVisibilityNoOne = v34,
						setKeyboardOffset = v33
					}),
					YouTube = React.createElement(EditSocialNetworksItem, {
						textChanged = v25,
						networkTitle = v35.YouTube,
						initialText = v24,
						placeholderText = v35.YouTubeExample,
						layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 3,
						focusOn = v36.focusOn == 3,
						isVisibilityNoOne = v34,
						setKeyboardOffset = v33
					}),
					Twitch = React.createElement(EditSocialNetworksItem, {
						textChanged = v27,
						networkTitle = v35.Twitch,
						initialText = v26,
						placeholderText = v35.TwitchExample,
						layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 4,
						focusOn = v36.focusOn == 4,
						isVisibilityNoOne = v34,
						setKeyboardOffset = v33
					}),
					Guilded = React.createElement(EditSocialNetworksItem, {
						textChanged = v29,
						networkTitle = v35.Guilded,
						initialText = v28,
						placeholderText = v35.GuildedExample,
						layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 5,
						focusOn = v36.focusOn == 5,
						isVisibilityNoOne = v34,
						setKeyboardOffset = v33
					}),
					Visibility = React.createElement("Frame", {
						BackgroundTransparency = 1,
						ZIndex = 2,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 6
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						NetworkLabel = React.createElement("TextLabel", {
							LayoutOrder = -1,
							BackgroundTransparency = 1,
							RichText = true,
							ZIndex = 0,
							Font = Font.Body.Font,
							Text = v35.VisibleTo,
							TextSize = v41,
							TextColor3 = Theme.TextDefault.Color,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						Dropdown = React.createElement(DropdownMenu, {
							dropdownMenuListPositionFixed = true,
							showDropShadow = true,
							placeholder = v35[v30],
							onChange = v44,
							screenSize = Vector2.new(math.clamp(v42.X - 48, 272, 400) - 48, 640),
							height = UDim.new(0, v41 + 20),
							cellDatas = {
								{
									text = v35.AllUsers,
									key = Constants.VisibilitySettings.AllUsers
								},
								{
									text = v35.FriendsFollowingAndFollowers,
									key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
								},
								{
									text = v35.FriendsAndFollowing,
									key = Constants.VisibilitySettings.FriendsAndFollowing
								},
								{
									text = v35.Friends,
									key = Constants.VisibilitySettings.Friends
								},
								{
									text = v35.NoOne,
									key = Constants.VisibilitySettings.NoOne
								}
							},
							defaultKey = v30
						})
					})
				})
			end,
			buttonStackInfo = {
				buttonHeight = 48,
				marginBetween = 6,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = t1.cancelOnActivated,
							text = v35.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = onSave,
							text = v35.saveButtonText
						}
					}
				},
				forcedFillDirection = Enum.FillDirection.Horizontal
			}
		}) }) })
	end

	return React.createElement(VerticalScrollView, {
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(),
		elasticBehavior = Enum.ElasticBehavior.Never
	}, { React.createElement(InteractiveAlert, {
		title = v35.socialNetworks,
		screenSize = v42,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, 30 + v32),
		middleContent = function() -- line: 290
			-- upvalues: React (copy), EditSocialNetworksItem (copy), v21 (copy), v35 (copy), v20 (copy), v37 (copy), SocialNetworksInEditProfileIXP (copy), v36 (copy), v34 (copy), v33 (copy), v23 (copy), v22 (copy), v25 (copy), v24 (copy), v27 (copy), v26 (copy), v29 (copy), v28 (copy), Font (copy), v41 (copy), Theme (copy), DropdownMenu (copy), v30 (copy), v44 (copy), v42 (copy), Constants (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Facebook = React.createElement(EditSocialNetworksItem, {
					textChanged = v21,
					networkTitle = v35.Facebook,
					initialText = v20,
					placeholderText = v35.FacebookExample,
					layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 1,
					focusOn = v36.focusOn == 1,
					isVisibilityNoOne = v34,
					setKeyboardOffset = v33
				}),
				Twitter = React.createElement(EditSocialNetworksItem, {
					textChanged = v23,
					networkTitle = v35.X,
					initialText = v22,
					placeholderText = v35.TwitterExample,
					layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 2,
					focusOn = v36.focusOn == 2,
					isVisibilityNoOne = v34,
					setKeyboardOffset = v33
				}),
				YouTube = React.createElement(EditSocialNetworksItem, {
					textChanged = v25,
					networkTitle = v35.YouTube,
					initialText = v24,
					placeholderText = v35.YouTubeExample,
					layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 3,
					focusOn = v36.focusOn == 3,
					isVisibilityNoOne = v34,
					setKeyboardOffset = v33
				}),
				Twitch = React.createElement(EditSocialNetworksItem, {
					textChanged = v27,
					networkTitle = v35.Twitch,
					initialText = v26,
					placeholderText = v35.TwitchExample,
					layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 4,
					focusOn = v36.focusOn == 4,
					isVisibilityNoOne = v34,
					setKeyboardOffset = v33
				}),
				Guilded = React.createElement(EditSocialNetworksItem, {
					textChanged = v29,
					networkTitle = v35.Guilded,
					initialText = v28,
					placeholderText = v35.GuildedExample,
					layoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 5,
					focusOn = v36.focusOn == 5,
					isVisibilityNoOne = v34,
					setKeyboardOffset = v33
				}),
				Visibility = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = v37 ~= SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 6
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12)
					}),
					NetworkLabel = React.createElement("TextLabel", {
						LayoutOrder = -1,
						BackgroundTransparency = 1,
						RichText = true,
						ZIndex = 0,
						Font = Font.Body.Font,
						Text = v35.VisibleTo,
						TextSize = v41,
						TextColor3 = Theme.TextDefault.Color,
						AutomaticSize = Enum.AutomaticSize.XY
					}),
					Dropdown = React.createElement(DropdownMenu, {
						dropdownMenuListPositionFixed = true,
						showDropShadow = true,
						placeholder = v35[v30],
						onChange = v44,
						screenSize = Vector2.new(math.clamp(v42.X - 48, 272, 400) - 48, 640),
						height = UDim.new(0, v41 + 20),
						cellDatas = {
							{
								text = v35.AllUsers,
								key = Constants.VisibilitySettings.AllUsers
							},
							{
								text = v35.FriendsFollowingAndFollowers,
								key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
							},
							{
								text = v35.FriendsAndFollowing,
								key = Constants.VisibilitySettings.FriendsAndFollowing
							},
							{
								text = v35.Friends,
								key = Constants.VisibilitySettings.Friends
							},
							{
								text = v35.NoOne,
								key = Constants.VisibilitySettings.NoOne
							}
						},
						defaultKey = v30
					})
				})
			})
		end,
		buttonStackInfo = {
			buttonHeight = 48,
			marginBetween = 6,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = t1.cancelOnActivated,
						text = v35.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onSave,
						text = v35.saveButtonText
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	}) })
end
