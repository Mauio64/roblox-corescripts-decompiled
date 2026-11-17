local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local EditSocialNetworksItem = require(EditProfile.Components.EditSocialNetworksItem)
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local Constants = require(EditProfile.Common.Constants)
require(EditProfile.Common.Types)
local SocialNetworksInEditProfileIXP = require(EditProfile.Flags.SocialNetworksInEditProfileIXP)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

return function(props)
	local state, setState = React.useState(props.socialNetworks.facebook)
	local state2, setState2 = React.useState(props.socialNetworks.twitter)
	local state3, setState3 = React.useState(props.socialNetworks.youtube)
	local state4, setState4 = React.useState(props.socialNetworks.twitch)
	local state5, setState5 = React.useState(props.socialNetworks.guilded)
	local state6, setState6 = React.useState(props.socialNetworksVisbility)
	local state7, setState7 = React.useState(0)
	local isVisibilityNoOne = state6 == Constants.VisibilitySettings.NoOne
	local v = useLocalization({
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

	local v2 = useNavigationProps(function(_, p)
		return { focusOn = p.focusOn }
	end)

	local v3 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({ isExposureEnabled = true })

	local v4 = useStyle()
	local font = v4.Font
	local theme = v4.Theme
	local textSize = font.BaseSize * font.Body.RelativeSize
	local screenSize = useScreenSize()

	local function onSave()
		props.saveOnActivated(state6, state, state2, state3, state4, state5)
	end

	local onChange = React.useCallback(function(p)
		setState6(p)
	end, {})

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = props.cancelOnActivated }, {
			React.createElement(
				VerticalScrollView,
				{
					useAutomaticCanvasSize = true,
					canvasSizeY = UDim.new(),
					elasticBehavior = Enum.ElasticBehavior.Never
				},
				{ React.createElement(InteractiveAlert, {
						title = v.socialNetworks,
						screenSize = screenSize,
						anchorPoint = Vector2.new(0.5, 0),
						position = UDim2.new(0.5, 0, 0, 30 + state7),
						middleContent = function()
							return React.createElement(
								"Frame",
								{
									BackgroundTransparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								},
								{
									UIListLayout = React.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										VerticalAlignment = Enum.VerticalAlignment.Center,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Facebook = React.createElement(EditSocialNetworksItem, {
										textChanged = setState,
										networkTitle = v.Facebook,
										initialText = state,
										placeholderText = v.FacebookExample,
										layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 2,
										focusOn = v2.focusOn == 1,
										isVisibilityNoOne = isVisibilityNoOne,
										setKeyboardOffset = setState7
									}),
									Twitter = React.createElement(EditSocialNetworksItem, {
										textChanged = setState2,
										networkTitle = v.X,
										initialText = state2,
										placeholderText = v.TwitterExample,
										layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 3,
										focusOn = v2.focusOn == 2,
										isVisibilityNoOne = isVisibilityNoOne,
										setKeyboardOffset = setState7
									}),
									YouTube = React.createElement(EditSocialNetworksItem, {
										textChanged = setState3,
										networkTitle = v.YouTube,
										initialText = state3,
										placeholderText = v.YouTubeExample,
										layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 4,
										focusOn = v2.focusOn == 3,
										isVisibilityNoOne = isVisibilityNoOne,
										setKeyboardOffset = setState7
									}),
									Twitch = React.createElement(EditSocialNetworksItem, {
										textChanged = setState4,
										networkTitle = v.Twitch,
										initialText = state4,
										placeholderText = v.TwitchExample,
										layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 5,
										focusOn = v2.focusOn == 4,
										isVisibilityNoOne = isVisibilityNoOne,
										setKeyboardOffset = setState7
									}),
									Guilded = React.createElement(EditSocialNetworksItem, {
										textChanged = setState5,
										networkTitle = v.Guilded,
										initialText = state5,
										placeholderText = v.GuildedExample,
										layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 6,
										focusOn = v2.focusOn == 5,
										isVisibilityNoOne = isVisibilityNoOne,
										setKeyboardOffset = setState7
									}),
									Visibility = React.createElement("Frame", {
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
										LayoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 1,
										ZIndex = 2
									}, {
										UIListLayout = React.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Vertical,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, 12)
										}),
										NetworkLabel = React.createElement("TextLabel", {
											LayoutOrder = -1,
											BackgroundTransparency = 1,
											FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
											Text = v.VisibleTo,
											TextSize = textSize,
											TextColor3 = theme.TextDefault.Color,
											AutomaticSize = Enum.AutomaticSize.XY,
											RichText = true,
											ZIndex = 0
										}),
										Dropdown = React.createElement(DropdownMenu, {
											placeholder = v[state6],
											onChange = onChange,
											screenSize = Vector2.new(math.clamp(screenSize.X - 48, 272, 400) - 48, 640),
											height = UDim.new(0, textSize + 20),
											dropdownMenuListPositionFixed = true,
											cellDatas = {
												{
													text = v.AllUsers,
													key = Constants.VisibilitySettings.AllUsers
												},
												{
													text = v.FriendsFollowingAndFollowers,
													key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
												},
												{
													text = v.FriendsAndFollowing,
													key = Constants.VisibilitySettings.FriendsAndFollowing
												},
												{
													text = v.Friends,
													key = Constants.VisibilitySettings.Friends
												},
												{
													text = v.NoOne,
													key = Constants.VisibilitySettings.NoOne
												}
											},
											showDropShadow = true,
											defaultKey = state6
										})
									})
								}
							)
						end,
						buttonStackInfo = {
							buttons = {
								{
									buttonType = ButtonType.Secondary,
									props = {
										onActivated = props.cancelOnActivated,
										text = v.cancelButtonText
									}
								},
								{
									buttonType = ButtonType.PrimarySystem,
									props = { onActivated = onSave, text = v.saveButtonText }
								}
							},
							buttonHeight = 48,
							marginBetween = 6,
							forcedFillDirection = Enum.FillDirection.Horizontal
						}
					}) }
			)
		})
	end

	return React.createElement(
		VerticalScrollView,
		{
			useAutomaticCanvasSize = true,
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never
		},
		{ React.createElement(InteractiveAlert, {
				title = v.socialNetworks,
				screenSize = screenSize,
				anchorPoint = Vector2.new(0.5, 0),
				position = UDim2.new(0.5, 0, 0, 30 + state7),
				middleContent = function()
					return React.createElement(
						"Frame",
						{ BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
						{
							UIListLayout = React.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Facebook = React.createElement(EditSocialNetworksItem, {
								textChanged = setState,
								networkTitle = v.Facebook,
								initialText = state,
								placeholderText = v.FacebookExample,
								layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 2,
								focusOn = v2.focusOn == 1,
								isVisibilityNoOne = isVisibilityNoOne,
								setKeyboardOffset = setState7
							}),
							Twitter = React.createElement(EditSocialNetworksItem, {
								textChanged = setState2,
								networkTitle = v.X,
								initialText = state2,
								placeholderText = v.TwitterExample,
								layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 3,
								focusOn = v2.focusOn == 2,
								isVisibilityNoOne = isVisibilityNoOne,
								setKeyboardOffset = setState7
							}),
							YouTube = React.createElement(EditSocialNetworksItem, {
								textChanged = setState3,
								networkTitle = v.YouTube,
								initialText = state3,
								placeholderText = v.YouTubeExample,
								layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 4,
								focusOn = v2.focusOn == 3,
								isVisibilityNoOne = isVisibilityNoOne,
								setKeyboardOffset = setState7
							}),
							Twitch = React.createElement(EditSocialNetworksItem, {
								textChanged = setState4,
								networkTitle = v.Twitch,
								initialText = state4,
								placeholderText = v.TwitchExample,
								layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 5,
								focusOn = v2.focusOn == 4,
								isVisibilityNoOne = isVisibilityNoOne,
								setKeyboardOffset = setState7
							}),
							Guilded = React.createElement(EditSocialNetworksItem, {
								textChanged = setState5,
								networkTitle = v.Guilded,
								initialText = state5,
								placeholderText = v.GuildedExample,
								layoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 6,
								focusOn = v2.focusOn == 5,
								isVisibilityNoOne = isVisibilityNoOne,
								setKeyboardOffset = setState7
							}),
							Visibility = React.createElement("Frame", {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								LayoutOrder = v3 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 1,
								ZIndex = 2
							}, {
								UIListLayout = React.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 12)
								}),
								NetworkLabel = React.createElement("TextLabel", {
									LayoutOrder = -1,
									BackgroundTransparency = 1,
									FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
									Text = v.VisibleTo,
									TextSize = textSize,
									TextColor3 = theme.TextDefault.Color,
									AutomaticSize = Enum.AutomaticSize.XY,
									RichText = true,
									ZIndex = 0
								}),
								Dropdown = React.createElement(DropdownMenu, {
									placeholder = v[state6],
									onChange = onChange,
									screenSize = Vector2.new(math.clamp(screenSize.X - 48, 272, 400) - 48, 640),
									height = UDim.new(0, textSize + 20),
									dropdownMenuListPositionFixed = true,
									cellDatas = {
										{
											text = v.AllUsers,
											key = Constants.VisibilitySettings.AllUsers
										},
										{
											text = v.FriendsFollowingAndFollowers,
											key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
										},
										{
											text = v.FriendsAndFollowing,
											key = Constants.VisibilitySettings.FriendsAndFollowing
										},
										{
											text = v.Friends,
											key = Constants.VisibilitySettings.Friends
										},
										{ text = v.NoOne, key = Constants.VisibilitySettings.NoOne }
									},
									showDropShadow = true,
									defaultKey = state6
								})
							})
						}
					)
				end,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = {
								onActivated = props.cancelOnActivated,
								text = v.cancelButtonText
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onSave, text = v.saveButtonText }
						}
					},
					buttonHeight = 48,
					marginBetween = 6,
					forcedFillDirection = Enum.FillDirection.Horizontal
				}
			}) }
	)
end
